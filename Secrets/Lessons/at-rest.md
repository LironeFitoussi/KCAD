# 🔐 Encrypting Kubernetes Secret Data at Rest

In this lesson, we explore **how to enable encryption at rest** for secret data stored in **Kubernetes' etcd database**. Although Kubernetes encodes secrets with **Base64** by default, this does *not* offer true security—anyone with access to the secrets can decode them easily. The real goal is to ensure the **etcd datastore encrypts secrets**, protecting them from unauthorized access.

---

## 🧪 Initial Setup and Secret Creation

1. **Start a Kubernetes Playground**

   * A single-node cluster using containerd and the `kubeadm` tool.

2. **Create a Generic Secret**

   ```bash
   kubectl create secret generic my-secret --from-literal=key1=supersecret
   ```

   * This creates a secret with the key-value pair `key1=supersecret`.

3. **Inspect the Secret**

   * View the secret:

     ```bash
     kubectl get secret my-secret -o yaml
     ```
   * Decode the Base64 value:

     ```bash
     echo <base64-string> | base64 -d
     ```
   * **Note**: This Base64 encoding is **not encryption**.

---

## 📂 Secret Storage in etcd

* Secrets are stored in etcd under the key:

  ```
  /registry/secrets/default/my-secret
  ```

* Use the **etcdctl** tool to access etcd:

  ```bash
  ETCDCTL_API=3 etcdctl \
    --cert /etc/kubernetes/pki/etcd/server.crt \
    --key /etc/kubernetes/pki/etcd/server.key \
    --cacert /etc/kubernetes/pki/etcd/ca.crt \
    get /registry/secrets/default/my-secret
  ```

* Output will show the **plaintext secret**, proving that etcd stores it **unencrypted by default**.

---

## 🛡️ Enabling Encryption at Rest

### 1. **Check for Existing Encryption**

* Inspect the `kube-apiserver` manifest:

  ```bash
  grep encryption-provider-config /etc/kubernetes/manifests/kube-apiserver.yaml
  ```

  * If no result, encryption is **not enabled**.

---

### 2. **Create Encryption Configuration File**

Create a file `/etc/kubernetes/enc/encryption-config.yaml` with content like:

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: <base64-encoded-32-byte-key>
      - identity: {}
```

* **Only `secrets` are encrypted**.

* **Order matters**:

  * First provider (`aescbc`) is used for encryption.
  * Others (e.g., `identity`) are for decryption fallback.

* Generate a 32-byte key:

  ```bash
  head -c 32 /dev/urandom | base64
  ```

---

### 3. **Update the kube-apiserver Manifest**

In `/etc/kubernetes/manifests/kube-apiserver.yaml`, add:

* **Encryption config path**:

  ```yaml
  --encryption-provider-config=/etc/kubernetes/enc/encryption-config.yaml
  ```

* **Volume mount**:

  ```yaml
  volumeMounts:
    - name: encryption-config
      mountPath: /etc/kubernetes/enc
      readOnly: true
  ```

* **Volumes**:

  ```yaml
  volumes:
    - name: encryption-config
      hostPath:
        path: /etc/kubernetes/enc
        type: DirectoryOrCreate
  ```

Save the file. The kube-apiserver will automatically restart via the static pod setup.

---

## ✅ Verification of Encryption

### 1. **Create a New Secret**

```bash
kubectl create secret generic my-secret-2 --from-literal=key2=topsecret
```

### 2. **Check etcd Again**

* Run the `etcdctl get` command for `my-secret-2`.
* This time, the value should be **encrypted** (unreadable text).

---

## 🔁 Re-encrypt Existing Secrets

Secrets created **before** enabling encryption remain unencrypted. To force re-encryption:

```bash
kubectl get secrets -o json | kubectl replace -f -
```

* This re-applies existing secrets, triggering the API server to store them in encrypted form.

---

## 🧩 Summary

* Kubernetes stores secrets in etcd, encoded in Base64 by default.
* **Encryption at rest** requires an explicit **encryption configuration file** and modifying the **kube-apiserver** manifest.
* After enabling encryption:

  * New secrets are encrypted.
  * Old secrets can be re-encrypted manually.
* Always **verify encryption** by accessing etcd directly using `etcdctl`.

---

This approach strengthens your Kubernetes security by ensuring that sensitive data stored in etcd is **protected even if the datastore is compromised**.

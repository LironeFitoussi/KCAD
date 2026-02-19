# 🔐 Security Contexts in Kubernetes

Kubernetes allows you to configure **security settings** for your containers—similar to Docker—using a feature called **Security Contexts**. These settings define how a container or pod should run in terms of user permissions and system capabilities.

---

## 📦 Security Contexts: Pod vs. Container Level

You can define a security context at two levels:

### ✅ **Pod Level**

* Applied to *all containers* in the pod.
* Defined under `.spec.securityContext`.

### ✅ **Container Level**

* Applied to *a specific container* only.
* Defined under `.spec.containers[*].securityContext`.
* **Overrides** any conflicting pod-level settings.

---

## 🧾 Example: Pod Definition with Security Contexts

### 🔸 At the Pod Level

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-security-example
spec:
  securityContext:
    runAsUser: 1000
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
```

* All containers in this pod will run as **user ID 1000**.

---

### 🔸 At the Container Level (Overrides Pod)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: container-security-example
spec:
  securityContext:
    runAsUser: 1000    # default for all containers
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
      securityContext:
        runAsUser: 2000   # overrides pod-level setting
```

* This container will run as **user ID 2000**, even though the pod-level user is set to 1000.

---

## ➕ Adding Linux Capabilities

To grant extra privileges (like network admin access), use the **`capabilities`** field under `securityContext`.

### Example:

```yaml
securityContext:
  capabilities:
    add: ["NET_ADMIN", "SYS_TIME"]
```

* `NET_ADMIN`: Allows network interface management.
* `SYS_TIME`: Allows changing the system clock.

You can also **drop capabilities** using:

```yaml
capabilities:
  drop: ["ALL"]
```

---

## 📌 Summary

* **Security Contexts** allow you to control:

  * User and group IDs (`runAsUser`)
  * Linux capabilities (`capabilities`)
* Defined at either:

  * **Pod level** – Applies to all containers
  * **Container level** – Overrides pod settings
* This helps enforce **least privilege** and improve **container security**.

---

### 🧪 Next Steps

Head to the **Coding Exercises** section to practice:

* Viewing security context configurations
* Setting user IDs and capabilities
* Troubleshooting misconfigurations

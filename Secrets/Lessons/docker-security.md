# 🔐 Docker Security Concepts (Before Security Contexts in Kubernetes)

Before diving into Kubernetes security contexts, it’s important to understand how **security works in Docker**. This lecture focuses on **process isolation, user permissions**, and **Linux capabilities** that impact container security.

---

## 🧱 Process Isolation in Docker

### 🖥️ Host vs Container

* A Docker host runs several processes, including:

  * OS processes
  * Docker daemon
  * Services like SSH
  * Containers and their processes

* When a container is launched (e.g., Ubuntu with `sleep 3600`), it **shares the host's kernel** but runs in a **separate namespace**.

### 🧩 Linux Namespaces

* **Containers are isolated using Linux namespaces.**
* Each container:

  * Has its **own process namespace**.
  * Can see only its own processes.
* On the **host**, all container processes are visible, but they may have **different PIDs** than what you see inside the container.

> 🧠 This provides **process isolation**, a core concept in container security.

---

## 👤 User Security in Docker

### Default Behavior

* Docker containers run processes as the **root user** by default.
* This is evident when inspecting running processes inside the container (`UID = 0` for root).

### Changing the User

* You can specify a non-root user in two ways:

  #### 1. At Runtime

  ```bash
  docker run -u 1000 ubuntu sleep 3600
  ```

  #### 2. In the Dockerfile

  ```dockerfile
  FROM ubuntu
  USER 1000
  ```

* When the image is built and run, the process runs as user `1000` by default.

---

## ⚠️ Is Root in Containers Dangerous?

### Key Questions:

* Is the container’s **root user** equal to the host’s **root user**?
* Can it perform host-level operations?

### Answer:

**No**, Docker uses **Linux capabilities** to restrict what the container’s root user can do.

---

## 🛡️ Linux Capabilities in Docker

### What are Linux Capabilities?

* Linux breaks root privileges into **specific capabilities** (e.g., modifying files, rebooting system, setting user IDs).
* Examples of capabilities:

  * `CAP_NET_BIND_SERVICE` – Bind to low-numbered ports
  * `CAP_SYS_TIME` – Change system clock
  * `CAP_SYS_BOOT` – Reboot system
  * Full list: [Linux capabilities man page](https://man7.org/linux/man-pages/man7/capabilities.7.html)

### Docker's Behavior

* Docker **limits** the container’s root privileges by **dropping many capabilities** by default.
* This makes the root user inside a container **less powerful** than the root user on the host.

---

## 🔧 Modifying Container Capabilities

You can customize capabilities using Docker options:

### ➕ Add Capabilities

```bash
docker run --cap-add=NET_ADMIN ubuntu
```

### ➖ Drop Capabilities

```bash
docker run --cap-drop=MKNOD ubuntu
```

### 🚨 Full Privileges (Use with caution!)

```bash
docker run --privileged ubuntu
```

* Gives the container **all** host privileges.

> 🧠 Avoid running containers as privileged unless absolutely necessary.

---

## 🧩 Why This Matters for Kubernetes

Kubernetes builds on these same concepts, and **Security Contexts** in Kubernetes use similar mechanisms (like user IDs and Linux capabilities) to enforce pod and container-level security.

Understanding Docker security fundamentals provides a strong foundation for working with **Kubernetes security features** effectively.

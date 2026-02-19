# Apply Secrets
kubectl apply -f secret-data.yml

# Describe Secrets
kubectl describe secret myapp-secret

# Get Secrets
kubectl get secrets

# Get Secret Data
kubectl get secret myapp-secret -o yaml


# Get Secret Data in Base64
kubectl get secret myapp-secret -o jsonpath='{.data.DB_HOST}' | base64 -d

# Get Secret Data in Base64
kubectl get secret myapp-secret -o jsonpath='{.data.DB_USER}' | base64 -d
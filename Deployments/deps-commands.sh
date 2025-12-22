# Create Deployment
kubectl apply -f deployment-definition.yaml

# Get Deployment
kubectl get deployment

# Delete Deployment
kubectl delete deployment myapp-deployment

# Replace Deployment by deleting and creating again
kubectl replace -f deployment-definition.yaml

# Update Deployment
kubectl apply -f deployment-definition.yaml

# Get All Objects
kubectl get all
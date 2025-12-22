# Create ReplicaSet
kubectl apply -f replicaset-definition.yml

# Get ReplicaSet
kubectl get replicaset

# Delete ReplicaSet
kubectl delete replicaset myapp-replicaset

# Replace ReplicaSet by deleting and creating again
kubectl replace -f replicaset-definition.yml

# update ReplicaSet 
kubectl apply -f replicaset-definition.yml

# delete ReplicaSet
kubectl delete replicaset myapp-replicaset

# manually scale ReplicaSet
kubectl scale replicaset --replicas=6 -f replicaset-definition.yml

# manually scale ReplicaSet simply
kubectl scale replicaset myapp-replicaset --replicas=6
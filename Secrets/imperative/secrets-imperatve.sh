# Create Secret using Imperative Command
# Template
kubectl create secret <type> <name> \
    --from-literal=<key>=<value>

# Example
kubectl create secret generic myapp-secret \
    --from-literal=MY_SECRET_VAR=myvalue

# With multiple keys
kubectl create secret generic myapp-secret \
    --from-literal=MY_SECRET_VAR=myvalue \
    --from-literal=MY_SECRET_VAR2=myvalue2 \
    --from-literal=MY_SECRET_VAR3=myvalue3

# With multiple keys from a file
kubectl create secret generic myapp-secret \
    --from-file=myapp-secret.properties

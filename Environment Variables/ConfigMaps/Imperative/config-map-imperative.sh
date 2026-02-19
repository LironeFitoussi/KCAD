# create ConfigMap using imperative command
kubectl create configmap myapp-config \
    --from-literal=MY_ENV_VAR=myvalue

# Example:
kubectl create configmap app-config \
    --from-literal=APP_COLOR=blue \
    --from-literal=APP_MODE=prod

# From File
kubectl create configmap app-config-file \
    --from-file=app-config.properties
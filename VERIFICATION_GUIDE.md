# 🚀 Guía Simple de Despliegue

## � Pasos Rápidos

### 1. Commit y Push
```bash
git add .
git commit -m "simplify helm chart"
git push origin main
```

### 2. Crear Secret en Kubernetes
```bash
# Crear namespace
kubectl create namespace fastapi

# Crear secret para GHCR (reemplaza TU_TOKEN)
kubectl create secret docker-registry ghcr-creds \
  --docker-server=ghcr.io \
  --docker-username=EvaristoGZ \
  --docker-password=TU_GITHUB_TOKEN \
  -n fastapi
```

### 3. Aplicar ArgoCD
```bash
kubectl apply -f argocd/application.yaml
```

### 4. Verificar
```bash
# Ver aplicación en ArgoCD
kubectl get applications -n argocd

# Ver pods
kubectl get pods -n fastapi

# Probar aplicación
kubectl port-forward svc/fastapi 8000:80 -n fastapi
curl http://localhost:8000
```

## � Troubleshooting Simple

**Si no funciona**:
1. Verifica que GitHub Actions haya creado la imagen
2. Verifica el secret: `kubectl get secret ghcr-creds -n fastapi`
3. Ve los logs: `kubectl logs -l app.kubernetes.io/name=fastapi -n fastapi`

¡Eso es todo! 🎉
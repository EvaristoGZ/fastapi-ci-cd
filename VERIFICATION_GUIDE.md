# 🚀 Guía de Verificación para Despliegue con ArgoCD

## 📋 Checklist Pre-Despliegue

### 1. ✅ Verificar que los cambios estén en el repositorio

```bash
# Verificar el estado del repositorio
git status

# Agregar todos los archivos nuevos
git add .

# Hacer commit de los cambios
git commit -m "feat: add complete Helm chart for ArgoCD deployment"

# Hacer push al repositorio
git push origin main
```

### 2. 🐳 Verificar que la imagen Docker existe en GHCR

```bash
# Verificar que el workflow de GitHub Actions haya completado exitosamente
# Ir a: https://github.com/EvaristoGZ/fastapi-ci-cd/actions

# Opcional: verificar que la imagen esté disponible
docker pull ghcr.io/evaristogz/fastapi-ci-cd:latest
```

### 3. ⚙️ Instalar ArgoCD en tu cluster (si no está instalado)

```bash
# Crear namespace para ArgoCD
kubectl create namespace argocd

# Instalar ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Esperar a que todos los pods estén listos
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Obtener la contraseña inicial del admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward para acceder a ArgoCD UI (en otra terminal)
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 4. 🔑 Configurar acceso a GHCR en Kubernetes

```bash
# Crear el secret para acceder a GHCR (usar tu token de GitHub)
kubectl create secret docker-registry ghcr-creds \
  --docker-server=ghcr.io \
  --docker-username=EvaristoGZ \
  --docker-password=<TU_GITHUB_TOKEN> \
  --docker-email=<TU_EMAIL> \
  -n fastapi

# O crear primero el namespace si no existe
kubectl create namespace fastapi
kubectl create secret docker-registry ghcr-creds \
  --docker-server=ghcr.io \
  --docker-username=EvaristoGZ \
  --docker-password=<TU_GITHUB_TOKEN> \
  --docker-email=<TU_EMAIL> \
  -n fastapi
```

### 5. 🚀 Aplicar la aplicación ArgoCD

```bash
# Aplicar la configuración de ArgoCD
kubectl apply -f argocd/application.yaml

# Verificar que la aplicación se creó
kubectl get applications -n argocd

# Ver el estado de la aplicación
kubectl describe application fastapi -n argocd
```

## 🔍 Verificaciones de Estado

### A. Verificar en ArgoCD UI

1. Accede a http://localhost:8080
2. Login: `admin` / `<contraseña-obtenida-anteriormente>`
3. Busca la aplicación `fastapi`
4. Verifica que esté en estado `Synced` y `Healthy`

### B. Verificar en Kubernetes

```bash
# Ver todos los recursos en el namespace fastapi
kubectl get all -n fastapi

# Ver los pods específicamente
kubectl get pods -n fastapi

# Ver logs de la aplicación
kubectl logs -l app.kubernetes.io/name=fastapi -n fastapi

# Verificar el servicio
kubectl get svc -n fastapi

# Port forward para probar la aplicación localmente
kubectl port-forward svc/fastapi 8000:80 -n fastapi
```

### C. Probar la aplicación

```bash
# En otra terminal, probar la aplicación
curl http://localhost:8000

# O abrir en navegador
# http://localhost:8000
```

## 🐛 Troubleshooting

### Si ArgoCD no puede sincronizar:

```bash
# Ver eventos de la aplicación
kubectl describe application fastapi -n argocd

# Ver logs de ArgoCD
kubectl logs -l app.kubernetes.io/name=argocd-application-controller -n argocd

# Forzar sincronización manual
kubectl patch application fastapi -n argocd --type merge --patch '{"operation":{"sync":{"prune":true}}}'
```

### Si los pods no inician:

```bash
# Ver describe del pod
kubectl describe pod <POD_NAME> -n fastapi

# Verificar el secret para pull de imagen
kubectl get secret ghcr-creds -n fastapi -o yaml

# Ver eventos del namespace
kubectl get events -n fastapi --sort-by=.metadata.creationTimestamp
```

### Si hay problemas con permisos de imagen:

```bash
# Verificar que el token de GitHub tenga permisos de lectura de packages
# Recrear el secret con un token válido
kubectl delete secret ghcr-creds -n fastapi
kubectl create secret docker-registry ghcr-creds \
  --docker-server=ghcr.io \
  --docker-username=EvaristoGZ \
  --docker-password=<NUEVO_TOKEN> \
  --docker-email=<TU_EMAIL> \
  -n fastapi
```

## ✅ Señales de Éxito

1. ✅ GitHub Actions workflow completado sin errores
2. ✅ Imagen Docker disponible en GHCR
3. ✅ ArgoCD aplicación en estado "Synced" y "Healthy"
4. ✅ Pods ejecutándose correctamente
5. ✅ Servicio responde en puerto 8000
6. ✅ Aplicación FastAPI accesible y funcionando

## 🔄 Flujo Completo de CI/CD

1. **Developer push** → GitHub
2. **GitHub Actions** → Build, Test, Security Scan, Push Image
3. **ArgoCD** → Detecta cambios en repo, aplica manifiestos
4. **Kubernetes** → Despliega nueva versión automáticamente

¡Tu aplicación estará completamente desplegada con CI/CD automatizado! 🎉
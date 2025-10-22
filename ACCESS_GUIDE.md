# 🚀 Cómo Acceder a tu Aplicación FastAPI

## 🔗 Opción 1: Port Forward (Desarrollo)

```bash
# Verificar que los pods estén corriendo
kubectl get pods -n fastapi

# Crear port forward (puerto local:puerto servicio)
kubectl port-forward svc/fastapi 8080:80 -n fastapi

# Acceder en navegador:
# http://localhost:8080
```

## 🌐 Opción 2: Ingress (Producción)

### 1. Habilitar Ingress
En `charts/fastapi/values.yaml`:
```yaml
ingress:
  enabled: true
  host: fastapi.tudominio.com  # Cambiar por tu dominio
```

### 2. Asegurar Ingress Controller
```bash
# Si usas nginx-ingress (común en clusters)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# O en minikube:
minikube addons enable ingress
```

### 3. Configurar DNS
- Si es para testing local, agrega a `/etc/hosts`:
  ```
  127.0.0.1 fastapi.local
  ```
- En producción, configura tu DNS para apuntar al LoadBalancer

## ☁️ Opción 3: LoadBalancer (Cloud)

### 1. Cambiar tipo de servicio
En `charts/fastapi/values.yaml`:
```yaml
service:
  type: LoadBalancer  # Cambiar de ClusterIP
  port: 80
  targetPort: 8000
```

### 2. Obtener IP externa
```bash
# Ver la IP externa asignada
kubectl get svc fastapi -n fastapi

# Acceder usando la EXTERNAL-IP mostrada
# http://EXTERNAL-IP
```

## 🔍 Comandos Útiles

```bash
# Ver todos los recursos
kubectl get all -n fastapi

# Ver logs de la aplicación
kubectl logs -l app.kubernetes.io/name=fastapi -n fastapi

# Descripción del servicio
kubectl describe svc fastapi -n fastapi

# Acceso directo al pod (debugging)
kubectl exec -it <pod-name> -n fastapi -- bash
```

## 🧪 Verificar que Funciona

```bash
# Con port-forward
curl http://localhost:8080

# Con LoadBalancer
curl http://EXTERNAL-IP

# Con Ingress
curl http://fastapi.tudominio.com
```

## 📍 Recomendaciones por Entorno

- **🏠 Local/Minikube**: Port Forward o Ingress con host local
- **☁️ Cloud (AWS/GCP/Azure)**: LoadBalancer o Ingress con dominio real
- **🏢 Cluster empresarial**: Ingress con certificados SSL

¡Elige la opción que mejor se adapte a tu entorno! 🎯
{{/*
Nombre completo de la aplicación
*/}}
{{- define "fastapi.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Labels comunes
*/}}
{{- define "fastapi.labels" -}}
app.kubernetes.io/name: fastapi
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Labels para selector
*/}}
{{- define "fastapi.selectorLabels" -}}
app.kubernetes.io/name: fastapi
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
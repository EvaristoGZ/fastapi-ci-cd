# Build de dependencias (si hiciera falta, aquí es casi no-op)
FROM python:3.14-slim AS builder
WORKDIR /app
RUN pip install --no-cache-dir fastapi uvicorn[standard]

# Runtime
FROM python:3.14-slim
WORKDIR /app
COPY --from=builder /usr/local /usr/local
COPY app ./app
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

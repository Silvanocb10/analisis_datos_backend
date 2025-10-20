# ----------------------------------------------------
# ETAPA 1: CONSTRUIR EL FRONTEND (React)
# ----------------------------------------------------
FROM node:20 as frontend_builder

WORKDIR /app/frontend
# Copia los archivos del frontend
COPY frontend/package.json frontend/package-lock.json ./
# Instala las dependencias de Node.js
RUN npm install

# Copia el resto del código fuente del frontend y construye la aplicación
COPY frontend/ .
RUN npm run build

# ----------------------------------------------------
# ETAPA 2: CONFIGURAR Y EJECUTAR EL BACKEND (Python)
# ----------------------------------------------------
FROM python:3.11-slim

# Establece el directorio de trabajo para el backend
WORKDIR /app

# Copia los archivos del backend (cambia 'backend' por 'analisis_datos_backend' si es tu carpeta principal)
COPY backend/ /app/backend/

# Copia los archivos de modelos y datos persistentes que necesite tu app
COPY backend/models/ /app/backend/models/
COPY backend/uploads/ /app/backend/uploads/

# Copia el archivo requirements.txt y lo instala
# Asumo que tienes un requirements.txt consolidado en la raíz para las dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia los archivos estáticos construidos (el frontend)
# La carpeta 'dist' es donde Vite guarda el build por defecto
COPY --from=frontend_builder /app/frontend/dist /app/backend/static

# Define la variable de entorno para el puerto de Hugging Face
ENV PORT=7860

# Comando para ejecutar tu aplicación backend
# Reemplaza 'main:app' si usas otro archivo/nombre de aplicación (ej. 'main:api' si usas FastAPI)
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "7860"]

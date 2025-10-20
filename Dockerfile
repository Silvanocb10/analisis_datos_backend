# Imagen base
FROM python:3.11

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos del backend
COPY . /app

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto
EXPOSE 7860

# Comando para ejecutar el servidor
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]

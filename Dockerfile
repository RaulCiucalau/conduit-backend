# ---------- Build stage ----------
FROM python:3.5-slim

# Set Python behavior inside the container
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create and use app directory
WORKDIR /app

# Copy dependency file first for better Docker cache usage
COPY requirements.txt .

# Install Python dependencies directly into the image
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# Move installed packages to the system site-packages
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose backend container port
EXPOSE 8000

# Set entrypoint to run the application
ENTRYPOINT ["/entrypoint.sh"]

# Start WSGI application with Gunicorn
CMD ["gunicorn", "conduit.wsgi:application", "--bind", "0.0.0.0:8000"]
# Guía de Despliegue en AWS

## 1. Configuración de la Base de Datos

### Opción A: RDS MySQL (Recomendado)
```bash
# Crear instancia RDS MySQL
aws rds create-db-instance \
  --db-instance-identifier penka-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password TU_CONTRASEÑA_FUERTE \
  --allocated-storage 20 \
  --vpc-security-group-ids sg-xxxxxxxxx
```

### Opción B: EC2 con MySQL
```bash
# Instalar MySQL en EC2
sudo apt update
sudo apt install mysql-server
sudo mysql_secure_installation
```

## 2. Configuración de Variables de Entorno

### Crear archivo .env en el servidor:
```bash
# Variables de entorno para producción
DB_HOST=tu-instancia-rds.region.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=TU_CONTRASEÑA_FUERTE
DB_NAME=penka
DB_PORT=3306
PORT=3001
NODE_ENV=production
CORS_ORIGIN=https://tu-dominio.com
```

## 3. Despliegue del Backend

### Opción A: EC2 (Recomendado para empezar)

#### 1. Crear instancia EC2
```bash
# Usar Amazon Linux 2 o Ubuntu
# Tipo: t3.micro (gratis)
# Security Group: Puerto 22 (SSH), 3001 (Backend), 80 (HTTP), 443 (HTTPS)
```

#### 2. Conectar y configurar
```bash
# Conectar via SSH
ssh -i tu-key.pem ubuntu@tu-ip-ec2

# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PM2 (gestor de procesos)
sudo npm install -g pm2

# Clonar o subir tu código
git clone tu-repositorio
cd tu-proyecto/backend

# Instalar dependencias
npm install

# Crear archivo .env
nano .env
# Pegar las variables de entorno

# Iniciar con PM2
pm2 start index.cjs --name "penka-backend"
pm2 startup
pm2 save
```

### Opción B: Elastic Beanstalk
```bash
# Instalar EB CLI
pip install awsebcli

# Inicializar aplicación
eb init penka-app --platform node.js --region us-east-1

# Crear entorno
eb create penka-production

# Configurar variables de entorno
eb setenv DB_HOST=tu-rds-endpoint
eb setenv DB_USER=admin
eb setenv DB_PASSWORD=tu-contraseña
eb setenv DB_NAME=penka
eb setenv NODE_ENV=production

# Desplegar
eb deploy
```

## 4. Configuración de Base de Datos

### Importar datos existentes:
```bash
# Desde tu máquina local
mysqldump -u root -p penka > penka_backup.sql

# Subir a RDS
mysql -h tu-rds-endpoint -u admin -p penka < penka_backup.sql
```

### O crear desde cero:
```bash
# Conectar a RDS
mysql -h tu-rds-endpoint -u admin -p

# Crear base de datos
CREATE DATABASE penka;
USE penka;

# Ejecutar script SQL
source penka.sql;
```

## 5. Configuración de Dominio y SSL

### Usar Route 53 y Certificate Manager:
```bash
# Registrar dominio en Route 53
# Solicitar certificado SSL en Certificate Manager
# Configurar Application Load Balancer
```

### Configurar Nginx (si usas EC2):
```nginx
server {
    listen 80;
    server_name tu-dominio.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name tu-dominio.com;
    
    ssl_certificate /etc/letsencrypt/live/tu-dominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tu-dominio.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## 6. Configuración del Frontend

### Actualizar URLs en el frontend:
```typescript
// Cambiar todas las URLs de localhost:3001 por tu dominio
const API_BASE_URL = 'https://tu-dominio.com';

// En todos los fetch:
fetch(`${API_BASE_URL}/api/propiedades`)
```

### Desplegar frontend:
```bash
# Build del frontend
npm run build

# Subir a S3 + CloudFront
aws s3 sync dist/ s3://tu-bucket-frontend
aws cloudfront create-invalidation --distribution-id E123456789 --paths "/*"
```

## 7. Configuración de Seguridad

### Security Groups:
- **RDS**: Solo puerto 3306 desde EC2
- **EC2**: Puertos 22 (SSH), 80 (HTTP), 443 (HTTPS)
- **ALB**: Puertos 80 y 443

### IAM Roles:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource": "arn:aws:rds-db:region:account:dbuser:db-instance-id/db-username"
    }
  ]
}
```

## 8. Monitoreo y Logs

### CloudWatch:
```bash
# Configurar logs de PM2
pm2 install pm2-cloudwatch
pm2 set pm2-cloudwatch:region us-east-1
pm2 set pm2-cloudwatch:logGroupName /aws/ec2/penka-backend
```

### Health Check:
```javascript
// Agregar endpoint de health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});
```

## 9. Backup y Recuperación

### Backup automático de RDS:
```bash
# Configurar snapshots automáticos en RDS
# Retención: 7 días
# Ventana de mantenimiento: 3:00-4:00 AM UTC
```

### Backup de archivos:
```bash
# Script de backup de imágenes
#!/bin/bash
aws s3 sync /var/www/penka/img s3://tu-bucket-backup/img --delete
```

## 10. Escalabilidad

### Auto Scaling Group:
```bash
# Configurar Auto Scaling para EC2
# Mínimo: 1 instancia
# Máximo: 3 instancias
# Métrica: CPU > 70%
```

### Load Balancer:
```bash
# Configurar Application Load Balancer
# Health check: /health
# Target group: puerto 3001
```

## 11. Costos Estimados (Mensual)

- **EC2 t3.micro**: $8.47
- **RDS t3.micro**: $12.41
- **S3 (5GB)**: $0.12
- **CloudFront**: $0.85
- **Route 53**: $0.50
- **Certificate Manager**: Gratis
- **Total**: ~$22.35/mes

## 12. Comandos Útiles

### Verificar estado:
```bash
# Backend
pm2 status
pm2 logs penka-backend

# Base de datos
mysql -h tu-rds-endpoint -u admin -p -e "SHOW DATABASES;"

# Logs del sistema
sudo journalctl -u nginx
sudo tail -f /var/log/nginx/error.log
```

### Reiniciar servicios:
```bash
# Backend
pm2 restart penka-backend

# Nginx
sudo systemctl restart nginx

# Base de datos (desde AWS Console)
```

## 13. Troubleshooting

### Problemas comunes:
1. **Conexión a base de datos**: Verificar Security Groups
2. **CORS errors**: Verificar CORS_ORIGIN en .env
3. **Archivos no encontrados**: Verificar permisos en /img
4. **SSL errors**: Verificar certificado en Certificate Manager

### Logs importantes:
- `/var/log/nginx/error.log`
- `pm2 logs penka-backend`
- CloudWatch Logs
- RDS Logs 
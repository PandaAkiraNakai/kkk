// Configuración de ejemplo para AWS
// Copia este archivo como config.js y modifica los valores

module.exports = {
  // Configuración de Base de Datos
  database: {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'tu_contraseña_aqui',
    database: process.env.DB_NAME || 'penka',
    port: process.env.DB_PORT || 3306
  },
  
  // Configuración del Servidor
  server: {
    port: process.env.PORT || 3001,
    nodeEnv: process.env.NODE_ENV || 'development'
  },
  
  // Configuración de CORS
  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:5173'
  }
}; 
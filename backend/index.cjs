const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const path = require('path');
const multer = require('multer');
const fs = require('fs');
require('dotenv').config(); // Cargar variables de entorno

const app = express();
app.use(cors());
app.use(express.json());
app.use('/img', express.static(path.join(__dirname, '../img')));

// Health check endpoint para AWS
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Configuración de base de datos con variables de entorno
const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'polo', // Contraseña de tu base de datos
  database: process.env.DB_NAME || 'penka',
  port: process.env.DB_PORT || 3306
});

db.connect(err => {
  if (err) throw err;
  console.log('Conectado a MySQL');
});

// Configuración de multer para guardar imágenes en img/propiedades
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const dir = path.join(__dirname, '../img/propiedades');
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    cb(null, dir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '_' + Math.round(Math.random() * 1E9);
    const ext = path.extname(file.originalname);
    cb(null, uniqueSuffix + ext);
  }
});
const upload = multer({ storage });

// Endpoint para obtener propiedades con foto principal
app.get('/api/propiedades-con-foto', (req, res) => {
  const {
    tipo, region, provincia, comuna, sector, min, max
  } = req.query;

  let sql = `
    SELECT p.*, 
      (SELECT g.foto FROM galeria g WHERE g.idpropiedades = p.num_propiedad AND g.principal = 1 LIMIT 1) AS foto,
      s.idcomunas, c.idprovincias, pr.idregion
    FROM propiedades p
    JOIN sectores s ON p.idsectores = s.idsectores
    JOIN comunas c ON s.idcomunas = c.idcomunas
    JOIN provincias pr ON c.idprovincias = pr.idprovincias
    JOIN regiones r ON pr.idregion = r.idregion
    WHERE 1=1
  `;
  const params = [];

  if (tipo) {
    sql += ' AND p.idtipo_propiedad = ?';
    params.push(tipo);
  }
  if (region) {
    sql += ' AND r.idregion = ?';
    params.push(region);
  }
  if (provincia) {
    sql += ' AND pr.idprovincias = ?';
    params.push(provincia);
  }
  if (comuna) {
    sql += ' AND c.idcomunas = ?';
    params.push(comuna);
  }
  if (sector) {
    sql += ' AND s.idsectores = ?';
    params.push(sector);
  }
  if (min) {
    sql += ' AND p.precio_uf >= ?';
    params.push(min);
  }
  if (max) {
    sql += ' AND p.precio_uf <= ?';
    params.push(max);
  }

  db.query(sql, params, (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// Endpoint para obtener propiedades (con filtro por rut_propietario)
app.get('/api/propiedades', (req, res) => {
  const { rut_propietario } = req.query;
  let sql = 'SELECT * FROM propiedades';
  const params = [];
  if (rut_propietario) {
    sql += ' WHERE rut_propietario = ?';
    params.push(rut_propietario);
  }
  db.query(sql, params, (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// Endpoint para obtener usuarios
app.get('/api/usuarios', (req, res) => {
  db.query('SELECT id, rut, nombres, ap_paterno, ap_materno, usuario, estado, tipo_usuario FROM usuarios', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// Endpoint de login para usuarios y propietarios
app.post('/api/login', (req, res) => {
  const { usuario, clave } = req.body;
  if (!usuario || !clave) {
    return res.status(400).json({ error: 'Usuario y clave requeridos' });
  }
  // Buscar en usuarios
  db.query('SELECT * FROM usuarios WHERE usuario = ? AND estado = 1', [usuario], (err, results) => {
    if (err) return res.status(500).json({ error: err });
    if (results.length === 0) {
      // Si no está en usuarios, buscar en propietarios (por correo o rut)
      db.query('SELECT * FROM propietarios WHERE correo = ? OR rut = ?', [usuario, usuario], (err2, results2) => {
        if (err2) return res.status(500).json({ error: err2 });
        if (results2.length === 0) {
          return res.status(401).json({ error: 'Usuario o clave incorrectos' });
        }
        const propietario = results2[0];
        bcrypt.compare(clave, propietario.password, (err3, isMatch) => {
          if (err3) return res.status(500).json({ error: err3 });
          if (!isMatch) {
            return res.status(401).json({ error: 'Usuario o clave incorrectos' });
          }
          // No se envía la clave al frontend
          const { password, ...propietarioData } = propietario;
          propietarioData.tipo_usuario = 'propietario';
          res.json(propietarioData);
        });
      });
    } else {
      const user = results[0];
      bcrypt.compare(clave, user.clave, (err, isMatch) => {
        if (err) return res.status(500).json({ error: err });
        if (!isMatch) {
          return res.status(401).json({ error: 'Usuario o clave incorrectos' });
        }
        // No se envía la clave al frontend
        const { clave, ...userData } = user;
        res.json(userData);
      });
    }
  });
});

// Endpoint para crear usuario
app.post('/api/usuarios', (req, res) => {
  const { rut, nombres, ap_paterno, ap_materno, usuario, clave, tipo_usuario, estado } = req.body;
  if (!rut || !nombres || !ap_paterno || !ap_materno || !usuario || !clave || !tipo_usuario) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }
  // Encriptar la contraseña
  bcrypt.hash(clave, 12, (err, hash) => {
    if (err) return res.status(500).json({ error: 'Error al encriptar la contraseña.' });
    db.query(
      'INSERT INTO usuarios (rut, nombres, ap_paterno, ap_materno, usuario, clave, estado, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [rut, nombres, ap_paterno, ap_materno, usuario, hash, estado || 0, tipo_usuario],
      (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'El RUT o usuario ya existe.' });
          }
          return res.status(500).json({ error: 'Error al crear el usuario.' });
        }
        res.json({ success: true, id: result.insertId });
      }
    );
  });
});

// Endpoint para crear propiedad y guardar imagen
app.post('/api/propiedades', upload.single('imagen'), (req, res) => {
  const {
    rut_propietario, titulopropiedad, descripcion, cant_banos, cant_domitorios, area_total, precio_uf, precio_pesos, idtipo_propiedad, idsectores
  } = req.body;
  if (!rut_propietario || !titulopropiedad || !descripcion || !cant_banos || !cant_domitorios || !area_total || !precio_uf || !precio_pesos || !idtipo_propiedad || !idsectores || !req.file) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }
  const fecha_publicacion = new Date().toISOString().slice(0, 10);
  const estado = 1;
  // Insertar propiedad
  db.query(
    'INSERT INTO propiedades (rut_propietario, titulopropiedad, descripcion, cant_banos, cant_domitorios, area_total, precio_uf, precio_pesos, idtipo_propiedad, idsectores, fecha_publicacion, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [rut_propietario, titulopropiedad, descripcion, cant_banos, cant_domitorios, area_total, precio_uf, precio_pesos, idtipo_propiedad, idsectores, fecha_publicacion, estado],
    (err, result) => {
      if (err) return res.status(500).json({ error: 'Error al crear la propiedad.' });
      const num_propiedad = result.insertId;
      // Guardar imagen en galeria
      const rutaFoto = 'img/propiedades/' + req.file.filename;
      db.query(
        'INSERT INTO galeria (foto, estado, principal, idpropiedades) VALUES (?, 1, 1, ?)',
        [rutaFoto, num_propiedad],
        (err2) => {
          if (err2) return res.status(500).json({ error: 'Propiedad creada, pero error al guardar la imagen.' });
          res.json({ success: true, id: num_propiedad });
        }
      );
    }
  );
});

// Endpoint para tipos de propiedad
app.get('/api/tipos-propiedad', (req, res) => {
  db.query('SELECT * FROM tipo_propiedad', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});
// Endpoint para regiones
app.get('/api/regiones', (req, res) => {
  db.query('SELECT * FROM regiones', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});
// Endpoint para comunas
app.get('/api/comunas', (req, res) => {
  db.query('SELECT * FROM comunas', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});
// Endpoint para sectores
app.get('/api/sectores', (req, res) => {
  db.query('SELECT * FROM sectores', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// Endpoint para provincias
app.get('/api/provincias', (req, res) => {
  db.query('SELECT * FROM provincias', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// Endpoint para obtener propietarios
app.get('/api/propietarios', (req, res) => {
  db.query('SELECT id, rut, nombre_completo, fecha_nacimiento, correo, sexo, telefono FROM propietarios', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

// Endpoint para crear propietario
app.post('/api/propietarios', (req, res) => {
  const { rut, nombre_completo, fecha_nacimiento, correo, password, sexo, telefono } = req.body;
  if (!rut || !nombre_completo || !fecha_nacimiento || !correo || !password || !sexo || !telefono) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }
  bcrypt.hash(password, 12, (err, hash) => {
    if (err) return res.status(500).json({ error: 'Error al encriptar la contraseña.' });
    const sql = 'INSERT INTO propietarios (rut, nombre_completo, fecha_nacimiento, correo, password, sexo, telefono) VALUES (?, ?, ?, ?, ?, ?, ?)';
    db.query(sql, [rut, nombre_completo, fecha_nacimiento, correo, hash, sexo, telefono], (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).json({ error: 'El RUT o correo ya existe.' });
        }
        return res.status(500).json({ error: 'Error al crear el propietario.' });
      }
      res.json({ success: true, id: result.insertId });
    });
  });
});

// Endpoint para actualizar propietario
app.put('/api/propietarios/:id', (req, res) => {
  const { id } = req.params;
  const { rut, nombre_completo, fecha_nacimiento, correo, password, sexo, telefono } = req.body;
  
  if (!rut || !nombre_completo || !fecha_nacimiento || !correo || !sexo || !telefono) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }
  
  let sql, params;
  
  if (password) {
    // Si se proporciona una nueva contraseña, encriptarla
    bcrypt.hash(password, 12, (err, hash) => {
      if (err) return res.status(500).json({ error: 'Error al encriptar la contraseña.' });
      
      sql = `UPDATE propietarios SET 
        rut = ?, nombre_completo = ?, fecha_nacimiento = ?, 
        correo = ?, password = ?, sexo = ?, telefono = ? 
        WHERE id = ?`;
      params = [rut, nombre_completo, fecha_nacimiento, correo, hash, sexo, telefono, id];
      
      db.query(sql, params, (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'El RUT o correo ya existe.' });
          }
          return res.status(500).json({ error: 'Error al actualizar el propietario.' });
        }
        if (result.affectedRows === 0) {
          return res.status(404).json({ error: 'Propietario no encontrado.' });
        }
        res.json({ success: true, message: 'Propietario actualizado correctamente.' });
      });
    });
  } else {
    // Si no se proporciona contraseña, mantener la existente
    sql = `UPDATE propietarios SET 
      rut = ?, nombre_completo = ?, fecha_nacimiento = ?, 
      correo = ?, sexo = ?, telefono = ? 
      WHERE id = ?`;
    params = [rut, nombre_completo, fecha_nacimiento, correo, sexo, telefono, id];
    
    db.query(sql, params, (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).json({ error: 'El RUT o correo ya existe.' });
        }
        return res.status(500).json({ error: 'Error al actualizar el propietario.' });
      }
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Propietario no encontrado.' });
      }
      res.json({ success: true, message: 'Propietario actualizado correctamente.' });
    });
  }
});

// Endpoint para eliminar propietario
app.delete('/api/propietarios/:id', (req, res) => {
  const { id } = req.params;
  
  db.query('DELETE FROM propietarios WHERE id = ?', [id], (err, result) => {
    if (err) return res.status(500).json({ error: 'Error al eliminar el propietario.' });
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Propietario no encontrado.' });
    }
    res.json({ success: true, message: 'Propietario eliminado correctamente.' });
  });
});

// Endpoint para eliminar propiedad
app.delete('/api/propiedades/:id', (req, res) => {
  const { id } = req.params;
  
  // Primero eliminar las imágenes de la galería
  db.query('DELETE FROM galeria WHERE idpropiedades = ?', [id], (err) => {
    if (err) return res.status(500).json({ error: 'Error al eliminar imágenes de la galería.' });
    
    // Luego eliminar la propiedad
    db.query('DELETE FROM propiedades WHERE num_propiedad = ?', [id], (err, result) => {
      if (err) return res.status(500).json({ error: 'Error al eliminar la propiedad.' });
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Propiedad no encontrada.' });
      }
      res.json({ success: true, message: 'Propiedad eliminada correctamente.' });
    });
  });
});

// Endpoint para eliminar usuario
app.delete('/api/usuarios/:id', (req, res) => {
  const { id } = req.params;
  
  db.query('DELETE FROM usuarios WHERE id = ?', [id], (err, result) => {
    if (err) return res.status(500).json({ error: 'Error al eliminar el usuario.' });
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado.' });
    }
    res.json({ success: true, message: 'Usuario eliminado correctamente.' });
  });
});

// Endpoint para actualizar propiedad
app.put('/api/propiedades/:id', upload.single('imagen'), (req, res) => {
  const { id } = req.params;
  const {
    rut_propietario, titulopropiedad, descripcion, cant_banos, cant_domitorios, 
    area_total, precio_uf, precio_pesos, idtipo_propiedad, idsectores
  } = req.body;
  
  if (!rut_propietario || !titulopropiedad || !descripcion || !cant_banos || 
      !cant_domitorios || !area_total || !precio_uf || !precio_pesos || 
      !idtipo_propiedad || !idsectores) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }
  
  // Actualizar propiedad
  const sql = `UPDATE propiedades SET 
    rut_propietario = ?, titulopropiedad = ?, descripcion = ?, 
    cant_banos = ?, cant_domitorios = ?, area_total = ?, 
    precio_uf = ?, precio_pesos = ?, idtipo_propiedad = ?, idsectores = ? 
    WHERE num_propiedad = ?`;
    
  db.query(sql, [
    rut_propietario, titulopropiedad, descripcion, cant_banos, cant_domitorios,
    area_total, precio_uf, precio_pesos, idtipo_propiedad, idsectores, id
  ], (err, result) => {
    if (err) return res.status(500).json({ error: 'Error al actualizar la propiedad.' });
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Propiedad no encontrada.' });
    }
    
    // Si se subió una nueva imagen, actualizar la galería
    if (req.file) {
      const rutaFoto = 'img/propiedades/' + req.file.filename;
      db.query(
        'UPDATE galeria SET foto = ? WHERE idpropiedades = ? AND principal = 1',
        [rutaFoto, id],
        (err2) => {
          if (err2) return res.status(500).json({ error: 'Propiedad actualizada, pero error al actualizar la imagen.' });
          res.json({ success: true, message: 'Propiedad actualizada correctamente.' });
        }
      );
    } else {
      res.json({ success: true, message: 'Propiedad actualizada correctamente.' });
    }
  });
});

// Endpoint para actualizar usuario
app.put('/api/usuarios/:id', (req, res) => {
  const { id } = req.params;
  const { rut, nombres, ap_paterno, ap_materno, usuario, clave, tipo_usuario, estado } = req.body;
  
  if (!rut || !nombres || !ap_paterno || !ap_materno || !usuario || !tipo_usuario) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }
  
  let sql, params;
  
  if (clave) {
    // Si se proporciona una nueva contraseña, encriptarla
    bcrypt.hash(clave, 12, (err, hash) => {
      if (err) return res.status(500).json({ error: 'Error al encriptar la contraseña.' });
      
      sql = `UPDATE usuarios SET 
        rut = ?, nombres = ?, ap_paterno = ?, ap_materno = ?, 
        usuario = ?, clave = ?, tipo_usuario = ?, estado = ? 
        WHERE id = ?`;
      params = [rut, nombres, ap_paterno, ap_materno, usuario, hash, tipo_usuario, estado || 0, id];
      
      db.query(sql, params, (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'El RUT o usuario ya existe.' });
          }
          return res.status(500).json({ error: 'Error al actualizar el usuario.' });
        }
        if (result.affectedRows === 0) {
          return res.status(404).json({ error: 'Usuario no encontrado.' });
        }
        res.json({ success: true, message: 'Usuario actualizado correctamente.' });
      });
    });
  } else {
    // Si no se proporciona contraseña, mantener la existente
    sql = `UPDATE usuarios SET 
      rut = ?, nombres = ?, ap_paterno = ?, ap_materno = ?, 
      usuario = ?, tipo_usuario = ?, estado = ? 
      WHERE id = ?`;
    params = [rut, nombres, ap_paterno, ap_materno, usuario, tipo_usuario, estado || 0, id];
    
    db.query(sql, params, (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).json({ error: 'El RUT o usuario ya existe.' });
        }
        return res.status(500).json({ error: 'Error al actualizar el usuario.' });
      }
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Usuario no encontrado.' });
      }
      res.json({ success: true, message: 'Usuario actualizado correctamente.' });
    });
  }
});

app.listen(3001, () => {
  console.log('API escuchando en http://localhost:3001');
});

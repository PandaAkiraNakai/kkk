# Guía de Migración a Firebase

## 1. Configuración Inicial

### Instalar Firebase CLI
```bash
npm install -g firebase-tools
```

### Inicializar Firebase en el proyecto
```bash
firebase login
firebase init
```

### Seleccionar servicios:
- Firestore Database
- Authentication
- Storage
- Hosting

## 2. Estructura de Base de Datos (Firestore)

### Colecciones principales:

#### `usuarios`
```javascript
{
  id: "auto-generated",
  rut: "12345678-9",
  nombres: "Juan",
  ap_paterno: "Pérez",
  ap_materno: "González",
  usuario: "juan.perez",
  tipo_usuario: "admin", // "admin", "usuario"
  estado: true,
  fecha_creacion: timestamp,
  ultima_sesion: timestamp
}
```

#### `propietarios`
```javascript
{
  id: "auto-generated",
  rut: "12345678-9",
  nombre_completo: "María González",
  fecha_nacimiento: "1990-05-15",
  correo: "maria@email.com",
  sexo: "F", // "M", "F"
  telefono: "+56912345678",
  fecha_creacion: timestamp
}
```

#### `propiedades`
```javascript
{
  id: "auto-generated",
  rut_propietario: "12345678-9",
  titulopropiedad: "Casa en Las Condes",
  descripcion: "Hermosa casa de 3 dormitorios...",
  cant_banos: 2,
  cant_dormitorios: 3,
  area_total: 120,
  precio_uf: 2500,
  precio_pesos: 85000000,
  idtipo_propiedad: "casa",
  idsectores: "las-condes-centro",
  fecha_publicacion: timestamp,
  estado: true,
  imagenes: [
    {
      url: "https://firebasestorage.googleapis.com/...",
      principal: true,
      nombre: "foto_principal.jpg"
    }
  ]
}
```

#### `regiones`, `provincias`, `comunas`, `sectores`
```javascript
{
  id: "auto-generated",
  nombre: "Región Metropolitana",
  estado: true
}
```

## 3. Configuración de Firebase

### firebase.json
```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
  "hosting": {
    "public": "dist",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### firestore.rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios pueden leer sus propios datos
    match /usuarios/{userId} {
      allow read: if request.auth != null && (request.auth.uid == userId || get(/databases/$(database)/documents/usuarios/$(request.auth.uid)).data.tipo_usuario == 'admin');
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Solo admins pueden gestionar propietarios
    match /propietarios/{propietarioId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && get(/databases/$(database)/documents/usuarios/$(request.auth.uid)).data.tipo_usuario == 'admin';
    }
    
    // Propiedades: propietarios pueden gestionar las suyas, admins pueden gestionar todas
    match /propiedades/{propiedadId} {
      allow read: if true; // Público para búsquedas
      allow write: if request.auth != null && (
        resource.data.rut_propietario == get(/databases/$(database)/documents/usuarios/$(request.auth.uid)).data.rut ||
        get(/databases/$(database)/documents/usuarios/$(request.auth.uid)).data.tipo_usuario == 'admin'
      );
    }
  }
}
```

## 4. Migración del Frontend

### Instalar dependencias
```bash
npm install firebase
npm install @firebase/firestore
npm install @firebase/auth
npm install @firebase/storage
```

### Configuración de Firebase (src/firebase/config.ts)
```typescript
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: "tu-api-key",
  authDomain: "tu-proyecto.firebaseapp.com",
  projectId: "tu-proyecto",
  storageBucket: "tu-proyecto.appspot.com",
  messagingSenderId: "123456789",
  appId: "tu-app-id"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export const storage = getStorage(app);
```

### Servicios de Firebase (src/services/)

#### authService.ts
```typescript
import { 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  User
} from 'firebase/auth';
import { doc, getDoc, setDoc } from 'firebase/firestore';
import { auth, db } from '../firebase/config';

export class AuthService {
  static async login(email: string, password: string) {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;
      
      // Obtener datos adicionales del usuario
      const userDoc = await getDoc(doc(db, 'usuarios', user.uid));
      if (userDoc.exists()) {
        return { ...user, ...userDoc.data() };
      }
      
      // Si no está en usuarios, buscar en propietarios
      const propietarioQuery = await getDocs(
        query(collection(db, 'propietarios'), 
        where('correo', '==', email))
      );
      
      if (!propietarioQuery.empty) {
        const propietario = propietarioQuery.docs[0];
        return { ...user, ...propietario.data(), tipo_usuario: 'propietario' };
      }
      
      return user;
    } catch (error) {
      throw error;
    }
  }
  
  static async logout() {
    await signOut(auth);
  }
  
  static onAuthStateChange(callback: (user: User | null) => void) {
    return onAuthStateChanged(auth, callback);
  }
}
```

#### propertyService.ts
```typescript
import { 
  collection, 
  addDoc, 
  updateDoc, 
  deleteDoc, 
  doc, 
  getDocs, 
  query, 
  where,
  orderBy,
  limit,
  startAfter
} from 'firebase/firestore';
import { ref, uploadBytes, getDownloadURL, deleteObject } from 'firebase/storage';
import { db, storage } from '../firebase/config';

export class PropertyService {
  static async getProperties(filters = {}) {
    try {
      let q = collection(db, 'propiedades');
      
      // Aplicar filtros
      if (filters.tipo) {
        q = query(q, where('idtipo_propiedad', '==', filters.tipo));
      }
      if (filters.minPrecio) {
        q = query(q, where('precio_uf', '>=', filters.minPrecio));
      }
      if (filters.maxPrecio) {
        q = query(q, where('precio_uf', '<=', filters.maxPrecio));
      }
      
      const snapshot = await getDocs(q);
      return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
      throw error;
    }
  }
  
  static async createProperty(propertyData: any, images: File[]) {
    try {
      // Subir imágenes
      const imageUrls = await Promise.all(
        images.map(async (image, index) => {
          const storageRef = ref(storage, `propiedades/${Date.now()}_${index}_${image.name}`);
          const snapshot = await uploadBytes(storageRef, image);
          return {
            url: await getDownloadURL(snapshot.ref),
            principal: index === 0,
            nombre: image.name
          };
        })
      );
      
      // Crear propiedad con URLs de imágenes
      const propertyWithImages = {
        ...propertyData,
        imagenes: imageUrls,
        fecha_publicacion: new Date(),
        estado: true
      };
      
      const docRef = await addDoc(collection(db, 'propiedades'), propertyWithImages);
      return { id: docRef.id, ...propertyWithImages };
    } catch (error) {
      throw error;
    }
  }
  
  static async updateProperty(id: string, propertyData: any) {
    try {
      const docRef = doc(db, 'propiedades', id);
      await updateDoc(docRef, propertyData);
      return { id, ...propertyData };
    } catch (error) {
      throw error;
    }
  }
  
  static async deleteProperty(id: string) {
    try {
      // Obtener imágenes para eliminarlas
      const docRef = doc(db, 'propiedades', id);
      const docSnap = await getDoc(docRef);
      
      if (docSnap.exists()) {
        const data = docSnap.data();
        // Eliminar imágenes del storage
        if (data.imagenes) {
          await Promise.all(
            data.imagenes.map(async (imagen: any) => {
              const imageRef = ref(storage, imagen.url);
              try {
                await deleteObject(imageRef);
              } catch (error) {
                console.log('Error eliminando imagen:', error);
              }
            })
          );
        }
      }
      
      // Eliminar documento
      await deleteDoc(docRef);
      return true;
    } catch (error) {
      throw error;
    }
  }
}
```

#### userService.ts
```typescript
import { 
  collection, 
  addDoc, 
  updateDoc, 
  deleteDoc, 
  doc, 
  getDocs 
} from 'firebase/firestore';
import { db } from '../firebase/config';

export class UserService {
  static async getUsers() {
    try {
      const snapshot = await getDocs(collection(db, 'usuarios'));
      return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
      throw error;
    }
  }
  
  static async createUser(userData: any) {
    try {
      const docRef = await addDoc(collection(db, 'usuarios'), {
        ...userData,
        fecha_creacion: new Date(),
        estado: true
      });
      return { id: docRef.id, ...userData };
    } catch (error) {
      throw error;
    }
  }
  
  static async updateUser(id: string, userData: any) {
    try {
      const docRef = doc(db, 'usuarios', id);
      await updateDoc(docRef, userData);
      return { id, ...userData };
    } catch (error) {
      throw error;
    }
  }
  
  static async deleteUser(id: string) {
    try {
      await deleteDoc(doc(db, 'usuarios', id));
      return true;
    } catch (error) {
      throw error;
    }
  }
}
```

## 5. Migración de Datos

### Script de migración (migrate-to-firebase.js)
```javascript
const mysql = require('mysql2/promise');
const { initializeApp } = require('firebase/app');
const { getFirestore, collection, addDoc } = require('firebase/firestore');

const firebaseConfig = {
  // Tu configuración de Firebase
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function migrateData() {
  // Conexión MySQL
  const mysqlConnection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'penka'
  });
  
  try {
    // Migrar usuarios
    const [usuarios] = await mysqlConnection.execute('SELECT * FROM usuarios');
    for (const usuario of usuarios) {
      await addDoc(collection(db, 'usuarios'), {
        rut: usuario.rut,
        nombres: usuario.nombres,
        ap_paterno: usuario.ap_paterno,
        ap_materno: usuario.ap_materno,
        usuario: usuario.usuario,
        tipo_usuario: usuario.tipo_usuario,
        estado: usuario.estado === 1,
        fecha_creacion: new Date()
      });
    }
    
    // Migrar propietarios
    const [propietarios] = await mysqlConnection.execute('SELECT * FROM propietarios');
    for (const propietario of propietarios) {
      await addDoc(collection(db, 'propietarios'), {
        rut: propietario.rut,
        nombre_completo: propietario.nombre_completo,
        fecha_nacimiento: propietario.fecha_nacimiento,
        correo: propietario.correo,
        sexo: propietario.sexo,
        telefono: propietario.telefono,
        fecha_creacion: new Date()
      });
    }
    
    // Migrar propiedades
    const [propiedades] = await mysqlConnection.execute('SELECT * FROM propiedades');
    for (const propiedad of propiedades) {
      await addDoc(collection(db, 'propiedades'), {
        rut_propietario: propiedad.rut_propietario,
        titulopropiedad: propiedad.titulopropiedad,
        descripcion: propiedad.descripcion,
        cant_banos: propiedad.cant_banos,
        cant_dormitorios: propiedad.cant_dormitorios,
        area_total: propiedad.area_total,
        precio_uf: propiedad.precio_uf,
        precio_pesos: propiedad.precio_pesos,
        idtipo_propiedad: propiedad.idtipo_propiedad,
        idsectores: propiedad.idsectores,
        fecha_publicacion: new Date(propiedad.fecha_publicacion),
        estado: propiedad.estado === 1
      });
    }
    
    console.log('Migración completada exitosamente');
  } catch (error) {
    console.error('Error en la migración:', error);
  } finally {
    await mysqlConnection.end();
  }
}

migrateData();
```

## 6. Actualización de Componentes

### Ejemplo: AdminDashboard con Firebase
```typescript
import React, { useState, useEffect } from 'react';
import { PropertyService } from '../services/propertyService';
import { UserService } from '../services/userService';
import { OwnerService } from '../services/ownerService';

const AdminDashboard: React.FC = () => {
  const [properties, setProperties] = useState([]);
  const [users, setUsers] = useState([]);
  const [owners, setOwners] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      const [propertiesData, usersData, ownersData] = await Promise.all([
        PropertyService.getProperties(),
        UserService.getUsers(),
        OwnerService.getOwners()
      ]);
      
      setProperties(propertiesData);
      setUsers(usersData);
      setOwners(ownersData);
    } catch (error) {
      console.error('Error cargando datos:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteProperty = async (id: string) => {
    try {
      await PropertyService.deleteProperty(id);
      await loadData(); // Recargar datos
    } catch (error) {
      console.error('Error eliminando propiedad:', error);
    }
  };

  // ... resto del componente
};
```

## 7. Despliegue

### Build y deploy
```bash
npm run build
firebase deploy
```

## 8. Ventajas de la Migración

✅ **Sin servidor propio** - No más problemas con Node.js  
✅ **Escalabilidad automática** - Firebase maneja todo  
✅ **Base de datos en tiempo real** - Actualizaciones automáticas  
✅ **Autenticación robusta** - Firebase Auth  
✅ **Almacenamiento de archivos** - Firebase Storage  
✅ **Hosting automático** - Firebase Hosting  
✅ **Reglas de seguridad** - Firestore Security Rules  
✅ **Backup automático** - Sin configuración adicional  
✅ **Monitoreo integrado** - Firebase Console  
✅ **CDN global** - Mejor rendimiento  

## 9. Costos Estimados

- **Firebase Spark Plan (Gratis)**: Hasta 50,000 lecturas/día, 20,000 escrituras/día
- **Firebase Blaze Plan**: $0.18 por 100,000 lecturas, $0.18 por 100,000 escrituras
- **Storage**: $0.026 por GB/mes
- **Hosting**: Gratis hasta 10GB/mes

Para una aplicación inmobiliaria típica, el plan gratuito debería ser suficiente para empezar. 
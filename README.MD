# 🚀 TODO List Application

Una aplicación completa de lista de tareas construida con **Vue.js**, **Node.js/Express** y **MySQL**, completamente containerizada con **Docker**.

## 🛠️ Tecnologías Utilizadas

### Frontend

- **Vue.js 3** - Framework de JavaScript
- **Vue Router 4** - Manejo de rutas
- **Axios** - Cliente HTTP para APIs
- **CSS3** - Estilos y diseño responsive

### Backend

- **Node.js** - Entorno de ejecución
- **Express.js** - Framework web
- **JWT** - Autenticación con tokens
- **bcryptjs** - Encriptación de contraseñas
- **CORS** - Manejo de peticiones cruzadas

### Base de Datos

- **MySQL 8.0** - Base de datos relacional

### Containerización

- **Docker** - Contenedores de aplicación
- **Docker Compose** - Orquestación de contenedores

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker instalado
- Docker Compose instalado

### Iniciar la Aplicación

#### Opción 1: Script Automatizado (Recomendado)

**Windows:**

```cmd
start-app.bat
```

**Linux/Mac:**

```
./start-app.sh
```

#### Opción 2: Manualmente

1. Clona el repositorio:

   ```
   git clone https://github.com/tu-usuario/tu-repositorio.git
    cd tu-repositorio
   ```

2. Construye y levanta los contenedores con Docker Compose:

   ```
   docker-compose up --build -d
   ```

3. Accede a la aplicación en tu navegador:
   ```
   http://localhost:8080
   ```

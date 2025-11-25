@echo off
echo ========================================
echo    INICIANDO TODO APP CON DOCKER
echo ========================================
echo.

echo Verificando Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker no esta instalado o no esta en el PATH
    echo Por favor, instala Docker Desktop desde: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo Verificando Docker Compose...
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker Compose no esta disponible
    pause
    exit /b 1
)

echo.
echo Limpiando contenedores previos...
docker-compose down

echo.
echo Construyendo y iniciando contenedores...
echo Esto puede tomar varios minutos la primera vez...
echo.

docker-compose up --build

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Ocurrio un problema al iniciar la aplicacion
    echo.
    echo Soluciones posibles:
    echo 1. Verifica que Docker este ejecutandose
    echo 2. Verifica que los puertos 8080, 3000 y 3306 esten libres
    echo 3. Ejecuta 'docker system prune -f' para limpiar recursos
    echo.
    pause
) else (
    echo.
    echo Aplicacion detenida correctamente
)

pause
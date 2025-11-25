@echo off
echo Deteniendo la aplicacion TODO App...
docker-compose down

if %errorlevel% equ 0 (
    echo Aplicacion detenida correctamente
) else (
    echo Error al detener la aplicacion
)

pause
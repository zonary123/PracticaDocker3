#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "========================================"
echo "    INICIANDO TODO APP CON DOCKER"
echo "========================================"
echo -e "${NC}"

# Verificar si Docker está instalado
echo -e "${YELLOW}Verificando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Docker no está instalado o no está en el PATH${NC}"
    echo "Por favor, instala Docker desde: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar si Docker Compose está instalado
echo -e "${YELLOW}Verificando Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}ERROR: Docker Compose no está disponible${NC}"
    exit 1
fi

# Verificar que Docker esté ejecutándose
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}ERROR: Docker no está ejecutándose${NC}"
    echo "Por favor, inicia Docker Desktop o el servicio de Docker"
    exit 1
fi

# Limpiar contenedores previos
echo -e "${YELLOW}Limpiando contenedores previos...${NC}"
docker-compose down

# Construir e iniciar contenedores
echo -e "${YELLOW}Construyendo y iniciando contenedores...${NC}"
echo -e "${YELLOW}Esto puede tomar varios minutos la primera vez...${NC}"
echo

# Verificar si se pasa el flag -d para detached mode
if [ "$1" = "-d" ] || [ "$1" = "--detach" ]; then
    echo -e "${GREEN}Iniciando en segundo plano...${NC}"
    docker-compose up --build -d
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}✅ Aplicación iniciada correctamente en segundo plano${NC}"
        echo
        echo -e "${BLUE}📱 Frontend:${NC} http://localhost:8080"
        echo -e "${BLUE}🔙 Backend:${NC}  http://localhost:3000"
        echo -e "${BLUE}🗃️  MySQL:${NC}    localhost:3306"
        echo
        echo -e "${YELLOW}Para ver los logs:${NC} docker-compose logs -f"
        echo -e "${YELLOW}Para detener:${NC}     docker-compose down"
        echo
    else
        echo -e "${RED}❌ Error al iniciar la aplicación${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Iniciando en primer plano...${NC}"
    echo -e "${YELLOW}Presiona Ctrl+C para detener la aplicación${NC}"
    echo
    docker-compose up --build
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}✅ Aplicación detenida correctamente${NC}"
    else
        echo
        echo -e "${RED}❌ Error en la aplicación${NC}"
        exit 1
    fi
fi
#!/bin/bash

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "========================================"
echo "    ESTADO DE LA APLICACION TODO APP"
echo "========================================"
echo -e "${NC}"

# Verificar contenedores
echo -e "${YELLOW}Contenedores en ejecución:${NC}"
docker-compose ps

echo
echo -e "${YELLOW}Últimos logs:${NC}"
docker-compose logs --tail=20

echo
echo -e "${YELLOW}Uso de recursos:${NC}"
docker stats --no-stream $(docker-compose ps -q) 2>/dev/null || echo "No hay contenedores ejecutándose"

echo
echo -e "${GREEN}URLs de la aplicación:${NC}"
echo -e "Frontend: http://localhost:8080"
echo -e "Backend:  http://localhost:3000"
echo -e "MySQL:    localhost:3306"
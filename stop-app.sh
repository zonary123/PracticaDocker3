#!/bin/bash

echo "Deteniendo la aplicación TODO App..."
docker-compose down

if [ $? -eq 0 ]; then
    echo "✅ Aplicación detenida correctamente"
else
    echo "❌ Error al detener la aplicación"
    exit 1
fi
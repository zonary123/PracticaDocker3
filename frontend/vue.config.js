module.exports = {
  devServer: {
    host: '0.0.0.0',       // Permite acceso desde otras máquinas / contenedores
    port: 8080,
    https: false,          // Cambia a true si quieres HTTPS
    client: {
      webSocketURL: {
        protocol: 'ws',    // Usa 'wss' si tu servidor es HTTPS
        hostname: 'localhost', // o la IP del contenedor
        port: 8080,
        pathname: '/ws'
      }
    }
  }
}

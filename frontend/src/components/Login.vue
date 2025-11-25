<template>
  <div class="login-container">
    <div class="login-form">
      <h1>Aplicación de Tareas</h1>
      <form @submit.prevent="handleSubmit">
        <div class="form-group">
          <label>Usuario</label>
          <input
            type="text"
            v-model="form.username"
            required
            placeholder="Ingresa tu usuario"
          />
        </div>
        <div class="form-group">
          <label>Contraseña</label>
          <input
            type="password"
            v-model="form.password"
            required
            placeholder="Ingresa tu contraseña"
          />
        </div>
        <button type="submit" :disabled="loading">
          {{ isLogin ? 'Iniciar Sesión' : 'Registrarse' }}
        </button>
        <p class="toggle-text" @click="isLogin = !isLogin">
          {{
            isLogin
              ? '¿Necesitas una cuenta? Regístrate'
              : '¿Ya tienes cuenta? Inicia Sesión'
          }}
        </p>
        <p v-if="error" class="error">{{ error }}</p>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const API_URL = 'http://localhost:3000/api';

export default {
  name: 'InicioSesion',
  data() {
    return {
      isLogin: true,
      loading: false,
      error: '',
      form: {
        username: '',
        password: ''
      }
    };
  },
  methods: {
    async handleSubmit() {
      this.loading = true;
      this.error = '';

      try {
        const endpoint = this.isLogin ? '/login' : '/register';
        const response = await axios.post(`${API_URL}${endpoint}`, this.form);

        if (this.isLogin) {
          localStorage.setItem('token', response.data.token);
          localStorage.setItem('username', response.data.username);
          this.$router.push('/todos');
        } else {
          this.isLogin = true;
          this.error = '¡Registro exitoso! Por favor inicia sesión.';
        }
      } catch (error) {
        this.error = error.response?.data?.error || 'Ocurrió un error';
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 20px;
}

.login-form {
  background: white;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 400px;
}

h1 {
  text-align: center;
  margin-bottom: 2rem;
  color: #333;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  color: #555;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #ddd;
  border-radius: 5px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

input:focus {
  outline: none;
  border-color: #667eea;
}

button {
  width: 100%;
  padding: 0.75rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: opacity 0.3s;
}

button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.toggle-text {
  text-align: center;
  margin-top: 1rem;
  color: #667eea;
  cursor: pointer;
  text-decoration: underline;
}

.error {
  color: #e74c3c;
  text-align: center;
  margin-top: 1rem;
}
</style>

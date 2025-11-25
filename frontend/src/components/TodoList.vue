<template>
  <div class="todo-container">
    <header class="header">
      <h1>My TODO List</h1>
      <div class="user-info">
        <span>Welcome, {{ username }}</span>
        <button @click="logout" class="logout-btn">Logout</button>
      </div>
    </header>

    <div class="todo-content">
      <div class="add-todo">
        <input
          v-model="newTodo.title"
          placeholder="What needs to be done?"
          @keyup.enter="addTodo"
          class="todo-input"
        />
        <textarea
          v-model="newTodo.description"
          placeholder="Description (optional)"
          class="todo-textarea"
        ></textarea>
        <button @click="addTodo" class="add-btn">Add Task</button>
      </div>

      <div class="todos-list">
        <div
          v-for="todo in todos"
          :key="todo.id"
          :class="['todo-item', { completed: todo.completed }]"
        >
          <div class="todo-content">
            <input
              type="checkbox"
              v-model="todo.completed"
              @change="updateTodo(todo)"
              class="checkbox"
            />
            <div class="todo-text">
              <h3>{{ todo.title }}</h3>
              <p v-if="todo.description">{{ todo.description }}</p>
              <small>Created: {{ formatDate(todo.created_at) }}</small>
            </div>
          </div>
          <button @click="deleteTodo(todo.id)" class="delete-btn">
            Delete
          </button>
        </div>

        <p v-if="todos.length === 0" class="empty-message">
          No tasks yet. Add your first task above!
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const API_URL = 'http://localhost:3000/api';

export default {
  name: 'TodoList',
  data() {
    return {
      todos: [],
      newTodo: {
        title: '',
        description: ''
      },
      username: ''
    };
  },
  async mounted() {
    this.username = localStorage.getItem('username');
    await this.loadTodos();
  },
  methods: {
    async loadTodos() {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`${API_URL}/todos`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        this.todos = response.data;
      } catch (error) {
        console.error('Error loading todos:', error);
      }
    },
    async addTodo() {
      if (!this.newTodo.title.trim()) return;

      try {
        const token = localStorage.getItem('token');
        const response = await axios.post(`${API_URL}/todos`, this.newTodo, {
          headers: { Authorization: `Bearer ${token}` }
        });

        this.todos.unshift(response.data);
        this.newTodo = { title: '', description: '' };
      } catch (error) {
        console.error('Error adding todo:', error);
      }
    },
    async updateTodo(todo) {
      try {
        const token = localStorage.getItem('token');
        await axios.put(`${API_URL}/todos/${todo.id}`, todo, {
          headers: { Authorization: `Bearer ${token}` }
        });
      } catch (error) {
        console.error('Error updating todo:', error);
      }
    },
    async deleteTodo(todoId) {
      try {
        const token = localStorage.getItem('token');
        await axios.delete(`${API_URL}/todos/${todoId}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        this.todos = this.todos.filter((todo) => todo.id !== todoId);
      } catch (error) {
        console.error('Error deleting todo:', error);
      }
    },
    logout() {
      localStorage.removeItem('token');
      localStorage.removeItem('username');
      this.$router.push('/login');
    },
    formatDate(dateString) {
      return new Date(dateString).toLocaleDateString();
    }
  }
};
</script>

<style scoped>
.todo-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: white;
  padding: 1rem 2rem;
  border-radius: 10px;
  margin-bottom: 2rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

h1 {
  color: #333;
  margin: 0;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.logout-btn {
  background: #e74c3c;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
}

.todo-content {
  max-width: 800px;
  margin: 0 auto;
}

.add-todo {
  background: white;
  padding: 1.5rem;
  border-radius: 10px;
  margin-bottom: 2rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.todo-input,
.todo-textarea {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #ddd;
  border-radius: 5px;
  margin-bottom: 1rem;
  font-size: 1rem;
}

.todo-input:focus,
.todo-textarea:focus {
  outline: none;
  border-color: #667eea;
}

.todo-textarea {
  min-height: 80px;
  resize: vertical;
}

.add-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
}

.todos-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.todo-item {
  background: white;
  padding: 1.5rem;
  border-radius: 10px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
}

.todo-item:hover {
  transform: translateY(-2px);
}

.todo-item.completed {
  opacity: 0.7;
}

.todo-content {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  flex: 1;
}

.checkbox {
  margin-top: 0.25rem;
}

.todo-text h3 {
  margin: 0 0 0.5rem 0;
  color: #333;
}

.todo-item.completed .todo-text h3 {
  text-decoration: line-through;
  color: #999;
}

.todo-text p {
  margin: 0 0 0.5rem 0;
  color: #666;
}

.todo-text small {
  color: #999;
}

.delete-btn {
  background: #e74c3c;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
}

.empty-message {
  text-align: center;
  color: white;
  font-size: 1.2rem;
  margin-top: 2rem;
}
</style>

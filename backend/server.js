const express = require('express')
const mysql = require('mysql2/promise')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const cors = require('cors')

const app = express()
const PORT = 3000
const JWT_SECRET = 'your-secret-key'

app.use(express.json())
app.use(cors())

// Database connection
const dbConfig = {
  host: process.env.DB_HOST || 'mysql',
  user: process.env.DB_USER || 'todo_user',
  password: process.env.DB_PASSWORD || 'todo_password',
  database: process.env.DB_NAME || 'todo_db'
}

// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization']
  const token = authHeader && authHeader.split(' ')[1]

  if (!token) {
    return res.status(401).json({ error: 'Access token required' })
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' })
    }
    req.user = user
    next()
  })
}

// Routes

// Register
app.post('/api/register', async (req, res) => {
  try {
    const { username, password } = req.body
    const connection = await mysql.createConnection(dbConfig)

    // Check if user exists
    const [
      existingUsers
    ] = await connection.execute('SELECT id FROM users WHERE username = ?', [
      username
    ])

    if (existingUsers.length > 0) {
      return res.status(400).json({ error: 'User already exists' })
    }

    // Hash password and create user
    const hashedPassword = await bcrypt.hash(password, 10)
    await connection.execute(
      'INSERT INTO users (username, password) VALUES (?, ?)',
      [username, hashedPassword]
    )

    await connection.end()
    res.status(201).json({ message: 'User created successfully' })
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' })
  }
})

// Login
app.post('/api/login', async (req, res) => {
  try {
    const { username, password } = req.body
    const connection = await mysql.createConnection(dbConfig)

    // Find user
    const [
      users
    ] = await connection.execute('SELECT * FROM users WHERE username = ?', [
      username
    ])

    if (users.length === 0) {
      return res.status(400).json({ error: 'Invalid credentials' })
    }

    const user = users[0]

    // Check password
    const validPassword = await bcrypt.compare(password, user.password)
    if (!validPassword) {
      return res.status(400).json({ error: 'Invalid credentials' })
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, username: user.username },
      JWT_SECRET
    )

    await connection.end()
    res.json({ token, username: user.username })
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' })
  }
})

// Get todos
app.get('/api/todos', authenticateToken, async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig)
    const [
      todos
    ] = await connection.execute(
      'SELECT * FROM todos WHERE user_id = ? ORDER BY created_at DESC',
      [req.user.id]
    )
    await connection.end()
    res.json(todos)
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' })
  }
})

// Create todo
app.post('/api/todos', authenticateToken, async (req, res) => {
  try {
    const { title, description } = req.body
    const connection = await mysql.createConnection(dbConfig)

    const [
      result
    ] = await connection.execute(
      'INSERT INTO todos (user_id, title, description, completed) VALUES (?, ?, ?, ?)',
      [req.user.id, title, description, false]
    )

    const [
      newTodo
    ] = await connection.execute('SELECT * FROM todos WHERE id = ?', [
      result.insertId
    ])

    await connection.end()
    res.status(201).json(newTodo[0])
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' })
  }
})

// Update todo
app.put('/api/todos/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params
    const { title, description, completed } = req.body
    const connection = await mysql.createConnection(dbConfig)

    await connection.execute(
      'UPDATE todos SET title = ?, description = ?, completed = ? WHERE id = ? AND user_id = ?',
      [title, description, completed, id, req.user.id]
    )

    await connection.end()
    res.json({ message: 'Todo updated successfully' })
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' })
  }
})

// Delete todo
app.delete('/api/todos/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params
    const connection = await mysql.createConnection(dbConfig)

    await connection.execute('DELETE FROM todos WHERE id = ? AND user_id = ?', [
      id,
      req.user.id
    ])

    await connection.end()
    res.json({ message: 'Todo deleted successfully' })
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' })
  }
})

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})

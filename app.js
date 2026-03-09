const express = require('express');
const app = express();
app.use(express.json());

// 1. GET /health
app.get('/health', (req, res) => res.status(200).json({ status: 'UP' }));

// 2. GET /status
app.get('/status', (req, res) => res.status(200).json({ status: 'Ready', env: 'Production' }));

// 3. POST /process
app.post('/process', (req, res) => {
    console.log("Processing data:", req.body);
    res.status(201).json({ message: 'Data processed successfully' });
});

app.listen(3000, '0.0.0.0', () => console.log('Server running on port 3000'));

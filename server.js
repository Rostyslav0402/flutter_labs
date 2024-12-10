const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());

// Базова URL для API
const BASE_URL = 'https://newsapi.org/v2/';
const API_KEY = '141221c6e9a846e3abc0a1047ba8195f';

// Універсальна функція для виконання запитів
const fetchData = async (endpoint) => {
    try {
        const response = await axios.get(${BASE_URL}${endpoint}, {
            headers: {
                'X-Auth-Token': API_KEY,
            },
        });
        return response.data;
    } catch (error) {
        throw new Error(Error fetching data: ${error.message});
    }
};

// Маршрут для отримання новин про техніку
app.get('/api/technews', async (req, res) => {
    try {
        //параметр'tech' новин про техніку
        const data = await fetchData(everything?q=tech&from=2024-11-21&to=2024-11-21&sortBy=popularity&apiKey=${API_KEY});
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Запуск сервера
app.listen(port, () => {
    console.log(Server running at http://localhost:${port});
});
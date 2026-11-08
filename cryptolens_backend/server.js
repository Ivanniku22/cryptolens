const express = require("express");
const axios = require("axios");
const NodeCache = require("node-cache");
const cors = require("cors");

const app = express();
const cache = new NodeCache({ stdTTL: 60 });

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const COINPAPRIKA_API = "https://api.coinpaprika.com/v1";

// Health check
app.get("/", (req, res) => {
  res.json({
    message: "CryptoLens backend is running!",
  });
});

// Get cryptocurrency list
app.get("/api/coins", async (req, res) => {
  try {
    const cachedCoins = cache.get("coins");

    if (cachedCoins) {
      return res.json(cachedCoins);
    }

    const response = await axios.get(`${COINPAPRIKA_API}/tickers`, {
      params: { quotes: "USD" },
    });

    cache.set("coins", response.data);

    res.json(response.data);
  } catch (error) {
    console.error("Error fetching coins:", error.message);

    res.status(500).json({
      message: "Failed to fetch cryptocurrency data.",
    });
  }
});

// Get individual coin ticker
app.get("/api/coins/:id", async (req, res) => {
  try {
    const coinId = req.params.id;
    const cacheKey = `coin_${coinId}`;

    const cachedCoin = cache.get(cacheKey);

    if (cachedCoin) {
      return res.json(cachedCoin);
    }

    const response = await axios.get(`${COINPAPRIKA_API}/tickers/${coinId}`, {
      params: { quotes: "USD" },
    });

    cache.set(cacheKey, response.data);

    res.json(response.data);
  } catch (error) {
    console.error("Error fetching coin:", error.message);

    res.status(500).json({
      message: "Failed to fetch coin details.",
    });
  }
});

// Get coin information/details
app.get("/api/coin-info/:id", async (req, res) => {
  try {
    const coinId = req.params.id;
    const cacheKey = `coin_info_${coinId}`;

    const cachedData = cache.get(cacheKey);

    if (cachedData) {
      return res.json(cachedData);
    }

    const response = await axios.get(`${COINPAPRIKA_API}/coins/${coinId}`);

    cache.set(cacheKey, response.data);

    res.json(response.data);
  } catch (error) {
    console.error("Error fetching coin information:", error.message);

    res.status(500).json({
      message: "Failed to fetch coin information.",
    });
  }
});

// Get historical price data
app.get("/api/coins/:id/historical", async (req, res) => {
  try {
    const coinId = req.params.id;
    const { start, interval, quote = "usd" } = req.query;

    const cacheKey = `history_${coinId}_${start}_${interval}_${quote}`;

    const cachedData = cache.get(cacheKey);

    if (cachedData) {
      return res.json(cachedData);
    }

    const response = await axios.get(
      `${COINPAPRIKA_API}/tickers/${coinId}/historical`,
      {
        params: {
          start,
          interval,
          quote,
        },
      },
    );

    cache.set(cacheKey, response.data);

    res.json(response.data);
  } catch (error) {
    console.error("Error fetching historical data:", error.message);

    res.status(500).json({
      message: "Failed to fetch historical price data.",
    });
  }
});

app.listen(PORT, () => {
  console.log(`CryptoLens backend running at http://localhost:${PORT}`);
});

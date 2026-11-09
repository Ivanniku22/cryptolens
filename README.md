# CryptoLens
### Cryptocurrency Market Research App

CryptoLens is a Flutter-based cryptocurrency research application that provides users with an overview of the cryptocurrency market. It integrates the CoinPaprika API through a Node.js backend to display market information, historical price data, and cryptocurrency details.

## Features

- **Cryptocurrency Market:** Browse cryptocurrency listings with prices and market information.
- **Search:** Search coins by name or symbol.
- **Sorting:** Sort cryptocurrencies by market capitalization, price, top gainers, and top losers.
- **Coin Details:** View individual cryptocurrency prices, market statistics, and coin information.
- **Historical Price Charts:** Interactive charts with multiple time ranges and price tooltips.
- **Watchlist:** Add or remove cryptocurrencies from a personalized watchlist.
- **Pagination:** Load cryptocurrency listings progressively.
- **API Integration:** Fetch market data and historical information through a backend service.
- **Caching:** Backend caching to reduce repeated API requests.
- **Error Handling:** Loading, error, and empty states for data requests.
- **Dark UI:** Dark-themed interface with green accents.

## Technology Stack

### Mobile Application
- Flutter
- Dart
- GetX — State management and dependency injection
- Dio — HTTP communication
- GetStorage — Local watchlist persistence

### Backend
- Node.js
- Express.js
- Axios
- NodeCache
- CORS

### Data Source
- [CoinPaprika API](https://api.coinpaprika.com/)

## Architecture

CryptoLens follows a layered architecture:

- **Presentation Layer:** Screens, controllers, and UI components.
- **Data Layer:** Models and repositories.
- **Service Layer:** API communication.
- **Backend:** Express REST API with caching.
- **External API:** CoinPaprika cryptocurrency data.

The Flutter application communicates with the backend, which retrieves and caches data from CoinPaprika.

## Backend API

The backend is deployed on Render:

**Base URL:**  
https://cryptolens-backend-irqi.onrender.com/api

| Endpoint | Description |
|---|---|
| `GET /coins` | Retrieve cryptocurrency listings |
| `GET /coins/:id` | Retrieve ticker information for a coin |
| `GET /coin-info/:id` | Retrieve coin metadata |
| `GET /coins/:id/historical` | Retrieve historical price data |

The backend uses in-memory caching with a 60-second cache duration.

## Running the Backend Locally

### Requirements
- Node.js
- npm

### Installation

```bash
cd cryptolens_backend
npm install
npm start
```

The backend runs locally on port 3000 by default.

Health check:

```text
http://localhost:3000/
```

## Running the Flutter Application

### Requirements
- Flutter SDK
- Dart SDK
- Android Studio or another Flutter-compatible IDE

### Installation

```bash
flutter pub get
flutter run
```

The Flutter application is configured to use the deployed backend by default.

## Building the APK

Generate a release APK using:

```bash
flutter build apk --release
```

APK output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Screenshots

_Add application screenshots here._

## Notes

- The backend uses Render's free hosting service.
- The backend may take some time to respond after periods of inactivity because the free service can spin down.
- The application requires an internet connection to retrieve cryptocurrency market data.
- Watchlist data is stored locally on the device.

## Project Purpose

CryptoLens was developed as a Flutter application project to demonstrate mobile application development, REST API integration, state management, backend communication, caching, and cryptocurrency market data visualization.

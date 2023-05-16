# ITCS424-FlutterProject (Weather Application)

The **Weather Application** is a Flutter application consisting of five pages that provide various weather-related features:

1. **Current Weather Page:** This page displays the current weather information based on the user's current location. It provides details such as temperature, weather condition, humidity, wind speed, and more.
2. **Search Weather Page:** This page allows users to search for the current weather of a specific city. Users can input the name of the city, and the app will fetch and display the corresponding weather information, including temperature, weather condition, and other relevant data.
3. **Weather Forecast Page:** This page presents a 5-day weather forecast, providing weather information for every 3 hours. Users can view the forecasted temperature, weather condition, and other relevant details for each time interval.
4. **Air Pollution Page:** The air pollution page provides real-time information about the air quality at the user's current location. It displays details such as air pollution index, pollutants concentration, and air quality level. This information helps users stay informed about the air quality in their vicinity.
5. **Settings Page:** The settings page allows users to customize the displayed unit of temperature according to their preferences. Users can choose between Celsius, Fahrenheit, or any other supported temperature units. This feature enables users to personalize the app based on their preferred unit of measurement.

## Developed By
- 6388064 Khunathip Suravanit
- 6388104 Peerawat Sorosthunyapong

## Getting Started

To run this project on your local machine, follow these steps:

### Prerequisites

- Flutter SDK (version >=2.19.2 <3.0.0)
- Dart SDK

### Installing

1. Clone the repository to your local machine.
2. Open the project in your preferred IDE or editor.
3. Run the following command in the project directory to get the required dependencies:

   ```bash
   flutter pub get
   ```
   
### Running the App

1. Connect your device or emulator.
2. Run the following command to start the app:

    ```bash
   flutter run
   ```
   
### Dependencies

This project relies on the following dependencies:

- Flutter SDK (>=2.19.2 <3.0.0)
- cupertino_icons (version ^1.0.2)
- geolocator (version ^9.0.2)
- http (version ^0.13.5)
- intl (version ^0.18.1)
- shared_preferences (version ^2.1.1)

### Development Dependencies

The following dev dependencies are used for testing:

- flutter_test (included in the Flutter SDK)

Project2-MileStone3

-Wei Miao

- App title: WeatherBuddy

This app can not run on emulator due to updating googlePlay service error, so please test on Android devices.

Apk available on PlayStore: https://play.google.com/store/apps/details?id=com.mad.weimiao.weatherbuddy

- Work in milestone3:

1. Refine UI and add landscape view.

2. Add background image which would change with the weather condition.

3. Add Help menu button and help content in a dialog view.

4. Fix a bug that the zip code text area is covered by the soft-keyboard when typing in the zip code.

- Future plan:

1. Add favorite button for users to save their favorite locations.

2. Add users nick name feature that allow users to set their nick name and the App will call the nick name when it reporting the weather.

- User Flow:

1. At start, the app will locate to current location as default location. Click the "GetWeather" button then the App will report the current weather of current location, and show weather info on the map.

2. To change location, drag the marker(long press) on map directly or input the zip code. Then click "GetWeather" to get current weather of the selected location.

3. To back to the current location, click the "Current Location" icon on map; To zoom in and out, use pinch gesture or use the "+/-" toolbar on the map.

4. When the "GetWeather" button clicked, the App will check the zip code EditText first, if it is empty, App will get location from map marker; if the zip code area is not empty, but it is not in 5-digit format, the app will alert user in voice; if the zip code in 5-digit numbers, the App will show the zip code location on map and report the current weather of it.

- Functionality logic:

1. App start -> get location(default or user input) -> get weather of selected location -> display weather on map and report weather in voice.

2. On the first time start after installation, the app will check and ask permission for location.

3. The app gets location from google maps API and get weather from weather API.

- Reference:

Google maps API for Android:

https://developers.google.com/maps/documentation/android-api/start

https://github.com/googlemaps/android-samples

Openweathermap API for Android:

https://openweathermap.org/current

https://openweathermap.org/examples

Android Text to Speech:

https://developer.android.com/reference/android/speech/tts/TextToSpeech.html

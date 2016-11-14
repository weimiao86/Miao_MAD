package com.mad.weimiao.weatherbuddy;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnMyLocationButtonClickListener;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.mad.weimiao.weatherbuddy.model.Weather;
import com.mad.weimiao.weatherbuddy.model.ZipToLatLon;

import org.json.JSONException;

import java.util.HashMap;
import java.util.Locale;

public class MainActivity extends AppCompatActivity
        implements
        OnMyLocationButtonClickListener,
        OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback,
        GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener,
        GoogleMap.OnMarkerDragListener,
        LocationListener,
        TextToSpeech.OnInitListener,
        View.OnTouchListener {

    // Request code for location permission request.
    private static final int LOCATION_PERMISSION_REQUEST_CODE = 1;

    //Flag indicating whether a requested permission has been denied after returning in
    private boolean mPermissionDenied = false;

    private GoogleMap mMap;
    private GoogleApiClient mGoogleApiClient;
    private LatLng latLng;
    private Marker currLocationMarker;
    private EditText zipEditText;
    private int PLACE_MARKER_AT_CURRENT_LOCATION = 1;
    private String CITY_TEXT;
    private String COUNTRY_TEXT;
    private String COND_MAIN;
    private String COND_DESCRIPTION;
    private String TEMP_TEXT;
    private String MIN_TEMP_TEXT;
    private String MAX_TEMP_TEXT;
    private String WIND_SPEED;
    private String WEATHER_TEXT = "";
    private TextToSpeech tts;
    private String reportText = "";
    private String TEMP_UNIT;
    private String SPEED_UNIT;
    private Integer CF = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        MapFragment mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
        tts = new TextToSpeech(this, this);

        //toolbar
        Toolbar toolbar = (Toolbar)findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //EditText on focus listener
        zipEditText = (EditText)findViewById(R.id.zipEditText);
        zipEditText.setOnTouchListener(this);

    }

    //clear zip text field when tapped.
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if(v.getId() == R.id.zipEditText && event.getAction() == MotionEvent.ACTION_DOWN){
            zipEditText.getText().clear();
        }
        return false;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu){
        getMenuInflater().inflate(R.menu.toolbar_layout, menu);
        return true;
    }

    @Override
    public void onPause() {
        if (tts != null) {
            tts.stop();
        }
        super.onPause();
        //Unregister for location callbacks:
        if (mGoogleApiClient != null && mGoogleApiClient.isConnected()) {
            LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
        }
    }

    @Override
    public void onDestroy() {
        if (tts != null) {
            tts.stop();
            tts.shutdown();
        }
        super.onDestroy();
    }

    @Override
    public void onResume() {
        if (mGoogleApiClient != null) {
            LocationRequest mLocationRequest = new LocationRequest();
            mLocationRequest.setInterval(5000); //5 seconds
            mLocationRequest.setFastestInterval(3000); //3 seconds
            mLocationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED) {

                return;
            }
            LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
        }
        super.onResume();
    }


    //reference https://developers.google.com/maps/documentation/android-api/location
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode != LOCATION_PERMISSION_REQUEST_CODE) {
            return;
        }
        if (PermissionUtils.isPermissionGranted(permissions, grantResults,
                Manifest.permission.ACCESS_FINE_LOCATION)) {
            // Enable the my location layer if the permission has been granted.
            enableMyLocation();
        } else {
            // Display the missing permission error dialog when the fragments resume.
            mPermissionDenied = true;
        }
    }

    //give error message if no permission
    private void showMissingPermissionError() {
        PermissionUtils.PermissionDeniedDialog
                .newInstance(true).show(getSupportFragmentManager(), "dialog");
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        mMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
        mMap.setOnMyLocationButtonClickListener(this);
        enableMyLocation();
        buildGoogleApiClient();
        mGoogleApiClient.connect();
        mMap.getUiSettings().setMapToolbarEnabled(false);
        mMap.getUiSettings().setZoomControlsEnabled(true);
        mMap.setOnMarkerDragListener(this);
        mMap.setInfoWindowAdapter(new GoogleMap.InfoWindowAdapter() {
            // Use default InfoWindow frame
            @Override
            public View getInfoWindow(Marker arg0) {
                return null;
            }
            // Defines the contents of the InfoWindow
            @Override
            public View getInfoContents(Marker arg0) {
                // Getting view from the layout file info_window_layout
                @SuppressLint("InflateParams")
                View infoWindow = getLayoutInflater().inflate(R.layout.map_info_window, null);
                TextView weather_city = (TextView) infoWindow.findViewById(R.id.weather_city);
                TextView weather_country = (TextView) infoWindow.findViewById(R.id.weather_country);
                TextView weather_main = (TextView) infoWindow.findViewById(R.id.weather_main);
                TextView weather_detail = (TextView) infoWindow.findViewById(R.id.weather_detail);
                TextView weather_tempV = (TextView) infoWindow.findViewById(R.id.weather_temp_value);
                TextView weather_tempMax = (TextView) infoWindow.findViewById(R.id.weather_temp_maxV);
                TextView weather_tempMin = (TextView) infoWindow.findViewById(R.id.weather_temp_minV);
                TextView weather_windSpeed = (TextView) infoWindow.findViewById(R.id.weather_windSpeedV);

                weather_city.setText(CITY_TEXT);
                weather_country.setText(COUNTRY_TEXT);
                weather_main.setText(COND_MAIN);
                weather_detail.setText(COND_DESCRIPTION);
                if(CF == 0) {
                    weather_tempV.setText(String.format("%s°F", TEMP_TEXT));
                    weather_tempMax.setText(String.format("%s°F", MAX_TEMP_TEXT));
                    weather_tempMin.setText(String.format("%s°F", MIN_TEMP_TEXT));
                    weather_windSpeed.setText(String.format("%s mph", WIND_SPEED));
                }
                if(CF == 1){
                    weather_tempV.setText(String.format("%s°C", TEMP_TEXT));
                    weather_tempMax.setText(String.format("%s°C", MAX_TEMP_TEXT));
                    weather_tempMin.setText(String.format("%s°C", MIN_TEMP_TEXT));
                    weather_windSpeed.setText(String.format("%s kph", WIND_SPEED));
                }
                // Returning the view containing InfoWindow contents
                return infoWindow;
            }
        });
    }

    protected synchronized void buildGoogleApiClient() {
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build();
    }

    // Enables the My Location layer if got the fine location permission.
    private void enableMyLocation() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            // no access Permission
            PermissionUtils.requestPermission(this, LOCATION_PERMISSION_REQUEST_CODE,
                    Manifest.permission.ACCESS_FINE_LOCATION, true);
        } else if (mMap != null) {
            // get the access Permission
            mMap.setMyLocationEnabled(true);
        }
    }

    @Override
    public boolean onMyLocationButtonClick() {
        PLACE_MARKER_AT_CURRENT_LOCATION = 1;
        EditText zipText = (EditText)findViewById(R.id.zipEditText);
        zipText.setText("");
        return false;//don't consume the event, just keep the default behavior
    }

    @Override
    protected void onResumeFragments() {
        super.onResumeFragments();
        if (mPermissionDenied) {
            // Permission was not granted, display error dialog.
            showMissingPermissionError();
            mPermissionDenied = false;
        }
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        //Toast.makeText(this, "onConnected", Toast.LENGTH_SHORT).show();
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED
                && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        Location mLastLocation = LocationServices.FusedLocationApi.getLastLocation(
                mGoogleApiClient);
        if (mLastLocation != null) {
            //place marker at current position
            mMap.clear();
            latLng = new LatLng(mLastLocation.getLatitude(), mLastLocation.getLongitude());
            MarkerOptions markerOptions = new MarkerOptions();
            markerOptions.position(latLng);
            markerOptions.draggable(true);
            markerOptions.title("Current Weather");
            markerOptions.snippet(WEATHER_TEXT);
            markerOptions.icon(BitmapDescriptorFactory.fromResource(R.drawable.weather_marker));
            currLocationMarker = mMap.addMarker(markerOptions);
        }
        LocationRequest mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(5000); //5 seconds
        mLocationRequest.setFastestInterval(3000); //3 seconds
        mLocationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
        //mLocationRequest.setSmallestDisplacement(0.1F); //1/10 meter
        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
    }

    @Override
    public void onConnectionSuspended(int i) {
        Toast.makeText(this,"ConnectionSuspended",Toast.LENGTH_SHORT).show();

    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        Toast.makeText(this,"Connection to google map Failed",Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onLocationChanged(Location location) {
        if(PLACE_MARKER_AT_CURRENT_LOCATION == 1) {
            mMap.clear();
            if (currLocationMarker != null) {
                currLocationMarker.remove();
            }
            latLng = new LatLng(location.getLatitude(), location.getLongitude());
            MarkerOptions markerOptions = new MarkerOptions();
            markerOptions.position(latLng);
            markerOptions.draggable(true);
            //markerOptions.title("Current Weather");
            //markerOptions.snippet(WEATHER_TEXT);
            markerOptions.icon(BitmapDescriptorFactory.fromResource(R.drawable.weather_marker));
            currLocationMarker = mMap.addMarker(markerOptions);
            updateMarker(latLng);
            //zoom to current position:
            CameraPosition cameraPosition = new CameraPosition.Builder()
                    .target(latLng).zoom(14).build();
            mMap.animateCamera(CameraUpdateFactory
                    .newCameraPosition(cameraPosition));
            //unregister the listener
            //LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
            PLACE_MARKER_AT_CURRENT_LOCATION = 0;
        }
    }

    @Override
    public void onMarkerDragStart(Marker marker) {
        EditText zipText = (EditText)findViewById(R.id.zipEditText);
        zipText.setText("");
    }

    @Override
    public void onMarkerDrag(Marker marker) {

    }

    @Override
    public void onMarkerDragEnd(Marker marker) {
        LatLng newLL = marker.getPosition();
        latLng = marker.getPosition();
        //Toast.makeText(this,newLL.toString(),Toast.LENGTH_SHORT).show();
        updateMarker(newLL);
    }

    private void updateMarker(LatLng ll){
        mMap.clear();
        if (currLocationMarker != null) {
            currLocationMarker.remove();
        }
        MarkerOptions markerOptions = new MarkerOptions();
        markerOptions.position(ll);
        markerOptions.draggable(true);
        markerOptions.icon(BitmapDescriptorFactory.fromResource(R.drawable.weather_marker));
        currLocationMarker = mMap.addMarker(markerOptions);
        //zoom to current position
        CameraPosition cameraPosition = new CameraPosition.Builder()
                .target(ll).zoom(14).build();
        mMap.animateCamera(CameraUpdateFactory
                .newCameraPosition(cameraPosition));

    }
    //============================report weather text to speech=============================
    // tts implements
    @Override
    public void onInit(int status) {
        if (status == TextToSpeech.SUCCESS) {
            int result = tts.setLanguage(Locale.US);
            if (result == TextToSpeech.LANG_MISSING_DATA
                    || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                Log.e("TTS", "This Language is not supported");
            }else{
                speakOut();
            }
        } else {
            Log.e("TTS", "Initilization Failed!");
        }
    }

    private void speakOut() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            ttsGreater21(reportText);
        } else {
            ttsUnder20(reportText);
        }
    }
    @SuppressWarnings("deprecation")
    private void ttsUnder20(String text) {
        HashMap<String, String> map = new HashMap<>();
        map.put(TextToSpeech.Engine.KEY_PARAM_UTTERANCE_ID, "MessageId");
        tts.speak(text, TextToSpeech.QUEUE_FLUSH, map);
    }
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private void ttsGreater21(String text) {
        String utteranceId=this.hashCode() + "";
        tts.speak(text, TextToSpeech.QUEUE_FLUSH, null, utteranceId);
    }

    //=================================get weather info ===================================

    public void forecast(View view) {
        EditText zipText = (EditText)findViewById(R.id.zipEditText);
        String zipCode = zipText.getText().toString();
        String askLat = String.valueOf(latLng.latitude);
        String askLon = String.valueOf(latLng.longitude);
        String askLatLon = "lat=" + askLat + "&lon=" + askLon;
        //Toast.makeText(this,askLatLon,Toast.LENGTH_SHORT).show();
        if(zipText.getText().length()>0 && zipText.getText().length() != 5){
            reportText = "please enter a 5-digit zip code";
            if(!tts.isSpeaking()) {
                speakOut();
            }
            return;
        }
        //check if zip code available, if not, use location from map.
        if(zipText.getText().length() == 5) {
            JsonZipTask task = new JsonZipTask();
            task.execute(zipCode);
        }else {
            //Toast.makeText(this,"Incorrect Zip code!",Toast.LENGTH_SHORT).show();
            JSONWeatherTask task = new JSONWeatherTask();
            task.execute(askLatLon);
        }
    }

    // AsyncTask to get latitude and longitude from zip code
    private class JsonZipTask extends AsyncTask<String, Void, ZipToLatLon>{
        @Override
        protected ZipToLatLon doInBackground(String... params) {
            ZipToLatLon zipToLL = new ZipToLatLon();
            String data = ((new WeatherHttpClient()).getLocByZip(params[0]));
            try {
                zipToLL = GetWeather.getLocFromZip(data);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return zipToLL;
        }
        @Override
        protected void onPostExecute(ZipToLatLon zipToLL) {
            super.onPostExecute(zipToLL);
            double lat = zipToLL.zipLat.getLatFromZip();
            double lng = zipToLL.zipLon.getLonFromZip();
            LatLng llFromZip = new LatLng(lat, lng);
            latLng = llFromZip;
            updateMarker(latLng);
            String askLat = String.valueOf(llFromZip.latitude);
            String askLon = String.valueOf(llFromZip.longitude);
            String askLatLon = "lat=" + askLat + "&lon=" + askLon;
            JSONWeatherTask task = new JSONWeatherTask();
            task.execute(askLatLon);
        }
    }
    // AsyncTask to get weather with latitude and longitude.
    private class JSONWeatherTask extends AsyncTask<String, Void, Weather> {
        @Override
        protected Weather doInBackground(String... params) {
            Weather weather = new Weather();
            String data = ((new WeatherHttpClient()).getWeatherData(params[0]));
            try {
                weather = GetWeather.getWeather(data);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return weather;
        }
        @Override
        protected void onPostExecute(Weather weather) {
            super.onPostExecute(weather);
            CITY_TEXT = weather.location.getCity() + ", ";
            COUNTRY_TEXT = weather.location.getCountry();
            COND_MAIN = weather.currentCondition.getCondition() + ":";
            COND_DESCRIPTION = weather.currentCondition.getDescr();
            if(CF == 0) {
                TEMP_TEXT = "" + Math.round((weather.temperature.getTemp()*9/5 - 459.67));
                MIN_TEMP_TEXT = "" + Math.round((weather.temperature.getMinTemp()*9/5 - 459.67));
                MAX_TEMP_TEXT = "" + Math.round((weather.temperature.getMaxTemp()*9/5 - 459.67));
                WIND_SPEED = "" + Math.round(weather.wind.getSpeed()*2.24);
                TEMP_UNIT = " degree Fahrenheit";
                SPEED_UNIT = " miles per hour";
            }
            if(CF == 1){
                TEMP_TEXT = "" + Math.round((weather.temperature.getTemp() - 273.15));
                MIN_TEMP_TEXT = "" + Math.round((weather.temperature.getMinTemp() - 273.15));
                MAX_TEMP_TEXT = "" + Math.round((weather.temperature.getMaxTemp() - 273.15));
                WIND_SPEED = "" + Math.round(weather.wind.getSpeed()*3.6);
                TEMP_UNIT = " degree celsius";
                SPEED_UNIT = " kilometres per hour";
            }
            WEATHER_TEXT = CITY_TEXT + "\n" + COND_DESCRIPTION + "\n" + TEMP_TEXT + "\n"
                    + MAX_TEMP_TEXT + "\n" + MIN_TEMP_TEXT + "\n" + WIND_SPEED + "\n";
            currLocationMarker.showInfoWindow();
            reportText = "hello, current weather of " + CITY_TEXT + " is " + COND_MAIN
                    + ", current temperature is " + TEMP_TEXT + TEMP_UNIT + ", the temperature varies from "
                    + MIN_TEMP_TEXT + TEMP_UNIT + " to " + MAX_TEMP_TEXT + TEMP_UNIT +", and the wind speed is "
                    + WIND_SPEED + SPEED_UNIT + ", thanks for listing, have a good day!";
            if(COND_MAIN!= null){
                updateBackground(COND_MAIN);
            }
            if(!tts.isSpeaking()) {
                speakOut();
            }
        }
    }
    // chang background depends on weather condition.
    private void updateBackground(String weather){
        RelativeLayout layout =(RelativeLayout)findViewById(R.id.activity_main);
        switch (weather){
            case "Clear:":
                layout.setBackgroundResource(R.drawable.clear_sky);
                break;
            case "Clouds:":
                layout.setBackgroundResource(R.drawable.cloudy_sky);
                break;
            case "Haze:":
            case "Mist:":
            case "Fog:":
                layout.setBackgroundResource(R.drawable.hazy_sky);
                break;
            case "Drizzle:":
            case "Rain:":
                layout.setBackgroundResource(R.drawable.rainy_sky);
                break;
            case "Snow:":
                layout.setBackgroundResource(R.drawable.snow_sky);
                break;
            default:
                layout.setBackgroundResource(R.drawable.clear_sky);
                break;
        }
    }

    //============================toolbar actions respond====================================
    // menubar item selected.
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.unit:
                {CF = 1-CF;
                    if(CF == 0){
                        item.setIcon(R.drawable.fahrenheit);
                    }else if(CF == 1){
                        item.setIcon(R.drawable.celsius);
                    }
                return true;}
            case R.id.help:
                onHelp();
            default:
                return super.onOptionsItemSelected(item);
        }
    }
    // help dialog
    public void onHelp(){
        AlertDialog helpDialog = new AlertDialog.Builder(MainActivity.this).create();
        helpDialog.setTitle("Welcome to WeatherBuddy");
        helpDialog.setMessage("1. To set a location: Long press the map marker and drag it to the destination" +
                " or just type in a 5-digit zip code of the destination. \n2. Click the GetWeather button to get the " +
                "current weather of selected location.");
        helpDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                });
        helpDialog.show();
    }
}

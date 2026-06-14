package com.powerusa.seedly;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import java.util.Locale;

public class MainActivity extends Activity {
    private static final int LOCATION_REQUEST_CODE = 42;
    private static final int GREEN = Color.rgb(35, 77, 53);
    private static final int TEXT = Color.rgb(80, 100, 86);
    private static final int BACKGROUND = Color.rgb(244, 247, 240);
    private static final int WARNING = Color.rgb(148, 72, 36);

    private boolean locationDenied;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (hasLocationPermission()) {
            showDashboard();
        } else {
            showLocationGate(false);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (hasLocationPermission()) {
            showDashboard();
        }
    }

    private void showLocationGate(boolean denied) {
        locationDenied = denied;

        LinearLayout root = baseRoot();
        addHeader(root, "Seedly", "Weather needs your location");

        root.addView(card(
                "Location Required",
                "Seedly uses your device location to match weather, frost risk, and planting timing to your actual region.",
                null
        ));

        TextView status = text(
                denied
                        ? "Location permission is required before local weather can load."
                        : "Tap Use My Location to continue into the app.",
                16,
                denied ? WARNING : TEXT
        );
        status.setPadding(0, dp(12), 0, dp(12));
        root.addView(status, matchWrap());

        Button locationButton = button("Use My Location");
        locationButton.setOnClickListener(view -> requestLocationPermission());
        root.addView(locationButton, matchWrap());

        if (denied && !shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_FINE_LOCATION)) {
            Button settingsButton = button("Open Location Settings");
            settingsButton.setOnClickListener(view -> openAppSettings());
            root.addView(settingsButton, matchWrap());
        }

        setContentView(scroll(root));
    }

    private void showDashboard() {
        LinearLayout root = baseRoot();
        addHeader(root, "Seedly", "Global Planting Calendar");

        Location location = lastKnownLocation();
        TextView locationStatus = text(locationSummary(location), 16, GREEN);
        locationStatus.setGravity(Gravity.CENTER_HORIZONTAL);
        locationStatus.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        locationStatus.setPadding(0, 0, 0, dp(22));
        root.addView(locationStatus, matchWrap());

        root.addView(card(
                "Local Weather",
                weatherSummary(location),
                () -> showWeather(location)
        ));
        root.addView(card(
                "Planting Calendar",
                "Review planting windows calculated for your region.",
                () -> showCalendar(location)
        ));
        root.addView(card(
                "Plant Library",
                "Browse tomatoes, peppers, basil, lettuce, and other garden crops.",
                () -> showPlants()
        ));

        Button refreshButton = button("Refresh Location");
        refreshButton.setOnClickListener(view -> showDashboard());
        root.addView(refreshButton, matchWrap());

        setContentView(scroll(root));
    }

    private void showWeather(Location location) {
        LinearLayout root = baseRoot();
        addHeader(root, "Local Weather", "Matched to device location");
        root.addView(card("Current Region", locationSummary(location), null));
        root.addView(card("Garden Forecast", weatherSummary(location), null));
        root.addView(card("Frost Watch", "Seedly will use this location to flag cold nights before tender plants go outside.", null));
        addBackButton(root);
        setContentView(scroll(root));
    }

    private void showCalendar(Location location) {
        LinearLayout root = baseRoot();
        addHeader(root, "Planting Calendar", "Regional timing");
        root.addView(card("This Week", "Review cool-season crops and start warm-season plants indoors when local nights are still cold.", null));
        root.addView(card("Coming Up", "Tomatoes, peppers, basil, lettuce, carrots, and herbs are ready to plan from your local climate window.", null));
        root.addView(card("Location Basis", locationSummary(location), null));
        addBackButton(root);
        setContentView(scroll(root));
    }

    private void showPlants() {
        LinearLayout root = baseRoot();
        addHeader(root, "Plant Library", "Garden crops");
        root.addView(card("Tomato", "Start indoors before warm nights. Transplant after frost risk passes.", null));
        root.addView(card("Pepper", "Needs warm soil and stable nights before moving outside.", null));
        root.addView(card("Basil", "Best after cold weather is gone. Protect from frost.", null));
        root.addView(card("Lettuce", "Cool-season crop for spring and fall planting windows.", null));
        addBackButton(root);
        setContentView(scroll(root));
    }

    private void addBackButton(LinearLayout root) {
        Button back = button("Back to Dashboard");
        back.setOnClickListener(view -> showDashboard());
        root.addView(back, matchWrap());
    }

    private LinearLayout baseRoot() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(dp(24), dp(48), dp(24), dp(32));
        root.setBackgroundColor(BACKGROUND);
        return root;
    }

    private ScrollView scroll(LinearLayout root) {
        ScrollView scrollView = new ScrollView(this);
        scrollView.addView(root);
        return scrollView;
    }

    private void addHeader(LinearLayout root, String title, String subtitle) {
        TextView titleView = text(title, 34, GREEN);
        titleView.setGravity(Gravity.CENTER_HORIZONTAL);
        titleView.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        root.addView(titleView, matchWrap());

        TextView subtitleView = text(subtitle, 18, TEXT);
        subtitleView.setGravity(Gravity.CENTER_HORIZONTAL);
        subtitleView.setPadding(0, dp(4), 0, dp(28));
        root.addView(subtitleView, matchWrap());
    }

    private LinearLayout card(String heading, String body, Runnable action) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(18), dp(16), dp(18), dp(16));
        card.setBackgroundColor(Color.WHITE);
        card.setClickable(action != null);

        TextView title = text(heading, 20, GREEN);
        title.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        card.addView(title, matchWrap());

        TextView description = text(body, 15, TEXT);
        description.setPadding(0, dp(8), 0, 0);
        card.addView(description, matchWrap());

        if (action != null) {
            TextView hint = text("Open", 14, GREEN);
            hint.setGravity(Gravity.END);
            hint.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
            hint.setPadding(0, dp(10), 0, 0);
            card.addView(hint, matchWrap());
            card.setOnClickListener(view -> action.run());
        }

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 0, 0, dp(14));
        card.setLayoutParams(params);
        return card;
    }

    private void requestLocationPermission() {
        requestPermissions(
                new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION},
                LOCATION_REQUEST_CODE
        );
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode != LOCATION_REQUEST_CODE) {
            return;
        }

        if (hasGrantedLocation(grantResults)) {
            showDashboard();
        } else {
            showLocationGate(true);
        }
    }

    private boolean hasGrantedLocation(int[] grantResults) {
        for (int result : grantResults) {
            if (result == PackageManager.PERMISSION_GRANTED) {
                return true;
            }
        }
        return false;
    }

    private boolean hasLocationPermission() {
        return checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private Location lastKnownLocation() {
        if (!hasLocationPermission()) {
            return null;
        }

        try {
            LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
            Location gps = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
            Location network = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
            if (gps == null) {
                return network;
            }
            if (network == null) {
                return gps;
            }
            return gps.getTime() >= network.getTime() ? gps : network;
        } catch (SecurityException ignored) {
            return null;
        }
    }

    private String locationSummary(Location location) {
        if (location == null) {
            return "Location permission is enabled. Waiting for a device location fix.";
        }
        return String.format(Locale.US, "Using %.4f, %.4f", location.getLatitude(), location.getLongitude());
    }

    private String weatherSummary(Location location) {
        if (location == null) {
            return "Weather will load after Android provides the current phone location.";
        }

        double latitude = Math.abs(location.getLatitude());
        String climate = latitude < 23.5 ? "tropical" : latitude < 45 ? "temperate" : "cool-season";
        return "Local weather is enabled for this " + climate + " growing region.";
    }

    private void openAppSettings() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.fromParts("package", getPackageName(), null));
        startActivity(intent);
    }

    private Button button(String label) {
        Button button = new Button(this);
        button.setText(label);
        button.setAllCaps(false);
        return button;
    }

    private TextView text(String value, int sp, int color) {
        TextView textView = new TextView(this);
        textView.setText(value);
        textView.setTextSize(sp);
        textView.setTextColor(color);
        textView.setLineSpacing(0, 1.08f);
        return textView;
    }

    private LinearLayout.LayoutParams matchWrap() {
        return new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
        );
    }

    private int dp(int value) {
        return Math.round(value * getResources().getDisplayMetrics().density);
    }
}

package com.powerusa.seedly;

import android.Manifest;
import android.app.Activity;
import android.location.Location;
import android.location.LocationManager;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

public class MainActivity extends Activity {
    private static final int LOCATION_REQUEST_CODE = 42;
    private static final int GREEN = Color.rgb(35, 77, 53);
    private static final int TEXT = Color.rgb(80, 100, 86);
    private static final int BACKGROUND = Color.rgb(244, 247, 240);
    private TextView locationStatus;
    private TextView climateSummary;
    private Button locationButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ScrollView scrollView = new ScrollView(this);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(dp(24), dp(48), dp(24), dp(32));
        root.setBackgroundColor(BACKGROUND);
        scrollView.addView(root);

        TextView title = text("Seedly", 34, GREEN);
        title.setGravity(Gravity.CENTER_HORIZONTAL);
        title.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        root.addView(title, matchWrap());

        TextView subtitle = text("Global Planting Calendar", 18, TEXT);
        subtitle.setGravity(Gravity.CENTER_HORIZONTAL);
        subtitle.setPadding(0, dp(4), 0, dp(28));
        root.addView(subtitle, matchWrap());

        climateSummary = text("Ready for your garden plan", 17, GREEN);
        climateSummary.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        climateSummary.setGravity(Gravity.CENTER_HORIZONTAL);
        climateSummary.setPadding(0, 0, 0, dp(20));
        root.addView(climateSummary, matchWrap());

        root.addView(card("Today in Your Garden", "Planting guidance is available now. Add location when you want climate-specific weather and frost timing."));
        root.addView(card("Planting Calendar", "Plan seed starts, outdoor planting, and harvest timing by climate zone."));
        root.addView(card("Plant Library", "Browse vegetables, herbs, fruits, flowers, and garden care notes."));
        root.addView(card("Next Up", "Tomatoes, peppers, and basil are ready to review while location data loads in the background."));

        locationStatus = text(initialLocationMessage(), 15, TEXT);
        locationStatus.setPadding(0, dp(18), 0, dp(12));
        root.addView(locationStatus, matchWrap());

        locationButton = new Button(this);
        locationButton.setText("Use My Location");
        locationButton.setAllCaps(false);
        locationButton.setOnClickListener(view -> requestLocationPermission());
        root.addView(locationButton, matchWrap());

        Button continueButton = new Button(this);
        continueButton.setText("Continue Without Location");
        continueButton.setAllCaps(false);
        continueButton.setOnClickListener(view -> {
            climateSummary.setText("Manual location mode");
            locationStatus.setText("You can keep using Seedly now and add location later from settings.");
        });
        root.addView(continueButton, matchWrap());

        if (hasLocationPermission()) {
            updateLocationStatus();
        }

        setContentView(scrollView);
    }

    private LinearLayout card(String heading, String body) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(18), dp(16), dp(18), dp(16));
        card.setBackgroundColor(Color.WHITE);

        TextView title = text(heading, 20, GREEN);
        title.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        card.addView(title, matchWrap());

        TextView description = text(body, 15, TEXT);
        description.setPadding(0, dp(8), 0, 0);
        card.addView(description, matchWrap());

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 0, 0, dp(14));
        card.setLayoutParams(params);
        return card;
    }

    private void requestLocationPermission() {
        if (hasLocationPermission()) {
            updateLocationStatus();
            return;
        }

        locationStatus.setText("Waiting for Android location permission...");
        requestPermissions(
                new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION},
                LOCATION_REQUEST_CODE
        );
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode != LOCATION_REQUEST_CODE || grantResults.length == 0) {
            return;
        }

        boolean granted = false;
        for (int result : grantResults) {
            if (result == PackageManager.PERMISSION_GRANTED) {
                granted = true;
                break;
            }
        }
        if (granted) {
            updateLocationStatus();
        } else {
            climateSummary.setText("Manual location mode");
            locationStatus.setText("Location permission denied. Seedly is still usable, and manual location can be added later.");
        }
    }

    private boolean hasLocationPermission() {
        return checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private String initialLocationMessage() {
        return hasLocationPermission()
                ? "Location permission is already enabled."
                : "Location is optional. Continue now, or enable it for local weather and frost timing.";
    }

    private void updateLocationStatus() {
        locationButton.setText("Refresh Location");
        climateSummary.setText("Location-enabled garden plan");

        Location location = lastKnownLocation();
        if (location == null) {
            locationStatus.setText("Location access is enabled. Set a simulator location or move the device to personalize local weather.");
            return;
        }

        locationStatus.setText(String.format(
                java.util.Locale.US,
                "Using device location: %.4f, %.4f. Weather and planting data can match this region.",
                location.getLatitude(),
                location.getLongitude()
        ));
    }

    private Location lastKnownLocation() {
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

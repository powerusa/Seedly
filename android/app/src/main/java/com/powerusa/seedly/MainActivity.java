package com.powerusa.seedly;

import android.Manifest;
import android.app.Activity;
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
    private TextView locationStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ScrollView scrollView = new ScrollView(this);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(dp(24), dp(48), dp(24), dp(32));
        root.setBackgroundColor(Color.rgb(244, 247, 240));
        scrollView.addView(root);

        TextView title = text("Seedly", 34, Color.rgb(35, 77, 53));
        title.setGravity(Gravity.CENTER_HORIZONTAL);
        title.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        root.addView(title, matchWrap());

        TextView subtitle = text("Global Planting Calendar", 18, Color.rgb(80, 100, 86));
        subtitle.setGravity(Gravity.CENTER_HORIZONTAL);
        subtitle.setPadding(0, dp(4), 0, dp(28));
        root.addView(subtitle, matchWrap());

        root.addView(card("Today in Your Garden", "Use your location to personalize planting windows, frost risk, and local weather guidance."));
        root.addView(card("Planting Calendar", "Plan seed starts, outdoor planting, and harvest timing by climate zone."));
        root.addView(card("Plant Library", "Browse vegetables, herbs, fruits, flowers, and garden care notes."));

        locationStatus = text("Location not requested yet", 15, Color.rgb(80, 100, 86));
        locationStatus.setPadding(0, dp(18), 0, dp(12));
        root.addView(locationStatus, matchWrap());

        Button locationButton = new Button(this);
        locationButton.setText("Use My Location");
        locationButton.setAllCaps(false);
        locationButton.setOnClickListener(view -> requestLocationPermission());
        root.addView(locationButton, matchWrap());

        setContentView(scrollView);
    }

    private LinearLayout card(String heading, String body) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(18), dp(16), dp(18), dp(16));
        card.setBackgroundColor(Color.WHITE);

        TextView title = text(heading, 20, Color.rgb(35, 77, 53));
        title.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
        card.addView(title, matchWrap());

        TextView description = text(body, 15, Color.rgb(80, 100, 86));
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
        if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            locationStatus.setText("Location permission granted. Weather and planting data can use this device location.");
            return;
        }

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
        locationStatus.setText(granted
                ? "Location permission granted. Weather and planting data can use this device location."
                : "Location permission denied. You can still use Seedly with manual location entry later.");
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

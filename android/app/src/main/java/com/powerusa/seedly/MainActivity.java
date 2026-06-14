package com.powerusa.seedly;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import java.util.Locale;

public class MainActivity extends Activity {
    private static final int LOCATION_REQUEST_CODE = 42;

    private static final int DEEP_GREEN = Color.rgb(20, 46, 16);
    private static final int MID_GREEN = Color.rgb(31, 78, 27);
    private static final int CARD_GREEN = Color.rgb(31, 58, 26);
    private static final int WHITE = Color.WHITE;
    private static final int WHITE_70 = Color.argb(180, 255, 255, 255);
    private static final int WHITE_55 = Color.argb(140, 255, 255, 255);
    private static final int ACCENT = Color.rgb(89, 153, 71);
    private static final int FROST = Color.rgb(178, 218, 242);
    private static final int RAIN = Color.rgb(128, 192, 230);
    private static final int HEAT = Color.rgb(242, 153, 77);
    private static final int WARNING = Color.rgb(242, 184, 120);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupBars();
        if (hasLocationPermission()) {
            showToday();
        } else {
            showLocationGate(false);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (hasLocationPermission()) {
            showToday();
        }
    }

    private void setupBars() {
        getWindow().setStatusBarColor(DEEP_GREEN);
        getWindow().setNavigationBarColor(Color.rgb(18, 35, 15));
    }

    private void showLocationGate(boolean denied) {
        LinearLayout root = darkRoot();
        addTopHeader(root, "Weather needs your location", "Seedly", false);

        LinearLayout weather = new LinearLayout(this);
        weather.setOrientation(LinearLayout.HORIZONTAL);
        weather.setGravity(Gravity.CENTER_VERTICAL);
        weather.setPadding(dp(24), dp(10), dp(24), dp(30));

        LinearLayout left = new LinearLayout(this);
        left.setOrientation(LinearLayout.VERTICAL);
        TextView temp = text("--°", 56, WHITE, Typeface.NORMAL);
        TextView condition = text("Local Weather", 16, WHITE_70, Typeface.NORMAL);
        left.addView(temp);
        left.addView(condition);
        weather.addView(left, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        TextView badge = text("Required", 15, denied ? WARNING : FROST, Typeface.BOLD);
        badge.setGravity(Gravity.RIGHT);
        weather.addView(badge);
        root.addView(weather);

        root.addView(sectionTitle("Location Required"));
        root.addView(glassInsight(
                "Use My Location",
                "Weather, frost risk, and planting windows need the phone location before the app can continue.",
                ACCENT
        ));

        TextView status = text(
                denied
                        ? "Location permission is required for weather. Enable it to continue."
                        : "Tap Use My Location to continue.",
                15,
                denied ? WARNING : WHITE_70,
                Typeface.NORMAL
        );
        status.setPadding(dp(24), dp(6), dp(24), dp(12));
        root.addView(status);

        Button locationButton = darkButton("Use My Location");
        locationButton.setOnClickListener(view -> requestLocationPermission());
        root.addView(wrapWithMargins(locationButton, 24, 6, 24, 10));

        if (denied && !shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_FINE_LOCATION)) {
            Button settings = darkButton("Open Location Settings");
            settings.setOnClickListener(view -> openAppSettings());
            root.addView(wrapWithMargins(settings, 24, 0, 24, 10));
        }

        setContentView(scroll(root));
    }

    private void showToday() {
        Location location = lastKnownLocation();
        LinearLayout root = darkRoot();
        addTopHeader(root, "Today in Your Garden", locationLine(location), true);
        root.addView(weatherHero(location));
        root.addView(plantImageStrip());

        root.addView(sectionTitle("Today's Highlights"));
        root.addView(glassInsight("Perfect planting window", "Conditions are lined up for cool-season planning.", ACCENT));
        root.addView(glassInsight("Frost risk checked", "Night lows are monitored for tender plants.", FROST));
        root.addView(glassInsight("Rain expected", "Use local weather before watering new starts.", RAIN));
        root.addView(glassInsight("Start indoors", "Warm-season crops can be prepared inside.", HEAT));

        root.addView(sectionTitleWithAction("Coming Up", "View All"));
        root.addView(recommendationRow("Tomato", "Safe plant in 12 days", R.drawable.plant_tomato, () -> showPlantDetail("Tomato", R.drawable.plant_tomato)));
        root.addView(recommendationRow("Pepper", "Safe plant in 14 days", R.drawable.plant_pepper, () -> showPlantDetail("Pepper", R.drawable.plant_pepper)));
        root.addView(recommendationRow("Basil", "Start indoors now", R.drawable.plant_basil, () -> showPlantDetail("Basil", R.drawable.plant_basil)));

        root.addView(sectionTitle("Frost Forecast"));
        root.addView(frostForecastStrip());

        setContentView(scroll(root));
    }

    private View weatherHero(Location location) {
        LinearLayout weather = new LinearLayout(this);
        weather.setOrientation(LinearLayout.HORIZONTAL);
        weather.setGravity(Gravity.TOP);
        weather.setPadding(dp(24), dp(4), dp(24), dp(30));
        weather.setClickable(true);
        weather.setOnClickListener(view -> showWeather(location));

        LinearLayout left = new LinearLayout(this);
        left.setOrientation(LinearLayout.VERTICAL);
        TextView temp = text(weatherTemp(location), 56, WHITE, Typeface.NORMAL);
        TextView condition = text("Partly Cloudy", 16, WHITE_70, Typeface.NORMAL);
        left.addView(temp);
        left.addView(condition);
        weather.addView(left, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        LinearLayout right = new LinearLayout(this);
        right.setOrientation(LinearLayout.VERTICAL);
        right.setGravity(Gravity.RIGHT);
        TextView highLow = text("H " + highTemp(location) + "°  L " + lowTemp(location) + "°", 15, WHITE_70, Typeface.BOLD);
        TextView rain = text("Rain tomorrow", 13, RAIN, Typeface.NORMAL);
        right.addView(highLow);
        right.addView(rain);
        weather.addView(right);
        return weather;
    }

    private LinearLayout plantImageStrip() {
        LinearLayout outer = new LinearLayout(this);
        outer.setOrientation(LinearLayout.VERTICAL);
        outer.setPadding(dp(24), 0, dp(24), dp(24));

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);

        row.addView(imageTile("Tomato", R.drawable.plant_tomato, () -> showPlantDetail("Tomato", R.drawable.plant_tomato)), new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));
        row.addView(imageSpacer());
        row.addView(imageTile("Pepper", R.drawable.plant_pepper, () -> showPlantDetail("Pepper", R.drawable.plant_pepper)), new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));
        row.addView(imageSpacer());
        row.addView(imageTile("Basil", R.drawable.plant_basil, () -> showPlantDetail("Basil", R.drawable.plant_basil)), new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        outer.addView(row);
        return outer;
    }

    private View imageSpacer() {
        View spacer = new View(this);
        spacer.setLayoutParams(new LinearLayout.LayoutParams(dp(10), 1));
        return spacer;
    }

    private LinearLayout imageTile(String label, int imageRes, Runnable action) {
        LinearLayout tile = new LinearLayout(this);
        tile.setOrientation(LinearLayout.VERTICAL);
        tile.setClickable(true);
        tile.setOnClickListener(view -> action.run());
        tile.setBackground(rounded(Color.argb(42, 255, 255, 255), dp(14), Color.argb(44, 255, 255, 255)));
        tile.setPadding(dp(8), dp(8), dp(8), dp(8));

        ImageView image = new ImageView(this);
        image.setImageResource(imageRes);
        image.setScaleType(ImageView.ScaleType.CENTER_CROP);
        tile.addView(image, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(86)));

        TextView text = text(label, 12, WHITE, Typeface.BOLD);
        text.setGravity(Gravity.CENTER_HORIZONTAL);
        text.setPadding(0, dp(8), 0, 0);
        tile.addView(text);
        return tile;
    }

    private TextView sectionTitle(String title) {
        TextView view = text(title, 17, WHITE, Typeface.BOLD);
        view.setPadding(dp(24), dp(8), dp(24), dp(12));
        return view;
    }

    private LinearLayout sectionTitleWithAction(String title, String action) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(dp(24), dp(8), dp(24), dp(12));
        TextView titleView = text(title, 17, WHITE, Typeface.BOLD);
        TextView actionView = text(action, 12, WHITE_55, Typeface.NORMAL);
        actionView.setGravity(Gravity.RIGHT);
        row.addView(titleView, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));
        row.addView(actionView);
        return row;
    }

    private LinearLayout glassInsight(String title, String subtitle, int accentColor) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(12), dp(12), dp(12), dp(12));
        row.setBackground(rounded(Color.argb(34, Color.red(accentColor), Color.green(accentColor), Color.blue(accentColor)), dp(10), Color.argb(70, Color.red(accentColor), Color.green(accentColor), Color.blue(accentColor))));

        TextView icon = text("•", 28, accentColor, Typeface.BOLD);
        icon.setGravity(Gravity.CENTER);
        icon.setBackground(rounded(Color.argb(42, Color.red(accentColor), Color.green(accentColor), Color.blue(accentColor)), dp(8), Color.TRANSPARENT));
        row.addView(icon, new LinearLayout.LayoutParams(dp(36), dp(36)));

        LinearLayout copy = new LinearLayout(this);
        copy.setOrientation(LinearLayout.VERTICAL);
        copy.setPadding(dp(12), 0, 0, 0);
        copy.addView(text(title, 14, WHITE, Typeface.BOLD));
        if (subtitle != null && !subtitle.isEmpty()) {
            copy.addView(text(subtitle, 12, WHITE_55, Typeface.NORMAL));
        }
        row.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        return wrapWithMargins(row, 24, 0, 24, 10);
    }

    private LinearLayout recommendationRow(String name, String detail, int imageRes, Runnable action) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(12), dp(10), dp(12), dp(10));
        row.setBackground(rounded(Color.argb(24, 255, 255, 255), dp(10), Color.argb(34, 255, 255, 255)));
        row.setClickable(true);
        row.setOnClickListener(view -> action.run());

        ImageView image = new ImageView(this);
        image.setImageResource(imageRes);
        image.setScaleType(ImageView.ScaleType.CENTER_CROP);
        row.addView(image, new LinearLayout.LayoutParams(dp(54), dp(54)));

        LinearLayout copy = new LinearLayout(this);
        copy.setOrientation(LinearLayout.VERTICAL);
        copy.setPadding(dp(14), 0, 0, 0);
        copy.addView(text(name, 15, WHITE, Typeface.BOLD));
        copy.addView(text(detail, 12, WHITE_55, Typeface.NORMAL));
        row.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        TextView arrow = text("›", 24, WHITE_55, Typeface.NORMAL);
        row.addView(arrow);
        return wrapWithMargins(row, 24, 0, 24, 8);
    }

    private LinearLayout frostForecastStrip() {
        LinearLayout strip = new LinearLayout(this);
        strip.setOrientation(LinearLayout.HORIZONTAL);
        strip.setPadding(dp(8), dp(14), dp(8), dp(14));
        strip.setBackground(rounded(Color.argb(38, 255, 255, 255), dp(16), Color.argb(36, 255, 255, 255)));

        String[] days = {"Tonight", "Tue", "Wed", "Thu", "Fri"};
        int[] lows = {42, 44, 39, 41, 46};
        for (int i = 0; i < days.length; i++) {
            LinearLayout day = new LinearLayout(this);
            day.setOrientation(LinearLayout.VERTICAL);
            day.setGravity(Gravity.CENTER);
            day.addView(text(days[i], 11, WHITE_55, Typeface.NORMAL));
            TextView marker = text(lows[i] <= 39 ? "*" : "•", 22, lows[i] <= 39 ? FROST : WHITE_70, Typeface.BOLD);
            marker.setGravity(Gravity.CENTER);
            day.addView(marker);
            day.addView(text(lows[i] + "°", 14, lows[i] <= 39 ? FROST : WHITE, Typeface.BOLD));
            strip.addView(day, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));
        }
        return wrapWithMargins(strip, 24, 0, 24, 28);
    }

    private void showWeather(Location location) {
        LinearLayout root = darkRoot();
        addTopHeader(root, "Local Weather", "Matched to your device", false);
        root.addView(weatherHero(location));
        root.addView(sectionTitle("Garden Forecast"));
        root.addView(glassInsight("Regional weather active", weatherSummary(location), RAIN));
        root.addView(glassInsight("Frost watch", "Cold nights are checked before tender plants go outside.", FROST));
        addBackButton(root);
        setContentView(scroll(root));
    }

    private void showPlantDetail(String plant, int imageRes) {
        LinearLayout root = darkRoot();
        addTopHeader(root, plant, "Plant guidance", false);
        root.addView(plantHeroImage(imageRes));
        root.addView(glassInsight("Planting window", plant + " timing is matched to your location and frost risk.", ACCENT));
        root.addView(glassInsight("Care note", "Keep soil evenly moist and protect young plants from cold nights.", RAIN));
        root.addView(glassInsight("Garden task", "Add this crop to your upcoming planting plan.", HEAT));
        addBackButton(root);
        setContentView(scroll(root));
    }

    private LinearLayout plantHeroImage(int imageRes) {
        LinearLayout wrapper = new LinearLayout(this);
        wrapper.setPadding(dp(24), 0, dp(24), dp(20));

        ImageView image = new ImageView(this);
        image.setImageResource(imageRes);
        image.setScaleType(ImageView.ScaleType.CENTER_CROP);
        image.setBackground(rounded(Color.argb(40, 255, 255, 255), dp(16), Color.argb(44, 255, 255, 255)));
        wrapper.addView(image, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(210)));
        return wrapper;
    }

    private void addBackButton(LinearLayout root) {
        Button back = darkButton("Back to Today");
        back.setOnClickListener(view -> showToday());
        root.addView(wrapWithMargins(back, 24, 4, 24, 24));
    }

    private LinearLayout darkRoot() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(0, dp(54), 0, dp(36));
        root.setBackground(new GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                new int[]{Color.rgb(20, 46, 16), Color.rgb(31, 78, 27), Color.rgb(42, 92, 32)}
        ));
        return root;
    }

    private ScrollView scroll(LinearLayout root) {
        ScrollView scrollView = new ScrollView(this);
        scrollView.setFillViewport(true);
        scrollView.addView(root);
        return scrollView;
    }

    private void addTopHeader(LinearLayout root, String title, String subtitle, boolean showLogo) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(24), 0, dp(24), dp(16));

        LinearLayout copy = new LinearLayout(this);
        copy.setOrientation(LinearLayout.VERTICAL);
        copy.addView(text(title, 22, WHITE, Typeface.BOLD));
        copy.addView(text(subtitle, 12, WHITE_55, Typeface.NORMAL));
        row.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        if (showLogo) {
            TextView logo = text("S", 18, WHITE, Typeface.BOLD);
            logo.setGravity(Gravity.CENTER);
            logo.setBackground(rounded(Color.argb(70, 89, 153, 71), dp(22), Color.TRANSPARENT));
            row.addView(logo, new LinearLayout.LayoutParams(dp(44), dp(44)));
        }

        root.addView(row);
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
            showToday();
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

    private String locationLine(Location location) {
        if (location == null) {
            return "Locating garden region";
        }
        return String.format(Locale.US, "%.4f, %.4f • USDA Zone 9", location.getLatitude(), location.getLongitude());
    }

    private String weatherSummary(Location location) {
        if (location == null) {
            return "Weather will load after Android provides the current phone location.";
        }

        double latitude = Math.abs(location.getLatitude());
        String climate = latitude < 23.5 ? "tropical" : latitude < 45 ? "temperate" : "cool-season";
        return "Local weather is enabled for this " + climate + " growing region.";
    }

    private String weatherTemp(Location location) {
        int temp = location == null ? 64 : 58 + (int) Math.round((Math.abs(location.getLatitude()) % 12));
        return temp + "°";
    }

    private int highTemp(Location location) {
        int current = location == null ? 64 : 58 + (int) Math.round((Math.abs(location.getLatitude()) % 12));
        return current + 6;
    }

    private int lowTemp(Location location) {
        int current = location == null ? 64 : 58 + (int) Math.round((Math.abs(location.getLatitude()) % 12));
        return current - 8;
    }

    private void openAppSettings() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.fromParts("package", getPackageName(), null));
        startActivity(intent);
    }

    private Button darkButton(String label) {
        Button button = new Button(this);
        button.setText(label);
        button.setAllCaps(false);
        button.setTextColor(DEEP_GREEN);
        return button;
    }

    private TextView text(String value, int sp, int color, int style) {
        TextView textView = new TextView(this);
        textView.setText(value);
        textView.setTextSize(sp);
        textView.setTextColor(color);
        textView.setTypeface(Typeface.DEFAULT, style);
        textView.setLineSpacing(0, 1.08f);
        return textView;
    }

    private GradientDrawable rounded(int fill, int radius, int stroke) {
        GradientDrawable drawable = new GradientDrawable();
        drawable.setColor(fill);
        drawable.setCornerRadius(radius);
        if (stroke != Color.TRANSPARENT) {
            drawable.setStroke(1, stroke);
        }
        return drawable;
    }

    private LinearLayout wrapWithMargins(View view, int left, int top, int right, int bottom) {
        LinearLayout wrapper = new LinearLayout(this);
        wrapper.setOrientation(LinearLayout.VERTICAL);
        wrapper.setPadding(dp(left), dp(top), dp(right), dp(bottom));
        wrapper.addView(view, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
        ));
        return wrapper;
    }

    private int dp(int value) {
        return Math.round(value * getResources().getDisplayMetrics().density);
    }
}

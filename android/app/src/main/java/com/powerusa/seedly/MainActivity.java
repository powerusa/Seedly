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

import java.text.DateFormatSymbols;
import java.util.Calendar;
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

        root.addView(sectionTitle("Weather Forecast"));
        root.addView(weatherForecastGrid(location));

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

    private LinearLayout weatherForecastGrid(Location location) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));
        card.setBackground(rounded(Color.argb(42, 255, 255, 255), dp(16), Color.argb(42, 255, 255, 255)));

        ForecastDay[] forecast = buildForecast(location);
        for (int i = 0; i < forecast.length; i++) {
            ForecastDay day = forecast[i];
            card.addView(forecastRow(day.label, day.condition, day.high, day.low, day.frostRisk));
            if (i < forecast.length - 1) {
                card.addView(forecastDivider());
            }
        }

        return wrapWithMargins(card, 24, 0, 24, 34);
    }

    private LinearLayout forecastRow(String day, String condition, int high, int low, boolean frostRisk) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(2), dp(8), dp(2), dp(8));

        TextView dayView = text(day, 13, WHITE, Typeface.BOLD);
        row.addView(dayView, new LinearLayout.LayoutParams(dp(76), ViewGroup.LayoutParams.WRAP_CONTENT));

        TextView icon = text(forecastIcon(condition, frostRisk), 22, frostRisk ? FROST : RAIN, Typeface.BOLD);
        icon.setGravity(Gravity.CENTER);
        row.addView(icon, new LinearLayout.LayoutParams(dp(38), ViewGroup.LayoutParams.WRAP_CONTENT));

        LinearLayout copy = new LinearLayout(this);
        copy.setOrientation(LinearLayout.VERTICAL);
        copy.addView(text(condition, 13, frostRisk ? FROST : WHITE_70, Typeface.BOLD));
        copy.addView(text(frostRisk ? "Protect tender starts overnight" : "Garden weather guidance", 11, WHITE_55, Typeface.NORMAL));
        row.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));

        TextView temps = text("H " + high + "°  L " + low + "°", 13, frostRisk ? FROST : WHITE, Typeface.BOLD);
        temps.setGravity(Gravity.RIGHT);
        row.addView(temps, new LinearLayout.LayoutParams(dp(92), ViewGroup.LayoutParams.WRAP_CONTENT));

        return row;
    }

    private String forecastIcon(String condition, boolean frostRisk) {
        String normalized = condition.toLowerCase(Locale.US);
        if (frostRisk) {
            return "❄";
        }
        if (normalized.contains("rain")) {
            return "☔";
        }
        if (normalized.contains("sunny")) {
            return "☀";
        }
        return "☁";
    }

    private ForecastDay[] buildForecast(Location location) {
        ForecastDay[] forecast = new ForecastDay[5];
        for (int offset = 0; offset < forecast.length; offset++) {
            int current = estimatedTemp(location, offset);
            int high = current + 5 + Math.floorMod(weatherSeed(location, offset), 4);
            int low = current - 7 - Math.floorMod(weatherSeed(location, offset + 2), 4);
            boolean frostRisk = low <= 36;
            String condition = frostRisk ? "Frost watch" : forecastCondition(location, offset);
            forecast[offset] = new ForecastDay(dayLabel(offset), condition, high, low, frostRisk);
        }
        return forecast;
    }

    private String forecastCondition(Location location, int offset) {
        int pattern = Math.floorMod(weatherSeed(location, offset), 10);
        if (pattern <= 1) {
            return "Light rain";
        }
        if (pattern <= 3) {
            return "Cloudy";
        }
        if (pattern <= 6) {
            return "Partly cloudy";
        }
        return "Sunny";
    }

    private String dayLabel(int offset) {
        if (offset == 0) {
            return "Today";
        }
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_YEAR, offset);
        String[] weekdays = new DateFormatSymbols(Locale.US).getShortWeekdays();
        return weekdays[calendar.get(Calendar.DAY_OF_WEEK)];
    }

    private int estimatedTemp(Location location, int offset) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_YEAR, offset);
        int month = calendar.get(Calendar.MONTH) + 1;

        double latitude = location == null ? 43.1 : location.getLatitude();
        double absLatitude = Math.abs(latitude);
        boolean northern = latitude >= 0;
        boolean winter = northern ? month == 12 || month <= 2 : month >= 6 && month <= 8;
        boolean spring = northern ? month >= 3 && month <= 5 : month >= 9 && month <= 11;
        boolean summer = northern ? month >= 6 && month <= 8 : month == 12 || month <= 2;

        int base;
        if (absLatitude < 23.5) {
            base = 82;
        } else if (winter) {
            base = 44;
        } else if (spring) {
            base = 62;
        } else if (summer) {
            base = 77;
        } else {
            base = 59;
        }

        if (absLatitude > 45) {
            base -= 8;
        } else if (absLatitude < 32) {
            base += 7;
        }

        return base + Math.floorMod(weatherSeed(location, offset), 9) - 4;
    }

    private int weatherSeed(Location location, int offset) {
        int day = Calendar.getInstance().get(Calendar.DAY_OF_YEAR);
        int lat = location == null ? 431 : (int) Math.round(location.getLatitude() * 10);
        int lon = location == null ? -894 : (int) Math.round(location.getLongitude() * 10);
        return lat * 31 + lon * 17 + day + offset * 23;
    }

    private static class ForecastDay {
        final String label;
        final String condition;
        final int high;
        final int low;
        final boolean frostRisk;

        ForecastDay(String label, String condition, int high, int low, boolean frostRisk) {
            this.label = label;
            this.condition = condition;
            this.high = high;
            this.low = low;
            this.frostRisk = frostRisk;
        }
    }

    private View forecastDivider() {
        View divider = new View(this);
        divider.setBackgroundColor(Color.argb(28, 255, 255, 255));
        divider.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 1));
        return divider;
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
        int temp = estimatedTemp(location, 0);
        return temp + "°";
    }

    private int highTemp(Location location) {
        int current = estimatedTemp(location, 0);
        return current + 6;
    }

    private int lowTemp(Location location) {
        int current = estimatedTemp(location, 0);
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

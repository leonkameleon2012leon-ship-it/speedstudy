# Grandma's Meal Planner - Flutter App

A user-friendly Flutter meal planning application designed specifically for elderly users (like grandmothers) to easily manage daily meal schedules with simplicity and accessibility in mind.

## Features

### 🎯 Core Functionality
- **Meal Categorization**: Organize meals as breakfast, lunch, snacks, and dinner
- **Dish Management**: Add individual dishes with ingredients for each meal
- **Time Scheduling**: Set specific times for each meal
- **Animated Intro**: Pleasant steaming plate animation with greetings like "Smacznego!" and "Have a great day at work!"
- **Push Notifications**: Receive reminders for upcoming meal times

### 📱 App Screens
1. **Intro Screen**: Animated welcome with steaming plate and greetings
2. **Home Screen**: Dashboard showing upcoming meals for today
3. **Meal Management**: Add/edit meals, dishes, and ingredients with time picker
4. **Daily Planner**: Timeline view of the full day's meal schedule

### ♿ Accessibility Features
- **Large Fonts**: Extra-large text (20-40px) for easy reading
- **High Contrast**: Warm color scheme with excellent visibility
- **Simple Navigation**: Intuitive, minimal UI designed for older users
- **Large Touch Targets**: Buttons and interactive elements sized 60px+ for easy tapping

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── ingredient.dart                # Ingredient model
│   ├── dish.dart                      # Dish with ingredients
│   └── meal.dart                      # Meal with category and timing
├── screens/                           # UI screens
│   ├── intro_screen.dart              # Animated intro
│   ├── home_screen.dart               # Main dashboard
│   ├── meal_management_screen.dart    # Add/edit meals
│   └── daily_planner_screen.dart      # Timeline view
├── services/                          # Business logic
│   ├── meal_service.dart              # Meal CRUD operations
│   ├── meal_provider.dart             # State management
│   └── notification_service.dart      # Push notifications
├── widgets/                           # Reusable widgets
└── utils/                             # Utilities
    └── theme_config.dart              # Accessibility theme
```

## Installation

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions

### Setup Steps

1. **Clone the repository** (if not already done):
```bash
cd /path/to/speedstudy
```

2. **Install Flutter dependencies**:
```bash
flutter pub get
```

3. **Run the app**:
```bash
# On connected device/emulator
flutter run

# For web
flutter run -d chrome

# For specific platform
flutter run -d android
flutter run -d ios
```

## Dependencies

Key packages used in this project:

- `provider: ^6.0.5` - State management
- `shared_preferences: ^2.2.2` - Local data storage
- `flutter_local_notifications: ^16.3.0` - Push notifications
- `timezone: ^0.9.2` - Timezone handling for notifications
- `intl: ^0.18.1` - Date/time formatting and localization

## Usage Guide

### Adding a Meal
1. Tap the "New Meal" button on the home screen
2. Select meal type (Breakfast, Lunch, Snack, Dinner)
3. Set the meal time using the time picker
4. Add dishes with the "Add Dish" button
5. Enter dish name and ingredients (comma-separated)
6. Tap "Save Meal" to store

### Viewing Daily Schedule
1. Tap the calendar icon in the app bar
2. View all meals in timeline format
3. Past meals are marked as completed
4. Tap any meal to edit

### Managing Notifications
- Notifications are automatically scheduled when you save a meal
- The app requests notification permissions on first launch
- Meal reminders appear at the scheduled time with dish details

## Customization

### Changing Theme Colors
Edit `lib/utils/theme_config.dart`:
```dart
static const Color warmOrange = Color(0xFFE67E22);  // Primary color
static const Color softCream = Color(0xFFFFF8DC);   // Background
```

### Adjusting Font Sizes
Modify values in `GrandmaThemeConfig.buildAccessibleTheme()`:
```dart
displayLarge: TextStyle(fontSize: 40, ...),  // Largest headers
bodyLarge: TextStyle(fontSize: 22, ...),     // Body text
```

### Adding Localization
The app uses greeting messages that can be customized in `lib/screens/intro_screen.dart`:
```dart
final List<String> _greetings = [
  'Smacznego! 🍽️',              // Polish
  'Have a great day at work! 💼', // English
  'Enjoy your meal! 😊',          // English
  'Bon Appétit! 🌟',             // French
];
```

## Platform-Specific Setup

### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Notifications Not Working
1. Verify permissions are granted in device settings
2. Check that timezone data is initialized
3. Ensure scheduled time is in the future

### Data Not Persisting
1. Clear app data and restart
2. Check SharedPreferences permissions
3. Verify JSON serialization in models

## Future Enhancements

- [ ] Multi-language support (Polish, English, Spanish)
- [ ] Weekly meal planning view
- [ ] Shopping list generation from ingredients
- [ ] Meal history and statistics
- [ ] Recipe suggestions
- [ ] Photo upload for dishes
- [ ] Voice commands for accessibility
- [ ] Cloud sync across devices

## Contributing

This is part of the Speed Study project. For contributions:
1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push and create a Pull Request

## License

MIT License - See main repository LICENSE file

## Support

For issues or questions:
- Open an issue on GitHub
- Check existing documentation in `/docs`
- Review the main Speed Study README

---

**Made with ❤️ for Grandmas everywhere who want to plan delicious meals!**

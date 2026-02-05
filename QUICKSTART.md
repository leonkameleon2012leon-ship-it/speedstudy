# Flutter Meal Planner - Quick Start Guide

## What is this app?

A simple, accessible meal planning app designed for elderly users (grandmothers) to manage daily meals with ease.

## Key Features

✅ **Easy meal scheduling** - Set breakfast, lunch, snacks, and dinner times  
✅ **Dish tracking** - Record what you're cooking with ingredients  
✅ **Reminders** - Get notifications when it's time to eat  
✅ **Large text** - Extra-large fonts for easy reading  
✅ **Simple interface** - No complicated menus or settings  

## How to Use

### First Time Setup
1. App opens with a nice animation
2. Allow notifications when prompted
3. Start adding your meals!

### Adding a Meal
1. Tap the big orange "New Meal" button
2. Choose meal type (Breakfast/Lunch/Snack/Dinner)
3. Set the time
4. Add dish names
5. Save!

### Viewing Your Day
- Home screen shows upcoming meals
- Tap calendar icon for full day view
- Tap any meal to edit

## For Developers

### Running the App

```bash
# Get dependencies
flutter pub get

# Run on device
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

### Project Architecture

```
meal_planner/
├── models/         # Data structures (Meal, Dish, Ingredient)
├── screens/        # UI pages (Home, Intro, Management, Planner)
├── services/       # Logic (Storage, Notifications, State)
└── utils/          # Helpers (Theme, Colors)
```

### Tech Stack
- **Framework**: Flutter 3.0+
- **State**: Provider pattern
- **Storage**: SharedPreferences (local)
- **Notifications**: flutter_local_notifications
- **Theme**: Custom accessibility-focused design

## Troubleshooting

**App won't start?**
- Run `flutter clean` then `flutter pub get`

**Notifications not working?**
- Check device notification permissions
- Ensure time zone data is initialized

**Changes not saving?**
- Clear app data and restart

## Support

Questions? Check:
- Main README.md for project overview
- FLUTTER_README.md for detailed docs
- GitHub issues for known problems

---

Made with care for grandmas everywhere! 👵❤️🍽️

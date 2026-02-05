/// Unique time manipulation utilities for meal scheduling
class ClockworkHelper {
  /// Converts duration into human-friendly grandmother speech
  static String speakDuration(Duration gap) {
    if (gap.isNegative) return 'right now dear';
    
    final totalMinutes = gap.inMinutes;
    if (totalMinutes < 1) return 'any second';
    if (totalMinutes < 60) return '$totalMinutes min away';
    
    final hrs = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    
    if (mins == 0) return '$hrs ${hrs == 1 ? 'hour' : 'hours'}';
    return '$hrs hr $mins min';
  }

  /// Generates warm greeting based on current hour
  static String warmGreetingByHour() {
    final hourNow = DateTime.now().hour;
    
    if (hourNow < 6) return 'Good night 🌙';
    if (hourNow < 12) return 'Good morning sunshine ☀️';
    if (hourNow < 17) return 'Good afternoon 🌤️';
    if (hourNow < 21) return 'Good evening 🌆';
    return 'Sweet dreams 💤';
  }

  /// Creates a unique ID using timestamp with better entropy
  static String generateUniqueId(String prefix) {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    // Use object hash plus timestamp for better uniqueness
    final entropy = Object().hashCode.abs();
    return '${prefix}_${stamp}_$entropy';
  }

  /// Checks if a given time is within next N hours
  static bool withinNextHours(DateTime? target, int hourWindow) {
    if (target == null) return false;
    final now = DateTime.now();
    final futureLimit = now.add(Duration(hours: hourWindow));
    return target.isAfter(now) && target.isBefore(futureLimit);
  }

  /// Format time in grandma-friendly way
  static String friendlyTimeFormat(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    
    if (hour == 0) return '12:$minute midnight';
    if (hour == 12) return '12:$minute noon';
    if (hour < 12) return '$hour:$minute morning';
    
    final pmHour = hour - 12;
    return '$pmHour:$minute afternoon';
  }
}

/// Language and greeting utilities
class GrandmaSpeak {
  static const polishPhrases = [
    'Smacznego!',
    'Dobrego dnia!',
    'Miłego posiłku!',
  ];

  static const englishPhrases = [
    'Enjoy your meal!',
    'Have a wonderful day!',
    'Bon appétit!',
  ];

  static String randomEncouragement() {
    final allPhrases = [...polishPhrases, ...englishPhrases];
    final index = DateTime.now().second % allPhrases.length;
    return allPhrases[index];
  }

  static String getMealEncouragement(String mealType) {
    final encouragements = {
      'breakfast': ['Great way to start!', 'Morning fuel!'],
      'lunch': ['Enjoy midday break!', 'Lunch time joy!'],
      'snack': ['Sweet treat time!', 'Yummy snack!'],
      'dinner': ['Evening delight!', 'Dinner is served!'],
    };
    
    final options = encouragements[mealType.toLowerCase()] ?? ['Enjoy!'];
    return options[DateTime.now().second % options.length];
  }
}

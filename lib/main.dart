import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'services/meal_provider.dart';
import 'utils/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(GrandmasFoodPlanner());
}

class GrandmasFoodPlanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (buildCtx) => MealProvider()..initialize(),
      child: MaterialApp(
        title: 'Grandma Meal Planner',
        debugShowCheckedModeBanner: false,
        theme: GrandmaThemeConfig.buildAccessibleTheme(),
        home: LaunchSequence(),
      ),
    );
  }
}

class LaunchSequence extends StatefulWidget {
  @override
  State<LaunchSequence> createState() => _LaunchSequenceState();
}

class _LaunchSequenceState extends State<LaunchSequence> {
  int _phaseIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupNotificationAccess();
  }

  void _setupNotificationAccess() async {
    await Future.delayed(Duration(milliseconds: 800));
    if (mounted) {
      final mealStore = Provider.of<MealProvider>(context, listen: false);
      await mealStore.requestNotificationPermissions();
    }
  }

  void _advanceToMainScreen() {
    setState(() => _phaseIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    return _phaseIndex == 0 
        ? IntroScreen(onComplete: _advanceToMainScreen)
        : HomeScreen();
  }
}

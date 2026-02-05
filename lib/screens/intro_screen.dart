import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated intro screen with steaming plate animation
class IntroScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const IntroScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _plateController;
  late AnimationController _steamController;
  late AnimationController _textController;
  late Animation<double> _plateScale;
  late Animation<double> _plateRotation;
  late Animation<double> _textFade;

  final List<String> _greetings = [
    'Smacznego! 🍽️',
    'Time to eat well! 💚',
    'Enjoy your meal! 😊',
    'Bon Appétit! 🌟',
  ];

  @override
  void initState() {
    super.initState();

    // Plate animation
    _plateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _plateScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _plateController,
        curve: Curves.elasticOut,
      ),
    );

    _plateRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _plateController,
        curve: Curves.easeOut,
      ),
    );

    // Steam animation (continuous)
    _steamController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    // Start animations
    _plateController.forward().then((_) {
      _textController.forward();
      // Auto-proceed after 3 seconds
      Future.delayed(const Duration(seconds: 3), widget.onComplete);
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _steamController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _greetings[DateTime.now().hour % _greetings.length];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      body: GestureDetector(
        onTap: widget.onComplete,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Steaming plate animation
              AnimatedBuilder(
                animation: Listenable.merge([_plateController, _steamController]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _plateScale.value,
                    child: Transform.rotate(
                      angle: _plateRotation.value,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Steam particles
                            ...List.generate(3, (index) {
                              final offset = (index * 0.33);
                              final animValue =
                                  (_steamController.value + offset) % 1.0;
                              return Positioned(
                                bottom: 100 + (animValue * 80),
                                left: 85 + (math.sin(animValue * math.pi * 2) * 20),
                                child: Opacity(
                                  opacity: 1.0 - animValue,
                                  child: Container(
                                    width: 20 - (animValue * 10),
                                    height: 20 - (animValue * 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // Plate
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orange.shade100,
                                    Colors.orange.shade300,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.shade200,
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '🍽️',
                                  style: TextStyle(fontSize: 80),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              // Greeting text
              AnimatedBuilder(
                animation: _textFade,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFade.value,
                    child: Column(
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B4226),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Meal Planner',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF8B6F47),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Tap to skip
              FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'Tap to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

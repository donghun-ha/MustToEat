import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must_to_eat/view/login.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Get.off(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'images/back.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 120,
            right: 120,
            child: Image.asset(
              'images/logo.png',
              width: 200,
            ),
          ),
          // Lottie animation in the center
          Center(
            child: Lottie.asset(
              'images/foodie.json',
              controller: _controller,
              width: 300,
              height: 300,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:food_planner_app/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

  /*  _controller.addStatusListener((status){
      if(status == AnimationStatus.completed){
        _checkLoginStatus();
      }
    })*/;
  }

  Future<void>_checkLoginStatus() async{
    final authProvider = Provider.of<MyAuthProvider>(context,listen: false);
    await authProvider.checkLoginStatus();
    if(authProvider.isLoggedIn && !authProvider.isGuest ){
      Navigator.pushNamed(context, 'home_screen');
    }else{
      Navigator.pushNamed(context, 'login_screen');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E4),
      body: Center(
        child: Lottie.asset(
          'assets/animation/splash_animation.json',
          controller: _controller,
          onLoaded: (composition) {

            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() {
              _checkLoginStatus();
              });
          },
          width: 300,
          height: 300,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                Text('Error loading animation: $error'),
                Text('Searched path: assets/animation/splash_animation.json'),
              ],
            );
          },
        ),
      ),
    );
  }
}
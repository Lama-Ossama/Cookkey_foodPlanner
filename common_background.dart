import 'package:flutter/material.dart';
import'package:food_planner_app/constants.dart';
Container buildBackGround() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/food_bg.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.5),          // subtle dark overlay to balance details
            kPrimaryColor.withOpacity(0.5),
          ],
        ),
      ),
    ),
  );
}
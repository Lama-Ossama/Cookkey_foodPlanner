import 'package:flutter/material.dart';
import 'package:food_planner_app/models/planned_meal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanProvider with ChangeNotifier {
  final List<PlannedMeal> _weeklyPlan = [];

  List<PlannedMeal> get weeklyPlan => List.unmodifiable(_weeklyPlan);

  /// إضافة وجبة ليوم معين
  void addMeal(PlannedMeal meal) {
    // نمنع إضافة أكتر من وجبة في نفس اليوم
    _weeklyPlan.removeWhere((m) => m.day == meal.day);
    _weeklyPlan.add(meal);
    notifyListeners();
  }


  void removeMealByDay(String day) {
    _weeklyPlan.removeWhere((meal) => meal.day == day);
    notifyListeners();
  }


  Future<void> uploadPlanToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    List<Map<String, dynamic>> planAsMap = _weeklyPlan.map((meal) => meal.toMap()).toList();

    await userDoc.set({'weeklyPlan': planAsMap}, SetOptions(merge: true));
  }


  Future<void> fetchPlanFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists && snapshot.data()?['weeklyPlan'] != null) {
      final List<dynamic> data = snapshot.data()!['weeklyPlan'];
      _weeklyPlan.clear();
      _weeklyPlan.addAll(data.map((e) => PlannedMeal.fromMap(e)).toList());
      notifyListeners();
    }
  }


  void clearPlan() {
    _weeklyPlan.clear();
    notifyListeners();
  }
}

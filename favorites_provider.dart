import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<MealSummary> _favorites = [];

  List<MealSummary> get favorites => List.unmodifiable(_favorites);


    void addFavorite(MealSummary meal) {
    if (!_favorites.any((m) => m.id == meal.id)) {
      _favorites.add(meal);
      notifyListeners();
    }
  }


  void removeFavorite(String mealId) {
    _favorites.removeWhere((meal) => meal.id == mealId);
    notifyListeners();
  }


  bool isFavorite(String mealId) {
    return _favorites.any((meal) => meal.id == mealId);
  }


  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }


  Future<void> uploadFavoritesToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    List<Map<String, dynamic>> favoritesMap = _favorites.map((meal) => meal.toMap()).toList();

    await userDoc.set({'favorites': favoritesMap}, SetOptions(merge: true));
  }

    Future<void> fetchFavoritesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists && snapshot.data()?['favorites'] != null) {
      final List<dynamic> data = snapshot.data()!['favorites'];
      _favorites.clear();
      _favorites.addAll(data.map((e) => MealSummary.fromMap(e)).toList());
      notifyListeners();
    }
  }
}

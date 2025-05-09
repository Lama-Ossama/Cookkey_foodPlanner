import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_planner_app/providers/plan_provider.dart';
import '../helper/shared_prefs.dart';

class  MyAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isGuest = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  bool get isFirebaseUserLoggedIn => FirebaseAuth.instance.currentUser != null;

  MyAuthProvider() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    _isLoggedIn = await SharedPrefsHelper.isUserLoggedIn();
    _isGuest = await SharedPrefsHelper.isGuestUser();

    print("CHECK LOGIN => Firebase: ${firebaseUser != null}, isLoggedIn: $_isLoggedIn, isGuest: $_isGuest");


    if (_isLoggedIn && !_isGuest && firebaseUser == null) {
      await logout();
    }

    notifyListeners();
  }

  Future<void> login(User? user) async {
    _isLoggedIn = true;
    _isGuest = false;
    await SharedPrefsHelper.setLoginStatus(isLoggedIn: true, isGuest: false);
    notifyListeners();
  }

  Future<void> loginAsGuest() async {
    _isLoggedIn = true;
    _isGuest = true;
    await SharedPrefsHelper.setLoginStatus(isLoggedIn: true, isGuest: true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _isGuest = false;
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('isGuest');
    notifyListeners();
  }
}

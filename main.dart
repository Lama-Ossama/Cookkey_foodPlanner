import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_planner_app/providers/favorites_provider.dart';
import 'package:food_planner_app/providers/plan_provider.dart';
import 'package:provider/provider.dart';
import 'package:food_planner_app/screens/areaMeals_screen.dart';
import 'package:food_planner_app/screens/categoryMeals_screen.dart';
import 'package:food_planner_app/screens/favorites_screen.dart';
import 'package:food_planner_app/screens/home_screen.dart';
import 'package:food_planner_app/screens/login_screen.dart';
import 'package:food_planner_app/screens/mealDetails_screen.dart';
import 'package:food_planner_app/screens/register_screen.dart';
import 'package:food_planner_app/firebase_options.dart';
import 'package:food_planner_app/screens/search_screen.dart';
import 'package:food_planner_app/screens/splash_screen.dart';
import 'package:food_planner_app/screens/weeklyPlan_screen.dart';
import 'package:food_planner_app/providers/auth_provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await precacheLottie();
  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(create:(_) => MyAuthProvider()),
      ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ChangeNotifierProvider(create: (_) => PlanProvider()),
    ],
      child: MyApp(),
    ),
  );

}
 Future<void> precacheLottie ()async{
  await rootBundle.load('assets/animation/splash_animation.json');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      routes: {
        'login_screen':(context)=> LoginScreen(),
        'register_screen':(context) => RegisterScreen(),
        'home_screen': (context) => HomeScreen(),
        'splash_screen':(context) => SplashScreen(),
        'categoryMeals_screen':(context) => CategoryMealsScreen(),
        'mealDetails_screen':(context) => MealDetailsScreen(),
        'areaMeals_screen':(context) => AreaMealsScreen(),
        'favorites_screen':(context) => FavoritesScreen(),
        'weeklyPlan_screen':(context) => WeeklyPlanScreen(),
        'search_screen':(context) => SearchScreen(),

      },
      initialRoute: 'splash_screen',
    );
  }
}

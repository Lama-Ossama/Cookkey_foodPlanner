import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';
import 'package:food_planner_app/services/listMealBasedOnCategory.dart';
import 'package:food_planner_app/helper/favorites_database.dart';
import 'package:food_planner_app/widgets/meal_tile.dart';

class CategoryMealsScreen extends StatefulWidget {
  const CategoryMealsScreen({super.key});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late Future<List<MealSummary>> _mealsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    _mealsFuture = MealsByCategoryService().fetchMealsByCategory(categoryName);
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(categoryName),
        iconTheme: const IconThemeData(color: Colors.brown),
        titleTextStyle: const TextStyle(
          color: Color(0xFFFFF1D6),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFEAC6),
      body: FutureBuilder<List<MealSummary>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load meals'));
          } else {
            final meals = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return MealTile(meal: meal);
              },
            );
          }
        },
      ),
    );
  }
}

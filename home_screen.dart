import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/models/meal_category_model.dart';
import 'package:food_planner_app/providers/auth_provider.dart';
import 'package:food_planner_app/services/CategoryService.dart';
import 'package:food_planner_app/widgets/categoryTile_widget.dart';
import 'package:food_planner_app/widgets/AreaTile_widget.dart';
import 'package:food_planner_app/data/area_data.dart';
import 'package:food_planner_app/models/all_areas_model.dart';
import 'package:food_planner_app/services/list_all_areas.dart';
import 'package:food_planner_app/services/get_random_meal.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/plan_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<MealSummary> _randomMealFuture;

  @override
  void initState() {
    super.initState();
    _randomMealFuture = RandomMealService().fetchRandomMeal();
  }

  final areas = areaFlags.entries.toList();
  final CategoryService categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAC6),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Cookkey', style: TextStyle(color: Color(0xFFFFF1D6),fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.brown),
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView( // Added to enable scrolling
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hello there 👋",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "What are you planning to eat today?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'search_screen');
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for recipes...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Section
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 105,
                child: FutureBuilder<List<MealCategoryModel>>(
                  future: categoryService.getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    } else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return buildCategoryTile(
                            category.name,
                            category.thumbnail,
                            const Color(0xFFF9D8A7),
                                () {
                              Navigator.pushNamed(
                                  context,
                                  'categoryMeals_screen',
                                  arguments: category.name);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Meal of the Day Section
              const Text("Meal of the Day 🍽", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FutureBuilder<MealSummary>(
                future: _randomMealFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("Failed to load meal");
                  } else {
                    final meal = snapshot.data!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            'mealDetails_screen',
                            arguments: meal.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16), // Reduced margin
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                meal.thumbnail,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                meal.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),

              // Areas Section
              const Text("Cuisines by Region", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: FutureBuilder<List<AllAreasModel>>(
                  future: AllAreasService().allAreas(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text('Failed to load areas');
                    } else {
                      final areas = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemCount: areas.length,
                        itemBuilder: (context, index) {
                          final area = areas[index].area;
                          final flagUrl = areaFlags[area] ?? 'https://via.placeholder.com/100x60?text=?';
                          return buildAreaTile(
                            title: area,
                            imageUrl: flagUrl,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'areaMeals_screen',
                                arguments: area,
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16), // Added bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9D8A7),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Cookkey',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFF1D6),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.brown),
            title: const Text('Home', style: TextStyle(color: Colors.brown)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.redAccent),
            title: const Text('Favorites', style: TextStyle(color: Colors.brown)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'favorites_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_sharp, color: Colors.black),
            title: const Text('Plan of the Week', style: TextStyle(color: Colors.brown)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'weeklyPlan_screen');
            },
          ),
          ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Log out', style: TextStyle(color: Colors.brown)),
              onTap: () async {

                _handleLogout(context);
              }
          ),
        ],
      ),
    );
  }
  Future<void> _handleLogout(BuildContext context) async {
    try{
      Navigator.pop(context);

    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    await authProvider.logout();
    Navigator.pushNamedAndRemoveUntil(
        context,
        'login_screen',
            (route) => false
    );
  } catch (e) {
  debugPrint('Logout error: $e');
  // Optionally show an error dialog
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Logout failed. Please try again.')),
  );
  }
  }
}
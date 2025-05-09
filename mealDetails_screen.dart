import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/models/meal_details_model.dart';
import 'package:food_planner_app/services/list_all_mealDetails.dart';
import 'package:food_planner_app/widgets/youtubePlayer.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  late Future<MealDetails > _mealFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mealId = ModalRoute.of(context)!.settings.arguments as String;
    _mealFuture = MealDetailsService().fetchMealDetails(mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAC6),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Meal Details"),
        iconTheme: const IconThemeData(color: Colors.brown),
        titleTextStyle: const TextStyle(
          color: Color(0xFFFFF1D6),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: FutureBuilder<MealDetails>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load meal details'));
          } else {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Image
                  Hero(
                    tag: meal.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        meal.thumbnail,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Meal Title
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category and Area
                  Row(
                    children: [
                      _buildDetailChip(Icons.category, meal.category),
                      const SizedBox(width: 8),
                      _buildDetailChip(Icons.location_on, meal.area),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 16),

                  // Ingredients Section
                  const Text(
                    "INGREDIENTS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: meal.ingredients.map((ingredient) => Chip(
                      backgroundColor: const Color(0xFFF9D8A7),
                      label: Text(
                        ingredient,
                        style: const TextStyle(color: Colors.brown),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 16),

                  // Instructions Section
                  const Text(
                    "INSTRUCTIONS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    meal.instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  // YouTube Video (if available)
                  if (meal.youtubeUrl.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 16),
                    const Text(
                      "VIDEO TUTORIAL",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 12),
                    YoutubePlayerWidget(videoUrl: meal.youtubeUrl),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.brown),
      backgroundColor: const Color(0xFFF9D8A7).withOpacity(0.6),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.brown,
        ),
      ),
    );
  }
}


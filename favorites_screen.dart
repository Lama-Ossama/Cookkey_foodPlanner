import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/helper/favorites_database.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<MealSummary>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = FavoritesDatabaseHelper.instance.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites ❤️'),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.brown),
        titleTextStyle: const TextStyle(
          color: Color(0xFFFFF1D6),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFEAC6),
      body: FutureBuilder<List<MealSummary>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite meals yet.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final meal = favorites[index];
                return ListTile(
                  leading: Image.network(meal.thumbnail, width: 60, fit: BoxFit.cover),
                  title: Text(meal.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FavoritesDatabaseHelper.instance.removeFavorite(meal.id);
                      setState(() {
                        _loadFavorites(); // reload after deletion
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'mealDetails_screen',
                      arguments: meal.id,
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

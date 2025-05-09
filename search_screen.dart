import 'package:flutter/material.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';
import 'package:food_planner_app/services/listMealBasedOnCategory.dart';
import 'package:food_planner_app/services/listMealBasedOnIngredient.dart';
import 'package:food_planner_app/services/listMealBasedOnArea.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchType = 'Category';
  String searchQuery = '';
  List<MealSummary> searchResults = [];
  bool isLoading = false;

  Future<void> performSearch() async {
    setState(() {
      isLoading = true;
      searchResults.clear();
    });

    try {
      List<MealSummary> results = [];

      if (searchType == 'Category') {
        results = await MealsByCategoryService().fetchMealsByCategory(searchQuery);
      } else if (searchType == 'Ingredient') {
        results = await MealsByIngredientService().fetchMealsByIngredient(searchQuery);
      } else if (searchType == 'Country') {
        results = await MealsByAreaService().fetchMealsByArea(searchQuery);
      }

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print("Search error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAC6),
      appBar: AppBar(
        title: const Text("Search Meals"),
        backgroundColor: const Color(0xFFFFEAC6),
        iconTheme: const IconThemeData(color: Colors.brown),
        titleTextStyle: const TextStyle(
          color: Colors.brown,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter keyword...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (value) {
                searchQuery = value.trim();
              },
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: searchType,
              items: const [
                DropdownMenuItem(value: 'Category', child: Text('Category')),
                DropdownMenuItem(value: 'Ingredient', child: Text('Ingredient')),
                DropdownMenuItem(value: 'Country', child: Text('Country')),
              ],
              onChanged: (value) {
                setState(() {
                  searchType = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: performSearch,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (searchResults.isEmpty && searchQuery.isNotEmpty)
              const Text("No meals found.")
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final meal = searchResults[index];
                    return ListTile(
                      title: Text(meal.name),
                      leading: Image.network(meal.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
                      onTap: () {
                        Navigator.pushNamed(context, 'mealDetails_screen', arguments: meal.id);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

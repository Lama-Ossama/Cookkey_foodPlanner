import 'dart:convert';
import 'package:http/http.dart' ;
import 'package:food_planner_app/helper/api.dart';
import '../models/meal_summary_model.dart';

class MealsByCategoryService {
  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
  Response response = await Api().get(url: 'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');

      final data = jsonDecode(response.body);
      final meals = data['meals'] as List<dynamic>;
      return meals.map((json) => MealSummary.fromJson(json)).toList();

  }
}

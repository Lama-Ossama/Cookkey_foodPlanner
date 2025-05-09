import 'dart:convert';
import 'package:http/http.dart';
import 'package:food_planner_app/helper/api.dart';
import '../models/meal_summary_model.dart';

class SearchMealService {
  Future<List<MealSummary>> searchMealsByName(String query) async {
    Response response = await Api().get(url: 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query');

      final data = jsonDecode(response.body);
      final mealsList = data['meals'];
      if (mealsList == null) {

        return [];
      }
      return mealsList.map<MealSummary>((json) => MealSummary.fromJson(json)).toList();
  }
}

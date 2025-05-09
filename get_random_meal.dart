import 'dart:convert';
import 'package:food_planner_app/helper/api.dart';
import 'package:http/http.dart';
import '../models/meal_summary_model.dart';

class RandomMealService {
  Future<MealSummary> fetchRandomMeal() async {
    Response response = await Api().get(url: 'https://www.themealdb.com/api/json/v1/1/random.php');

      final data = jsonDecode(response.body);
      final mealData = data['meals'][0];
      return MealSummary.fromJson(mealData);

  }
}

//service بتجيب كل الوجبات حسب المكون
import 'dart:convert';
import 'package:http/http.dart' ;
import 'package:food_planner_app/helper/api.dart';
import '../models/meal_summary_model.dart';
class MealsByIngredientService {
  Future<List<MealSummary>> fetchMealsByIngredient(String ingredient) async {
   Response response = await Api().get(url: 'https://www.themealdb.com/api/json/v1/1/filter.php?i=$ingredient');


      final decoded = jsonDecode(response.body);
      final List meals = decoded['meals'];
      return meals.map((json) => MealSummary.fromJson(json)).toList();
  }
}

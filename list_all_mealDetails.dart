import 'dart:convert';
import 'package:http/http.dart' ;
import 'package:food_planner_app/helper/api.dart';
import '../models/meal_details_model.dart';

class MealDetailsService {
  Future<MealDetails> fetchMealDetails(String id) async {
   Response response = await Api().get(url: 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');


      final decoded = jsonDecode(response.body);
      final List meals = decoded['meals'];
      return MealDetails.fromJson(meals.first);

  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_category_model.dart';

class CategoryService {
  Future<List<MealCategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    final data = jsonDecode(response.body);
    final List categories = data['categories'];

    return categories.map((json) => MealCategoryModel.fromJson(json)).toList();
  }
}

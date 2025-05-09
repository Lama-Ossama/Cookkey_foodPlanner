import 'package:food_planner_app/models/meal_summary_model.dart';
class PlannedMeal {
  final String id;
  final String name;
  final String thumbnail;
  final String day;


  PlannedMeal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.day,
  });

  // بحول من object ل map (database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'day': day,
    };
  }

  // بحول من map ل object
  factory PlannedMeal.fromMap(Map<String, dynamic> map) {
    return PlannedMeal(
      id: map['id'],
      name: map['name'],
      thumbnail: map['thumbnail'],
      day: map['day'],
    );
  }
}

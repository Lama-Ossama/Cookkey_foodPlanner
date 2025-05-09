class MealSummary {
  final String id;
  final String name;
  final String thumbnail;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }
//عشان احول من model ل database (favorites)
  factory MealSummary.fromMap(Map<String, dynamic> map) {
    return MealSummary(
      id: map['id'],
      name: map['name'],
      thumbnail: map['thumbnail'],
    );
  }
  //للتحويل من database ل model
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
    };
  }
}


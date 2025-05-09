class MealCategoryModel {
  final String name;
  final String thumbnail;
  final String description;

  MealCategoryModel({
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory MealCategoryModel.fromJson(Map<String, dynamic> json) {
    return MealCategoryModel(
      name: json['strCategory'],
      thumbnail: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}

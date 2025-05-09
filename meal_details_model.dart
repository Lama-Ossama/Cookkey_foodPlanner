class MealDetails {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  MealDetails({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return MealDetails(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      youtubeUrl: json['strYoutube']??'',
      ingredients: ingredients,
      measures: measures,
    );
  }
}

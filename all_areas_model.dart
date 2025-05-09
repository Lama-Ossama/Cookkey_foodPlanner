
class AllAreasModel{
  final String area;
  AllAreasModel({required this.area});
  factory AllAreasModel.fromJson(Map<String, dynamic> json){
    return AllAreasModel(area:json['strArea']);
  }
}


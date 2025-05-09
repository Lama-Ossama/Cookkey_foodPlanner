
// service بتجيب كل البلاد
import 'package:food_planner_app/models/all_areas_model.dart';
import 'dart:convert';
import 'package:http/http.dart' ;
import 'package:food_planner_app/helper/api.dart';
class AllAreasService{
  Future<List<AllAreasModel>> allAreas () async{
    Response response = await Api().get(url: 'https://www.themealdb.com/api/json/v1/1/list.php?a=list');

      final decoded = jsonDecode(response.body);
      final List areas = decoded['meals'];
      return areas.map((json) => AllAreasModel.fromJson(json)).toList();


    }
  }



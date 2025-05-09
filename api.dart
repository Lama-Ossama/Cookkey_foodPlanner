import 'package:http/http.dart' as http;
class Api{
  Future<http.Response> get({required String url}) async{
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 ){
      return response;
    }else
      {
        throw Exception(
          'there is a problem loading data${response.statusCode}');
      }
  }
}
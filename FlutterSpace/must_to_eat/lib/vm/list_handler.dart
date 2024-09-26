import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:must_to_eat/model/must_eat.dart';

class ListHandler {
  final String defaultUrl = "http://127.0.0.1:8000/must_eat";
  final GetStorage box = GetStorage();

  Future<List<dynamic>> queryJSONData() async {
    var url =
        Uri.parse('$defaultUrl/select?user_id=${box.read('must_user_id')}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    // print(result);
    return result.map((e) => MustEat.fromlist(e)).toList();
    // MustEat.fromlist(e)
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:must_to_eat/model/user.dart';

class UserHandler {
  final String defaultUrl = "http://127.0.0.1:8000/user";

  insertJSONData(User user) async {
    var url = Uri.parse(
        '$defaultUrl/insert?id=${user.id}&password=${user.password}&name=${user.name}&phone=${user.phone}&address=${user.address}&email=${user.email}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == "Cool") {
      return true;
    } else {
      return false;
    }
  }

  loginJSONData(String id, String password) async {
    var url = Uri.parse('$defaultUrl/login?id=${id}&password=${password}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    print(dataConvertedJSON);
    var result = dataConvertedJSON['available'];
    return result;
  }

  idCheck(String id) async {
    var url = Uri.parse('$defaultUrl/check_id?id=$id');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['available'];
    print(result);
    return result;
  }
}

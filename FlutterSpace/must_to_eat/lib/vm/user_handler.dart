import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:must_to_eat/model/user.dart';

class UserHandler {
  final String defaultUrl = "http://127.0.0.1:8000/user";
  final GetStorage box = GetStorage();

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

  updateJSONData(String id, String name, String phone, String address,
      String email) async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/user/update?id=$id&name=$name&phone=$phone&address=$address&email=$email');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == 'Cool') {
      return true;
    } else {
      return false;
    }
  }

  updatePWJSONData(String id, String password) async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/user/updatePW?id=$id&password=$password');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == 'Cool') {
      return true;
    } else {
      return false;
    }
  }
}

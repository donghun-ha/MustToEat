import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
    print(result);
    print(result.runtimeType);
    if (result == 'Cool') {
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

  selectJSONData() async {
    var url = Uri.parse('$defaultUrl/select?id=${box.read('must_user_id')}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
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

  uploadImage(XFile imageFile) async {
    String filename = '';
    // 파일 전송
    var requset = http.MultipartRequest(
      "POST",
      Uri.parse("$defaultUrl/upload"),
    );
    var multipartFile =
        await http.MultipartFile.fromPath('file', imageFile.path);
    requset.files.add(multipartFile);

    // for getting file name
    List preFileName = imageFile.path.split('/');
    filename = preFileName[preFileName.length - 1];

    var response = await requset.send();

    // 200 번은 성공
    if (response.statusCode == 200) {
      return filename;
    } else {
      return false;
    }
  }

  insertUserImage(String id, String imagePath) async {
    var url = Uri.parse('$defaultUrl/insertImage?id=$id&imagePath=$imagePath');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    print(result);
    print(result.runtimeType);
    if (result == 'Cool') {
      return true;
    } else {
      return false;
    }
  }

  deleteUserImage(String filename) async {
    var url = Uri.parse('$defaultUrl/deleteFile/$filename');
    var response = await http.delete(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == "OK") {
      return true;
    } else {
      return false;
    }
  }
}

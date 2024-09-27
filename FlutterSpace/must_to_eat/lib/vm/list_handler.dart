import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:must_to_eat/model/must_eat.dart';

class ListHandler {
  final String defaultUrl = "http://127.0.0.1:8000/must_eat";
  final GetStorage box = GetStorage();

  Future<List<dynamic>> queryJSONData(String search) async {
    var url = Uri.parse(
        '$defaultUrl/select?user_id=${box.read('must_user_id')}&search=$search');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    return result.map((e) => MustEat.fromlist(e)).toList();
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

  insertJSONData(MustEat mustEat) async {
    var url = Uri.parse(
        '$defaultUrl/insert?user_id=${mustEat.userId}&name=${mustEat.name}&address=${mustEat.address}&longtitude=${mustEat.longtitude}&latitude=${mustEat.latitude}&image=${mustEat.image}&review=${mustEat.review}&rank_point=${mustEat.rankPoint}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == "OK") {
      //
      print('succescsc');
    } else {
      //
      print('falseqqq');
    }
  }

  deleteJSONData(int seq) async {
    var url = Uri.parse('$defaultUrl/delete?seq=$seq');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == "OK") {
      //
      print('succescsc');
    } else {
      //
      print('falseqqq');
    }
  }
}

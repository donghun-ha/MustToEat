import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_to_eat/model/must_eat.dart';
import 'package:must_to_eat/vm/list_handler.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final ListHandler handler = ListHandler();
  final GetStorage box = GetStorage();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController reviewController;
  late TextEditingController estimateController;
  double? latData;
  double? longData;
  Position? currentPosition;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    reviewController = TextEditingController();
    estimateController = TextEditingController();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = position;
        latData = position.latitude;
        longData = position.longitude;
        latitudeController.text = latData.toString();
        longitudeController.text = longData.toString();
      });
    } catch (e) {
      print("위치 정보를 가져올 수 없습니다: $e");
      latData = 37.5665;
      longData = 126.9780;
      latitudeController.text = latData.toString();
      longitudeController.text = longData.toString();
    }
  }

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  void addRestaurant() {
    // 여기에 서버로 데이터를 보내는 로직을 구현할 예정
    // 현재는 임시로 콘솔에 출력만 합니다.
    print('Restaurant Name: ${nameController.text}');
    print('Phone: ${phoneController.text}');
    print('Latitude: ${latitudeController.text}');
    print('Longitude: ${longitudeController.text}');
    print('Rating: ${estimateController.text}');
    print('Image Path: ${imageFile?.path}');

    // 데이터 추가 후 이전 화면으로 돌아가기
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Restaurant',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/back.png'), fit: BoxFit.cover),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('images/back.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: getImageFromGallery,
                    child: const Text('Select Image'),
                  ),
                  const SizedBox(height: 16),
                  if (imageFile != null)
                    Image.file(File(imageFile!.path),
                        height: 200, fit: BoxFit.cover)
                  else
                    const Text('No image selected'),
                  const SizedBox(height: 16),
                  buildTextField(
                      'Name', nameController, 'Enter restaurant name'),
                  buildTextField('Phone', phoneController, 'Enter phone number',
                      TextInputType.phone),
                  buildTextField('Address', addressController, 'Address',
                      TextInputType.text),
                  buildTextField('Latitude', latitudeController, 'Latitude',
                      TextInputType.number),
                  buildTextField('Longitude', longitudeController, 'Longitude',
                      TextInputType.number),
                  buildTextField(
                      'review', reviewController, 'review', TextInputType.text),
                  buildTextField('Rating', estimateController,
                      'Enter rating (0-5)', TextInputType.number),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => insertAction(),
                    child: const Text('Add Restaurant'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, String hint,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  insertAction() async {
    // 이미지 올리기
    // filename이 필요하므로 filename을 얻기 전까지는 다음 단계를 멈춘다.
    var result = await handler.uploadImage(imageFile!);

    if (result != false) {
      // address에 올리기
      MustEat mustEat = MustEat(
        userId: box.read('must_user_id'),
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        longtitude: double.parse(longitudeController.text.trim()),
        latitude: double.parse(latitudeController.text.trim()),
        review: reviewController.text.trim(),
        rankPoint: double.parse(estimateController.text.trim()),
        image: result,
      );
      await handler.insertJSONData(mustEat);
      Get.back();
    }
  }
}

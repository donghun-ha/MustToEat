import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
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
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
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
      // 기본 위치 설정 (예: 서울시청)
      latData = 37.5665;
      longData = 126.9780;
      latitudeController.text = latData.toString();
      longitudeController.text = longData.toString();
    }
  }

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
        title: const Text('Add Restaurant', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('images/back.png'), fit: BoxFit.cover),
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
                    Image.file(File(imageFile!.path), height: 200, fit: BoxFit.cover)
                  else
                    const Text('No image selected'),
                  const SizedBox(height: 16),
                  buildTextField('Name', nameController, 'Enter restaurant name'),
                  buildTextField('Phone', phoneController, 'Enter phone number', TextInputType.phone),
                  buildTextField('Latitude', latitudeController, 'Latitude', TextInputType.number),
                  buildTextField('Longitude', longitudeController, 'Longitude', TextInputType.number),
                  buildTextField('Rating', estimateController, 'Enter rating (0-5)', TextInputType.number),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: addRestaurant,
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

  Widget buildTextField(String label, TextEditingController controller, String hint, [TextInputType? keyboardType]) {
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
}
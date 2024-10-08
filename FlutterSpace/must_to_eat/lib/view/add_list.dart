import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_to_eat/model/must_eat.dart';
import 'package:must_to_eat/view/location_picker.dart';
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
  late TextEditingController addressController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController reviewController;
  late TextEditingController estimateController;

  String? nameError;
  String? addressError;
  String? latError;
  String? longError;
  String? reviewError;
  String? ratingError;

  double? latData;
  double? longData;
  Position? currentPosition;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
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
      // latData = 37.5665;
      // longData = 126.9780;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // 키보드 올라와도 레이아웃이 변경되지 않도록 설정
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
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('images/back.png', fit: BoxFit.cover),
            ),
            SingleChildScrollView(
              child: Padding(
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
                      Image.file(
                        File(imageFile!.path),
                        height: 200,
                      )
                    else
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: const Center(
                            child: Text(
                          '이미지를 선택하세요!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        )),
                      ),
                    const SizedBox(height: 16),
                    buildTextField('Name', nameController,
                        'Enter restaurant name', nameError),
                    buildTextField('Address', addressController, 'Address',
                        addressError, TextInputType.text),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            var returnLatLong = await Get.to(
                                () => const LocationPicker(),
                                arguments: [latData, longData]);
                            if (returnLatLong != null) {
                              latData = returnLatLong[0];
                              longData = returnLatLong[1];
                              latitudeController.text = latData.toString();
                              longitudeController.text = longData.toString();
                            }
                            setState(() {});
                          },
                          label: const Text('위치 변경'),
                          icon: const Icon(Icons.location_on_rounded),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: latitudeController,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: 'Latitude',
                            hintText: 'Latitude',
                            border: const OutlineInputBorder(),
                            errorText: latError),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: longitudeController,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: 'Longitude',
                            hintText: 'Longitude',
                            border: const OutlineInputBorder(),
                            errorText: longError),
                      ),
                    ),
                    buildTextField('review', reviewController, 'review',
                        reviewError, TextInputType.text),
                    buildTextField(
                        'Rating',
                        estimateController,
                        'Enter rating (0-5)',
                        ratingError,
                        TextInputType.number),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => insertAction(),
                      child: const Text('Add Restaurant'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      String hint, String? error,
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
            errorText: error),
      ),
    );
  }

  insertAction() async {
    // 이미지 올리기
    // filename이 필요하므로 filename을 얻기 전까지는 다음 단계를 멈춘다.
    nameError = nameController.text.trim().isEmpty ? '맛집 이름을 입력해주세요' : null;
    addressError = addressController.text.trim().isEmpty ? '주소를 입력해주세요' : null;
    latError = latitudeController.text.trim().isEmpty ? '위도를 입력해주세요' : null;
    longError = longitudeController.text.trim().isEmpty ? '경도를 입력해주세요' : null;
    reviewError = reviewController.text.trim().isEmpty ? '리뷰를 입력해주세요' : null;
    ratingError = estimateController.text.trim().isEmpty ? '점수를 입력해주세요' : null;

    if (nameError != null ||
        addressError != null ||
        latError != null ||
        longError != null ||
        reviewError != null ||
        ratingError != null) {
      // 입력 실패
      print('빈값 채워주세요');
    } else {
      String result = '';
      if (imageFile == null) {
        //
        print('이미지 선택 알람');
      } else {
        result = await handler.uploadImage(imageFile!);
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
    setState(() {});
  }
}

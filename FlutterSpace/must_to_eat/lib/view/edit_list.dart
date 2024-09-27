import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_to_eat/model/must_eat.dart';
import 'package:must_to_eat/view/location_picker.dart';
import 'package:must_to_eat/vm/list_handler.dart';

class EditList extends StatefulWidget {
  const EditList({super.key});

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  final ListHandler handler = ListHandler();
  // final GetStorage box = GetStorage();

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
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  final MustEat value = Get.arguments ?? "__";

  int firstDisp = 0;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: value.name);
    addressController = TextEditingController(text: value.address);
    latitudeController = TextEditingController(text: value.latitude.toString());
    longitudeController =
        TextEditingController(text: value.longtitude.toString());
    reviewController = TextEditingController(text: value.review);
    estimateController =
        TextEditingController(text: value.rankPoint.toString());
  }

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      firstDisp += 1;
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Restaurant',
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
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: firstDisp == 0
                          ? Image.network(
                              'http://127.0.0.1:8000/must_eat/view/${value.image}')
                          : Image.file(File(imageFile!.path))),
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
                              arguments: [value.latitude, value.longtitude]);
                          if (returnLatLong != null) {
                            latitudeController.text =
                                returnLatLong[0].toString();
                            longitudeController.text =
                                returnLatLong[1].toString();
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
                  buildTextField('Rating', estimateController,
                      'Enter rating (0-5)', ratingError, TextInputType.number),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (firstDisp == 0) {
                        updateAction();
                      } else {
                        updateActionAll();
                      }
                    },
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

  // 이미지 변경없음
  updateAction() async {
    bool check = checkData();
    if (check) {
      MustEat mustEat = MustEat(
        seq: value.seq,
        userId: value.userId,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        longtitude: double.parse(longitudeController.text.trim()),
        latitude: double.parse(latitudeController.text.trim()),
        review: reviewController.text.trim(),
        rankPoint: double.parse(estimateController.text.trim()),
        image: value.image,
      );
      await handler.updateJSONData(mustEat);
      Get.back();
    }
    setState(() {});
  }

  updateActionAll() async {
    print('all');
    bool check = checkData();
    if (check) {
      await handler.removeImage(value.image!);
      await handler.uploadImage(imageFile!);
      List preFileName = imageFile!.path.split('/');
      MustEat mustEat = MustEat(
        seq: value.seq,
        userId: value.userId,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        longtitude: double.parse(longitudeController.text.trim()),
        latitude: double.parse(latitudeController.text.trim()),
        review: reviewController.text.trim(),
        rankPoint: double.parse(estimateController.text.trim()),
        image: preFileName[preFileName.length - 1],
      );
      await handler.updateJSONDataAll(mustEat);
      Get.back();
    }
    setState(() {});
  }

  checkData() {
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
      // 입력 실패 빈칸을 채워야함
      return false;
    } else {
      // 입력
      return true;
    }
  }
}

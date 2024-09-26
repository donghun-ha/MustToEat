import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_to_eat/model/must_eat.dart';

class EditList extends StatefulWidget {
  const EditList({super.key});

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  late TextEditingController nameController;
  late TextEditingController reviewController;
  late TextEditingController estimateController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  MustEat value = Get.arguments ?? '__';

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: value.name);
    reviewController = TextEditingController(text: value.review);
    estimateController = TextEditingController(
      text: value.rankPoint.toString(),
    );
    latitudeController = TextEditingController(text: value.latitude.toString());
    longitudeController =
        TextEditingController(text: value.longtitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/back.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () => getImageFromGallery(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFD4D05),
                      foregroundColor: Colors.white,
                      fixedSize: const Size(150, 0),
                    ),
                    child: const Text('Image'),
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 200,
                  child: Center(
                    child: _buildImageWidget(),
                  ),
                ),
                buildLocationFields(),
                buildTextField('Name', nameController),
                buildTextField('Review', reviewController, TextInputType.text),
                buildRatingField('Rating', estimateController),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: ElevatedButton(
                    onPressed: updateList,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 0),
                      backgroundColor: const Color(0xffFBB816),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imageFile != null) {
      return Image.file(File(imageFile!.path));
    } else if (value.image != null) {
      return Image.asset('images/placeholder.png');
    } else {
      return const Text('No image selected');
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRatingField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocationFields() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Location :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 135,
              child: TextField(
                controller: latitudeController,
                decoration: const InputDecoration(
                  hintText: '위도',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 135,
              child: TextField(
                controller: longitudeController,
                decoration: const InputDecoration(
                  hintText: '경도',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        imageFile = XFile(pickedFile.path);
      });
    }
  }

  Future updateList() async {
    // 여기에 서버로 데이터를 보내는 로직을 구현할 예정
    // 현재는 임시로 콘솔에 출력만 합니다.
    // print('Updated Name: ${nameController.text}');
    // print('Updated Phone: ${phoneController.text}');
    // print('Updated Rating: ${estimateController.text}');
    // print('Updated Latitude: ${latitudeController.text}');
    // print('Updated Longitude: ${longitudeController.text}');
    // print('Updated Image: ${imageFile?.path ?? "Not changed"}');

    _showDialog();
  }

  _showDialog() {
    Get.defaultDialog(
      title: '수정 결과',
      middleText: '수정이 완료되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: true);
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

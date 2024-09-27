import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:must_to_eat/vm/user_handler.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({super.key});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  UserHandler handler = UserHandler();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final GetStorage box = GetStorage();
  // Get Arguments
  var value = Get.arguments ?? '___';

  @override
  void initState() {
    super.initState();
    nameController.text = value[1];
    phoneController.text = value[2];
    addressController.text = value[3];
    emailController.text = value[4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _userAppBar(context),
      body: Stack(
        children: [
          _backgroundImage(),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  _editTextfied(),
                  const SizedBox(height: 200),
                  _editButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _userAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '회원정보 수정',
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
    );
  }

  _backgroundImage() {
    return Center(
      child: Positioned.fill(
        child: Image.asset(
          'images/back.png',
          fit: BoxFit.cover, // 이미지를 전체 영역에 맞게 조정
          width: 450,
        ),
      ),
    );
  }

  _editTextfied() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '이름을 수정해주십시오',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: '전화번호를 수정해주십시오',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: '주소를 수정해주십시오',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: '이메일을 수정해주십시오',
            ),
          ),
        ),
      ],
    );
  }

  _editButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty &&
              phoneController.text.isNotEmpty &&
              addressController.text.isNotEmpty &&
              emailController.text.isNotEmpty) {
            _showDialog();
          } else {
            errorSnackBar();
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(150, 0),
          backgroundColor: const Color(0xffFBB816),
        ),
        child: const Text(
          '회원정보 수정',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '회원정보 수정',
      middleText: '회원정보를 수정하시겠습니까?',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('아니오'),
        ),
        TextButton(
          onPressed: () async {
            String id = GetStorage().read('must_user_id');
            await handler.updateJSONData(
              id,
              nameController.text.trim(),
              phoneController.text.trim(),
              addressController.text.trim(),
              emailController.text.trim(),
            );
            Get.back();
            Get.back();
          },
          child: const Text('예'),
        ),
      ],
    );
  }

  errorSnackBar() {
    print("Error");
  }
}// End

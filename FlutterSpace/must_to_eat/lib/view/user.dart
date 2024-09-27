import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_to_eat/view/user_edit.dart';
import 'package:must_to_eat/view/user_password_edit.dart';
import 'package:must_to_eat/vm/user_handler.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  // Property
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  UserHandler handler = UserHandler();
  List<dynamic> userData = [];

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });

      // 이미지 파일을 서버에 업로드
      var success = await handler.uploadImage(imageFile!);
      if (success == false) {
        // 실패
      } else {
        await handler.insertUserImage(userData[0], success);
        if (userData[6] != null) {
          handler.deleteUserImage(userData[6]);
        }

        getData();
      }

      // if (success) {
      //   // 업로드 성공 시 추가 작업 (예: 사용자 데이터 갱신)
      //   Get.snackbar('성공', '이미지가 성공적으로 업로드되었습니다.',
      //       snackPosition: SnackPosition.BOTTOM);
      // } else {
      //   // 업로드 실패 시 처리
      //   Get.snackbar('실패', '이미지 업로드에 실패했습니다.',
      //       snackPosition: SnackPosition.BOTTOM);
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    userData.clear();
    List<dynamic> temp = await handler.selectJSONData();
    userData.addAll(temp);
    print(userData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _userAppBar(context),
      body: Stack(
        children: [
          _backgroundImage(),
          userData.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _userImage(),
                      _userInformation(),
                      const SizedBox(height: 250),
                      _userSettings(),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  // --- Functions ---

  _userAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'User Information',
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

  _userImage() {
    return GestureDetector(
      onTap: getImageFromGallery,
      child: Column(
        children: [
          if (userData[6] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                    'http://127.0.0.1:8000/user/view/${userData[6]}'),
                // FileImage(
                //   File(
                //     imageFile!.path,
                //   ),
                // ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(
                  'images/user.png',
                ),
              ),
            ),
        ],
      ),
    );
  }

  _userInformation() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 2.0), // 테두리 설정
        borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name :   ${userData[2]}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const UserEdit(), arguments: [
                      userData[0],
                      userData[2],
                      userData[3],
                      userData[4],
                      userData[5],
                    ])!
                        .then((value) => getData()),
                    child: const Text(
                      '회원정보 수정',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Phone :  ${userData[3]}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Address :   ${userData[4]}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'E-mail :   ${userData[5]}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _userSettings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Get.to(const UserPasswordEdit()),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(150, 0),
              backgroundColor: const Color(0xffFBB816),
            ),
            child: const Text(
              '비밀번호 변경',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => _showDialog(),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(150, 0),
              backgroundColor: const Color(0xffFD4D05),
            ),
            child: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '로그아웃',
      middleText: '로그아웃을 하시겠습니까?',
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
          onPressed: () {
            Get.back();
            Get.back();
            Get.back();
          },
          child: const Text('예'),
        ),
      ],
    );
  }
} // End
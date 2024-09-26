import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPasswordEdit extends StatefulWidget {
  const UserPasswordEdit({super.key});

  @override
  State<UserPasswordEdit> createState() => _UserPasswordEditState();
}

class _UserPasswordEditState extends State<UserPasswordEdit> {
  // Property
  TextEditingController currentPwController = TextEditingController();
  TextEditingController newPwController = TextEditingController();
  TextEditingController newPwConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Stack(
        children: [
          _backgroundImage(),
          _changePassword(),
        ],
      ),
    );
  }

  // --- Functions ---
  _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Change Password",
        style: TextStyle(fontWeight: FontWeight.bold),
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

  _changePassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber, width: 2.0), // 테두리 설정
          borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: currentPwController,
                decoration: const InputDecoration(
                  labelText: '현재 비밀번호를 입력해주십시오',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: newPwController,
                decoration: const InputDecoration(
                  labelText: '새로운 비밀번호를 입력해주십시오',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: newPwConfirmController,
                decoration: const InputDecoration(
                  labelText: '새로운 비밀번호를 재입력해주십시오',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
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
          ],
        ),
      ),
    );
  }
}// End

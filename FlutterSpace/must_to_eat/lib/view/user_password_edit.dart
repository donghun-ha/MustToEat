import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:must_to_eat/vm/user_handler.dart';

class UserPasswordEdit extends StatefulWidget {
  const UserPasswordEdit({super.key});

  @override
  State<UserPasswordEdit> createState() => _UserPasswordEditState();
}

class _UserPasswordEditState extends State<UserPasswordEdit> {
  // Property
  UserHandler handler = UserHandler();
  TextEditingController currentPwController = TextEditingController();
  TextEditingController newPwController = TextEditingController();
  TextEditingController newPwConfirmController = TextEditingController();
  String? currentpasswordError;
  String? passwordError;
  String? passwordConfirmError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        height: 500,
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
                obscureText: true,
                controller: currentPwController,
                decoration: InputDecoration(
                  hintText: '현재 비밀번호를 입력해주십시오',
                  errorText: currentpasswordError,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: newPwController,
                decoration: InputDecoration(
                  hintText: '새로운 비밀번호를 입력해주십시오',
                  errorText: passwordError,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: newPwConfirmController,
                decoration: InputDecoration(
                  hintText: '새로운 비밀번호를 재입력해주십시오',
                  errorText: passwordConfirmError,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: ElevatedButton(
                onPressed: () => passwordAction(),
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

  passwordAction() async {
    setState(() {
      currentpasswordError =
          currentPwController.text.trim().isEmpty ? '비밀번호를 입력해주세요.' : null;
      passwordError =
          newPwController.text.trim().isEmpty ? '새로운 비밀번호를 입력해주세요.' : null;
      passwordConfirmError = newPwConfirmController.text.trim().isEmpty
          ? '새로운 비밀번호를 입력해주세요.'
          : null;

      // 비밀번호 일치 여부 검사
      if (newPwController.text != newPwConfirmController.text) {
        passwordConfirmError = '비밀번호가 일치하지 않습니다!';
        passwordError = '비밀번호가 일치하지 않습니다!';
      }
    });

    // 에러가 없을 때만 비밀번호 변경 요청 실행
    if (currentpasswordError == null &&
        passwordError == null &&
        passwordConfirmError == null) {
      _showDialog();
    } else {
      errorSnackBar();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: '비밀번호 변경',
      middleText: '비밀번호를 변경하시겠습니까?',
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
            await handler.updatePWJSONData(
                id, newPwConfirmController.text.trim());

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

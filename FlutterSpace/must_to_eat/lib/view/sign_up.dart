// 2024-09-25(수)
// Author: 하동훈
// Description: sign up page ui구현

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must_to_eat/model/user.dart';
import 'package:must_to_eat/vm/user_handler.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Property
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfrimController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? idError;
  String? passwordError;
  String? passwordConfirmError;
  String? emailError;
  String? nameError;
  String? phoneError;
  String? addressError;

  UserHandler handler = UserHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      resizeToAvoidBottomInset: false, // 키보드 올라와도 레이아웃이 변경되지 않도록 설정
      body: Stack(
        children: [
          _backgroundImage(),
          _signUp(),
        ],
      ),
    );
  }

  // --- Functions ---
  _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Sign up',
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
    return Positioned.fill(
      child: Image.asset(
        'images/back.png',
        fit: BoxFit.cover, // 이미지를 전체 영역에 맞게 조정
      ),
    );
  }

  _signUp() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // 키보드 높이만큼 여백을 줘서 텍스트 필드가 올라오도록 함
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
                child: TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'ID를 입력해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password를 입력해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: passwordConfrimController,
                  decoration: const InputDecoration(
                    labelText: 'Password를 확인해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '이름을 입력해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호를 입력해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: '주소를 입력해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: '이메일을 입력해주십시오',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(55.0),
                child: ElevatedButton(
                  onPressed: () {
                    signUpAction();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 0),
                    backgroundColor: const Color(0xffFBB816),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Function ---
  signUpAction() async {
    // idController.text.trim().isNotEmpty &&
    // passwordController.text.trim().isNotEmpty &&
    // passwordConfrimController.text.trim().isNotEmpty &&
    // nameController.text.trim().isNotEmpty &&
    // phoneController.text.trim().isNotEmpty &&
    // addressController.text.trim().isNotEmpty &&
    // emailController.text.trim().isNotEmpty
    if (idController.text.trim().isEmpty) {
      idError = '아이디를 입력해주세요!';
    } else {
      // 아이디 중복

      // 중복이 아닐때
    }
    passwordError =
        passwordController.text.trim().isEmpty ? '비밀번호를 입력해주세요!' : null;
    passwordConfirmError =
        passwordConfrimController.text.trim() != passwordController.text.trim()
            ? '비밀번호가 일치하지 않습니다!'
            : null;
    nameError = nameController.text.trim().isEmpty ? '이름을 입력해주세요!' : null;
    phoneError = phoneController.text.trim().isEmpty ? '전화번호를 입력해주세요!' : null;
    addressError = addressController.text.trim().isEmpty ? '주소를 입력해주세요!' : null;
    emailError = emailController.text.trim().isEmpty ? '이메일을 입력해주세요!' : null;

    if (passwordError != null ||
        idError != null ||
        passwordConfirmError != null ||
        nameError != null ||
        phoneError != null ||
        addressError != null ||
        emailError != null) {
      // 회원가입 실패
      //
      print('실패2ß');
    } else {
      // 회원가입
      User user = User(
        id: idController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        email: emailController.text.trim(),
      );
      bool result = await handler.insertJSONData(user);

      // 회원 가입 성공시 true
      if (result) {
        // 알람창
        print('성공');
        Get.back();
      } else {
        // 실패시
        // 알람창
        print('실패');
      }
    }
  }
} // End

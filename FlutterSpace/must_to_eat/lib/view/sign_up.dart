// 2024-09-25(수)
// Author: 하동훈
// Description: sign up page ui구현

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    Get.back();
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
}// End

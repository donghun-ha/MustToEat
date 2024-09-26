// 2024-09-25(수)
// Author: 하동훈
// Description: login page ui구현

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must_to_eat/view/foodie_list.dart';
import 'package:must_to_eat/view/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드 올라와도 레이아웃이 변경되지 않도록 설정
      body: Stack(
        children: [
          _backgroundImage(),
          _login(),
        ],
      ),
    );
  }

  // --- Functions ---

  _backgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'images/back.png',
        fit: BoxFit.cover, // 이미지를 전체 영역에 맞게 조정
      ),
    );
  }

  _login() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // 키보드 높이만큼 여백을 줘서 텍스트 필드가 올라오도록 함
        ),
        child: Column(
          children: [
            SizedBox(
              width: 500,
              height: 500,
              child: Image.asset(
                'images/logo.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                controller: pwController,
                decoration: const InputDecoration(
                  labelText: 'Password를 입력해주십시오',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('아이디가 없으신가요?'),
                TextButton(
                  onPressed: () => Get.to(const SignUp()),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(105.0),
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 로직
                  Get.to(const FoodieList());
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 0),
                  backgroundColor: const Color(0xffFBB816),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} // End

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:photo_town/screens/login.dart';
import 'signup_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupStartScreen extends StatefulWidget {
  const SignupStartScreen({super.key});

  @override
  State<SignupStartScreen> createState() => _SignupStartScreenState();
}

class _SignupStartScreenState extends State<SignupStartScreen> {
  final TextEditingController emailController = TextEditingController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      final text = emailController.text;
      final currentlyHasText = text.isNotEmpty;
      if (currentlyHasText != hasText) {
        setState(() {
          hasText = currentlyHasText;
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // ✅ 구글 로그인 처리 함수
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 로그인 취소

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // 로그인 성공 후 메인 화면으로 이동 (경로 수정 가능)
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google 로그인 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "처음 방문하셨나요?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "회원가입을 위해 이메일을 입력해주세요",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: '이메일을 입력하세요',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 192, 192, 192),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: hasText
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupDetailScreen(
                            email: emailController.text.trim(),
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasText ? Color(0xFFDBEFC4) : Color(0xFFE0E0E0),
                      foregroundColor: hasText ? Colors.black : Color.fromARGB(255, 82, 82, 82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text("확인"),
                  ),
                  const SizedBox(height: 25),

                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "  또는  ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 112, 112, 112),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 7),

                  // ✅ 구글 로그인 버튼
                  OutlinedButton(
                    onPressed: _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: Color.fromARGB(255, 192, 192, 192),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            "Google로 시작하기",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 128, 128, 128),
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        const TextSpan(text: "이미 회원이신가요? "),
                        TextSpan(
                          text: " 로그인하기",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),
                  GestureDetector(
                    onTap: () {
                      // 비회원 진입 로직
                    },
                    behavior: HitTestBehavior.translucent,
                    child: const Text(
                      "건너뛰기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 185, 185, 185),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

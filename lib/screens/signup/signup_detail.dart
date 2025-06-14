import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupDetailScreen extends StatefulWidget {
  final String email;
  const SignupDetailScreen({super.key, required this.email});

  @override
  State<SignupDetailScreen> createState() => _SignupDetailScreenState();
}

class _SignupDetailScreenState extends State<SignupDetailScreen> {
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 설정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final password = passwordController.text.trim();
                if (password.isEmpty) return;
                try {
                  await _authService.signUp(widget.email, password);
                  if (mounted) {
                    Navigator.popUntil(context, ModalRoute.withName('/login'));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 실패: $e')),
                  );
                }
              },
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

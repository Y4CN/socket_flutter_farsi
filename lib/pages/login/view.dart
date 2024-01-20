import 'package:flutter/material.dart';
import 'package:flutter_farsi_socket/pages/chat/view.dart';
import 'package:flutter_farsi_socket/pages/login/logic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic _logic = Get.put(LoginLogic());
  final TextEditingController _nameController = TextEditingController();
  final box = GetStorage();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                controller: _nameController,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(() {
              return _logic.loading.value
                  ? const CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 6,
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () {
                        if (_nameController.text.trim().isEmpty) {
                          return;
                        }
                        _logic.login(_nameController.text.trim());
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}

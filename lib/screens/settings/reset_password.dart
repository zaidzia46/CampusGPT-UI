import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_conn/dio.dart';

class UpdatePwd extends StatefulWidget {
  const UpdatePwd({super.key});

  @override
  State<UpdatePwd> createState() => _UpdatePwdState();
}

class _UpdatePwdState extends State<UpdatePwd> {
  final _formKey = GlobalKey<FormState>();
  Color cursorColor = Color(0xFF06B6D4);

  final TextEditingController oldPwdController = TextEditingController();
  final TextEditingController newPwdController = TextEditingController();
  final TextEditingController conNewPwdController = TextEditingController();

  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  Future<void> UpdatePwd() async {
    try {
      final response = await APIClient.dio.post(
        '/student/update-password',
        data: {
          'old_password': oldPwdController.text,
          'new_password': newPwdController.text,
          'confirm_password': conNewPwdController.text,
        },
      );
      Get.snackbar(
        'Update Password',
        response.data['message'],
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        Get.snackbar(
          'Error',
          e.response!.data['message'],
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Please try later',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Update your password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                /// OLD PASSWORD
                TextFormField(
                  controller: oldPwdController,
                  obscureText: obscureOld,
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureOld ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureOld = !obscureOld;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your old password";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                /// NEW PASSWORD
                TextFormField(
                  controller: newPwdController,
                  obscureText: obscureNew,
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                /// CONFIRM PASSWORD
                TextFormField(
                  controller: conNewPwdController,
                  obscureText: obscureConfirm,
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != newPwdController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        UpdatePwd();
                      }
                    },
                    child: const Text(
                      "Update Password",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

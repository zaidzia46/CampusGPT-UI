import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_conn/dio.dart';
import '../controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/starry_background.dart';
import 'main_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool _obscurePassword = true;

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> login_client(BuildContext context) async {
    bool hasInternet = await checkInternet();
    if (!hasInternet) {
      Get.snackbar(
        "No Internet",
        "Please check your internet connection",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    try {
      final response = await APIClient.dio.post(
        '/auth/login',
        data: {
          'username': emailController.text,
          'password': passwordController.text,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final accessToken = response.data["access_token"];
      final refreshToken = response.data["refresh_token"];

      await APIClient.storage.write(key: 'access_token', value: accessToken);
      await APIClient.storage.write(key: 'refresh_token', value: refreshToken);
          await Get.put(SettingsController()).loadUserRole();
      authController.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      authController.isLoadingForLogin.value = false;
      Get.offAll(() => const MainScreen());
    } on DioException catch (e) {
      await Future.delayed(Duration(seconds: 1));
      authController.isLoadingForLogin.value = false;
      final error = e.response?.data['detail'];
      if (error == 'Wrong email or password') {
        Get.snackbar(
          error,
          'Please enter valid email or password',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (error == 'Invalid university email') {
        Get.snackbar(
          error,
          'Please enter your valid university email',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          error,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> reset_pwd(BuildContext context) async {
    try {
      final response = await APIClient.dio.post(
        '/auth/forgot-password',
        data: {'email': resetPasswordController.text},
      );
      if (response.data['message'] == 'A reset link has been sent') {
        Get.snackbar(
          'Reset',
          'A reset link has been sent',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data['detail'];
      Get.snackbar(
        'Error',
        error,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  bool _validateFields() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Empty fields check
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please enter both email and password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'p-b-font',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to explore campus information instantly',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFCBD5E1),
                    fontFamily: 'i-s-font',
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  cursorColor: Color(0xFF06B6D4),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF06B6D4),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF334155),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      cursorColor: Color(0xFF06B6D4),
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF06B6D4),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF334155),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                height: 170,
                                width: MediaQuery.of(context).size.width - 2,
                                decoration: BoxDecoration(
                                  color: Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextField(
                                        cursorColor: Color(0xFF06B6D4),
                                        controller: resetPasswordController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Enter your email',
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          hintText:
                                              'fa22-bcs-000@students.cuisahiwal.edu.pk',
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (resetPasswordController
                                              .text
                                              .isNotEmpty) {
                                            reset_pwd(context);
                                            Get.back();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF06B6D4,
                                          ),
                                        ),
                                        child: Text('Send'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Forgot password',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'p-s-font',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_validateFields()) {
                          authController.isLoadingForLogin.value = true;
                          login_client(context);
                        }
                      },
                      child: authController.isLoadingForLogin.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'p-m-font',
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔗 Go to signup
                Center(
                  child: TextButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: const Color(0xFF06B6D4),
                        fontSize: 14,
                        fontFamily: 'p-s-font',
                        fontWeight: FontWeight.w900,
                      ),
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> register_client(BuildContext context) async {
    try {
      final response = await APIClient.dio.post(
        '/auth/register',
        data: {
          'username': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(response.data['message']);
      if (response.data['message'] == 'Account created successfully') {
        Get.snackbar(
          'Account created',
          'You can sign in now',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
        Get.offAll(() => const LoginScreen());
      }
    } on DioException catch (e) {
      authController.isLoadingForSignup.value = false;
      Get.snackbar(
        'Error',
        'Please try later',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> send_otp() async {
    bool hasInternet = await checkInternet();
    if (!hasInternet) {
      Get.snackbar(
        "No Internet",
        "Please check your internet connection",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    try {
      final response = await APIClient.dio.post(
        '/auth/send-otp',
        data: {'email': emailController.text},
      );
      authController.isLoadingForSignup.value = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 170,
              width: MediaQuery.of(context).size.width - 2,
              decoration: BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      cursorColor: Color(0xFF06B6D4),
                      controller: otpController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (otpController.text.isNotEmpty) {
                          final isVerified = await verify_otp();
                          if (isVerified && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                      ),
                      child: Text('Verify'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      Get.snackbar(
        'OTP Verification',
        response.data['message'],
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } on DioException catch (e) {
      await Future.delayed(Duration(seconds: 1));
      authController.isLoadingForSignup.value = false;
      final error = e.response?.data['detail'];
      if (error == 'User already exists with this email') {
        Get.snackbar(
          'Error',
          error,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (error == 'Invalid university email') {
        Get.snackbar(
          'Error',
          error,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          "Please try later",
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  Future<bool> verify_otp() async {
    try {
      final response = await APIClient.dio.post(
        '/auth/verify-otp',
        data: {'email': emailController.text, 'otp': otpController.text},
      );
      Get.snackbar(
        'OTP Verification',
        response.data['message'],
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      if (!mounted) return false;
      register_client(context);
      return true;
    } on DioException catch (e) {
      final error = e.response?.data['detail'];
      otpController.clear();
      Get.snackbar(
        'Error',
        error,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  bool _validateFields() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill in all the fields.',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters long.',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'p-b-font',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your smart guide to campus information starts here',
                  style: TextStyle(
                    fontFamily: 'i-s-font',
                    fontSize: 14,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  cursorColor: Color(0xFF06B6D4),
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF06B6D4),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF334155),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 📧 Email
                TextField(
                  cursorColor: Color(0xFF06B6D4),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'University Email Address',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF06B6D4),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF334155),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  cursorColor: Color(0xFF06B6D4),
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF06B6D4),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF334155),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_validateFields()) {
                          authController.isLoadingForSignup.value = true;
                          send_otp();
                        }
                      },
                      child: authController.isLoadingForSignup.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'p-m-font',
                              ),
                            ),
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

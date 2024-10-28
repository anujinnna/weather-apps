import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';
import 'package:weather_app/widgets/custom_textbutton.dart';
import 'package:weather_app/widgets/custom_textfield.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTap;
  RegisterPage({required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isLoading = false;

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нууц үг таарахгүй байна!')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await _firebaseMessaging.deleteToken();
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        await firestore.collection('users').doc(uid).set({
          'email': emailController.text.trim(),
          'uid': uid,
          'token': token,
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: widget.onTap)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Алдаа: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/register.png",
                  width: 230, height: 230),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Бүртгүүлэх",
                    style: customFonts.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dividerLine),
                    overflow: TextOverflow.clip),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                leadIcon: FontAwesomeIcons.envelope,
                icon: false,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                hintText: "Нууц үг",
                obscureText: false,
                leadIcon: FontAwesomeIcons.lock,
                icon: false,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: "Нууц үг баталгаажуулах",
                obscureText: false,
                leadIcon: FontAwesomeIcons.lock,
                icon: false,
              ),
              const SizedBox(height: 20),
              CustomTextButton(
                text: "Бүртгүүлэх",
                onPressed: () {
                  if (!_isLoading) {
                    signUp();
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Бүртгэлтэй хаяг байгаа?',
                    style: customFonts.copyWith(),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      'Нэвтрэх',
                      style: customFonts.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/auth/services/register_page.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';
import 'package:weather_app/widgets/custom_textbutton.dart';
import 'package:weather_app/widgets/custom_textfield.dart';
import 'dart:convert';
import '../../screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onTap;
  LoginPage({required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  Future<void> signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await getLocation(uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Алдаа: ${e.toString()}')),
      );
    }
  }

  Future<void> getLocation(String uid) async {
    String apiKey = 'ad24f919676e1e8cd024a871df0ab7ea';
    String city = 'Ulaanbaatar';
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey";

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double lat = data['coord']['lat'];
        double lon = data['coord']['lon'];

        await firestore.collection('users').doc(uid).update({
          'lat': lat,
          'lon': lon,
        });
      } else {
        throw Exception('Байршил авж чадсангүй.');
      }
    } catch (e) {
      print('Алдаа: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/login.png", width: 280, height: 280),
            const SizedBox(height: 20),
            Text(
              "Нэвтрэх",
              style: customFonts.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dividerLine),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
              leadIcon: FontAwesomeIcons.envelope,
              icon: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
              leadIcon: FontAwesomeIcons.lock,
              icon: true,
            ),
            const SizedBox(height: 20),
            CustomTextButton(
              text: "Нэвтрэх",
              onPressed: widget.onTap,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Бүртгэлтэй хаяг байгаа?',
                  style: customFonts.copyWith(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Бүртгүүлэх',
                    style: customFonts.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

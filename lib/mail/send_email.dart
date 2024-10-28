import 'package:http/http.dart' as http;

void sendEmail(String userEmail, String weatherData) async {
  var url = Uri.parse('');
  var response = await http.post(
    url,
    body: {
      'email': userEmail,
      'weatherData': weatherData,
    },
  );

  if (response.statusCode == 200) {
    print('Мэйл амжилттай илгээгдлээ');
  } else {
    print('Мэйл илгээхэд алдаа гарлаа');
  }
}

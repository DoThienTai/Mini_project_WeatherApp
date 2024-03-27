import 'dart:convert';
import 'package:http/http.dart' as http;
class NetworkHelper {
  NetworkHelper({ required this.url});
  late final String url;

  Future<dynamic> getData() async{
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
       String data = response.body;
       dynamic decodeData = jsonDecode(data);
       return decodeData;
    } else {
      print(response.statusCode);
    }
  }
}
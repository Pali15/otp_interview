import 'dart:convert';

import 'package:http/http.dart' as http;

class GrammarService {
  static const _apiKey = "9b34db0ad9msh2f44b90d2ceb347p140037jsn20145954eac9";
  static const _endPoint =
      "https://lingua-robot.p.rapidapi.com/language/v1/entries/en/";

  Future<bool> checkForGrammar(String word) async {
    final response = await http.get(Uri.parse("$_endPoint$word"),
        headers: {"x-rapidapi-key": _apiKey});

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (json["entries"] as List).isNotEmpty;
    } else {
      throw Exception("Failed to fetch");
    }
  }
}

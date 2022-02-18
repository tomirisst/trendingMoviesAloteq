import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:trending_movies_aloteq/constants/strings.dart';
import 'package:trending_movies_aloteq/models/moviesInfo.dart';

Future<List<Movies>> fetchMovies() async {
  final response = await http.get(Uri.parse(Strings.moviesUrl));
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    List<Movies> list = [];

    for (var item in result["results"]) {
      list.add(Movies.fromJson(item));
    }
    // print('${list.first}');
    return list;
  } else {
    throw Exception('Failed to load movies');
  }
}

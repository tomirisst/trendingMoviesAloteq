import 'package:flutter/material.dart';
import 'package:trending_movies_aloteq/screens/details_screen.dart';
import 'screens/intro_screen.dart';
import 'package:http/http.dart' as http;
import './screens/details_screen.dart';

void main() {
  runApp(MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trending Movies',
      home: IntroScreen(),
      routes: {
        DetailsScreen.routeName: (context) => DetailsScreen(),
      },); 
  }
}

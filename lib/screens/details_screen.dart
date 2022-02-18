import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trending_movies_aloteq/screens/intro_screen.dart';
import 'dart:async';
import '../models/movieDescription.dart';
import '../models/moviesInfo.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreen createState() => _DetailsScreen();
  static const routeName = '/movie-details';
}

class _DetailsScreen extends State<DetailsScreen> {
  Movie? movieInfo;

  Future<void> getMovie(String? id) async {
    movieInfo = await getMovieInfo(id);
    setState(() {});
    return;
  }

  @override
  void initState() {
    setState(() {
      // getMovie(id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    final movieTitle = routeArgs['title'];
    final backgroundPoster = routeArgs['backgroundPoster'];
    final posterImage = routeArgs['posterImage'];
    final date = routeArgs['date'];
    final id = routeArgs['id'];
    final overview = routeArgs['overview'];

    getMovie(id);

    return FutureBuilder<Movie>(builder: (context, snapshot) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
          title: Text(
            movieTitle.toString(),
            maxLines: 2,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Stack(children: [
              Container(
                  decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage('https://image.tmdb.org/t/p/original' +
                        backgroundPoster.toString()),
                    fit: BoxFit.cover),
              )),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      const Color.fromARGB(169, 0, 0, 0).withOpacity(0.8),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ]),
            Container(
              child: ListView(
                  padding: const EdgeInsets.only(left: 16, top: 110),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image(
                                image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500' +
                                        posterImage.toString()),
                                width: 190,
                                height: 240,
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 48),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isAdult(movieInfo!.adult),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Stack(
                                      alignment: const Alignment(.2, 0.0),
                                      children: [
                                        buildBox(
                                          child: const Text(
                                            '8',
                                            style: const TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const CircularProgressIndicator(
                                          value: 8 / 10,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ('Дата выхода: \n' + date! + '\n'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                          convertDuration(movieInfo!.duration) +
                                              '\n',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      Text(
                                          // 'd',
                                          (movieInfo!.budget.toString() + '\$'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 36),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'О фильме',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Жанр',
                            style: TextStyle(
                              color: Color.fromARGB(255, 173, 173, 173),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            overview!,
                            maxLines: 15,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        ),
      );
    });
  }

  Widget buildBox({required Widget child}) => Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(160, 31, 23, 39),
        ),
        padding: const EdgeInsets.all(8),
        child: child,
      );
}

Future<Movie> getMovieInfo(String? id) async {
  final responseInfo = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/' +
          id! +
          '?api_key=2f05ecb893a6f356e596873f1972d65b&language=en'));
  if (responseInfo.statusCode == 200) {
    final result = jsonDecode(responseInfo.body);
    var movieInfo = Movie.fromJson(result);
    return movieInfo;
  } else {
    throw Exception('Failed to load movies');
  }
}

String convertDuration(int? duration) {
  if (duration! ~/ 60 == 1) {
    return (duration ~/ 60).toString() +
        ' час ' +
        (duration % 60).toString() +
        ' мин';
  } else if (duration ~/ 60 == 2 ||
      duration ~/ 60 == 3 ||
      duration ~/ 60 == 4) {
    return (duration ~/ 60).toString() +
        ' часa ' +
        (duration % 60).toString() +
        ' мин';
  } else {
    return (duration ~/ 60).toString() +
        ' часов ' +
        (duration % 60).toString() +
        ' мин';
  }
}

String isAdult(bool? adult) {
  if (adult!) {
    return '18+';
  } else {
    return '';
  }
}

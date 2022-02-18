import 'package:flutter/material.dart';
import 'package:trending_movies_aloteq/models/moviesInfo.dart';
import 'package:trending_movies_aloteq/services/api_manager.dart';

import 'details_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreen createState() => _IntroScreen();
}

class _IntroScreen extends State<IntroScreen> {
  List<Movies> movies = [];

  Future<void> getMovies() async {
    movies = await fetchMovies();
    setState(() {});
    return;
  }

  @override
  void initState() {
    setState(() {
      getMovies();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: const Text(
            'Фильмы',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ),
        buildBackgroundCard(),
      ],
    );
  }

  Widget buildBackgroundCard() {
    return FutureBuilder<Movies>(builder: (context, snapshot) {
      return GridView.builder(
          shrinkWrap: true,
          itemCount: movies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 247),
          controller: new ScrollController(keepScrollOffset: false),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            var movie = movies[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DetailsScreen.routeName, arguments: {
                  'title': movie.title,
                  'backgroundPoster': movie.backgroundPoster,
                  'rating': movie.rating.toString(),
                  'posterImage': movie.posterImage,
                  'date': movie.date,
                  'id': movie.id!.toString(),
                  'overview': movie.overview,
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: NetworkImage(
                          ('https://image.tmdb.org/t/p/w500' +
                              movie.posterImage.toString()),
                        ),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    Stack(
                      alignment: Alignment(0.9, -0.9),
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                        ),
                        buildBox(
                          child: Text(
                            movie.rating!.toDouble().toString(),
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircularProgressIndicator(
                          value: movie.rating!.toDouble() / 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.all(5)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  movie.title!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  // softWrap: true,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  movie.date!.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(255, 194, 186, 186),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    });
  }

  Widget buildBox({required Widget child}) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(160, 31, 23, 39),
        ),
        padding: EdgeInsets.all(8),
        child: child,
      );
}

//??Adding gradient to the container?? But it doesn't work as planned
// foregroundDecoration: BoxDecoration(
//   gradient: LinearGradient(
//     begin: Alignment.bottomCenter,
//     end: Alignment.topCenter,
//     colors: [
//     Color.fromARGB(199, 0, 0, 0),
//     Colors.transparent,
//     ],
//   ),
// ),

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../shared/tmdb_service.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  List<dynamic> _movies = [];

  Future<void> _loadMovies() async {
    try {
      final tmdbService = TmdbService();

      final Map<String, dynamic> data = await tmdbService.fetchMovies();

      setState(() {
        _movies = data['results'];
      });

      for (final movie in _movies) {
        movie['poster_path'] =
            // ignore: prefer_interpolation_to_compose_strings
            'https://image.tmdb.org/t/p/w500' + movie['poster_path'];
      }

      // print(data['results']);
    } catch (e) {
      print('Error loading movies: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return Image.network(
                    movie['poster_path'],
                    fit: BoxFit.cover,
                  );
                }),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 500.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.70,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                carouselController: _carouselController,
                items: _movies.map((movie) {
                  final posterPath = movie['poster_path'] ?? '';
                  final imageUrl = 'https://image.tmdb.org/t/p/w500$posterPath';

                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 320,
                                margin: const EdgeInsets.only(top: 30),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child:
                                    Image.network(imageUrl, fit: BoxFit.cover),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                movie['title'],
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              // rating
                              const SizedBox(height: 20),
                              // Text(
                              //   movie['description'],
                              //   style: TextStyle(
                              //       fontSize: 14.0,
                              //       color: Colors.grey.shade600),
                              //   textAlign: TextAlign.center,
                              // ),
                              const SizedBox(height: 20),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: _current == _movies.indexOf(movie)
                                    ? 1.0
                                    : 0.0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            movie['vote_average'].toString(),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey.shade600),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.grey.shade600,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '2h',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey.shade600),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.play_circle_filled,
                                              color: Colors.grey.shade600,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Watch',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey.shade600),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

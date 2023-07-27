import 'dart:convert';
import 'package:http/http.dart' as http;

class TmdbService {
  static const String _baseURL = 'http://api.themoviedb.org/3';

  Future<Map<String, dynamic>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          '$_baseURL/movie/popular?api_key=2358f9240794e5caa7d50309b01d37b8&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseURL/movie/$movieId?api_key=2358f9240794e5caa7d50309b01d37b8&append_to_response=credits'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}

import 'dart:convert';
import 'package:gutendex_elibrary/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ApiResponse {
  final List<Book> books;
  final String? nextUrl;

  ApiResponse(this.books, this.nextUrl);
}

class ApiService {
  final String baseUrl = 'https://gutendex.com';

  Future<ApiResponse> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Book> books = (data['results'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();
      final String? nextUrl = data['next'];
      await _cacheBooks(books);
      return ApiResponse(books, nextUrl);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<ApiResponse> fetchBooksFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Book> books = (data['results'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();
      final String? nextUrl = data['next'];
      await _cacheBooks(books);
      return ApiResponse(books, nextUrl);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<ApiResponse> fetchBooksByAuthor(String authorLastName) async {
    final response =
        await http.get(Uri.parse('$baseUrl/books?search=$authorLastName'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Book> books = (data['results'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();
      return ApiResponse(books, '');
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<ApiResponse> fetchBooksByKeyword(String keywords) async {
    final response =
        await http.get(Uri.parse('$baseUrl/books?search=$keywords'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Book> books = (data['results'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();
      final String? nextUrl = data['next'];
      await _cacheBooks(books);
      return ApiResponse(books, nextUrl);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _cacheBooks(List<Book> books) async {
    final box = await Hive.openBox<Book>('booksCache');
    for (var book in books) {
      await box.put(book.id, book);
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookhub/src/models/book_model.dart';
import 'package:html/parser.dart' show parse;

class BookService {
  static Future<List<Book>> getPaginatedBooks(
      String consulta, int page, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$consulta&startIndex=${(page - 1) * pageSize}&maxResults=$pageSize'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      List<Book> libros = items.map((item) {
        final volumeInfo = item['volumeInfo'];

        // Verifica si "imageLinks" existe y no es null
        final imageLinks = volumeInfo['imageLinks'];
        final imagenUrl =
            imageLinks != null ? imageLinks['thumbnail'] : 'errorImage';

        return Book(
          id: item['id'],
          titulo: volumeInfo['title'],
          autor: volumeInfo['authors'] != null
              ? volumeInfo['authors'][0]
              : 'Desconocido',
          imagenUrl: imagenUrl,
          description: '',
        );
      }).toList();

      return libros;
    } else {
      throw Exception('Error al obtener libros');
    }
  }

  static Future<Book> getBookDetails(String bookId) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes/$bookId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final volumeInfo = data['volumeInfo'];
      final title = volumeInfo?['title'] ?? 'N/A';
      final authors = volumeInfo?['authors']?.join(', ') ?? 'N/A';
      final descriptionHtml = volumeInfo?['description'] ?? 'N/A';
      final imageLinks = volumeInfo?['imageLinks'];
      final thumbnail = imageLinks?['thumbnail'] ?? '';

      // Convierte el HTML a texto plano
      final description = parse(descriptionHtml).body!.text;

      return Book(
        id: bookId,
        titulo: title,
        autor: authors,
        imagenUrl: thumbnail,
        description: description,
      );
    } else {
      throw Exception('Error al cargar los detalles del libro');
    }
  }

  static Future<List<Book>> searchBooks(
      String query, int startIndex, int maxResults) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$query&startIndex=$startIndex&maxResults=$maxResults'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      List<Book> libros = items.map((item) {
        final volumeInfo = item['volumeInfo'];

        // Verifica si "imageLinks" existe y no es null
        final imageLinks = volumeInfo['imageLinks'];
        final imagenUrl =
            imageLinks != null ? imageLinks['thumbnail'] : 'errorImage';

        return Book(
          id: item['id'],
          titulo: volumeInfo['title'],
          autor: volumeInfo['authors'] != null
              ? volumeInfo['authors'][0]
              : 'Desconocido',
          imagenUrl: imagenUrl,
          description: '',
        );
      }).toList();

      return libros;
    } else {
      throw Exception('Error al obtener libros');
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

// Fungsi untuk melakukan scraping
Future<List<Map<String, String>>> fetchArticles(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final listBeritaDiv = document.querySelector('.list-berita');

      if (listBeritaDiv != null) {
        final articleElements = listBeritaDiv.querySelectorAll('article');
        final articles = <Map<String, String>>[];

        for (var article in articleElements) {
          final titleElement = article.querySelector('h2.title');
          final contentElement = article.querySelector('p');
          final urls = article.querySelector('a');

          final title = titleElement != null ? titleElement.text.trim() : 'No title';
          final content = contentElement != null ? contentElement.text.trim() : 'No content';
          final href = urls?.attributes['href'] ?? 'No link';
          articles.add({
            'title': title,
            'content': content,
            'href': href
          });
        }
        return articles;
      } else {
        print('Div with class "list-berita" not found');
        return [];
      }
    } else {
      print('Failed to load page: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error occurred: $e');
    return [];
  }
}

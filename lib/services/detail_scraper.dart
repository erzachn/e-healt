import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

// Fungsi untuk melakukan scraping
Future<List<Map<String, String>>> fetchDetail(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      // ignore: non_constant_identifier_names
      final DetailBeritaDiv = document.querySelector('.detail');
      final image = DetailBeritaDiv?.querySelector('img')?.attributes['src'];

      if (DetailBeritaDiv != null) {
        final pElements = DetailBeritaDiv.querySelectorAll('p');
        final detailArticle = <Map<String, String>>[];

        for (var p in pElements) {
          final contentElement = p;
          // ignore: unnecessary_null_comparison
          final detail = contentElement != null ? contentElement.text.trim() : 'No content';
          detailArticle.add({
            'p': detail,
          });
        }
        detailArticle.add({
          'url': image.toString(),
        });
        return detailArticle;
      } else {
        print('Data not found');
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

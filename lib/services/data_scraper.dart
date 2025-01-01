import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class DataScraper {
  static Future<Map<String, String>> fetchData() async {
    const url = 'https://kekerasan.kemenpppa.go.id/ringkasan';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);

        // Selector perlu disesuaikan dengan elemen HTML di web
        final totalCases = document.querySelector('.bg-aqua .inner h3')?.text.trim() ?? "Tidak ditemukan";
        final maleVictims = document.querySelector('.bg-green .inner h3')?.text.trim() ?? "Tidak ditemukan";
        final femaleVictims = document.querySelector('.bg-yellow .inner h3')?.text.trim() ?? "Tidak ditemukan";

        return {
          'Jumlah Kasus': totalCases,
          'Korban Laki-laki': maleVictims,
          'Korban Perempuan': femaleVictims,
        };
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

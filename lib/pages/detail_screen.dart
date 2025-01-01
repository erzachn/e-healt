import 'package:ehealt/services/detail_scraper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String url;

  const ArticleDetailPage(
      {super.key, required this.title, required this.content, required this.url});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  List<Map<String, String>> detail = [];
  bool isLoading = true;
  String combinedText = '';
  String textGemini = '';
  String link = '';

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['API_GOOGLE'] ?? 'API URL not found',
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
  );

  Future<void> loadDetail() async {
    final fetchedDetail = await fetchDetail(widget.url);
    setState(() {
      detail = fetchedDetail;
      combinedText = detail
          .map((item) => item['p']) // Ambil nilai dari key 'p'
          .where((text) =>
              text != null &&
              text.isNotEmpty &&
              text != "ADVERTISEMENT" &&
              text !=
                  "SCROLL TO CONTINUE WITH CONTENT") // Hilangkan null atau string kosong
          .join("\n\n"); // Gabungkan dengan baris baru
      _gemini(combinedText);
    });
  }

  Future<void> _gemini(String q) async {
    final chat = model.startChat(history: [
      Content.multi([
        TextPart('halo\n'),
      ]),
      Content.model([
        TextPart('halo'),
      ]),
    ]);
    final message = 'Buat berita berikut lebih singkat 3 paragragf, enak dibaca: $q';
    final content = Content.text(message);
    final response = await chat.sendMessage(content);
    textGemini = response.text.toString();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.green,))
            : textGemini.isEmpty
                ? const Center(child: Text(''))
                : SingleChildScrollView(
                    child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Image(
                                image: NetworkImage(
                                    detail.last['url'].toString()))),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            textGemini,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}

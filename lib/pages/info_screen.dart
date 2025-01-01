
import 'package:ehealt/berita_scraper.dart';
import 'package:ehealt/pages/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<Map<String, String>> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  Future<void> loadArticles() async {
    const url =
        'https://www.detik.com/tag/kekerasan-remaja/'; // Ganti dengan URL yang akan di-scrape
    final fetchedArticles = await fetchArticles(url);

    setState(() {
      articles = fetchedArticles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.green,))
        : articles.isEmpty
            ? const Center(child: Text('No articles found'))
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailPage(
                              title: article['title'] ?? 'No title',
                              content: article['content'] ?? 'No content',
                              url: article['href'] ?? 'No url'
                            ),
                          ),
                        );
                      },
                      title: Text(
                        article['title'] ?? 'No title',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        article['content'] ?? 'No content',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
  }
}

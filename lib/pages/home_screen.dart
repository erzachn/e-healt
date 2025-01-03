import 'package:ehealt/services/data_scraper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String>? data;
  bool isLoading = false;
  String errorMessage = "";
  String textGemini = 'No data';
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

  @override
  void initState() {
    super.initState();
    loadData();
    _gemini();
  }

  Future<void> _gemini() async {
    final chat = model.startChat(history: [
      Content.multi([
        TextPart('halo\n'),
      ]),
      Content.model([
        TextPart('halo'),
      ]),
    ]);
    final message =
        'Tulis 5 poin saja secara random, tips menghindari kekerasan. jangan gunakan text style';
    final content = Content.text(message);
    final response = await chat.sendMessage(content);
    print(response);
    textGemini = await response.text.toString();
    setState(() {});
  }

  void loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final fetchedData = await DataScraper.fetchData();
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            ),
          )
        : errorMessage.isNotEmpty
            ? Text(
                'No data found',
                style: const TextStyle(color: Colors.red),
              )
            : data != null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  "Kasus kekerasan di indonesia",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                slideCard(data: data)
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Tips menghindari kekerasan',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Card(
                            elevation: 2,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    textGemini,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: loadData,
                    child: const Text('Muat Data'),
                  );
  }
}

class slideCard extends StatelessWidget {
  const slideCard({
    super.key,
    required this.data,
  });

  final Map<String, String>? data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(14),
                  color: Colors.red[900]),
              width: 110,
              height: 110,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 20),
                child: Column(
                  children: [
                    Text("Jumlah kasus",
                        style: GoogleFonts.poppins(
                            fontSize: 10)),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            '${data!['Jumlah Kasus'] ?? '0'}',
                            style:
                                GoogleFonts.poppins(
                                    fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().shimmer(),
            SizedBox(
              width: 20,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(14),
                  color: Colors.blue[900]),
              width: 110,
              height: 110,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 20),
                child: Column(
                  children: [
                    Text("korban laki-laki",
                        style: GoogleFonts.poppins(
                            fontSize: 10)),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            '${data!['Korban Laki-laki'] ?? '0'}',
                            style:
                                GoogleFonts.poppins(
                                    fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().shimmer( delay: 200.ms),
            SizedBox(
              width: 20,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(14),
                  color: Colors.pink[900]),
              width: 110,
              height: 110,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 20),
                child: Column(
                  children: [
                    Text("korban perempuan",
                        style: GoogleFonts.poppins(
                            fontSize: 10)),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            '${data!['Korban Perempuan'] ?? '0'}',
                            style:
                                GoogleFonts.poppins(
                                    fontSize: 30,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().shimmer( delay: 400.ms, ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}

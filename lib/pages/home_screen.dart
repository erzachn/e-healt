
import 'package:ehealt/services/data_scraper.dart';
import 'package:flutter/material.dart';
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
            child: CircularProgressIndicator(color: Colors.green,),
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
                                Card(
                                  elevation: 2,
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //         image: Image.network(
                                    //                 'https://akcdn.detik.net.id/community/media/visual/2023/05/07/ilustrasi-penganiayaan_43.jpeg?w=300&q=80')
                                    //             .image,
                                    //         fit: BoxFit.cover)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Jumlah Kasus: ${data!['Jumlah Kasus'] ?? 'Tidak tersedia'}',
                                                style:
                                                    GoogleFonts.poppins(
                                                        fontSize: 16),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Korban Laki-laki: ${data!['Korban Laki-laki'] ?? 'Tidak tersedia'}',
                                                style:
                                                    GoogleFonts.poppins(
                                                        fontSize: 16),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Korban Perempuan: ${data!['Korban Perempuan'] ?? 'Tidak tersedia'}',
                                                style:
                                                    GoogleFonts.poppins(
                                                        fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Align(
                          //   child: Text(
                          //     'Lorem ipsum odor amet, consectetuer adipiscing elit. Quis consequat ligula sodales nisl tortor ex natoque. Et commodo nam donec feugiat, nulla sed vitae fusce. Dolor id class semper semper bibendum sem sodales. Pellentesque eu posuere molestie consequat cras lacus. Non pulvinar a hac, imperdiet aliquam placerat aptent nam. Ipsum sapien morbi semper dis luctus ridiculus varius justo adipiscing. Class egestas per justo, himenaeos nisl molestie.Blandit posuere facilisi fusce quam molestie. Nisl elit augue dictum volutpat, eros purus. Quam lectus consectetur augue habitant bibendum, dictum maecenas purus id. Vitae suscipit enim mattis rutrum at vestibulum curabitur. Dui habitasse dis lacus eget porttitor varius. Proin laoreet conubia proin sagittis sagittis bibendum luctus. Rhoncus tristique pretium, fames facilisi dis imperdiet. Aenean non senectus mus inceptos lectus congue vulputate? Nibh massa platea senectus; curae felis magna.',
                          //     style: GoogleFonts.poppins(),
                          //     textAlign: TextAlign.justify,
                          //   ),
                          //   alignment: Alignment.centerLeft,
                          // ),
                          Text('Tips menghindari kekerasan',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          Card(
                            elevation: 2,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    textGemini,
                                    style:
                                        GoogleFonts.poppins(fontSize: 16),
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

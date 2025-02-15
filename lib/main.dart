import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:ehealt/pages/home_screen.dart';
import 'package:ehealt/pages/info_screen.dart';
import 'package:ehealt/pages/setting_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eHealth App',
        home: const MainPage(),
        darkTheme: ThemeData(
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: Colors.green),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
        ),
        theme: ThemeData(
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: Colors.green),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String? _numberbot = dotenv.env['BOTNUMBER'];
  String? _number = dotenv.env['NUMBER'];

  final List<Widget> _pages = [
    const HomePage(),
    const InfoPage(),
    SettingsPage(), // Made SettingsPage a const
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          "REMAJA SEHAT",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10), child: Container()),
      ),
      drawer: Drawer(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Menu',
                  style: GoogleFonts.poppins(fontSize: 26),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "CHAT KONSUL",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  content: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            var intent = AndroidIntent(
                              action: 'android.intent.action.VIEW',
                              data:
                                  'https://wa.me/$_numberbot', // Added WhatsApp URL
                              package: 'com.whatsapp', // Package WhatsApp
                              flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                            );
                            intent.launch();
                          },
                          child: Text('Konsul AI')),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            var intent = AndroidIntent(
                              action: 'android.intent.action.VIEW',
                              data:
                                  'https://wa.me/$_number?', // Added WhatsApp URL
                              package: 'com.whatsapp', // Package WhatsApp
                              flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                            );
                            intent.launch();
                          },
                          child: Text('Konsul Real'))
                    ],
                  ),
                );
              },
            );
          },
          elevation: 0,
          child: Icon(Icons.message)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.article), label: 'News'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:ehealt/pages/home_screen.dart';
import 'package:ehealt/pages/info_screen.dart';
import 'package:ehealt/pages/setting_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      theme: ThemeData(

      ),
      home: const MainPage(), // Set MainPage as the home widget
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

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
    final mainColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Icon(Icons.menu),
        backgroundColor: mainColor,
        title: Text(
          "REMAJA SEHAT",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(10), child: Container()),
      ),
      drawer: Container(),
      body: SafeArea(child: _pages[_selectedIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const intent =  AndroidIntent(
            action: 'android.intent.action.VIEW',
            data: 'https://wa.me/6285187086869?text=.menu', // Added WhatsApp URL
            package: 'com.whatsapp', // Package WhatsApp
            flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          intent.launch();
        },
        elevation: 0,
        child: const FaIcon(
          FontAwesomeIcons.whatsapp,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.article), label: 'Berita'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
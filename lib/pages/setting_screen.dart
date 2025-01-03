import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String imageUrl = 'https://i.pinimg.com/736x/40/f8/0b/40f80bc3990f0b472c588b16c6f6daa9.jpg';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage('./assets/ic_logo_radius.png'),
          width: 110,
        ),
        SizedBox(height: 20,),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                Card(
                  elevation: 0.2,
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Account'),),
                ),
                Card(
                  elevation: 0.2,
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                      leading: Icon(Icons.book),
                      title: Text('Reading'),
                  ),
                ),
                Card(
                  elevation: 0.2,
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Dibuat Oleh:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 20),
                            ),
                            content: Container(
                              height: 200,
                              clipBehavior: Clip.hardEdge,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          imageUrl))),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              IconButton(
                                onPressed: () {
                                  print(MediaQuery.of(context).size.width);
                                  var intent = AndroidIntent(
                                    action: 'android.intent.action.VIEW',
                                    data:
                                        'https://guthib.com', // Added WhatsApp URLPackage WhatsApp
                                    flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                                  );
                                  intent.launch();
                                },
                                icon: Icon(Icons.discord),
                              ),
                              IconButton(
                                onPressed: () {
                                  print(MediaQuery.of(context).size.width);
                                  var intent = AndroidIntent(
                                    action: 'android.intent.action.VIEW',
                                    data:
                                        'https://facebook.com', // Added WhatsApp URL/ Package WhatsApp
                                    flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                                  );
                                  intent.launch();
                                },
                                icon: Icon(Icons.facebook),
                              ),
                            ],
                          );
                        },
                      ).then((value) {
                        imageUrl = 'https://i.pinimg.com/736x/b7/31/26/b7312644e40d0355303f0889cf6fb6d3.jpg';
                      },);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        const Text('VERSI 1.2'),
        const SizedBox(height: 10,),
      ],
    );
  }
}

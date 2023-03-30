import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/Profile.dart';
import 'package:health/View.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var val = 1.0;
  bool accept_disc = false;
  late Future<String> permissionStatusFuture;

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return "null";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => sd(context));
    NotificationPermissions.requestNotificationPermissions(
            iosSettings: const NotificationSettingsIos(
                sound: true, badge: true, alert: true))
        .then((_) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    });

    getjsondata();
    setState(() {
      accept_disc = false;
      animatex = 0.0;
      animatey - 0.0;
      val = 1.0;
      isloading = true;
    });
  }

  var data;
  Future getjsondata() async {
    var response = await http.get(Uri.parse(
        "https://sheets.googleapis.com/v4/spreadsheets/1qBPmLgUd-ii5RFk2ZBO_F7wYN75i9nV83pg_Yd4WpjQ/values/Organs?alt=json&key=AIzaSyC58rzMrvVWXQy5uENZn1cC02vWDbt0mSs"));

    setState(() {
      var decode = json.decode(response.body);
      data = decode["values"];
    });
    if (data != null) {
      setState(() {
        isloading = false;
      });
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void getMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
      );
    });
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // settings.authorizationStatus.name
    // _firebaseMessaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {},
    //     onResume: (Map<String, dynamic> message) async {},
    //     onLaunch: (Map<String, dynamic> message) async {});
  }

  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  bool? isloading;

  String? value;
  var height;
  var width;
  var x;
  var y;

  var animatex = 0.0;
  var animatey = 0.0;

  navigatetotabscreen(
      BuildContext context, nametransfer, datatranfer, imagename) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.push(context, MaterialPageRoute(builder: ((BuildContext context) {
      return View(nametransfer, datatranfer, imagename);
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E80A31),
        title: Text("Health"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isloading = true;
                });
                getjsondata();
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Profile();
                }));
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: accept_disc != true
          ? Container()
          : isloading!
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    color: Color(0xff0E80A31),
                  ),
                )
              : Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn,
                      onEnd: () {
                        setState(() {
                          val = 1.0;
                          animatex = 0;
                          animatey = 0;
                        });
                      },
                      transform:
                          Matrix4.translationValues(animatex, animatey, 0)
                            ..scale(val),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                // scale: 2.0,
                                image: AssetImage("assets/man_image_1.jpeg"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    cbutton1("Pharynx", 0.05, 0.2, 0.1, 0.1),
                    cbutton1("Larynx", 0.05, 0.2, 0.1, 0.175),
                    cbutton1("Heart", 0.05, 0.2, 0.1, 0.235),
                    cbutton1("Arteries", 0.055, 0.2, 0.1, 0.3),
                    cbutton1("Muscles", 0.05, 0.2, 0.1, 0.365),
                    cbutton1("GallBladder", 0.053, 0.2, 0.08, 0.512),
                    cbutton1("Liver", 0.058, 0.2, 0.08, 0.44),
                    cbutton1("Kidney", 0.05, 0.2, 0.06, 0.61),
                    cbutton1("Skeleton", 0.06, 0.2, 0.05, 0.69),
                    cbutton1("Intestines", 0.08, 0.2, 0.04, 0.76),
                    cbutton("Brain", 0.05, 0.2, 0.2, 0.1),
                    cbutton("Lymph Nodes", 0.05, 0.22, 0.17, 0.212),
                    cbutton("Lungs", 0.05, 0.2, 0.12, 0.305),
                    cbutton("Spleen", 0.05, 0.2, 0.1, 0.38),
                    cbutton("Stomach", 0.055, 0.2, 0.09, 0.54),
                    cbutton("Bone Marrow", 0.07, 0.2, 0.08, 0.46),
                    cbutton("Veins", 0.06, 0.2, 0.06, 0.61),
                    cbutton("Pancreas", 0.07, 0.2, 0.05, 0.7),
                    cbutton("Urinary Bladder", 0.09, 0.24, 0.028, 0.78),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03),
                        child: Container(
                          child: Text(
                            "Please select any Organ Label",
                            style: GoogleFonts.roboto(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
    );
  }

  Widget cbutton(value, height, width, x, y) {
    return Positioned(
      right: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: GestureDetector(
        onTap: () {
          setState(() {
            switch (value) {
              case "Brain":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 0.1;

                navigatetotabscreen(
                    context, value.toString(), data[1], "assets/brain.jpg");
                break;
              case "Lymph Nodes":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 1.1;
                animatey = -MediaQuery.of(context).size.height * 0.8;
                navigatetotabscreen(
                    context, value, data[4], "assets/lymph_node.jpg");

                break;
              case "Lungs":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 0.8;
                navigatetotabscreen(
                    context, value.toString(), data[5], "assets/lungs.jpg");

                break;
              case "Spleen":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 1.2;
                animatey = -MediaQuery.of(context).size.height * 1.1;
                navigatetotabscreen(
                    context, value.toString(), data[14], "assets/spleen.jpg");

                break;
              case "Bone Marrow":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 1.5;
                animatey = -MediaQuery.of(context).size.height * 1.2;
                navigatetotabscreen(context, value.toString(), data[15],
                    "assets/Bone_marrow.jpg");

                break;
              case "Stomach":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 1.6;
                navigatetotabscreen(
                    context, value.toString(), data[16], "assets/stomach.jpg");

                break;
              case "Veins":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 1.8;
                animatey = -MediaQuery.of(context).size.height * 1.6;
                navigatetotabscreen(
                    context, value.toString(), data[17], "assets/veins.jpg");

                break;
              case "Pancreas":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 1.5;
                navigatetotabscreen(
                    context, value.toString(), data[18], "assets/pancreas.jpg");

                break;
              case "Urinary Bladder":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 1.8;
                navigatetotabscreen(context, value.toString(), data[19],
                    "assets/Urinary_bladder.jpg");

                break;
              default:
            }
          });
          debugPrint(value);
        },
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * height,
          width: MediaQuery.of(context).size.width * width,
        ),
      ),
    );
  }

  Widget cbutton1(value, height, width, x, y) {
    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: GestureDetector(
        onTap: () {
          setState(() {
            switch (value) {
              case "Pharynx":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 0.4;
                navigatetotabscreen(
                    context, value.toString(), data[2], "assets/Pharynx.jpg");

                break;
              case "Larynx":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 0.5;
                navigatetotabscreen(
                    context, value.toString(), data[3], "assets/larynx.jpg");

                break;
              case "Heart":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height;
                navigatetotabscreen(
                    context, value.toString(), data[6], "assets/heart.jpg");

                break;
              case "Arteries":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 0.9;
                animatey = -MediaQuery.of(context).size.height * 0.8;
                navigatetotabscreen(
                    context, value.toString(), data[7], "assets/artery.jpg");

                break;
              case "Muscles":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 0.8;
                animatey = -MediaQuery.of(context).size.height * 0.8;
                navigatetotabscreen(
                    context, value.toString(), data[8], "assets/muscle.jpg");

                break;
              case "Liver":
                val = 3;
                animatex = -MediaQuery.of(context).size.width;
                animatey = -MediaQuery.of(context).size.height * 1.4;
                navigatetotabscreen(
                    context, value.toString(), data[9], "assets/liver.jpg");

                break;
              case "GallBladder":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 0.9;
                animatey = -MediaQuery.of(context).size.height * 1.5;
                navigatetotabscreen(context, value.toString(), data[10],
                    "assets/gallbladder.jpg");

                break;
              case "Kidney":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 0.9;
                animatey = -MediaQuery.of(context).size.height * 1.5;
                navigatetotabscreen(
                    context, value.toString(), data[11], "assets/kidney.jpg");

                break;
              case "Skeleton":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 0.6;
                animatey = -MediaQuery.of(context).size.height * 1.5;
                navigatetotabscreen(
                    context, value.toString(), data[12], "assets/skeleton.jpg");

                break;
              case "Intestines":
                val = 3;
                animatex = -MediaQuery.of(context).size.width * 0.9;
                animatey = -MediaQuery.of(context).size.height * 1.7;
                navigatetotabscreen(context, value.toString(), data[13],
                    "assets/intestine.jpg");

                break;
              default:
            }
          });
          debugPrint(value);
        },
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * height,
          width: MediaQuery.of(context).size.width * width,
        ),
      ),
    );
  }

  sd(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 50.0,
            // insetAnimationCurve: Curves.bounceInOut,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Divider(
                      height: 20,
                    ),
                    Text(
                      '''Disclaimer:

The information provided by this app is for educational and informational purposes only. It is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified healthcare provider with any questions you may have regarding a medical condition. Never disregard professional medical advice or delay seeking it because of information obtained from this app.

''',
                      style: GoogleFonts.roboto(fontSize: 10),
                    ),
                    Divider(
                      height: 30,
                    ),
                    Text(
                      '''Terms and Conditions:

1. Acceptance of Terms and Conditions: By using this app, you agree to be bound by these Terms and Conditions. If you do not agree with these Terms and Conditions, please do not use this app.

2. Ownership and Intellectual Property: All content, including but not limited to text, graphics, images, and software, is the property of the app owners and is protected by copyright and other intellectual property laws.

3. User Conduct: You agree to use this app only for lawful purposes and in a way that does not infringe on the rights of others. You may not use this app in any way that is harmful, threatening, abusive, defamatory, invasive of privacy, or otherwise objectionable.

4. Accuracy of Information: The app owners make every effort to provide accurate and up-to-date information. However, they make no warranties or representations regarding the accuracy, completeness, or reliability of the information provided.

5. Limitation of Liability: The app owners shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of this app or the information contained herein.

6. Modification of Terms and Conditions: The app owners reserve the right to modify these Terms and Conditions at any time without prior notice. Your continued use of this app constitutes your acceptance of the modified Terms and Conditions.

7. Governing Law: These Terms and Conditions shall be governed by and construed in accordance with the laws of the jurisdiction in which the app owners are located.

8. Entire Agreement: These Terms and Conditions constitute the entire agreement between you and the app owners regarding the use of this app and supersede all prior agreements and understandings, whether written or oral.''',
                      style: GoogleFonts.roboto(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Navigator.pop(context);
                              // SystemNavigator.pop();
                              exit(0);
                            },
                            icon: Icon(Icons.cancel)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                accept_disc = true;
                              });
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.check))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

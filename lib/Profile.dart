import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Flexible(child: Text("Creators of this App")),
        backgroundColor: Color(0xff0E80A31),
      ),
      body: Container(
        child: Card(
          elevation: 50,
          margin: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  profilepic("assets/p1.jpeg", "Sarthak Sarkar"),
                  profilepic("assets/p2.1.jpg", "Shikhar Agarwal"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  profilepic("assets/p3.jpg", "Haider Mustafa Naqvi"),
                  profilepic("assets/p4.jpg", "Abdul Basit"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  ClipRect profilepic(image, name) {
    return ClipRect(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          children: [
            ClipOval(
              child: Image(
                image: AssetImage(
                  image,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Flexible(
                child: Text(
                  name,
                  style: GoogleFonts.roboto(),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

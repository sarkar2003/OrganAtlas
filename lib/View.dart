import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class View extends StatefulWidget {
  final name;
  final data;
  final image;
  const View(this.name, this.data, this.image);
  @override
  ViewState createState() => ViewState(this.name, this.data, this.image);
}

class ViewState extends State<View> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ViewState(name, data, image);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E80A31),
        title: Text(widget.name.toString()),
        bottom: TabBar(controller: _tabController, isScrollable: true, tabs: [
          Tab(
            child: Text("Image"),
          ),
          Tab(child: Text("Functions")),
          Tab(child: Text("Nutrients Required")),
          Tab(child: Text("Location In Body")),
          Tab(child: Text("Made Up Of"))
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tabs(widget.data[1], widget.image, 1),
          Tabs(widget.data[2], widget.image, 2),
          Tabs(widget.data[3], widget.image, 3),
          Tabs(widget.data[4], widget.image, 4),
          Tabs(widget.data[5], widget.image, 5),
        ],
      ),
    );
  }
}

class Tabs extends StatelessWidget {
  final data;
  final image;
  final no;

  const Tabs(this.data, this.image, this.no);
  @override
  Widget build(BuildContext context) {
    debugPrint(image);
    return Container(
      decoration: BoxDecoration(
        // color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage(
            image.toString(),
          ),
          // fit: BoxFit.fill
        ),
      ),
      child: no == 1
          ? Container()
          : Container(
              margin: EdgeInsets.all(20),
              // color: Colors.transparent,
              child: Opacity(
                  opacity: 0.8,
                  child: Card(
                    elevation: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Disclaimer: Please Consult your doctor before taking any action based on our data",
                              style: GoogleFonts.roboto(fontSize: 20),
                            ),
                          ),
                          Divider(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 5.0, right: 5.0),
                            child: Text(
                              data,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Divider(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
    );
  }
}

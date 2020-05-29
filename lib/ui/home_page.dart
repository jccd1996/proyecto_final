import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global_info_page.dart';
import 'local_info_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme)),
      home: Scaffold(
        backgroundColor: Colors.orange[800],
        body: IndexedStack(
          children: pages,
          index: currentPage,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          backgroundColor: Colors.grey[300],
          selectedItemColor: Colors.orange[800],
          onTap: (page) {
            _onItemTapped(page);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: SizedBox(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              title: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  void _loadPages() {
    pages = [];
    pages.add(LocalInfoPage());
    pages.add(GlobalInfoPage());
  }

  void _onItemTapped(int pages) {
    setState(() {
      currentPage = pages;
    });
  }
}

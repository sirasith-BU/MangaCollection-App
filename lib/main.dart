import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';
import 'Screens/AddManga.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Manga Collection",
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color(0xFF333333),
            body: TabBarView(children: const [HomePage(), AddMangaPage()]),
            bottomNavigationBar: const TabBar(
              tabs: [
                Tab(
                    child: Text("Manga",
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                Tab(
                    child: Text("Add Manga",
                        style: TextStyle(color: Colors.white, fontSize: 16)))
              ],
            ),
          ),
        ));
  }
}

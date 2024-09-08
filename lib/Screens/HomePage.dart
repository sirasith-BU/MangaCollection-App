import 'package:flutter/material.dart';
import 'package:mangacollectionapp/Database/database_helper.dart';
import 'AddManga.dart';
import 'Details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> mangaList = [];
  String _selectedPublisher = 'All';
  String _selectedType = 'All';
  String? databasePath;

  @override
  void initState() {
    super.initState();
    loadMangaList();
  }

  Future<void> loadMangaList() async {
    List<Map<String, dynamic>> mangas = await DatabaseHelper().getMangaList();
    setState(() {
      mangaList = mangas.where((manga) {
        final matchesType =
            _selectedType == 'All' || manga['type'] == _selectedType;
        final matchesPublisher = _selectedPublisher == 'All' ||
            manga['publisher'] == _selectedPublisher;
        return matchesType && matchesPublisher;
      }).toList();
    });
  }

  // Future<void> LoadMangaList() async {
  //   List<Map<String, dynamic>> Mangas = await DatabaseHelper().getMangaList();
  //   setState(() {
  //     if (_selectedPublisher != 'All' || _selectedType != 'All') {
  //       if (_selectedType == 'All' && _selectedPublisher != 'All') {
  //         mangaList =
  //             Mangas.where((manga) => manga['publisher'] == _selectedPublisher)
  //                 .toList();
  //       }
  //       if (_selectedType != 'All' && _selectedPublisher == 'All') {
  //         mangaList =
  //             Mangas.where((manga) => manga['type'] == _selectedType).toList();
  //       }
  //       if (_selectedType != 'All' && _selectedPublisher != 'All') {
  //         mangaList = Mangas.where((manga) =>
  //             manga['type'] == _selectedType &&
  //             manga['publisher'] == _selectedPublisher).toList();
  //       }
  //     } else {
  //       mangaList = Mangas;
  //     }
  //   });
  // }

  void navigateToAddMangaPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMangaPage()),
    ).then((_) {
      loadMangaList();
    });
  }

  void _navigateToMangaDetailsPage(Map<String, dynamic> manga) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MangaDetailsPage(
          id: manga['id'],
          title: manga['title'],
          type: manga['type'],
          publisher: manga['publisher'],
          imageUrl: manga['imageUrl'],
          start_volume: manga['startVolume'],
          end_volume: manga['endVolume'],
          not_have: manga['not_have'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MANGA COLLECTION'),
        titleTextStyle: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        backgroundColor: Color(0xFF333333),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      backgroundColor: Color(0xFFF4F4F4),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Search manga title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    loadMangaList();
                  } else {
                    mangaList = mangaList.where((manga) {
                      return manga['title']
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  }
                });
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(labelText: "Type"),
                    items: <String>['All', 'Manga', 'Light Novel']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue!;
                        loadMangaList();
                      });
                    },
                  )),
                  Expanded(
                      child: DropdownButtonFormField<String>(
                    value: _selectedPublisher,
                    decoration: InputDecoration(labelText: "Publisher"),
                    items: <String>[
                      'All',
                      'Siam Inter comics',
                      'Luckpim',
                      'Pheonix Next',
                      'Dex',
                      'First Page Pro'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPublisher = newValue!;
                        loadMangaList();
                      });
                    },
                  ))
                ],
              )),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                final manga = mangaList[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToMangaDetailsPage(manga);
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Image.network(
                            manga['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            manga['title'],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _navigateToAddMangaPage,
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.green,
      // ),
    );
  }
}

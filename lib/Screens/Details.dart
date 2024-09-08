import 'package:flutter/material.dart';
import 'package:mangacollectionapp/Database/database_helper.dart';
import 'package:mangacollectionapp/Screens/AddManga.dart';
import 'package:mangacollectionapp/main.dart';

class MangaDetailsPage extends StatefulWidget {
  final int id;
  final String title;
  final String type;
  final String publisher;
  final String imageUrl;
  final int start_volume;
  final int end_volume;
  final String not_have;

  const MangaDetailsPage({super.key, 
    required this.id,
    required this.title,
    required this.type,
    required this.publisher,
    required this.imageUrl,
    required this.start_volume,
    required this.end_volume,
    required this.not_have,
  });

  @override
  State<MangaDetailsPage> createState() => _MangaDetailsPageState();
}

class _MangaDetailsPageState extends State<MangaDetailsPage> {
  void _deleteManga() async {
    await DatabaseHelper().deleteManga(widget.id);
    // Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const MyApp()));
  }

  void _editManga() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMangaPage(isEdit: true, manga: {
          'id': widget.id,
          'title': widget.title,
          'type': widget.type,
          'publisher': widget.publisher,
          'imageUrl': widget.imageUrl,
          'startVolume': widget.start_volume,
          'endVolume': widget.end_volume,
          'not_have': widget.not_have,
        }),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this manga?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Navigator.of(context).pop(); // Close the dialog
                _deleteManga(); // Call delete function
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manga Details"),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: Color(0xFF333333),
      ),
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(widget.imageUrl,
                width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Type: ${widget.type}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Publisher: ${widget.publisher}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Have ${widget.start_volume} - ${widget.end_volume}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.not_have.isNotEmpty ? "Not have ${widget.not_have}" : "",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, fixedSize: Size(100, 70)),
                  onPressed: _editManga,
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, fixedSize: Size(100, 70)),
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}

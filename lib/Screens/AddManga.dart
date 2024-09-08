import 'package:flutter/material.dart';
import 'package:mangacollectionapp/Database/database_helper.dart';
import 'package:mangacollectionapp/main.dart';

class AddMangaPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? manga;

  const AddMangaPage({super.key, this.isEdit = false, this.manga});

  @override
  _AddMangaPageState createState() => _AddMangaPageState();
}

class _AddMangaPageState extends State<AddMangaPage> {
  late TextEditingController _titleController;
  late TextEditingController _typeController;
  late TextEditingController _publisherController;
  late TextEditingController _imageUrlController;
  late TextEditingController _startVolumeController;
  late TextEditingController _endVolumeController;
  late TextEditingController _notHaveController;

  final List<String> _typeOptions = ['Manga', 'Light Novel'];
  final List<String> _publisherOptions = [
    'Siam Inter comics',
    'Luckpim',
    'Pheonix Next',
    'Dex',
    'First Page Pro'
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.manga?['title']);
    _typeController = TextEditingController(text: widget.manga?['type']);
    _publisherController =
        TextEditingController(text: widget.manga?['publisher']);
    _imageUrlController =
        TextEditingController(text: widget.manga?['imageUrl']);
    _startVolumeController = TextEditingController(
        text: widget.manga?['startVolume']?.toString() ?? '');
    _endVolumeController = TextEditingController(
        text: widget.manga?['endVolume']?.toString() ?? '');
    _notHaveController =
        TextEditingController(text: widget.manga?['not_have'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _publisherController.dispose();
    _imageUrlController.dispose();
    _startVolumeController.dispose();
    _endVolumeController.dispose();
    _notHaveController.dispose();
    super.dispose();
  }

  void _saveManga() async {
    Map<String, dynamic> manga = {
      'title': _titleController.text,
      'type': _typeController.text,
      'publisher': _publisherController.text,
      'imageUrl': _imageUrlController.text,
      'startVolume': _startVolumeController.text,
      'endVolume': _endVolumeController.text,
      'not_have': _notHaveController.text,
    };

    if (widget.isEdit) {
      await DatabaseHelper().updateManga(widget.manga?['id'], manga);
    } else {
      await DatabaseHelper().insertManga(manga);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const MyApp()));
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Manga' : 'Add Manga'),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: Color(0xFF333333),
      ),
      backgroundColor: Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title (ชื่อมังงะ)'),
                // autofocus: true,
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Please enter a Title'
                      : null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _typeController.text.isNotEmpty
                    ? _typeController.text
                    : null,
                decoration: InputDecoration(labelText: 'Type (ประเภท)'),
                items: _typeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _typeController.text = newValue ?? '';
                  });
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    _typeController.text = newValue;
                  }
                },
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Please select a type'
                      : null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _publisherController.text.isNotEmpty
                    ? _publisherController.text
                    : null,
                decoration: InputDecoration(labelText: 'Publisher (สำนักพิมพ์)'),
                items: _publisherOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _publisherController.text = newValue ?? '';
                  });
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    _publisherController.text = newValue;
                  }
                },
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Please select a publisher'
                      : null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL (URL รูปภาพ)'),
              ),
              TextFormField(
                controller: _startVolumeController,
                decoration: InputDecoration(labelText: 'Start Volume (เล่มที่)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter start Volume";
                  } else {
                    int? intValue = int.tryParse(value);
                    if (intValue == null) {
                      return "Please enter a valid number";
                    } else if (intValue < 1) {
                      return "Please enter more than 0";
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endVolumeController,
                decoration: InputDecoration(labelText: 'End Volume (ถึงเล่มที่)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter end Volume";
                  } else {
                    int? intValue = int.tryParse(value);
                    if (intValue == null) {
                      return "Please enter a valid number";
                    } else if (intValue < 1) {
                      return "Please enter more than 0";
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notHaveController,
                decoration: InputDecoration(labelText: 'Not Have (เล่มที่ยังไม่มี)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: widget.isEdit ? Size(160, 70) : Size(140, 70)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    int? startVolume =
                        int.tryParse(_startVolumeController.text);
                    int? endVolume = int.tryParse(_endVolumeController.text);

                    if (startVolume != null &&
                        endVolume != null &&
                        startVolume <= endVolume) {
                      _saveManga();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Start Volume must be less than or equal to End Volume')),
                      );
                    }
                  }
                },
                child: Text(
                  widget.isEdit ? 'Save Changes' : 'Add Manga',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

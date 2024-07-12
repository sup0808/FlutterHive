import 'package:demo_hive/models/notes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes/boxes.dart';

class note_screen extends StatefulWidget {
  @override
  State<note_screen> createState() => _note_screenState();
}

class _note_screenState extends State<note_screen> {
  final titleController  = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
      ),
      body:ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box ,_){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(data[index].title.toString()),
                    Text(data[index].description.toString()),

                  ],
                ),
              ),
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter Title" ,
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 5,),
                  TextFormField(
                    controller: descriptionController ,
                    decoration: InputDecoration(
                        hintText: "Enter Description" ,
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(title: titleController.text, description: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);
                  //  data.save();
                    print("Hive Database $box");
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Add"))
            ],
          );
        });
  }
}

import 'dart:convert';

import 'package:contact/details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Contacts> contacts = List<Contacts>();

  Future<List<Contacts>> fetchContacts() async {
    var url = 'https://jsonplaceholder.typicode.com/users';
    var response = await http.get(url);
    var note = List<Contacts>();
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        note.add(Contacts.fromJson(noteJson));
      }
    }
    return note;
  }

  @override
  void initState() {
    fetchContacts().then((value) {
      setState(() {
        contacts.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Json'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        contacts[index].name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Details(contacts[index].name, contacts[index].number),
                    settings: RouteSettings(arguments: contacts[index]),
                  ),
                );
              },
            );
          },
          itemCount: contacts.length,
        ),
      ),
    );
  }
}

class Contacts {
  String name;
  String number;

  Contacts(this.name, this.number);

  Contacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['phone'];
  }
}

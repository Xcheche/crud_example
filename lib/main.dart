import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Person implements Comparable {
  final int id;
  final String firstName;
  final String lastName;

  const Person({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  @override
  int compareTo(covariant Person other) => other.id.compareTo(id);

  @override
  bool operator ==(covariant Person other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Person, id = $id, firstName: $firstName, lastName: $lastName';
}

class PersonDB {
  final String dbName;
  Database? _db;
  List<Person> _persons = []; // Corrected the type to Person
  final _streamController = StreamController<List<Person>>.broadcast();

  PersonDB({required this.dbName});

  Future<List<Person>> _fetchPeople() async {
    // Implement the logic to fetch people from the database
    return [];
  }

  Future<bool> open() async {
    if (_db != null) {
      return true;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dbName'; // Corrected path variable

    try {
      final db = await openDatabase(path);
      _db = db;

      // create table
      const create = '''CREATE TABLE IF NOT EXISTS PEOPLE(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        FIRST_NAME TEXT NOT NULL,
        LAST_NAME TEXT NOT NULL
      )''';

      await db.execute(create);
      // read all existing person objects from the db
      final persons = await _fetchPeople(); // Corrected variable name
      _persons = persons;
      _streamController.add(_persons);
      return true; // Return true after successfully opening the database
    } catch (e) {
      print('Error = $e');
      return false;
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key); // Fixed the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crud Example'),
      ),
      body: Center(
          // Implement your UI here
          ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

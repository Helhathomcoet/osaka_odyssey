import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osaka_odyssey/ChapterService/ChapterService.dart';
import 'package:osaka_odyssey/ChaptersList.dart'; // Assure-toi que le chemin est correct
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:osaka_odyssey/Models/Chapter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Scrapper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Manga Scrapper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Chapter>>?
      _searchFuture; 

  void _search() {
    setState(() {
      _searchFuture = ChapterService().fetchChapters(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Rechercher un manga',
                suffixIcon: IconButton(
                  onPressed: _search, // Lancer la recherche
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (value) => _search(),
            ),
          ),
          Expanded(
            // Utilisez un FutureBuilder pour construire l'UI basée sur le résultat de la recherche
            child: _searchFuture == null
                ? Center(child: Text("Entrez une recherche pour commencer."))
                : ChaptersList(searchQuery: _controller.text),
          ),
        ],
      ),
    );
  }
}

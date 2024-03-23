import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  final List<String> _items = [];

  Future<void> fetchMangaImages() async {
    final webScraper = WebScraper('https://lelscans.net');
    if (await webScraper.loadWebPage('/scan-one-piece/1111/2')) {
      List<Map<String, dynamic>> elements =
          webScraper.getElement('div#image img', ['src']);
      if (elements.isNotEmpty) {
        // Construit l'URL complet
        String imageUrl =
            'https://lelscans.net' + elements.first['attributes']['src'];
        print(imageUrl);
        // Ici, tu pourrais par exemple utiliser imageUrl pour l'afficher dans ton application
      }
    }
  }

  void _addItem() {
    fetchMangaImages();
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
                labelText: 'Ajouter un élément',
                suffixIcon: IconButton(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                ),
              ),
              onSubmitted: (value) => _addItem(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:osaka_odyssey/ChapterService/ChapterService.dart';
import 'package:osaka_odyssey/Models/Chapter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChaptersList extends StatefulWidget {

  final String searchQuery;

  const ChaptersList({Key? key, this.searchQuery = ""}) : super(key: key); 

  @override
  _ChaptersListState createState() => _ChaptersListState();
}

class _ChaptersListState extends State<ChaptersList> {
  final ChapterService _chapterService = ChapterService();

  Future<void> DownloadChapter(Chapter chapter) async {
    final directory = await getApplicationDocumentsDirectory(); // Obtient le répertoire de documents de l'application
    final chapterDir = Directory('${directory.path}/${chapter.title.replaceAll(' ', '_')}'); // Crée un dossier pour le chapitre
    if (!chapterDir.existsSync()) {
      chapterDir.createSync(); // Crée le dossier s'il n'existe pas
    }
    
    // Simulé: remplacer par votre logique pour obtenir les URLs des images de scan
    final imageUrls = [
      chapter.downloadUrl  + "/1.jpg",
      chapter.downloadUrl  + "/2.jpg",
      chapter.downloadUrl  + "/3.jpg",
    ];

    print(imageUrls);

    for (String imageUrl in imageUrls) {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File('${chapterDir.path}/${imageUrl.split('/').last}');
        await file.writeAsBytes(response.bodyBytes); // Sauvegarde l'image dans le dossier du chapitre
      } else {
        // Gérer l'erreur de téléchargement
        print('Erreur lors du téléchargement de $imageUrl');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des Chapitres"),
      ),
      body: FutureBuilder<List<Chapter>>(
        future: _chapterService.fetchChapters( widget.searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur lors du chargement"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Chapter chapter = snapshot.data![index];
              return ListTile(
                title: Text(chapter.title),
                trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    DownloadChapter(chapter);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

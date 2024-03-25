import 'package:osaka_odyssey/Models/Chapter.dart';
import 'package:http/http.dart' as http;
import "package:html/parser.dart" as parser;
import "package:html/dom.dart" as dom;

class ChapterService {
  Future<List<Chapter>> fetchChapters(String manga) async {
    try {
      final url = Uri.parse('https://mangascan-fr.com/manga/' + manga);
      print('Chargement de ' + url.toString());

      final response = await http.get(url);
      if (response.statusCode == 200) {
        dom.Document document = parser.parse(response.body);

        List<Chapter> chapters = [];

        var chapterElements = document.querySelectorAll('li.volume- > h5.chapter-title-rtl > a');
        for (var element in chapterElements) {
          // Récupération du titre complet du chapitre
          String fullTitle = element.text.trim(); // 'Juujika no Rokunin 156 : Chapitre 156'
          
          // Essayez de trouver le numéro du chapitre dans le titre
          var titleMatch = RegExp(r'(\d+)').firstMatch(fullTitle);
          if (titleMatch != null) {
            String chapterNumber = titleMatch.group(1)!;
            // Le titre du chapitre pourrait être simplifié si nécessaire
            String chapterTitle = "Chapitre " + chapterNumber;
            String downloadUrl = element.attributes['href'] ?? "";

            chapters.add(Chapter(title: chapterTitle, downloadUrl: downloadUrl));
          }
        }

        return chapters;
      } else {
        print('Erreur de chargement de la page avec le statut: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Une exception a été levée lors de la récupération des chapitres: ' + e.toString());
      return [];
    }
  }
}

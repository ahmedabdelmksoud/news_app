import 'package:dio/dio.dart';
import 'package:news_app/model/artical_model.dart';

class NewServices {
  final Dio dio;
  NewServices(this.dio);

  Future<List<ArticalModel>> getNews({required String category}) async {
    try {
      Response response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=ede7615b802845b5930f8fc2eef69bae&category=$category',
      );

      Map<String, dynamic> jesondata = response.data;

      List<dynamic> articles = jesondata['articles'];

      List<ArticalModel> articalList = [];
      for (var artical in articles) {
        ArticalModel articalModel = ArticalModel(
          image: artical['urlToImage'] ?? '',
          title: artical['title'] ?? '',
          subtitle: artical['description'] ?? '',
          url: artical['url'] ?? '',
        );
        articalList.add(articalModel);
      }
      return articalList;
    } catch (e) {
      return [];
    }
  }
}

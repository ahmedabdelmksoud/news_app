import 'package:flutter/material.dart';
import 'package:news_app/model/artical_model.dart';
import 'package:news_app/widgets/news_titel.dart';

class NewListView extends StatelessWidget {
  final List<ArticalModel> articals;

  const NewListView({super.key, required this.articals});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: NewsTitle(articalModel: articals[index]),
        );
      }, childCount: articals.length),
    ); // Adjust childCount as needed
  }
}

import 'package:flutter/material.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/widgets/category_card.dart';

class CategoriesListView extends StatelessWidget {
  CategoriesListView({super.key});

  final List<Map<String, dynamic>> categories = [
    {"name": "Technology", "image": "assets/technology.jpeg"},
    {"name": "Sports", "image": "assets/sports.avif"},
    {"name": "Science", "image": "assets/science.avif"},

    {"name": "Health", "image": "assets/health.avif"},
    {"name": "Business", "image": "assets/business.avif"},
    {"name": "Entertainment", "image": "assets/entertaiment.avif"},
    {"name": "General", "image": "assets/general.avif"},
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: CategoryModel(
              categoryName: categories[index]['name'],
              image: categories[index]['image'],
            ),
          );
        },
      ),
    );
  }
}

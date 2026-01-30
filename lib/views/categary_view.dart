import 'package:flutter/material.dart';
import 'package:news_app/widgets/new_list_view_bulider.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.category});

  final String category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          category[0].toUpperCase() + category.substring(1),
          style: const TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: CustomScrollView(slivers: [NewListViewBulider(category: category)]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:news_app/widgets/catrgray_list_view.dart';
import 'package:news_app/widgets/new_list_view_bulider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        surfaceTintColor: Colors.transparent,

        backgroundColor: Colors.blue,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "News ", style: TextStyle(color: Colors.black)),
              TextSpan(text: "App", style: TextStyle(color: Colors.yellow)),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CategoriesListView()),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          NewListViewBulider(category: 'general'),
        ],
      ),
    );
  }
}

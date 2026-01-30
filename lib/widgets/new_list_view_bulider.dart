import 'package:flutter/material.dart';
import 'package:news_app/widgets/news_list_view.dart';
import 'package:provider/provider.dart';
import 'package:news_app/provider/news_provider.dart';

class NewListViewBulider extends StatefulWidget {
  const NewListViewBulider({super.key, required this.category});

  final String category;

  @override
  State<NewListViewBulider> createState() => _NewListViewBuliderState();
}

class _NewListViewBuliderState extends State<NewListViewBulider> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          );
        } else if (newsProvider.errorMessage.isNotEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text("Error: ${newsProvider.errorMessage}")),
          );
        } else if (newsProvider.articles.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text("No articles found")),
          );
        } else {
          return NewListView(articals: newsProvider.articles);
        }
      },
    );
  }
}

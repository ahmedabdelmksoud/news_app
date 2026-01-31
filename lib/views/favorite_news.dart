import 'package:flutter/material.dart';
import 'package:news_app/model/artical_model.dart';
import 'package:news_app/services/firebase_services.dart';
import 'package:news_app/views/article_web_view.dart';

class FavoriteNewsView extends StatefulWidget {
  const FavoriteNewsView({super.key});

  @override
  State<FavoriteNewsView> createState() => _FavoriteNewsViewState();
}

class _FavoriteNewsViewState extends State<FavoriteNewsView> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Favorite ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: "News",
                style: TextStyle(color: Colors.yellow),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<ArticalModel>>(
        stream: _firebaseServices.getFavoriteNewsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final article = favorites[index];
              return FavoriteNewsCard(
                article: article,
                onRemove: () async {
                  final confirm = await _confirmRemove(context);
                  if (confirm &&
                      article.url != null &&
                      article.url!.isNotEmpty) {
                    await _firebaseServices.removeFavoriteNews(article.url!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Removed from favorites')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // ================= EMPTY =================
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Favorite News Yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your favorite news to see them here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ================= DIALOG =================
  Future<bool> _confirmRemove(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove from favorites'),
            content: const Text('Are you sure you want to remove this news?'),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// ======================================================
// ================== FAVORITE CARD =====================
// ======================================================

class FavoriteNewsCard extends StatelessWidget {
  final ArticalModel article;
  final VoidCallback onRemove;

  const FavoriteNewsCard({
    super.key,
    required this.article,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (article.url == null || article.url!.isEmpty) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ArticleWebView(url: article.url!, title: article.title ?? ''),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            if (article.image != null && article.image!.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      article.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // ================= CONTENT =================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (article.subtitle != null && article.subtitle!.isNotEmpty)
                    Text(
                      article.subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

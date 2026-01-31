import 'package:flutter/material.dart';
import 'package:news_app/model/artical_model.dart';
import 'package:news_app/views/article_web_view.dart';
import 'package:provider/provider.dart';
import 'package:news_app/provider/favorites_provider.dart';

class NewsTitle extends StatelessWidget {
  final ArticalModel articalModel;

  const NewsTitle({super.key, required this.articalModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (articalModel.url == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleWebView(
              url: articalModel.url!,
              title: articalModel.title ?? '',
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            if (articalModel.image != null && articalModel.image!.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      articalModel.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favProvider, _) {
                        final isFav = favProvider.isFavorite(articalModel.url);

                        return GestureDetector(
                          onTap: () {
                            favProvider.toggleFavorite(articalModel);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav
                                      ? "Removed from Favorites 💔"
                                      : "Added to Favorites ❤️",
                                ),
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.white,
                            ),
                          ),
                        );
                      },
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
                    articalModel.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (articalModel.subtitle != null &&
                      articalModel.subtitle!.isNotEmpty)
                    Text(
                      articalModel.subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
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

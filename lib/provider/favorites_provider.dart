import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/model/artical_model.dart';
import 'package:news_app/services/firebase_services.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseServices _firebaseServices = FirebaseServices();

  List<ArticalModel> _favorites = [];
  StreamSubscription? _subscription;

  List<ArticalModel> get favorites => _favorites;

  // ================= LOAD =================
  void loadFavorites() {
    _subscription?.cancel();

    _subscription = _firebaseServices.getFavoriteNewsStream().listen((data) {
      _favorites = data;
      notifyListeners();
    });
  }

  // ================= CHECK =================
  bool isFavorite(String? url) {
    if (url == null) return false;
    return _favorites.any((item) => item.url == url);
  }

  // ================= TOGGLE =================
  Future<void> toggleFavorite(ArticalModel article) async {
    if (article.url == null) return;

    final exists = isFavorite(article.url);

    if (exists) {
      await _firebaseServices.removeFavoriteNews(article.url!);
    } else {
      await _firebaseServices.addFavoriteNews(article);
    }
  }

  // ================= CLEAR =================
  void clear() {
    _favorites = [];
    _subscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

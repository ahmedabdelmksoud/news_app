import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/artical_model.dart';
import 'package:news_app/services/new_services.dart';

class NewsProvider extends ChangeNotifier {
  late NewServices _newsServices;
  List<ArticalModel> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = 'general';

  NewsProvider() {
    _newsServices = NewServices(Dio());
  }

  // Getters
  List<ArticalModel> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  // Fetch news by category
  Future<void> fetchNews(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _articles = await _newsServices.getNews(category: category);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load news: ${e.toString()}';
      _articles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear articles
  void clearArticles() {
    _articles = [];
    _errorMessage = '';
    notifyListeners();
  }

  // Reset provider
  void reset() {
    _articles = [];
    _isLoading = false;
    _errorMessage = '';
    _selectedCategory = 'general';
    notifyListeners();
  }
}

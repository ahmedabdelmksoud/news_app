import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/provider/navbar_provider.dart';
import 'package:news_app/provider/localization_provider.dart';
import 'package:news_app/views/home_view.dart';
import 'package:news_app/views/profile_view.dart';
import 'package:news_app/views/favorite_news.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const FavoriteNewsView(),
      const ProfileView(),
    ];

    return Consumer<NavbarProvider>(
      builder: (context, navbarProvider, _) {
        return Scaffold(
          body: pages[navbarProvider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navbarProvider.currentIndex,
            onTap: (index) {
              navbarProvider.setIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: context.watch<LocalizationProvider>().translate('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: context.watch<LocalizationProvider>().translate(
                  'profile',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

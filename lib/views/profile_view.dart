import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:news_app/provider/localization_provider.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/profile_header.dart';
import 'package:news_app/widgets/language_option.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.watch<LocalizationProvider>().translate('profile'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackgroundDark(isDarkMode),
      ),
      backgroundColor: AppColors.getBackgroundColor(isDarkMode),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE HEADER
            const ProfileHeader(),

            const SizedBox(height: 32),

            /// SETTINGS
            Text(
              context.watch<LocalizationProvider>().translate('settings'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(isDarkMode),
              ),
            ),
            const SizedBox(height: 16),

            /// THEME CARD
            Card(
              color: AppColors.getCardColor(isDarkMode),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.watch<LocalizationProvider>().translate('theme'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Consumer<ThemeProvider>(
                      builder: (_, themeProvider, __) {
                        return Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: themeProvider.setDarkMode,
                          activeColor: AppColors.primary,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// LANGUAGE CARD
            Card(
              color: AppColors.getCardColor(isDarkMode),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    LanguageOption(
                      flag: '🇬🇧',
                      languageName: 'English',
                      languageCode: 'en',
                    ),
                    SizedBox(height: 8),
                    LanguageOption(
                      flag: '🇸🇦',
                      languageName: 'العربية',
                      languageCode: 'ar',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

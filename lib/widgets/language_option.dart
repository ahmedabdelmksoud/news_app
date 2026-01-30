import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/provider/localization_provider.dart';
import 'package:news_app/utils/app_colors.dart';

class LanguageOption extends StatelessWidget {
  final String flag;
  final String languageName;
  final String languageCode;

  const LanguageOption({
    super.key,
    required this.flag,
    required this.languageName,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalizationProvider>();
    final isSelected =
        (languageCode == 'en' && provider.isEnglish) ||
        (languageCode == 'ar' && provider.isArabic);

    return GestureDetector(
      onTap: () => provider.setLocale(languageCode),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Text(languageName),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

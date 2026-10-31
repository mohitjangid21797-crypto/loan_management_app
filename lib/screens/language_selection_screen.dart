import 'package:flutter/material.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../utils/spacing.dart';
import '../widgets/localized_text.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  static const Map<String, Map<String, String>> _languages = {
    'en': {'name': 'English', 'native': 'English', 'flag': '🇺🇸'},
    'as': {'name': 'Assamese', 'native': 'অসমীয়া', 'flag': '🇮🇳'},
    'bn': {'name': 'Bengali', 'native': 'বাংলা', 'flag': '🇧🇩'},
    'gu': {'name': 'Gujarati', 'native': 'ગુજરાતી', 'flag': '🇮🇳'},
    'hi': {'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
    'kn': {'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
    'ml': {'name': 'Malayalam', 'native': 'മലയാളം', 'flag': '🇮🇳'},
    'mr': {'name': 'Marathi', 'native': 'मराठी', 'flag': '🇮🇳'},
    'ne': {'name': 'Nepali', 'native': 'नेपाली', 'flag': '🇳🇵'},
    'or': {'name': 'Odia', 'native': 'ଓଡ଼ିଆ', 'flag': '🇮🇳'},
    'pa': {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ', 'flag': '🇮🇳'},
    'ta': {'name': 'Tamil', 'native': 'தமிழ்', 'flag': '🇮🇳'},
    'te': {'name': 'Telugu', 'native': 'తెలుగు', 'flag': '🇮🇳'},
    'ur': {'name': 'Urdu', 'native': 'اردو', 'flag': '🇵🇰'},
  };

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<AppLocaleProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Select Language', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: _languages.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final entry = _languages.entries.elementAt(index);
            final code = entry.key;
            final data = entry.value;
            final isSelected = localeProvider.locale.languageCode == code;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final navigator = Navigator.of(context);
                  await context.read<AppLocaleProvider>().setLanguage(code);
                  if (mounted) {
                    navigator.pop(code);
                  }
                },
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E3A8A).withValues(alpha: 0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[200]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        data['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name']!,
                              style: GoogleFonts.inter(
                                fontSize: AppSpacing.fontLg,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                            Text(
                              data['native']!,
                              style: GoogleFonts.inter(
                                fontSize: AppSpacing.fontMd,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF1E3A8A),
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
import 'package:amritdhara/providers/locale_provider.dart';
import 'package:amritdhara/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    // Access the provider to change the language
    final provider = Provider.of<LocaleProvider>(context, listen: false);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8E2FF), Colors.white],
            stops: [0.18, 0.92],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Divider(color: Colors.black87, height: 0.5, thickness: 0.5),
              const SizedBox(height: 13),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSettingsItem(
                      icon: Icons.brightness_6,
                      title: AppLocalizations.of(context)!.mode,
                      subtitle: 'Dark & Light',
                      trailing: Switch(
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                        },
                        activeTrackColor: Colors.lightBlueAccent,
                        activeColor: const Color(0xFF1976D2),
                      ),
                    ),
                    // --- THIS IS THE UPDATED SECTION ---
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: AppLocalizations.of(context)!.language,
                      trailing: PopupMenuButton(
                        onSelected: (Locale locale) {
                          provider.setLocale(locale);
                        },
                        itemBuilder: (BuildContext context) {
                          // Map of language codes to their native names
                          const languageMap = {
                            'en': 'English',
                            'hi': 'हिंदी',
                            'bn': 'বাংলা',
                            'ta': 'தமிழ்',
                            'te': 'తెలుగు',
                            'mr': 'मराठी',
                            'gu': 'ગુજરાતી',
                            'kn': 'ಕನ್ನಡ',
                          };

                          return L10n.all.map((locale) {
                            return PopupMenuItem(
                              value: locale,
                              child: Text(languageMap[locale.languageCode] ?? locale.languageCode),
                            );
                          }).toList();
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF1568EC),
                          size: 18,
                        ),
                      ),
                    ),
                    // --- END OF UPDATED SECTION ---
                    _buildSettingsItem(
                      icon: Icons.star_border,
                      title: AppLocalizations.of(context)!.rateApp,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.info_outline,
                      title: AppLocalizations.of(context)!.terms,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.lock_outline,
                      title: AppLocalizations.of(context)!.privacy,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.share,
                      title: AppLocalizations.of(context)!.shareApp,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80.0,
                  vertical: 90.0,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 5,
                    shadowColor: Colors.red.withOpacity(0.4),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.logout,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  AppLocalizations.of(context)!.madeBy,
                  style: const TextStyle(color: Color(0xFF0D47A1), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    // ... (This helper widget remains the same)
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xCA1198B8), Color(0xFF0D648C)],
                    stops: [0.2, 0.9],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF1568EC),
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
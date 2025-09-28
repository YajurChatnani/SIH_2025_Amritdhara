import 'package:amritdhara/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  // State for the dark mode toggle switch
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    // The Drawer widget is the root of the sidebar UI
    return Drawer(
      width:
          MediaQuery.of(context).size.width *
          0.85, // Takes up 85% of screen width
      // Apply a custom shape with rounded corners on the right
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        // The gradient background that covers the entire drawer
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
                    // Back button to close the drawer
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
                    // Title
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                    // Spacer to keep the title centered
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Divider(color: Colors.black87, height: 0.5, thickness: 0.5),

              const SizedBox(height: 13),

              // List of settings items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSettingsItem(
                      icon: Icons.brightness_6,
                      title: 'Mode',
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
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: 'Language',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.star_border,
                      title: 'Rate This App',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.info_outline,
                      title: 'Terms & Conditions',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.lock_outline,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.share,
                      title: 'Share This App',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80.0,
                  vertical: 90.0,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
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
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Footer text
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Made by Amritdhara',
                  style: TextStyle(color: Color(0xFF0D47A1), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A helper widget to build each item in the settings list
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.transparent, // Make card transparent to show gradient
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Circular Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xCA1198B8), Color(0xFF0D648C)],
                    stops: [0.2, 0.9],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              // Title and Subtitle
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              // Trailing widget (Switch or Arrow)
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

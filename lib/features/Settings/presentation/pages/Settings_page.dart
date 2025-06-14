import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/localization/locale_cubit.dart';

import '../../../../core/di/di.dart';
import '../bloc/Settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late SettingsCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<SettingsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body:SettingsScreen(),
      ),
    );
  }
}



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for the controls
  bool _isDarkMode = false;
  bool _areNotificationsOn = true;
  double _volume = 80.0;
  String _selectedStorySpeed = 'Normal';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Appearance Section ---
          const _SectionHeader(title: 'Appearance'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                icon: Icons.brightness_4_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch to dark mode',
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                  activeColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Audio Section ---
          const _SectionHeader(title: 'Audio'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                icon: Icons.volume_up_outlined,
                title: 'Volume',
                trailing: Expanded(
                  child: Row(
                    children: [
                      const Text('0%', style: TextStyle(color: Colors.grey)),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                            });
                          },
                          activeColor: Colors.black,
                          inactiveColor: Colors.grey[300],
                        ),
                      ),
                      const Text('100%', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, indent: 56),
              _SettingsRow(
                icon: Icons.timer_outlined,
                title: 'Story Speed',
                trailing: _buildDropdown(
                  value: _selectedStorySpeed,
                  items: ['Slow', 'Normal', 'Fast'],
                  onChanged: (value) {
                    setState(() {
                      _selectedStorySpeed = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- General Section ---
          const _SectionHeader(title: 'General'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Receive story recommendations',
                trailing: Switch(
                  value: _areNotificationsOn,
                  onChanged: (value) {
                    setState(() {
                      _areNotificationsOn = value;
                    });
                  },
                  activeColor: Colors.black,
                ),
              ),
              const Divider(height: 1, indent: 56),
              _SettingsRow(
                icon: Icons.language_outlined,
                title: 'Language',
                trailing: _buildDropdown(
                  value: _selectedLanguage,
                  items: ['English', 'العربية', ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                      if(value == 'English'){
                        context.read<LocaleCubit>().changeLanguage('en');
                      }
                      else{
                        context.read<LocaleCubit>().changeLanguage('ar');
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Account Section ---
          const _SectionHeader(title: 'Account'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                title: 'Edit Profile',
                onTap: () {
                  // Handle navigation to Edit Profile page
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for custom dropdown to match the design
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.unfold_more, color: Colors.grey),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Helper widget for section headers like "Appearance"
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// Helper widget for the container with border and rounded corners
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// Helper widget for each row in a settings group
class _SettingsRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.grey[600]),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
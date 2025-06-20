import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import 'package:wise_child/features/Settings/presentation/widgets/settings_group.dart';
import 'package:wise_child/features/Settings/presentation/widgets/settings_row.dart';
import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';
import 'package:wise_child/l10n/app_localizations.dart';
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

      child: Scaffold(backgroundColor: Colors.white, body: SettingsScreen()),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _areNotificationsOn = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    String? userImage = CacheService.getData(key: CacheKeys.userPhoto);
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            stretch: true,
            title: Text(
              AppLocalizations.of(context)!.appName,
              style: getBoldStyle(color: Colors.white, fontSize: 24),
            ),
            pinned: true,
            floating: true,
            expandedHeight: 230,
            collapsedHeight: 56,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    Assets.appbarbackgroundJpg,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 200,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          userImage ?? '',
                          scale: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SectionHeader(title: AppLocalizations.of(context)!.general),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SettingsGroup(
                children: [
                  SettingsRow(
                    icon: Icons.notifications_outlined,
                    title: AppLocalizations.of(context)!.notifications,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.receiveStoryRecommendations,
                    trailing: Switch(
                      value: _areNotificationsOn,
                      inactiveTrackColor: ColorManager.white,
                      inactiveThumbColor: Colors.grey,
        
                      activeTrackColor: ColorManager.primaryColor.withOpacity(
                        0.6,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _areNotificationsOn = value;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  SettingsRow(
                    icon: Icons.language_outlined,
                    title: AppLocalizations.of(context)!.language,
                    trailing: _buildDropdown(
                      value: _selectedLanguage,
                      items: ['English', 'العربية'],
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                          if (value == 'English') {
                            context.read<LocaleCubit>().changeLanguage('en');
                          } else {
                            context.read<LocaleCubit>().changeLanguage('ar');
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SectionHeader(title: AppLocalizations.of(context)!.account),
            ),

            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                child: ListTile(
                  splashColor: ColorManager.primaryColor.withOpacity(0.2),
                  leading: Icon(
                    Icons.edit_outlined,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.editProfile,
                    style: getMediumStyle(color:Colors.black87, fontSize: 16),
                  ),
                  trailing:  Icon(Icons.arrow_forward_ios_outlined,size: 16,),
                  onTap: () {
                    // Handle logout
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
        
                color: Colors.white,
                child: ListTile(
                  splashColor: ColorManager.primaryColor.withOpacity(0.2),
                  leading: Icon(
                    Icons.person_off_outlined,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.removeAccount,
                    style: getMediumStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                  trailing: Icon(Icons.delete),
                  onTap: () {
                    // Handle logout
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                child: ListTile(
                  splashColor: ColorManager.primaryColor.withOpacity(0.2),
                  title: Center(
                    child: Text(
                      AppLocalizations.of(context)!.logout,
                      style: getMediumStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  ),
                  trailing: Icon(Icons.logout_outlined),
                  onTap: () {
                    // Handle logout
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.unfold_more, color: Colors.grey),
          items: items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../core/di/di.dart';
import '../bloc/Home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: viewModel, child: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(),
          SliverToBoxAdapter(child: _buildHeader(textTheme)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Progress Overview', style: textTheme.titleMedium),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildProgressOverview(textTheme)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.myChildren,
                style: textTheme.titleMedium,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildMyChildren()),
          SliverToBoxAdapter(child: const SizedBox(height: 30)),
          SliverToBoxAdapter(child: _buildUploadCustomStoryButton(textTheme)),
          SliverToBoxAdapter(
            child: const SizedBox(height: kBottomNavigationBarHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  CacheService.getData(key: CacheKeys.userPhoto),
                ),
                // Use your asset
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${CacheService.getData(key: CacheKeys.userFirstName)} ${CacheService.getData(key: CacheKeys.userLastName)}!',
                    style: textTheme.titleLarge,
                  ),
                  Text(
                    'Welcome back',
                    style: textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: _buildProgressCard(textTheme, 'Stories Read', '15')),
          const SizedBox(width: 16),
          Expanded(child: _buildProgressCard(textTheme, 'Days Active', '22')),
        ],
      ),
    );
  }

  Widget _buildProgressCard(TextTheme textTheme, String title, String value) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(value, style: textTheme.headlineSmall?.copyWith(fontSize: 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildMyChildren() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildChildAvatar(),
          const SizedBox(width: 10),
          _buildChildAvatar(),
          // Add more children or an "add child" button
        ],
      ),
    );
  }

  Widget _buildChildAvatar() {
    return Container(
      padding: const EdgeInsets.all(2), // For border effect if needed
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Background for the border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          CacheService.getData(key: CacheKeys.userPhoto),
        ), // Use your asset
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildUploadCustomStoryButton(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: TextButton(
          onPressed: () {
            /* TODO: Upload action */
          },
          child: Text(
            'Upload Custom Story',
            style: textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

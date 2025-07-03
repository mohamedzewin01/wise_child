import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/bloc/ChildDetailsPage_cubit.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/content/social_connections_section.dart' ;
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/loading/error_content.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/loading/loading_content.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'basic_info_card.dart';
import 'statistics_card.dart';
import 'stories_section.dart';


class ChildDetailsContent extends StatelessWidget {
  final Children child;
  final String ageString;
  final String languageCode;

  const ChildDetailsContent({
    super.key,
    required this.child,
    required this.ageString,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildDetailsCubit, ChildDetailsState>(
      builder: (context, state) {
        return switch (state) {
          ChildDetailsPageLoading() => const LoadingContent(),
          ChildDetailsPageSuccess() => _buildSuccessContent(state),
          ChildDetailsPageFailure() => ErrorContent(
            onRetry: () => _retryLoading(context),
          ),
          _ => _buildInitialContent(),
        };
      },
    );
  }

  Widget _buildInitialContent() {
    return Column(
      children: [
        BasicInfoCard(
          child: child,
          ageString: ageString,
          languageCode: languageCode,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSuccessContent(ChildDetailsPageSuccess state) {
    final childDetails = state.childrenDetailsEntity.child;

    return Column(
      children: [
        // Basic Info Card
        BasicInfoCard(
          child: child,
          ageString: ageString,
          languageCode: languageCode,
        ),

        const SizedBox(height: 16),

        // Statistics Overview Card
        StatisticsCard(childDetails: childDetails),

        const SizedBox(height: 16),

        // Stories Section
        if (childDetails?.stories?.isNotEmpty == true)
          StoriesSection(stories: childDetails!.stories!,childId:child.idChildren??0 ,),

        const SizedBox(height: 16),

        // Social Connections Section
        SocialConnectionsSection(childDetails: childDetails),

        const SizedBox(height: 100),
      ],
    );
  }

  void _retryLoading(BuildContext context) {
    final cubit = context.read<ChildDetailsCubit>();
    cubit.getChildDetails(childId: child.idChildren ?? 0);
  }
}
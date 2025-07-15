// استبدال محتوى الملف الأصلي lib/features/StoryInfo/presentation/pages/StoryInfo_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/features/StoryInfo/presentation/bloc/StoryInfo_cubit.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_content.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_loading_widget.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_error_widget.dart';

class StoryInfoPage extends StatefulWidget {
  final int storyId;
  final bool isRTL;

  const StoryInfoPage({
    super.key,
    required this.storyId,
    this.isRTL = true,
  });

  @override
  State<StoryInfoPage> createState() => _StoryInfoPageState();
}

class _StoryInfoPageState extends State<StoryInfoPage> {
  late StoryInfoCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoryInfoCubit>();
    _loadStoryInfo();
  }

  void _loadStoryInfo() {
    viewModel.storyInfo(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocBuilder<StoryInfoCubit, StoryInfoState>(
          builder: (context, state) {
            if (state is StoryInfoLoading) {
              return StoryInfoLoadingWidget(onRetry: _retryLoading);
            } else if (state is StoryInfoSuccess) {
              if (state.storyInfoEntity == null) {
                return StoryInfoErrorWidget(onRetry: _retryLoading);
              }
              return StoryInfoContent(
                storyInfo: state.storyInfoEntity!,
                isRTL: widget.isRTL,
              );
            } else if (state is StoryInfoFailure) {
              return StoryInfoErrorWidget(onRetry: _retryLoading);
            }
            return StoryInfoLoadingWidget(onRetry: _retryLoading);
          },
        ),
      ),
    );
  }

  void _retryLoading() {
    HapticFeedback.lightImpact();
    _loadStoryInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }
}



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Analysis/presentation/bloc/Analysis_cubit.dart';
import 'package:wise_child/features/StoriesPlay/presentation/bloc/StoriesData_cubit.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/story_screen.dart';

import 'package:wise_child/features/StoriesPlay/presentation/widgets/no_content_screen.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/processing_screen.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/sorty_loading.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_error.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/story_play_dto.dart';

class StoriesPlayPage extends StatefulWidget {
  const StoriesPlayPage({
    super.key,
    required this.childId,
    required this.storyId,
  });

  final int childId;
  final int storyId;

  @override
  State<StoriesPlayPage> createState() => _StoriesPlayPageState();
}

class _StoriesPlayPageState extends State<StoriesPlayPage>
    with TickerProviderStateMixin {
  late StoriesDataCubit viewModel;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoriesDataCubit>();
    context.read<AnalysisCubit>().addStoryView(widget.storyId, widget.childId);

    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _loadingController.repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    // إعادة تعيين الاتجاه الافتراضي عند مغادرة الصفحة
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: viewModel
            ..getStories(childId: widget.childId, storyId: widget.storyId),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<StoriesDataCubit, StoriesDataState>(
          builder: (context, state) {
            if (state is StoriesPlayLoading) {
              return StoryLoading(loadingAnimation: _loadingAnimation);
            }

            if (state is StoriesPlayFailure) {
              return StoryError(
                function: () {
                  viewModel.getStories(
                    childId: widget.childId,
                    storyId: widget.storyId,
                  );
                },
              );
            }

            if (state is StoriesPlaySuccess) {
              String status = state.storyPlayEntity.status ?? '';
              List<Clips> storyPages = state.storyPlayEntity.clips ?? [];

              if (status == 'processing') {
                return ProcessingScreen(
                 message:  state.storyPlayEntity.message ?? '',
                  loadingAnimation: _loadingAnimation,
                );
              }

              if (storyPages.isEmpty) {
                return NoContentScreen();
              }

              return StoryScreen(storyPages: storyPages);
            }

            return StoryLoading(loadingAnimation: _loadingAnimation);
          },
        ),
      ),
    );
  }




}



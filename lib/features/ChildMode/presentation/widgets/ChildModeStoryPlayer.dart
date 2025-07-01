// // lib/features/ChildMode/presentation/widgets/child_mode_video_player.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wise_child/features/ChildMode/presentation/widgets/child_friendly_controls.dart';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class ChildModeVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String storyTitle;
//   final VoidCallback? onVideoEnd;
//
//   const ChildModeVideoPlayer({
//     super.key,
//     required this.videoUrl,
//     required this.storyTitle,
//     this.onVideoEnd,
//   });
//
//   @override
//   State<ChildModeVideoPlayer> createState() => _ChildModeVideoPlayerState();
// }
//
// class _ChildModeVideoPlayerState extends State<ChildModeVideoPlayer>
//     with TickerProviderStateMixin {
//   late VideoPlayerController _videoController;
//   late AnimationController _bounceController;
//   late AnimationController _sparkleController;
//   late Animation<double> _bounceAnimation;
//
//   bool _isInitialized = false;
//   bool _showControls = true;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _bounceController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _sparkleController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );
//
//     _bounceAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _bounceController,
//       curve: Curves.elasticOut,
//     ));
//
//     _initializeVideo();
//     _sparkleController.repeat();
//   }
//
//   Future<void> _initializeVideo() async {
//     try {
//       _videoController = VideoPlayerController.network(widget.videoUrl);
//       await _videoController.initialize();
//
//       setState(() => _isInitialized = true);
//
//       _videoController.addListener(() {
//         if (_videoController.value.isPlaying != _isPlaying) {
//           setState(() => _isPlaying = _videoController.value.isPlaying);
//         }
//
//         // التحقق من انتهاء الفيديو
//         if (_videoController.value.position >= _videoController.value.duration) {
//           widget.onVideoEnd?.call();
//         }
//       });
//
//       _bounceController.forward();
//     } catch (e) {
//       print('Error initializing video: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     _bounceController.dispose();
//     _sparkleController.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     HapticFeedback.lightImpact();
//
//     if (_videoController.value.isPlaying) {
//       _videoController.pause();
//     } else {
//       _videoController.play();
//     }
//   }
//
//   void _showControlsTemporarily() {
//     setState(() => _showControls = true);
//
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // خلفية متدرجة ملونة
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.purple.shade900,
//                   Colors.blue.shade900,
//                   Colors.black,
//                 ],
//               ),
//             ),
//           ),
//
//           // مشغل الفيديو
//           if (_isInitialized)
//             Center(
//               child: AnimatedBuilder(
//                 animation: _bounceAnimation,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _bounceAnimation.value,
//                     child: AspectRatio(
//                       aspectRatio: _videoController.value.aspectRatio,
//                       child: GestureDetector(
//                         onTap: _showControlsTemporarily,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: VideoPlayer(_videoController),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//           // شاشة التحميل
//           if (!_isInitialized)
//             _buildLoadingScreen(),
//
//           // عناصر تفاعلية متحركة
//           ..._buildSparkleEffects(),
//
//           // أزرار التحكم الودودة للأطفال
//           if (_showControls && _isInitialized)
//             ChildFriendlyControls(
//               videoController: _videoController,
//               isPlaying: _isPlaying,
//               onPlayPause: _togglePlayPause,
//               onClose: () => Navigator.of(context).pop(),
//               storyTitle: widget.storyTitle,
//             ),
//
//           // زر الخروج المخفي
//           _buildHiddenExitButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingScreen() {
//     return Container(
//       color: Colors.black.withOpacity(0.8),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // رسوم متحركة للتحميل
//             AnimatedBuilder(
//               animation: _sparkleController,
//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: _sparkleController.value * 2 * math.pi,
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.yellow.shade300,
//                           Colors.orange.shade300,
//                           Colors.pink.shade300,
//                         ],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.orange.withOpacity(0.6),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.play_circle_filled,
//                       size: 50,
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 30),
//
//             Text(
//               'جاري تحضير القصة... 🎬',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // مؤشر التحميل الملون
//             Container(
//               width: 200,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               child: AnimatedBuilder(
//                 animation: _sparkleController,
//                 builder: (context, child) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(3),
//                     child: LinearProgressIndicator(
//                       value: _sparkleController.value,
//                       backgroundColor: Colors.transparent,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Colors.yellow.shade300,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildSparkleEffects() {
//     return List.generate(15, (index) {
//       return AnimatedBuilder(
//         animation: _sparkleController,
//         builder: (context, child) {
//           final offset = (index * 0.1) % 1.0;
//           final animationValue = (_sparkleController.value + offset) % 1.0;
//
//           final screenSize = MediaQuery.of(context).size;
//           final xPos = (index % 5) * (screenSize.width / 5) +
//               math.sin(animationValue * 2 * math.pi) * 30;
//           final yPos = screenSize.height * animationValue;
//
//           return Positioned(
//             left: xPos,
//             top: yPos,
//             child: Transform.rotate(
//               angle: animationValue * 2 * math.pi,
//               child: Icon(
//                 Icons.star_rounded,
//                 size: 15 + (index % 3) * 5,
//                 color: [
//                   Colors.yellow.shade300,
//                   Colors.pink.shade300,
//                   Colors.blue.shade300,
//                   Colors.green.shade300,
//                 ][index % 4].withOpacity(0.7),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   Widget _buildHiddenExitButton() {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 10,
//       right: 10,
//       child: GestureDetector(
//         onTap: () => Navigator.of(context).pop(),
//         child: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.close_rounded,
//             color: Colors.white.withOpacity(0.7),
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // =======================================
// // Child Friendly Controls
// // =======================================
//
// // lib/features/ChildMode/presentation/widgets/child_friendly_controls.dart
//

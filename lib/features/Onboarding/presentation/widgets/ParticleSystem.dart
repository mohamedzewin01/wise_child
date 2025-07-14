// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// // Advanced Particle System for Background
// class ParticleSystem extends StatefulWidget {
//   final Color primaryColor;
//   final Color secondaryColor;
//   final int particleCount;
//
//   const ParticleSystem({
//     super.key,
//     required this.primaryColor,
//     required this.secondaryColor,
//     this.particleCount = 20,
//   });
//
//   @override
//   State<ParticleSystem> createState() => _ParticleSystemState();
// }
//
// class _ParticleSystemState extends State<ParticleSystem>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late List<Particle> particles;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 15),
//       vsync: this,
//     )..repeat();
//
//     _initializeParticles();
//   }
//
//   void _initializeParticles() {
//     particles = List.generate(widget.particleCount, (index) {
//       return Particle(
//         initialX: math.Random().nextDouble(),
//         initialY: math.Random().nextDouble(),
//         size: 20 + math.Random().nextDouble() * 40,
//         speed: 0.5 + math.Random().nextDouble() * 1.5,
//         color: index % 2 == 0 ? widget.primaryColor : widget.secondaryColor,
//         opacity: 0.1 + math.Random().nextDouble() * 0.3,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return CustomPaint(
//           painter: ParticlePainter(
//             particles: particles,
//             animationValue: _animationController.value,
//           ),
//           size: Size.infinite,
//         );
//       },
//     );
//   }
// }
//
// class Particle {
//   final double initialX;
//   final double initialY;
//   final double size;
//   final double speed;
//   final Color color;
//   final double opacity;
//
//   Particle({
//     required this.initialX,
//     required this.initialY,
//     required this.size,
//     required this.speed,
//     required this.color,
//     required this.opacity,
//   });
// }
//
// class ParticlePainter extends CustomPainter {
//   final List<Particle> particles;
//   final double animationValue;
//
//   ParticlePainter({
//     required this.particles,
//     required this.animationValue,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final particle in particles) {
//       final paint = Paint()
//         ..color = particle.color.withOpacity(particle.opacity)
//         ..style = PaintingStyle.fill;
//
//       // Calculate position with floating effect
//       final x = (particle.initialX + (animationValue * particle.speed * 0.3)) % 1.0;
//       final y = (particle.initialY +
//           (math.sin(animationValue * 2 * math.pi * particle.speed) * 0.1)) % 1.0;
//
//       final position = Offset(
//         x * size.width,
//         y * size.height,
//       );
//
//       // Add pulsing effect
//       final pulseSize = particle.size * (1 + math.sin(animationValue * 4 * math.pi) * 0.2);
//
//       canvas.drawCircle(position, pulseSize / 2, paint);
//
//       // Add glow effect
//       final glowPaint = Paint()
//         ..color = particle.color.withOpacity(particle.opacity * 0.3)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
//
//       canvas.drawCircle(position, pulseSize, glowPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//
// // Morphing Background with Gradient Animation
// class MorphingGradientBackground extends StatefulWidget {
//   final List<Color> colors;
//   final Duration duration;
//
//   const MorphingGradientBackground({
//     super.key,
//     required this.colors,
//     this.duration = const Duration(seconds: 8),
//   });
//
//   @override
//   State<MorphingGradientBackground> createState() => _MorphingGradientBackgroundState();
// }
//
// class _MorphingGradientBackgroundState extends State<MorphingGradientBackground>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: _interpolateColors(),
//               stops: _generateStops(),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   List<Color> _interpolateColors() {
//     final t = _animation.value;
//     return widget.colors.map((color) {
//       return Color.lerp(
//         color,
//         color.withOpacity(0.7 + 0.3 * math.sin(t * 2 * math.pi)),
//         0.3 * math.sin(t * math.pi),
//       )!;
//     }).toList();
//   }
//
//   List<double> _generateStops() {
//     final t = _animation.value;
//     return [
//       0.0,
//       0.3 + 0.2 * math.sin(t * 2 * math.pi),
//       0.7 + 0.2 * math.cos(t * 2 * math.pi),
//       1.0,
//     ];
//   }
// }
//
// // 3D Transform Container for Images
// class Transform3DContainer extends StatefulWidget {
//   final Widget child;
//   final Duration duration;
//   final bool autoRotate;
//
//   const Transform3DContainer({
//     super.key,
//     required this.child,
//     this.duration = const Duration(seconds: 10),
//     this.autoRotate = true,
//   });
//
//   @override
//   State<Transform3DContainer> createState() => _Transform3DContainerState();
// }
//
// class _Transform3DContainerState extends State<Transform3DContainer>
//     with TickerProviderStateMixin {
//   late AnimationController _rotationController;
//   late Animation<double> _rotationAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _rotationController = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     );
//
//     _rotationAnimation = Tween<double>(
//       begin: 0.0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(
//       parent: _rotationController,
//       curve: Curves.linear,
//     ));
//
//     if (widget.autoRotate) {
//       _rotationController.repeat();
//     }
//   }
//
//   @override
//   void dispose() {
//     _rotationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _rotationAnimation,
//       builder: (context, child) {
//         return Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.identity()
//             ..setEntry(3, 2, 0.001) // perspective
//             ..rotateY(math.sin(_rotationAnimation.value) * 0.1)
//             ..rotateX(math.cos(_rotationAnimation.value) * 0.05),
//           child: widget.child,
//         );
//       },
//     );
//   }
// }
//
// // Liquid Loading Animation
// class LiquidLoadingAnimation extends StatefulWidget {
//   final Color color;
//   final double size;
//
//   const LiquidLoadingAnimation({
//     super.key,
//     required this.color,
//     this.size = 100.0,
//   });
//
//   @override
//   State<LiquidLoadingAnimation> createState() => _LiquidLoadingAnimationState();
// }
//
// class _LiquidLoadingAnimationState extends State<LiquidLoadingAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat();
//
//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 2 * math.pi,
//     ).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return CustomPaint(
//           painter: LiquidPainter(
//             color: widget.color,
//             animationValue: _animation.value,
//           ),
//           size: Size(widget.size, widget.size),
//         );
//       },
//     );
//   }
// }
//
// class LiquidPainter extends CustomPainter {
//   final Color color;
//   final double animationValue;
//
//   LiquidPainter({
//     required this.color,
//     required this.animationValue,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     final path = Path();
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;
//
//     // Create liquid wave effect
//     for (int i = 0; i <= 360; i++) {
//       final angle = i * math.pi / 180;
//       final waveRadius = radius +
//           (math.sin(angle * 4 + animationValue) * 10) +
//           (math.sin(angle * 2 + animationValue * 2) * 5);
//
//       final x = center.dx + math.cos(angle) * waveRadius;
//       final y = center.dy + math.sin(angle) * waveRadius;
//
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//
//     path.close();
//     canvas.drawPath(path, paint);
//
//     // Add inner glow
//     final glowPaint = Paint()
//       ..color = color.withOpacity(0.3)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
//
//     canvas.drawPath(path, glowPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//
// // Shimmer Effect Widget
// class ShimmerEffect extends StatefulWidget {
//   final Widget child;
//   final Color highlightColor;
//   final Color baseColor;
//   final Duration duration;
//
//   const ShimmerEffect({
//     super.key,
//     required this.child,
//     this.highlightColor = Colors.white,
//     this.baseColor = Colors.grey,
//     this.duration = const Duration(milliseconds: 1500),
//   });
//
//   @override
//   State<ShimmerEffect> createState() => _ShimmerEffectState();
// }
//
// class _ShimmerEffectState extends State<ShimmerEffect>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     )..repeat();
//
//     _animation = Tween<double>(
//       begin: -1.0,
//       end: 2.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return ShaderMask(
//           shaderCallback: (bounds) {
//             return LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [
//                 widget.baseColor,
//                 widget.highlightColor,
//                 widget.baseColor,
//               ],
//               stops: [
//                 math.max(0.0, _animation.value - 0.3),
//                 _animation.value,
//                 math.min(1.0, _animation.value + 0.3),
//               ],
//             ).createShader(bounds);
//           },
//           child: widget.child,
//         );
//       },
//     );
//   }
// }
//
// // Advanced Ripple Effect
// class AdvancedRippleEffect extends StatefulWidget {
//   final Widget child;
//   final Color rippleColor;
//   final Duration duration;
//   final VoidCallback? onTap;
//
//   const AdvancedRippleEffect({
//     super.key,
//     required this.child,
//     required this.rippleColor,
//     this.duration = const Duration(milliseconds: 600),
//     this.onTap,
//   });
//
//   @override
//   State<AdvancedRippleEffect> createState() => _AdvancedRippleEffectState();
// }
//
// class _AdvancedRippleEffectState extends State<AdvancedRippleEffect>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//
//   Offset? _tapPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _fadeAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
//     ));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _handleTap(TapDownDetails details) {
//     setState(() {
//       _tapPosition = details.localPosition;
//     });
//     _controller.reset();
//     _controller.forward();
//     widget.onTap?.call();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _handleTap,
//       child: Stack(
//         children: [
//           widget.child,
//           if (_tapPosition != null)
//             AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Positioned.fill(
//                   child: CustomPaint(
//                     painter: RipplePainter(
//                       center: _tapPosition!,
//                       radius: _scaleAnimation.value * 250,
//                       color: widget.rippleColor.withOpacity(_fadeAnimation.value),
//                     ),
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class RipplePainter extends CustomPainter {
//   final Offset center;
//   final double radius;
//   final Color color;
//
//   RipplePainter({
//     required this.center,
//     required this.radius,
//     required this.color,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(center, radius, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
// widgets إضافية للشرح التفاعلي
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

// Widget للشرح السريع مع نصائح
class QuickTipShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String tip;
  final Widget child;
  final IconData icon;
  final Color color;

  const QuickTipShowcase({
    super.key,
    required this.showcaseKey,
    required this.tip,
    required this.child,
    this.icon = Icons.lightbulb,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      height: 120,
      width: 280,
      container: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'نصيحة سريعة 💡',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}

// Widget للشرح مع خطوات متعددة
class MultiStepShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final List<ShowcaseStep> steps;
  final Widget child;
  final Color primaryColor;

  const MultiStepShowcase({
    super.key,
    required this.showcaseKey,
    required this.steps,
    required this.child,
    this.primaryColor = Colors.blue,
  });

  @override
  State<MultiStepShowcase> createState() => _MultiStepShowcaseState();
}

class _MultiStepShowcaseState extends State<MultiStepShowcase> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[currentStep];

    return Showcase.withWidget(
      key: widget.showcaseKey,
      height: 300,
      width: 320,
      container: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(step.icon, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      step.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${currentStep + 1}/${widget.steps.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    if (step.image != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: step.image!,
                      ),
                    ],
                    if (step.bullets != null) ...[
                      const SizedBox(height: 12),
                      ...step.bullets!.map((bullet) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                bullet,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ],
                ),
              ),
            ),

            // Navigation
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                if (currentStep > 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        currentStep--;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'السابق',
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(),

                // Progress indicator
                Row(
                  children: List.generate(widget.steps.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index <= currentStep
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                // Next/Finish button
                ElevatedButton(
                  onPressed: () {
                    if (currentStep < widget.steps.length - 1) {
                      setState(() {
                        currentStep++;
                      });
                    } else {
                      ShowCaseWidget.of(context).next();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: widget.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    currentStep < widget.steps.length - 1 ? 'التالي' : 'إنهاء',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}

// نموذج للخطوة في الشرح متعدد الخطوات
class ShowcaseStep {
  final String title;
  final String description;
  final IconData icon;
  final Widget? image;
  final List<String>? bullets;

  ShowcaseStep({
    required this.title,
    required this.description,
    required this.icon,
    this.image,
    this.bullets,
  });
}

// Widget للشرح التفاعلي مع الألعاب
class InteractiveShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;
  final VoidCallback? onInteraction;
  final Color color;

  const InteractiveShowcase({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
    this.onInteraction,
    this.color = Colors.purple,
  });

  @override
  State<InteractiveShowcase> createState() => _InteractiveShowcaseState();
}

class _InteractiveShowcaseState extends State<InteractiveShowcase>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: widget.showcaseKey,
      height: 250,
      width: 300,
      container: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _hasInteracted ? 1.0 : _pulseAnimation.value,
                      child: Icon(
                        _hasInteracted ? Icons.check_circle : Icons.touch_app,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Interactive element
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _hasInteracted = true;
                  });
                  _pulseController.stop();
                  widget.onInteraction?.call();

                  // Auto advance after interaction
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      ShowCaseWidget.of(context).next();
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _hasInteracted
                        ? Colors.green
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _hasInteracted ? Icons.check : Icons.touch_app,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _hasInteracted ? 'رائع! 🎉' : 'اضغط هنا للتجربة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_hasInteracted) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✅ تم! سيتم الانتقال للخطوة التالية تلقائياً',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      child: widget.child,
    );
  }
}

// Widget للشرح مع الفيديو
class VideoShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final String videoUrl;
  final Widget child;

  const VideoShowcase({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      height: 350,
      width: 320,
      container: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.play_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Video placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اضغط لمشاهدة الفيديو',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => ShowCaseWidget.of(context).next(),
                  child: Text(
                    'تخطي الفيديو',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Play video logic here
                    _playVideo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                  ),
                  child: const Text('مشاهدة'),
                ),
              ],
            ),
          ],
        ),
      ),
      child: child,
    );
  }

  void _playVideo(BuildContext context) {
    // Implement video player logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('فيديو تعليمي'),
        content: const Text('سيتم تشغيل الفيديو هنا...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ShowCaseWidget.of(context).next();
            },
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

// Widget للشرح مع الصور المتحركة
class AnimatedImageShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final List<String> imagePaths;
  final Widget child;

  const AnimatedImageShowcase({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.child,
  });

  @override
  State<AnimatedImageShowcase> createState() => _AnimatedImageShowcaseState();
}

class _AnimatedImageShowcaseState extends State<AnimatedImageShowcase>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startImageRotation();
  }

  void _startImageRotation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % widget.imagePaths.length;
        });
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
        _startImageRotation();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: widget.showcaseKey,
      height: 400,
      width: 320,
      container: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.slideshow, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Animated images
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'صورة ${_currentImageIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Image indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imagePaths.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentImageIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Navigation
            Center(
              child: ElevatedButton(
                onPressed: () => ShowCaseWidget.of(context).next(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                ),
                child: const Text('متابعة'),
              ),
            ),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}

// مساعد لإنشاء شرح سريع للقوائم
class ListItemShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;
  final int itemIndex;
  final int totalItems;

  const ListItemShowcase({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
    required this.itemIndex,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      height: 180,
      width: 280,
      container: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${itemIndex + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$itemIndex من $totalItems',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (itemIndex > 0)
                  TextButton(
                    onPressed: () {
                      // Navigate to previous item
                    },
                    child: Text(
                      'السابق',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: () => ShowCaseWidget.of(context).next(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(itemIndex < totalItems - 1 ? 'التالي' : 'إنهاء'),
                ),
              ],
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}

// Widget للشرح مع الاختبار السريع
class QuizShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final Widget child;

  const QuizShowcase({
    super.key,
    required this.showcaseKey,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.child,
  });

  @override
  State<QuizShowcase> createState() => _QuizShowcaseState();
}

class _QuizShowcaseState extends State<QuizShowcase> {
  int? selectedAnswer;
  bool hasAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: widget.showcaseKey,
      height: 350,
      width: 320,
      container: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اختبر معلوماتك 🧠',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Options
            ...widget.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isCorrect = index == widget.correctAnswer;
              final isSelected = selectedAnswer == index;

              Color getOptionColor() {
                if (!hasAnswered) return Colors.white.withOpacity(0.2);
                if (isSelected && isCorrect) return Colors.green;
                if (isSelected && !isCorrect) return Colors.red;
                if (isCorrect) return Colors.green;
                return Colors.white.withOpacity(0.1);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: hasAnswered ? null : () {
                    setState(() {
                      selectedAnswer = index;
                      hasAnswered = true;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: getOptionColor(),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (hasAnswered && isCorrect)
                          const Icon(Icons.check, color: Colors.white, size: 20),
                        if (hasAnswered && isSelected && !isCorrect)
                          const Icon(Icons.close, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Result message
            if (hasAnswered) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selectedAnswer == widget.correctAnswer
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedAnswer == widget.correctAnswer
                          ? Icons.celebration
                          : Icons.info,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedAnswer == widget.correctAnswer
                            ? 'رائع! إجابة صحيحة 🎉'
                            : 'لا بأس، ستتعلم أكثر مع الوقت 😊',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Continue button
            Center(
              child: ElevatedButton(
                onPressed: hasAnswered
                    ? () => ShowCaseWidget.of(context).next()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.white.withOpacity(0.3),
                ),
                child: Text(
                  hasAnswered ? 'متابعة' : 'اختر إجابة',
                  style: TextStyle(
                    color: hasAnswered ? Colors.orange : Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}
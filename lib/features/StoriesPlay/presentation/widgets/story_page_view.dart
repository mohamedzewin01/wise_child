import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/cashed_image.dart';

class StoryPageView extends StatelessWidget {

  final String imageUrl;
  final String text;

  const StoryPageView({super.key, required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(

      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomImage(url:
            imageUrl,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
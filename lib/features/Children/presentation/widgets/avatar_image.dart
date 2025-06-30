// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:wise_child/core/api/api_constants.dart';
// import 'package:wise_child/core/utils/name_utils.dart';
//
// class AvatarWidget extends StatelessWidget {
//   final String? imageUrl;
//   final String firstName;
//   final String lastName;
//   final double radius;
//   final Color backgroundColor;
//   final Color textColor;
//
//   const AvatarWidget({
//     super.key,
//     this.imageUrl,
//
//     this.radius = 28.0,
//     this.backgroundColor = Colors.purpleAccent,
//     this.textColor = Colors.black87,
//     required this.firstName,
//     required this.lastName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child;
//     if (imageUrl != null && imageUrl!.isNotEmpty) {
//       child = CircleAvatar(
//         backgroundColor: Colors.grey.shade300,
//         radius: radius,
//
//         backgroundImage: CachedNetworkImageProvider(
//           '${ApiConstants.urlImage}$imageUrl',
//
//         ),
//       );
//     } else {
//       child = CircleAvatar(
//         radius: radius,
//         backgroundColor: backgroundColor.withOpacity(0.3),
//         child: Text(
//           NameUtils.extractNameInitials('$firstName $lastName'),
//           style: TextStyle(
//             fontSize: radius * 0.6,
//             fontWeight: FontWeight.bold,
//             color: textColor,
//           ),
//         ),
//       );
//     }
//     return child;
//   }
// }
///
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/name_utils.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String firstName;
  final String lastName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    required this.firstName,
    required this.lastName,
    this.radius = 28.0,
    this.backgroundColor = Colors.purpleAccent,
    this.textColor = Colors.white,
    this.showBorder = false,
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
          color: borderColor,
          width: borderWidth,
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: _buildAvatar(),
    );
  }

  Widget _buildAvatar() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: '${ApiConstants.urlImage}$imageUrl',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor.withOpacity(0.3),
              ),
              child: Center(
                child: SizedBox(
                  width: radius * 0.6,
                  height: radius * 0.6,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      backgroundColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => _buildInitialsAvatar(),
          ),
        ),
      );
    } else {
      return _buildInitialsAvatar();
    }
  }

  Widget _buildInitialsAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor.withOpacity(0.15),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor.withOpacity(0.8),
              backgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Text(
            NameUtils.extractNameInitials('$firstName $lastName'),
            style: getBoldStyle(
              color: textColor,
              fontSize: radius * 0.85,
            )

            // TextStyle(
            //   fontSize: radius * 0.99,
            //   fontWeight: FontWeight.bold,
            //   color: textColor,
            //   // letterSpacing: 1,
            // ),
          ),
        ),
      ),
    );
  }
}
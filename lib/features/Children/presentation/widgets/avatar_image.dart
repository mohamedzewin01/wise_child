import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/utils/name_utils.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String firstName;
  final String lastName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const AvatarWidget({
    super.key,
    this.imageUrl,

    this.radius = 28.0,
    this.backgroundColor = Colors.purpleAccent,
    this.textColor = Colors.black87,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(
          '${ApiConstants.urlImage}$imageUrl',
        ),
      );
    } else {
      child = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor.withOpacity(0.3),
        child: Text(
          NameUtils.extractNameInitials('$firstName $lastName'),
          style: TextStyle(
            fontSize: radius * 0.7,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      );
    }
    return child;
  }
}

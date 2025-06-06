import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.usernameController,
    required this.hintText,
    this.textInputType,
    this.validator,
    required this.title,
    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.prefixIcon, this.maxLines,
  });

  final TextEditingController usernameController;

  final String hintText;
  final String title;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;

  final TextInputType? textInputType;

  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty  ? const SizedBox() :  Text(
          title,
          style:getSemiBoldStyle(color: Colors.black54,fontSize: 14)


        ),
   SizedBox(height: 8),
        TextFormField(
          onTap: onTap,
          readOnly: readOnly ?? false,
          maxLines: maxLines ?? 1,
          controller: usernameController,
          decoration: InputDecoration(
            hintText:hintText,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
            hintStyle: getSemiBoldStyle(color: Colors.black38,fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: ColorManager.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color:  ColorManager.inputBorder.withOpacity(0.7),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: ColorManager.chatUserBg.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
          ),

          keyboardType: textInputType,
          validator: validator,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

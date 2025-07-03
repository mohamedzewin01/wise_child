
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _focusAnimation;
  late Animation<Color?> _colorAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.white.withOpacity(0.2),
      end: Colors.white.withOpacity(0.4),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _focusAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _colorAnimation.value ?? Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                if (_isFocused)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.isPassword && !_isPasswordVisible,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              onTap: widget.onTap,
              style: getRegularStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: getRegularStyle(
                  color: Colors.white.withOpacity(_isFocused ? 1.0 : 0.7),
                  fontSize: _isFocused ? 14 : 12,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white.withOpacity(0.8),
                    size: 16,
                  ),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                floatingLabelStyle: getRegularStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                errorStyle: getRegularStyle(
                  color: Colors.red.shade300,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

enum CustomButtonType { primary, secondary, tertiary, disabled }

class CustomButton extends TextButton {
  final CustomButtonType buttonType;
  final double buttonHeight;
  final double buttonWidth;
  final double cornerRadius;

  CustomButton({
    super.key,
    required this.buttonType,
    required VoidCallback onPressed,
    this.buttonHeight = 45,
    this.buttonWidth = double.infinity,
    this.cornerRadius = 8.0,
    required super.child,
  }) : super(
          onPressed:
              buttonType == CustomButtonType.disabled ? () {} : onPressed,
          style: _buildButtonStyle(
              buttonType, buttonWidth, buttonHeight, cornerRadius),
        );

  static ButtonStyle _buildButtonStyle(CustomButtonType buttonType,
      double buttonWidth, double buttonHeight, double cornerRadius) {
    switch (buttonType) {
      case CustomButtonType.primary:
        return TextButton.styleFrom(
          side: const BorderSide(
            width: 1.0, // Border width
            color: Color(0xff8F17D8), // Border color
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius), // Corner radius
          ),
          minimumSize: Size(buttonWidth, buttonHeight),
          visualDensity: VisualDensity.comfortable,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: const Color(0xff8F17D8),
        );
      case CustomButtonType.secondary:
        return TextButton.styleFrom(
          side: const BorderSide(
            width: 1.0, // Border width
            color: Colors.grey, // Border color
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius), // Corner radius
          ),
          minimumSize: Size(buttonWidth, buttonHeight),
          visualDensity: VisualDensity.comfortable,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: Colors.white,
        );
      case CustomButtonType.tertiary:
        return TextButton.styleFrom(
          side: const BorderSide(
            width: 1.0, // Border width
            color: Colors.grey, // Border color
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius), // Corner radius
          ),
          minimumSize: Size(buttonWidth, buttonHeight),
          visualDensity: VisualDensity.comfortable,
          foregroundColor: const Color(0xff8F17D8),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: Colors.white,
        );
      case CustomButtonType.disabled:
        return TextButton.styleFrom(
          side: const BorderSide(
            width: 1.0, // Border width
            color: Color(0xFFD6D6D6), // Border color
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius), // Corner radius
          ),
          minimumSize: Size(buttonWidth, buttonHeight),
          visualDensity: VisualDensity.comfortable,
          foregroundColor: const Color(0xFFADADAD),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: const Color(0xFFD6D6D6),
        );
    }
  }
}

import 'package:flutter/material.dart';

enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final bool loading; // <--- Tambahan loading

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.height = 50,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.padding,
    this.loading = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: loading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2.5,
                ),
              )
            : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconPosition == IconPosition.left
                    ? [
                        Icon(icon, color: textColor),
                        const SizedBox(width: 8),
                        Text(
                          text,
                          style: TextStyle(
                            color: textColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    : [
                        Text(
                          text,
                          style: TextStyle(
                            color: textColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(icon, color: textColor),
                      ],
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}



// Usage Example:
// CustomButton(
//   text: "Submit",
//   onPressed: () => print("Submit pressed"),
// )

// CustomButton(
//   text: "Next",
//   icon: Icons.arrow_forward,
//   iconPosition: IconPosition.right,
//   backgroundColor: Colors.green,
// )

// CustomButton(
//   text: "Back",
//   icon: Icons.arrow_back,
//   iconPosition: IconPosition.left,
//   backgroundColor: Colors.grey.shade800,
// )

// CustomButton(
//   text: "Submit",
//   loading: true, // tampilkan spinner
//   onPressed: () => print("Submit pressed"),
// )

// CustomButton(
//   text: "Next",
//   icon: Icons.arrow_forward,
//   iconPosition: IconPosition.right,
//   loading: false,
//   backgroundColor: Colors.green,
// )
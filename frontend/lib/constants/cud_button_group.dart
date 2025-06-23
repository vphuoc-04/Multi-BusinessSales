import 'package:flutter/material.dart';

class Button {
  final String label;
  final Color color;
  final VoidCallback onTap;

  Button({
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class CudButtonGroup extends StatelessWidget {
  final List<Button> buttons;

  const CudButtonGroup({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons
          .map((button) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: button.onTap,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: button.color,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      button.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

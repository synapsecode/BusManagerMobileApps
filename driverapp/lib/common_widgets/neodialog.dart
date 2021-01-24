import 'package:flutter/material.dart';

class NeoDialog extends StatelessWidget {
  final Color color;
  final String title;
  final double fontSize;
  final double topHeight;
  final Widget content;
  final List<Widget> actions;
  const NeoDialog({
    this.color = Colors.black,
    this.title,
    this.fontSize = 32,
    this.content,
    this.actions,
    this.topHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Container(
        width: double.infinity,
        height: topHeight,
        color: color,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
      content: content,
      actions: actions,
    );
  }
}

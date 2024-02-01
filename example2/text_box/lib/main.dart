import 'package:flutter/material.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Example: text box',
      home: _Page(),
    ),
  );
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example: text box'),
      ),
      body: IntrinsicSizeBuilder(
        subject: const Text(
          str,
          style: TextStyle(fontSize: 25),
        ),
        constrainedAxis: Axis.horizontal, // constrain it to device width
        builder: (context, textSize, text) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _WithBorder(
                size: textSize,
                child: text,
              ),
              const SizedBox(height: 10),
              _WithBorder(
                size: textSize,
                child: const Text(
                  "And here's some text put in a text box of exact same size as previous one.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WithBorder extends StatelessWidget {
  final Size size;
  final Widget child;

  const _WithBorder({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

const str =
    "Here's a text that we want to know the size of! It might be long or short............... in this case, quite long.";

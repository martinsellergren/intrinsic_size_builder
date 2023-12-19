library intrinsic_size_builder;

import 'package:flutter/material.dart';

class IntrinsicSizeBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Size childSize, Widget child)
      builder;

  const IntrinsicSizeBuilder({
    super.key,
    required this.child,
    required this.builder,
  });

  @override
  State<IntrinsicSizeBuilder> createState() => _IntrinsicSizeBuilderState();
}

class _IntrinsicSizeBuilderState extends State<IntrinsicSizeBuilder> {
  final _subjectKey = GlobalKey();
  Size? _size;
  bool _isDetermined = false;
  BoxConstraints? _lastConstraints;

  void _evaluateSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = _subjectKey.currentContext?.size;
      if (size != _size) {
        setState(() => _size = size);
      }
      setState(() => _isDetermined = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        Future(() => setState(() => _isDetermined = false));
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_lastConstraints != null && _lastConstraints != constraints) {
            Future(() => setState(() => _isDetermined = false));
          }
          _lastConstraints = constraints;
          return Stack(
            children: [
              if (!_isDetermined)
                () {
                  _evaluateSize();
                  return Opacity(
                    opacity: 0,
                    child: KeyedSubtree(
                      key: _subjectKey,
                      child: widget.child,
                    ),
                  );
                }(),
              if (_size != null)
                widget.builder(
                  context,
                  _size!,
                  OverflowBox(
                    maxHeight: double.infinity,
                    child: KeyedSubtree(
                      key: _isDetermined ? _subjectKey : null,
                      child: widget.child,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

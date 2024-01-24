library intrinsic_size_builder;

import 'package:flutter/material.dart';

typedef WithSizeBuilder = Widget Function(
    BuildContext context, Size subjectSize, Widget subject);

class IntrinsicSizeBuilder extends StatefulWidget {
  const IntrinsicSizeBuilder(
      {super.key,
      required this.subject,
      required this.builder,
      this.constrainedAxis,
      this.firstFrameWidget});

  final Widget subject;
  final WithSizeBuilder builder;

  /// The axis to retain constraints on, if any, when determining subject size.
  final Axis? constrainedAxis;

  /// Shown only first frame. This frame is used for determining subject size.
  /// Experiment with this if you're trying to avoid initial flicker.
  /// Defaults to transparency.
  final Widget? firstFrameWidget;

  /// Refresh the sizing of any IntrinsicSizeBuilder further up the widget tree.
  /// Basically, always call this when a child is resized.
  ///
  /// See the example/ how you can do it for an Image.network, where the size
  /// differs between loading and loaded state.
  static void refresh(BuildContext context) {
    const SizeChangedLayoutNotification().dispatch(context);
  }

  @override
  State<IntrinsicSizeBuilder> createState() => _IntrinsicSizeBuilderState();
}

class _IntrinsicSizeBuilderState extends State<IntrinsicSizeBuilder> {
  final _evaluationKey = GlobalKey();
  final _evaluatedKey = GlobalKey();
  Size? _size;

  @override
  void initState() {
    super.initState();
    _evaluate();
  }

  void _evaluate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = _evaluationKey.currentContext?.size;
      if (size == null) return;
      setState(() => _size = size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subject = UnconstrainedBox(
      constrainedAxis: widget.constrainedAxis,
      child: KeyedSubtree(
        key: _evaluationKey,
        child: widget.subject,
      ),
    );
    final child = _size == null
        ? null
        : KeyedSubtree(
            key: _evaluatedKey,
            child: widget.builder(
              context,
              _size!,
              widget.subject,
            ),
          );
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        _evaluate();
        return false;
      },
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: subject,
          ),
          child ?? widget.firstFrameWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}

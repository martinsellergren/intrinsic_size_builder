import 'package:flutter/material.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Example: sliver app bar',
    home: _Page(),
  ));
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntrinsicSizeBuilder(
        constrainedAxis: Axis.horizontal,
        subject: const _FlexibleSpace(),
        builder: (context, flexibleSpaceSize, flexibleSpace) =>
            IntrinsicSizeBuilder(
          subject: const _Bottom(),
          constrainedAxis: Axis.horizontal,
          builder: (context, bottomSize, bottom) => CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                pinned: true,
                title: const Text('Example: sliver app bar'),
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(child: flexibleSpace),
                ),
                expandedHeight: flexibleSpaceSize.height + bottomSize.height,
                bottom: PreferredSize(
                  preferredSize: bottomSize,
                  child: bottom,
                ),
              ),
              SliverList.builder(
                itemCount: 100,
                itemBuilder: (context, index) => Container(
                  color: Colors.green[100],
                  alignment: Alignment.center,
                  child: Text('item$index'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FlexibleSpace extends StatelessWidget {
  const _FlexibleSpace();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Here's a flexible space widget which just contains some text. We need to know its size, so that we can use it in the SliverAppBar. In this case, it's just some text here, but it might contain any content.",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Text(
        "And here's the bottom widget, that also just contains some text in this case.",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}

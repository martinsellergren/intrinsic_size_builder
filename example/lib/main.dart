import 'package:flutter/material.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';

void main() {
  runApp(const MaterialApp(home: Page()));
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  String _imgUrl = 'https://placehold.co/600x400.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () =>
                setState(() => _imgUrl = 'https://placehold.co/600x400.png'),
            child: const Text('1'),
          ),
          ElevatedButton(
            onPressed: () =>
                setState(() => _imgUrl = 'https://placehold.co/600x600.png'),
            child: const Text('2'),
          ),
          ElevatedButton(
            onPressed: () =>
                setState(() => _imgUrl = 'https://placehold.co/600x800.png'),
            child: const Text('3'),
          ),
        ],
      ),
      body: IntrinsicSizeBuilder(
        child: _Image(
          key: ValueKey(_imgUrl),
          imgUrl: _imgUrl,
          loadingBuilder: (_) => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        builder: (context, heroImageSize, heroImage) => CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Example for intrinsic_size_builder'),
              flexibleSpace: FlexibleSpaceBar(
                background: heroImage,
              ),
              expandedHeight: heroImageSize.height,
            ),
            SliverList.builder(
              itemCount: 10,
              itemBuilder: (context, i) => const Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatefulWidget {
  final String imgUrl;
  final Widget Function(BuildContext) loadingBuilder;

  const _Image({
    required this.imgUrl,
    required this.loadingBuilder,
    super.key,
  });

  @override
  State<_Image> createState() => _ImageState();
}

class _ImageState extends State<_Image> {
  late final Image _image = Image.network(
    widget.imgUrl,
    fit: BoxFit.cover,
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _image.image
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((info, call) async {
      await Future.delayed(const Duration(seconds: 1)); // Just for demo purpose
      if (!mounted) return;
      const SizeChangedLayoutNotification().dispatch(context);
      setState(() => _isLoading = false);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? widget.loadingBuilder.call(context) : _image;
  }
}

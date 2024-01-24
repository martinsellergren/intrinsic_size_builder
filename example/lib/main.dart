import 'package:flutter/material.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';

enum Status {
  loading,
  loaded,
}

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
  Status _status = Status.loading;

  @override
  void initState() {
    super.initState();
    () async {
      // Just to simulate some page state data being loaded, etc.
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _status = Status.loaded);
    }();
  }

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
      body: switch (_status) {
        Status.loading => const _LoadingBody(),
        Status.loaded => _LoadedBody(imgUrl: _imgUrl),
      },
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final String imgUrl;
  const _LoadedBody({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return IntrinsicSizeBuilder(
      constrainedAxis: Axis.horizontal,
      subject: _Image(
        key: ValueKey(imgUrl),
        imgUrl: imgUrl,
        loadingBuilder: (_) => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      builder: (context, imageSize, image) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Example for intrinsic_size_builder'),
              flexibleSpace: FlexibleSpaceBar(
                background: image,
              ),
              expandedHeight: imageSize.height,
            ),
            SliverList.builder(
              itemCount: 10,
              itemBuilder: (context, i) => const Placeholder(),
            ),
          ],
        );
      },
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
      setState(() => _isLoading = false);
      IntrinsicSizeBuilder.refresh(context);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? widget.loadingBuilder.call(context) : _image;
  }
}

# [text_box](https://github.com/MartinSellergren/intrinsic_size_builder/tree/main/example/text_box)

A simple example illustrating getting the intrinsic size of some text widget.

# [sliver_app_bar](https://github.com/MartinSellergren/intrinsic_size_builder/tree/main/example/sliver_app_bar)

A sliver app bar with dynamic sizing of flexible space and bottom.

Notice:
- We nest 2 IntrinsicSizeBuilder's in this case, to get both flexibleSpace height and bottom height.

# [images](https://github.com/MartinSellergren/intrinsic_size_builder/tree/main/example/images)

Put images in a SliverAppBar of dynamic, varying sizes.

Notice:
- We manually call Image.network().resolve() to be able to add a status listener.
- When the image is loaded we need to call IntrinsicSizeBuilder.refresh(context), so that the IntrinsicSizeBuilder detects the new size of the widget. This is necessary since the loading and loaded heights differ.
- This examples also illustrate the use of the `firstFrameWidget` parameter. This is a visual optimization. In this (forced) case you can see a red (unwanted) background for 1 frame, just after launch, if you do not set `firstFrameWidget`. The `firstFrameWidget` is set to the LoadingBody with same key as the *real* LoadingBody, resulting in, the LoadingBody is displayed 1 extra frame, and the transition from LoadingBody to LoadedBody happens without the 1-frame red glitch.
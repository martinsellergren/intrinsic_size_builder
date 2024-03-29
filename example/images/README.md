# images

Put images in a SliverAppBar of dynamic, varying sizes.

Notice:
- We manually call Image.network().resolve() to be able to add a status listener.
- When the image is loaded we need to call IntrinsicSizeBuilder.refresh(context), so that the IntrinsicSizeBuilder detects the new size of the widget. This is necessary since the loading and loaded heights differ.
- This examples also illustrate the use of the `firstFrameWidget` parameter. This is a visual optimization. In this (forced) case you can see a red (unwanted) background for 1 frame, just after launch, if you do not set `firstFrameWidget`. The `firstFrameWidget` is set to the LoadingBody with same key as the *real* LoadingBody, resulting in, the LoadingBody is displayed 1 extra frame, and the transition from LoadingBody to LoadedBody happens without the 1-frame red glitch.
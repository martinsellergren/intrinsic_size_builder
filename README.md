Finds the intrinsic size of a widget and provides it in a convenient builder.

# Background

This is a small but very useful package for those cases when you need to know the intrinsic size of some widget, prior to adding it in the widget tree.

**_What is intrinsic size?_**
It's the size a widget gets when it can determine its size itself. As opposed to the case where the parent restricts the sizing.
**_Note_**
You may allow the parent to restrict the size thought, through the  `constrainedAxis` parameter of IntrinsicSizeBuilder.

# Usage

One very good usage is when you want a SliverAppBar with dynamically sized flexible space/ bottom. Checkout the examples.

Trivial case:

```dart
IntrinsicSizeBuilder(
  subject: const Text(
    'Hello world',
    style: TextStyle(fontSize: 25),
  ),
  builder: (context, subjectSize, subject) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        subject,
        Text('The size of subject is $subjectSize'),
      ],
    ),
  ),
)
```

# How does it work?

Under the hood, the builder puts the `subject` (the widget which you need the size for) in the widget tree for just 1 frame with zero opacity, during which time the size is determined. After that the builder function is called, with the subject and its size, and the real widget is displayed.

**_Does this mean glitchy ui?_**
If you find the initial (transparent) 1 frame problematic, then use the `firstFrameWidget` parameter. You may for example prolong your loading screen 1 frame to completely eliminate any glitch. Illustrated in [this example](https://github.com/MartinSellergren/intrinsic_size_builder/tree/main/example/images).

**_What about when the subject changes size?_**
When the subject's intrinsic dimensions change you need to inform the IntrinsicSizeBuilder to redo the size evaluation. You do this simply by calling the static method `IntrinsicSizeBuilder.refresh(context)`. It will refresh all IntrinsicSizeBuilders above `context`. There's no 1 frame glitch in this case - the currently displayed widget is preserved during the 1-frame evaluation.

# Author

- [Martin Sellergren](https://github.com/MartinSellergren)
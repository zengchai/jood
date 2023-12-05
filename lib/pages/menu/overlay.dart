import 'package:flutter/material.dart';

extension OverlayExt on BuildContext {
  Future<T> showOverlayLoader<T>({
    required Future<T> Function() asyncFunction,
    Color opacityColor = Colors.black,
    Widget? loadingWidget,
    double opacity = .5,
  }) async {
    final navigatorState =
    Navigator.of(this, rootNavigator: false);
    final overlayState = navigatorState.overlay!;

    final overlayEntryOpacity = OverlayEntry(builder: (context) {
      return Opacity(
          opacity: opacity,
          child: Container(
            color: opacityColor,
          ));
    });
    final overlayEntryLoader = OverlayEntry(builder: (context) {
      return loadingWidget ??
          const Center(
              child: SizedBox(
                height: 90,
                width: 90,
                child: Text('Loading...'),
              ));
    });
    overlayState.insert(overlayEntryOpacity);
    overlayState.insert(overlayEntryLoader);

    T data;

    try {
      data = await asyncFunction();
    } on Exception catch (_) {
      overlayEntryLoader.remove();
      overlayEntryOpacity.remove();
      rethrow;
    }

    overlayEntryLoader.remove();
    overlayEntryOpacity.remove();
    return data;
  }
}

class OverlayLoadingIndicator extends StatelessWidget {
  const OverlayLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      child: Center(
        child: Container(
          height: 125,
          width: 120,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularProgressIndicator(),
              Text("Loading..."),
            ],
          ),
        ),
      ),
    );
  }
}
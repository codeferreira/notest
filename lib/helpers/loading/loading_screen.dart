import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notest/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textStream = StreamController<String>();
    textStream.add(text);

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return OverlayWidget(size: size, textStream: textStream);
      },
    );

    overlayState.insert(overlay);

    return LoadingScreenController(
      close: () {
        textStream.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textStream.add(text);
        return true;
      },
    );
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    }

    controller = showOverlay(context: context, text: text);
  }
}

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({
    super.key,
    required this.size,
    required this.textStream,
  });

  final Size size;
  final StreamController<String> textStream;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(150),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.8,
            maxHeight: size.height * 0.8,
            minWidth: size.width * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: textStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data as String,
                          textAlign: TextAlign.center,
                        );
                      }

                      return Container();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Widget child;
  final LoadingIndicatorType indicatorType;
  final Color? spinnerColor;
  final ValueNotifier<LoadingStatus> loadingStatusNotifier;

  const LoadingIndicator({
    super.key,
    required this.child,
    this.indicatorType = LoadingIndicatorType.Overlay,
    this.spinnerColor,
    required this.loadingStatusNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoadingStatus>(
      valueListenable: loadingStatusNotifier,
      child: child,
      builder: (_, LoadingStatus value, Widget? builderChild) {
        Widget content;

        switch (indicatorType) {
          // Overlay...
          case LoadingIndicatorType.Overlay:
            List<Widget> children = [builderChild ?? Container()];

            if (value == LoadingStatus.Show) {
              children.add(loadingIndicator());
            }

            content = Stack(children: children);
            break;

          // Normal spinner...
          case LoadingIndicatorType.Spinner:
            content = value == LoadingStatus.Show
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator.adaptive()))
                : (builderChild ?? Container());
            break;
        }

        return content;
      },
    );
  }

  // Loading Indicator...
  Widget loadingIndicator() {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black54,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

//------ Loading Status Notifier ----//
class LoadingIndicatorNotifier extends ChangeNotifier {
  final ValueNotifier<LoadingStatus> _loadingStatus =
      ValueNotifier<LoadingStatus>(LoadingStatus.Hide);

  ValueNotifier<LoadingStatus> get statusNotifier => _loadingStatus;

  void show() {
    _loadingStatus.value = LoadingStatus.Show;
    notifyListeners();
  }

  void hide() {
    _loadingStatus.value = LoadingStatus.Hide;
    notifyListeners();
  }

  void disposeNotifier() {
    _loadingStatus.dispose();
  }
}

// Loading Status...
enum LoadingStatus {
  Show,
  Hide,
}

enum LoadingIndicatorType {
  Overlay,
  Spinner,
}

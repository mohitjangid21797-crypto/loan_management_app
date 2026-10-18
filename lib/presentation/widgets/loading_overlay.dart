import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';

/// Shows [child], and while [loading] dims it and blocks taps behind a
/// progress indicator.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({required this.loading, required this.child, super.key});

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: context.l10n.splashLoading,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

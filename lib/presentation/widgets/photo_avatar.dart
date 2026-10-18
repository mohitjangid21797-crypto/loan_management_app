import 'dart:io';

import 'package:flutter/material.dart';

/// A round photo from a file path, or [placeholder] when there is none.
/// Tappable when [onTap] is set; [semanticLabel] then describes the action.
class PhotoAvatar extends StatelessWidget {
  const PhotoAvatar({
    required this.path,
    required this.placeholder,
    this.onTap,
    this.semanticLabel,
    this.radius = 56,
    super.key,
  });

  final String? path;
  final Widget placeholder;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final filePath = path;
    final file = filePath != null && File(filePath).existsSync()
        ? File(filePath)
        : null;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: file == null ? null : FileImage(file),
      child: file == null ? placeholder : null,
    );
    if (onTap == null) {
      return avatar;
    }
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(onTap: onTap, radius: radius, child: avatar),
    );
  }
}

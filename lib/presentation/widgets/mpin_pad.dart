import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';

/// Dot indicator plus a numeric keypad for entering an MPIN.
///
/// Calls [onCompleted] once [length] digits are entered. The parent decides
/// what happens next and calls [MpinPadState.clear] (via a [GlobalKey]) to
/// reset, optionally with a shake to signal an error.
class MpinPad extends StatefulWidget {
  const MpinPad({
    required this.length,
    required this.onCompleted,
    this.enabled = true,
    this.onBiometric,
    super.key,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final bool enabled;

  /// Shows a fingerprint key in the bottom-left slot when set.
  final VoidCallback? onBiometric;

  @override
  State<MpinPad> createState() => MpinPadState();
}

class MpinPadState extends State<MpinPad>
    with SingleTickerProviderStateMixin {
  static const double _keySize = 72;

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  String _digits = '';

  @override
  void didUpdateWidget(MpinPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _digits = '';
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  /// Empties the entry. With [shake], the dots wobble to show an error.
  void clear({bool shake = false}) {
    setState(() => _digits = '');
    if (shake) {
      _shake.forward(from: 0);
    }
  }

  void _press(String digit) {
    if (!widget.enabled || _digits.length >= widget.length) {
      return;
    }
    setState(() => _digits += digit);
    if (_digits.length == widget.length) {
      widget.onCompleted(_digits);
    }
  }

  void _backspace() {
    if (!widget.enabled || _digits.isEmpty) {
      return;
    }
    setState(() => _digits = _digits.substring(0, _digits.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: l10n.mpinDigitsEntered(_digits.length, widget.length),
            excludeSemantics: true,
            child: AnimatedBuilder(
              animation: _shake,
              builder: (context, child) {
                final t = _shake.value;
                final dx = math.sin(t * math.pi * 6) * 14 * (1 - t);
                return Transform.translate(offset: Offset(dx, 0), child: child);
              },
              child: _Dots(filled: _digits.length, total: widget.length),
            ),
          ),
          const SizedBox(height: 32),
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [for (final d in row) _digitKey(d)],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.onBiometric == null
                  ? const SizedBox(width: _keySize, height: _keySize)
                  : _iconKey(
                      icon: Icons.fingerprint,
                      label: l10n.mpinUseBiometric,
                      onPressed: widget.onBiometric,
                    ),
              _digitKey('0'),
              _iconKey(
                icon: Icons.backspace_outlined,
                label: l10n.mpinBackspace,
                onPressed: widget.enabled ? _backspace : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _digitKey(String digit) {
    return SizedBox(
      width: _keySize,
      height: _keySize,
      child: FilledButton.tonal(
        onPressed: widget.enabled ? () => _press(digit) : null,
        style: FilledButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Text(digit, style: context.textStyles.headlineSmall),
      ),
    );
  }

  Widget _iconKey({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: _keySize,
      height: _keySize,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: IconButton(
          onPressed: onPressed,
          iconSize: 28,
          icon: Icon(icon),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < total; i++)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? colors.primary : Colors.transparent,
              border: Border.all(color: colors.primary, width: 2),
            ),
          ),
      ],
    );
  }
}

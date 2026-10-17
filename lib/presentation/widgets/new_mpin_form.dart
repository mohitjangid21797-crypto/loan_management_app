import 'package:flutter/material.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/widgets/mpin_pad.dart';

/// Asks for a new MPIN twice (4 or 6 digits) and hands it to [onSubmit].
///
/// [onSubmit] returns a failure to show, or null when it worked.
class NewMpinForm extends StatefulWidget {
  const NewMpinForm({required this.onSubmit, super.key});

  final Future<Failure?> Function(String mpin) onSubmit;

  @override
  State<NewMpinForm> createState() => _NewMpinFormState();
}

class _NewMpinFormState extends State<NewMpinForm> {
  final _padKey = GlobalKey<MpinPadState>();
  int _length = AppConstants.mpinMinLength;
  String? _first;
  String? _error;
  bool _busy = false;

  Future<void> _onCompleted(String value) async {
    final first = _first;
    if (first == null) {
      _padKey.currentState?.clear();
      setState(() {
        _first = value;
        _error = null;
      });
      return;
    }
    if (first != value) {
      _padKey.currentState?.clear(shake: true);
      setState(() {
        _first = null;
        _error = context.l10n.mpinMismatch;
      });
      return;
    }
    setState(() => _busy = true);
    final failure = await widget.onSubmit(value);
    if (!mounted || failure == null) {
      return;
    }
    _padKey.currentState?.clear(shake: true);
    setState(() {
      _busy = false;
      _first = null;
      _error = failure.message(context.l10n);
    });
  }

  void _setLength(int length) {
    setState(() {
      _length = length;
      _first = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final confirming = _first != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Text(
              confirming ? l10n.mpinConfirmPrompt : l10n.mpinEnterPrompt,
              style: context.textStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 4, label: Text(l10n.mpinFourDigits)),
                ButtonSegment(value: 6, label: Text(l10n.mpinSixDigits)),
              ],
              selected: {_length},
              onSelectionChanged:
                  confirming || _busy ? null : (s) => _setLength(s.first),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 24,
              child: _error == null
                  ? null
                  : Text(
                      _error!,
                      style: TextStyle(color: context.colors.error),
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(height: 16),
            MpinPad(
              key: _padKey,
              length: _length,
              enabled: !_busy,
              onCompleted: _onCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/core/utils/currency_formatter.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/core/utils/emi_calculator.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';
import 'package:loan_management_app/presentation/providers/loan_provider.dart';
import 'package:loan_management_app/presentation/widgets/emi_preview_card.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/loading_overlay.dart';

/// Create a loan. [customerId] pre-selects the customer.
class LoanFormScreen extends ConsumerStatefulWidget {
  const LoanFormScreen({this.customerId, super.key});

  final String? customerId;

  @override
  ConsumerState<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends ConsumerState<LoanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _rate = TextEditingController();
  final _tenure = TextEditingController();
  String? _customerId;
  LoanType _type = LoanType.compound;
  DateTime _startDate = AppDateUtils.today();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _customerId = widget.customerId;
  }

  @override
  void dispose() {
    _amount.dispose();
    _rate.dispose();
    _tenure.dispose();
    super.dispose();
  }

  int? get _amountPaise => CurrencyFormatter.tryParseToPaise(_amount.text);
  double? get _ratePercent => double.tryParse(_rate.text.trim());
  int? get _tenureMonths => int.tryParse(_tenure.text.trim());

  /// The planned schedule, or null while the inputs are not valid yet.
  List<Installment>? _preview() {
    final amount = _amountPaise;
    final rate = _ratePercent;
    final months = _tenureMonths;
    if (Validators.amountPaise(amount) != null ||
        Validators.ratePercent(rate) != null ||
        Validators.tenureMonths(months) != null) {
      return null;
    }
    return EmiCalculator.generateSchedule(
      principalPaise: amount!,
      annualRatePercent: rate!,
      tenureMonths: months!,
      startDate: _startDate,
      type: _type,
    );
  }

  Future<void> _pickDate() async {
    final today = AppDateUtils.today();
    final picked = await showDatePicker(
      context: context,
      helpText: context.l10n.loanStartDateLabel,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year + 10, today.month, today.day),
    );
    if (picked != null) {
      setState(() => _startDate = AppDateUtils.utcMidnight(picked));
    }
  }

  Future<void> _save() async {
    final customerId = _customerId;
    if (customerId == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    final result = await ref.read(createLoanProvider)(
      customerId: customerId,
      principalPaise: _amountPaise ?? 0,
      annualRatePercent: _ratePercent ?? -1,
      tenureMonths: _tenureMonths ?? 0,
      type: _type,
      startDate: _startDate,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final failure = result.failureOrNull;
    if (failure != null) {
      context.showSnack(failure.message(context.l10n));
      return;
    }
    context.showSnack(context.l10n.loanCreated);
    await context.pushReplacement(
      RouteNames.loanDetailPath(result.valueOrNull!.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customers = ref.watch(customerPickerProvider);
    final preview = _preview();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loanAddTitle)),
      body: customers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorDatabase,
          onRetry: () => ref.invalidate(customerPickerProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              message: l10n.loanNoCustomers,
            );
          }
          return LoadingOverlay(
            loading: _saving,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: list.any((c) => c.id == _customerId)
                          ? _customerId
                          : null,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.loanCustomerLabel,
                      ),
                      items: [
                        for (final customer in list)
                          DropdownMenuItem(
                            value: customer.id,
                            child: Text(
                              '${customer.name} · ${customer.mobile}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() => _customerId = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amount,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.loanAmountLabel,
                        prefixText: '${AppConstants.currencySymbol} ',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (_) =>
                          Validators.amountPaise(_amountPaise)?.message(l10n),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _rate,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.loanRateLabel,
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (_) =>
                          Validators.ratePercent(_ratePercent)?.message(l10n),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tenure,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: l10n.loanTenureLabel,
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (_) =>
                          Validators.tenureMonths(_tenureMonths)?.message(l10n),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loanTypeLabel,
                      style: context.textStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<LoanType>(
                      segments: [
                        ButtonSegment(
                          value: LoanType.simple,
                          label: Text(l10n.loanTypeSimple),
                        ),
                        ButtonSegment(
                          value: LoanType.compound,
                          label: Text(l10n.loanTypeCompound),
                        ),
                      ],
                      selected: {_type},
                      onSelectionChanged: (selection) =>
                          setState(() => _type = selection.first),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event),
                      title: Text(l10n.loanStartDateLabel),
                      subtitle: Text(context.formatDate(_startDate)),
                      onTap: _pickDate,
                    ),
                    if (preview != null) EmiPreviewCard(schedule: preview),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _saving || _customerId == null
                            ? null
                            : _save,
                        child: Text(l10n.loanCreate),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

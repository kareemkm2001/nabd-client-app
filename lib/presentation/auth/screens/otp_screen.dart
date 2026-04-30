import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localization.dart';
import '../../home/screens/home_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  static const int _otpLength = 4;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<AnimationController> _scaleControllers;
  String? _inlineError;
  bool _isApplyingOtp = false;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      _otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(_otpLength, (_) => FocusNode());
    for (final node in _focusNodes) {
      node.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
    _scaleControllers = List<AnimationController>.generate(
      _otpLength,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
        lowerBound: 0,
        upperBound: 1,
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (final controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _currentCode(BuildContext context) {
    return context.read<AuthCubit>().composeOtp(
          _controllers.map((c) => c.text).toList(growable: false),
        );
  }

  Future<void> _verify() async {
    final code = _currentCode(context);
    await context.read<AuthCubit>().verifyOtp(code);
  }

  Future<void> _animateField(int index) async {
    final controller = _scaleControllers[index];
    await controller.forward();
    if (!mounted) return;
    await controller.reverse();
  }

  void _focusField(int index) {
    if (index < 0 || index >= _otpLength) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNodes[index].requestFocus();
    });
  }

  void _setDigitsFromPaste(String input) {
    _isApplyingOtp = true;
    final cubit = context.read<AuthCubit>();
    final digits = cubit.splitOtpDigits(input, length: _otpLength);

    for (var i = 0; i < _otpLength; i++) {
      _controllers[i].text = digits[i];
      if (digits[i].isNotEmpty) {
        _animateField(i);
      }
    }

    final lastFilled = digits.lastIndexWhere((digit) => digit.isNotEmpty);
    if (lastFilled == _otpLength - 1) {
      _isApplyingOtp = false;
      _focusNodes.last.unfocus();
      _verify();
      return;
    }
    _isApplyingOtp = false;
    _focusField((lastFilled + 1).clamp(0, _otpLength - 1));
  }

  void _onChanged(int index, String value) {
    if (_isApplyingOtp) {
      return;
    }

    final cubit = context.read<AuthCubit>();
    final sanitized = cubit.sanitizeOtpInput(value);

    if (_inlineError != null) {
      setState(() {
        _inlineError = null;
      });
    }

    if (sanitized.length > 1) {
      _setDigitsFromPaste(sanitized);
      return;
    }

    final digit = sanitized.isEmpty ? '' : sanitized[0];
    if (_controllers[index].text != digit) {
      _isApplyingOtp = true;
      _controllers[index].value = TextEditingValue(
        text: digit,
        selection: TextSelection.collapsed(offset: digit.length),
      );
      _isApplyingOtp = false;
    }

    if (digit.isNotEmpty) {
      _animateField(index);
      if (index < _otpLength - 1) {
        _focusField(index + 1);
      } else {
        _focusNodes[index].unfocus();
        _verify();
      }
    }
  }

  KeyEventResult _onKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusField(index - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _buildOtpField({
    required BuildContext context,
    required int index,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _scaleControllers[index],
      builder: (context, child) {
        final scale = Tween<double>(
          begin: 1,
          end: 1.08,
        ).transform(_scaleControllers[index].value);
        final isFocused = _focusNodes[index].hasFocus;
        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isFocused ? colorScheme.primary : colorScheme.outlineVariant,
                width: isFocused ? 1.8 : 1.2,
              ),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
            ),
            child: child,
          ),
        );
      },
      child: Focus(
        focusNode: _focusNodes[index],
        onKeyEvent: (_, event) => _onKeyEvent(index, event),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          autofocus: index == 0,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction:
              index == _otpLength - 1 ? TextInputAction.done : TextInputAction.next,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          maxLength: 1,
          onChanged: (value) => _onChanged(index, value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthVerified) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder<void>(
              pageBuilder: (_, __, ___) => HomeScreen(),
              transitionsBuilder: (_, animation, __, page) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: page,
                ),
              ),
            ),
            (_) => false,
          );
        }

        if (state is AuthCodeSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalization.t('code_resent'))),
          );
        }

        setState(() {
          _inlineError = state.errorMessage;
        });
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isSubmitting = state is AuthLoading;

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalization.t('otp_verification')),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalization.t('otp_sent_to'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.phoneNumber,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: List<Widget>.generate(_otpLength, (index) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: index == _otpLength - 1 ? 0 : 10,
                            ),
                            child: _buildOtpField(
                              context: context,
                              index: index,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (_inlineError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _inlineError!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isSubmitting ? null : _verify,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(AppLocalization.t('confirm')),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            for (final c in _controllers) {
                              c.clear();
                            }
                            _focusField(0);
                            await context.read<AuthCubit>().resendOtp();
                          },
                    child: Text(AppLocalization.t('resend_code')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

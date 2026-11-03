import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'input_box.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefix,
    this.isPassword = false,
    this.showCheck = false,
    this.showCheckSpace = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;

  final String label;
  final String? hint;
  final Widget? prefix;
  final bool isPassword;
  final bool showCheck;
  final bool showCheckSpace;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with WidgetsBindingObserver {
  final focusNode = FocusNode();
  bool hidePassword = true;
  Timer? timer;
  double? scrollBeforeFocus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(onFocusChange);
    widget.controller.addListener(refresh);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(refresh);
    timer?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void refresh() => setState(() {});

  void onFocusChange() {
    refresh();
    if (focusNode.hasFocus) {
      scrollBeforeFocus = Scrollable.maybeOf(context)?.position.pixels;
      scrollLater();
    }
  }

  @override
  void didChangeMetrics() {
    if (focusNode.hasFocus) scrollLater();
  }

  void scrollLater() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 150), scrollAboveKeyboard);
  }

  // scrolls so the field ends 5px above the keyboard, flutter's own scroll
  // to the cursor leaves a bigger gap so it is corrected here
  void scrollAboveKeyboard() {
    if (!mounted || !focusNode.hasFocus) return;

    final scrollable = Scrollable.maybeOf(context);
    final box = context.findRenderObject();
    if (scrollable == null || box == null) return;
    final viewport = RenderAbstractViewport.maybeOf(box);
    if (viewport == null) return;

    final position = scrollable.position;
    final needed = viewport.getOffsetToReveal(box, 1).offset + 5;
    final target = min(
      max(needed, scrollBeforeFocus ?? position.pixels),
      position.maxScrollExtent,
    );

    if ((target - position.pixels).abs() > 0.5) {
      position.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrefix = widget.prefix != null;
    final isUp = focusNode.hasFocus || widget.controller.text.isNotEmpty;

    // the phone fields are laid out slightly differently in the design
    final labelTop = hasPrefix ? 7.0 : (widget.isPassword ? 11.0 : 10.0);
    final valueTop = hasPrefix ? 22.75 : 25.0;
    final valueHeight = hasPrefix ? 22.0 : 20.0;

    return GestureDetector(
      onTap: focusNode.requestFocus,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 50,
        child: InputBox(
          child: Row(
            children: [
              const SizedBox(width: 10),
              ?widget.prefix,
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 150),
                        top: isUp ? labelTop : 15,
                        left: 0,
                        right: 0,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: isUp ? AppText.label : AppText.hint,
                          child: Text(
                            isUp ? widget.label : (widget.hint ?? widget.label),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Positioned(
                        top: valueTop,
                        left: 0,
                        right: 0,
                        height: valueHeight,
                        child: TextField(
                          controller: widget.controller,
                          focusNode: focusNode,
                          obscureText: widget.isPassword && hidePassword,
                          keyboardType: widget.keyboardType,
                          textCapitalization: widget.textCapitalization,
                          textInputAction: widget.textInputAction,
                          inputFormatters: widget.inputFormatters,
                          onChanged: widget.onChanged,
                          style: AppText.value,
                          cursorColor: AppColors.brand,
                          scrollPadding: EdgeInsets.zero,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              rightIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget rightIcon() {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: () => setState(() => hidePassword = !hidePassword),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 7),
          child: SvgPicture.asset(
            'assets/icons/eye.svg',
            width: 24,
            height: 24,
            colorFilter: hidePassword
                ? null
                : const ColorFilter.mode(AppColors.brand, BlendMode.srcIn),
          ),
        ),
      );
    }

    if (widget.showCheckSpace) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 7),
        child: SizedBox(
          width: 24,
          height: 24,
          child: widget.showCheck
              ? Center(
                  child: SvgPicture.asset(
                    'assets/icons/check_badge.svg',
                    width: 18,
                    height: 18,
                  ),
                )
              : null,
        ),
      );
    }

    return const SizedBox(width: 10);
  }
}

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
    this.isValid,
    this.showCheckSpace = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
  });

  final TextEditingController controller;

  final String label;
  final String? hint;
  final Widget? prefix;
  final bool isPassword;
  final bool Function()? isValid;
  final bool showCheckSpace;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final focusNode = FocusNode();
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(refresh);
    widget.controller.addListener(refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    focusNode.dispose();
    super.dispose();
  }

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return _RevealWholeField(child: field());
  }

  Widget field() {
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
                        // fixed line height keeps the text in the same place
                        // when it shrinks to fit a narrow field
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: isUp ? 14 : 19.6,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 150),
                              style: isUp ? AppText.label : AppText.hint,
                              child: Text(
                                isUp
                                    ? widget.label
                                    : (widget.hint ?? widget.label),
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
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
                          style: AppText.value,
                          cursorColor: AppColors.brand,
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
          child: (widget.isValid?.call() ?? false)
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

// Flutter scrolls the caret into view and adds room for the selection handle,
// which puts the field about 34px above the keyboard. Replacing what it asks
// to reveal with the whole field plus 5px makes that one scroll land exactly
// 5px above the keyboard, so nothing has to correct it afterwards.
class _RevealWholeField extends SingleChildRenderObjectWidget {
  const _RevealWholeField({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderRevealWholeField();
}

class _RenderRevealWholeField extends RenderProxyBox {
  static const gapAboveKeyboard = 5.0;

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    super.showOnScreen(
      rect: Rect.fromLTRB(0, 0, size.width, size.height + gapAboveKeyboard),
      duration: duration,
      curve: curve,
    );
  }
}

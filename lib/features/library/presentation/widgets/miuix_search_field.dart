import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// Compose Miuix / KoWSU-style search bar (`SuperSearchBar.kt`) with 45dp
/// `surfaceContainerHigh` capsule, `Icons.search_rounded`, animated clear icon,
/// and horizontal slide-in plain-text Cancel action.
class MiuixSearchField extends StatefulWidget {
  const MiuixSearchField({
    super.key,
    required this.focusNode,
    required this.hintText,
    required this.query,
    required this.isExpanded,
    required this.cancelLabel,
    required this.onChanged,
    required this.onSubmitted,
    required this.onOpen,
    required this.onClear,
  });

  final FocusNode focusNode;
  final String hintText;
  final String query;
  final bool isExpanded;
  final String cancelLabel;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onOpen;
  final VoidCallback onClear;

  @override
  State<MiuixSearchField> createState() => _MiuixSearchFieldState();
}

class _MiuixSearchFieldState extends State<MiuixSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.query);

  @override
  void didUpdateWidget(covariant MiuixSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final miuix = MiuixTheme.of(context);
    final colors = miuix.colors;

    return SizedBox(
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!widget.isExpanded) {
                widget.onOpen();
              } else {
                widget.focusNode.requestFocus();
              }
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: colors.onSurfaceContainerHigh,
                    ),
                  ),
                  Expanded(
                    child: widget.isExpanded
                        ? Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: false,
                                fillColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                            child: TextField(
                              controller: _controller,
                              focusNode: widget.focusNode,
                              onChanged: widget.onChanged,
                              onSubmitted: widget.onSubmitted,
                              textInputAction: TextInputAction.search,
                              maxLines: 1,
                              cursorColor: colors.primary,
                              style: miuix.textStyles.main.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: colors.onSurface,
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                filled: false,
                                fillColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: widget.hintText,
                                hintStyle: miuix.textStyles.main.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: colors.onSurfaceContainerHigh
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          )
                        : MiuixText(
                            widget.hintText,
                            style: miuix.textStyles.main.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: colors.onSurfaceContainerHigh
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: widget.isExpanded && widget.query.isNotEmpty
                        ? GestureDetector(
                            key: const ValueKey('search_clear_btn'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _controller.clear();
                              widget.onChanged('');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, right: 14),
                              child: Icon(
                                Icons.cancel_rounded,
                                size: 18,
                                color: colors.onSurfaceVariantActions,
                              ),
                            ),
                          )
                        : const SizedBox(
                            key: ValueKey('search_no_clear'),
                            width: 14,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -1.0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
            );
          },
          child: widget.isExpanded
              ? GestureDetector(
                  key: const ValueKey('search_cancel'),
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onClear,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 4,
                      top: 8,
                      bottom: 8,
                    ),
                    child: MiuixText(
                      widget.cancelLabel,
                      style: miuix.textStyles.main.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: colors.primary,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('search_no_cancel')),
        ),
        ],
      ),
    );
  }
}

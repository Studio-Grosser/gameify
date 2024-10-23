import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/custom_checkbox.dart';
import 'package:gameify/widgets/score_display.dart';
import 'package:gap/gap.dart';

class HabitDisplay extends StatefulWidget {
  const HabitDisplay(
      {super.key,
      required this.habit,
      this.value,
      this.onTap,
      this.onDelete,
      this.onEdit,
      this.onReset,
      this.showCheckbox = true,
      this.showSelectionBorder = false});
  final Habit habit;
  final int? value;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onReset;
  final bool showCheckbox;
  final bool showSelectionBorder;

  @override
  State<HabitDisplay> createState() => _HabitDisplayState();
}

class _HabitDisplayState extends State<HabitDisplay>
    with SingleTickerProviderStateMixin {
  bool get showOptions => widget.onDelete != null || widget.onEdit != null;
  bool get isTappable => widget.onTap != null || widget.value != null;
  String get habitText => _controller.isForwardOrCompleted
      ? 'habit.options.reset'.tr()
      : widget.habit.name;

  late AnimationController _controller;
  late Animation<double> _animation;

  final Duration holdDuration = const Duration(milliseconds: 1500);
  final Duration reverseDuration = const Duration(milliseconds: 500);

  static const _defaultScale = 1.0;
  static const _animatedScale = 0.98;
  static const Duration _scaleDuration = Duration(milliseconds: 100);
  double _currentScale = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: holdDuration,
      reverseDuration: reverseDuration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
        reverseCurve: Curves.easeInOut));
  }

  void startAnimation() {
    if (widget.onReset != null && (widget.value ?? 0) > 0) {
      _controller.forward().whenComplete(() {
        HapticFeedback.mediumImpact();
        HapticFeedback.lightImpact();
        widget.onReset!();
        _controller.reverse();
      });
    }
  }

  void endAnimation() {
    if (widget.onReset != null) _controller.reverse();
  }

  void onTap() async {
    if (widget.onTap != null) {
      setState(() {
        _currentScale = _animatedScale;
      });
      HapticFeedback.lightImpact();
      widget.onTap!();
      await Future.delayed(_scaleDuration);
      setState(() {
        _currentScale = _defaultScale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: AnimatedScale(
        scale: _currentScale,
        duration: _scaleDuration,
        curve: Curves.easeInOut,
        child: Opacity(
          opacity: widget.habit.isActive ? 1 : 0.75,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Slidable(
              enabled: showOptions,
              key: UniqueKey(),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => widget.onEdit!(),
                    backgroundColor: Themes.accent,
                    foregroundColor: Themes.shade1,
                    label: 'habit.options.edit'.tr(),
                    icon: CupertinoIcons.square_pencil,
                  ),
                  SlidableAction(
                    onPressed: (_) => widget.onDelete!(),
                    backgroundColor: Themes.danger,
                    foregroundColor: Themes.shade1,
                    label: 'habit.options.delete'.tr(),
                    icon: CupertinoIcons.trash,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: onTap,
                onLongPress: startAnimation,
                onLongPressUp: endAnimation,
                child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        height: 66,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: widget.showSelectionBorder
                                ? BorderRadius.circular(15)
                                : null,
                            border: widget.showSelectionBorder
                                ? Border.all(width: 2, color: Themes.accent)
                                : null,
                            gradient: LinearGradient(stops: [
                              0,
                              _animation.value,
                              _animation.value
                            ], colors: [
                              Themes.accent,
                              Themes.accent,
                              theme.colorScheme.primaryContainer,
                            ])),
                        child: Row(
                          children: [
                            if (isTappable && widget.showCheckbox) ...[
                              if (_controller.isForwardOrCompleted) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Icon(
                                    CupertinoIcons.arrow_counterclockwise,
                                    color: Themes.shade2,
                                  ),
                                ),
                              ] else ...[
                                CustomCheckbox(
                                    onTap: () => widget.onTap!(),
                                    mode: widget.habit.mode,
                                    value: widget.value),
                              ]
                            ],
                            const Gap(10),
                            Expanded(
                                child: Text(habitText,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: _controller.isAnimating
                                            ? Themes.shade2
                                            : theme
                                                .textTheme.bodyMedium?.color),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1)),
                            ScoreDisplay(value: widget.habit.score),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

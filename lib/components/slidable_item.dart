import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableItem extends StatelessWidget {
  const SlidableItem({
    required this.child,
    this.startSlidableAction,
    this.endSlidableAction,
    this.enabled = true,
    this.borderRadius,
    super.key,
  });
  final Widget child;
  final SlidableAction? startSlidableAction;
  final SlidableAction? endSlidableAction;
  final bool enabled;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final startAction = startSlidableAction;
    final endAction = endSlidableAction;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (startAction != null)
                  Expanded(
                    child: SizedBox.expand(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: startAction.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                if (endAction != null)
                  Expanded(
                    child: SizedBox.expand(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: endAction.backgroundColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Slidable(
            enabled: enabled,
            key: UniqueKey(),
            startActionPane: startAction == null
                ? null
                : ActionPane(
                    dismissible: DismissiblePane(
                        closeOnCancel: true,
                        onDismissed: () {
                          startAction.onPressed?.call(context);
                        }),
                    extentRatio: 0.2,
                    motion: const BehindMotion(),
                    children: [startAction],
                  ),
            endActionPane: endAction == null
                ? null
                : ActionPane(
                    dismissible: DismissiblePane(
                        closeOnCancel: true,
                        onDismissed: () {
                          endAction.onPressed?.call(context);
                        }),
                    extentRatio: 0.2,
                    motion: const BehindMotion(),
                    children: [endAction],
                  ),
            child: Builder(
              builder: (context) {
                final controller = Slidable.of(context);
                return ValueListenableBuilder<int>(
                  valueListenable:
                      controller?.direction ?? ValueNotifier<int>(0),
                  builder: (context, value, _) {
                    return child;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

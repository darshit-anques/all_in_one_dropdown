import 'package:flutter/material.dart';

/// A reusable ListView widget with built-in support for separators,
/// scroll direction, padding, controller, and more.
///
/// Can be used across your app to reduce repetitive `ListView.separated` setup.
class CommonListViewWidget extends StatelessWidget {
  /// Number of items to display in the list.
  final int? itemCount;

  /// Builder function for each item.
  final Widget? Function(BuildContext, int) itemBuilder;

  /// Scroll physics for the list (e.g., `BouncingScrollPhysics`, `NeverScrollableScrollPhysics`).
  final ScrollPhysics? physics;

  /// Scroll direction (`Axis.vertical` or `Axis.horizontal`).
  final Axis? scrollDirection;

  /// Builder for separators between items. Defaults to an empty `SizedBox`.
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Whether the list scrolls in reverse order.
  final bool? reverse;

  /// Optional scroll controller for the list.
  final ScrollController? controller;

  /// Creates a [CommonListViewWidget].
  const CommonListViewWidget({
    super.key,
    this.itemCount,
    required this.itemBuilder,
    this.physics,
    this.scrollDirection,
    this.separatorBuilder,
    this.padding,
    this.reverse,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      controller: controller,
      padding: padding ?? EdgeInsets.zero,
      scrollDirection: scrollDirection ?? Axis.vertical,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: itemCount ?? 0,
      cacheExtent: 999999999999999,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder ?? (context, index) => const SizedBox(),
      reverse: reverse ?? false,
    );
  }
}

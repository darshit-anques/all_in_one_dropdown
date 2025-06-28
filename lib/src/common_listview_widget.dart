import 'package:flutter/material.dart';

class CommonListViewWidget extends StatelessWidget {
  final int? itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  final ScrollPhysics? physics;
  final Axis? scrollDirection;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final bool? reverse;
  final ScrollController? controller;

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
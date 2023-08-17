import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_moviles/components/detail/widgets/animated_detail_header.dart';
import 'package:project_moviles/components/detail/widgets/place_comments_widget.dart';
import 'package:project_moviles/extensions/text_theme_x.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/event.dart';
import '../../models/place.dart';
import '../events/translate_animation.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({
    super.key,
    required this.event,
    required this.screenHeight,
  });

  final Event event;
  final double screenHeight;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late ScrollController _controller;
  late ValueNotifier<double> bottomPercentNotifier;
  bool _isAnimatingScroll = false;

  void _scrollListener() {
    final percent =
        _controller.position.pixels / MediaQuery.of(context).size.height;
    bottomPercentNotifier.value = (percent / .3).clamp(0.0, 1.0);
  }

  void _isScrollingListener() {
    final percent = _controller.position.pixels / widget.screenHeight;
    if (!_controller.position.isScrollingNotifier.value) {
      if (percent < .3 && percent > .1) {
        setState(() => _isAnimatingScroll = true);
        _controller
            .animateTo(
              widget.screenHeight * .3,
              duration: kThemeAnimationDuration,
              curve: Curves.decelerate,
            )
            .then((value) => setState(() => _isAnimatingScroll = false));
      }
      if (percent < .1 && percent > 0) {
        setState(() => _isAnimatingScroll = true);
        _controller
            .animateTo(
              0,
              duration: kThemeAnimationDuration,
              curve: Curves.decelerate,
            )
            .then((value) => setState(() => _isAnimatingScroll = false));
      }
      if (percent < .6 && percent > .3) {
        setState(() => _isAnimatingScroll = true);
        _controller
            .animateTo(
              widget.screenHeight * .3,
              duration: kThemeAnimationDuration,
              curve: Curves.decelerate,
            )
            .then((value) => setState(() => _isAnimatingScroll = false));
      }
    }
  }

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: widget.screenHeight * .3);
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.position.isScrollingNotifier
          .addListener(_isScrollingListener);
    });
    bottomPercentNotifier = ValueNotifier(1);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _isAnimatingScroll,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
                  delegate: BuilderPersistentDelegate(
                    maxExtent: MediaQuery.of(context).size.height,
                    minExtent: 240,
                    builder: (percent) {
                      final bottomPercent = (percent / .3).clamp(0.0, 1.0);
                      return AnimatedDetailHeader(
                        topPercent: ((1 - percent) / .7).clamp(0.0, 1.0),
                        bottomPercent: bottomPercent,
                        event: widget.event
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: TranslateAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.black26,
                              ),
                              Flexible(
                                child: Text(
                                  widget.event.address,
                                  style: context.bodyText1
                                      .copyWith(color: Colors.blue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(widget.event.description),
                          const SizedBox(height: 10),
                          Text(widget.event.description),
                          const SizedBox(height: 10),
                          Text(widget.event.description),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 150))
              ],
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: bottomPercentNotifier,
            builder: (context, value, child) {
              return Positioned.fill(
                top: null,
                bottom: -130 * (1 - value),
                child: child!,
              );
            },
            child: const PlaceCommentsWidget(),
          )
        ],
      ),
    );
  }
}

class BuilderPersistentDelegate extends SliverPersistentHeaderDelegate {
  BuilderPersistentDelegate({
    required double maxExtent,
    required double minExtent,
    required this.builder,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent;

  final double _maxExtent;
  final double _minExtent;
  final Widget Function(double percent) builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(shrinkOffset / _maxExtent);
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

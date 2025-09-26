import 'package:flutter/material.dart';

/// Simple reveal for a single widget: slide + fade + optional scale.
class ContentReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset beginOffset;
  final double beginScale;
  final bool animateOnce; // set true to avoid re-triggering on rebuild

  const ContentReveal({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 0.04),
    this.beginScale = 0.99,
    this.animateOnce = true,
  }) : super(key: key);

  @override
  State<ContentReveal> createState() => _ContentRevealState();
}

class _ContentRevealState extends State<ContentReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(parent: _ctrl, curve: widget.curve);
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _slide = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero)
        .animate(curved);
    _scale = Tween<double>(begin: widget.beginScale, end: 1.0).animate(curved);

    if (widget.delay == Duration.zero) {
      _play();
    } else {
      Future.delayed(widget.delay, _play);
    }
  }

  void _play() {
    if (mounted && (!_played || !widget.animateOnce)) {
      _ctrl.forward(from: 0);
      _played = true;
    }
  }

  @override
  void didUpdateWidget(covariant ContentReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    // replay if animateOnce is false and widget updates
    if (!widget.animateOnce && mounted) {
      _play();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Reveal multiple children in a staggered way.
/// By default lays out children in a Column with crossAxisAlignment.start.
/// You can set `axis` and `wrap` strategies yourself by wrapping children as needed.
class StaggeredReveal extends StatefulWidget {
  final List<Widget> children;
  final Duration duration; // total duration for entire sequence
  final Duration initialDelay;
  final Curve curve;
  final double staggerFraction; // fraction of total per item overlap space (0..1)
  final Offset beginOffset;
  final double beginScale;
  final bool animateOnce;

  const StaggeredReveal({
    Key? key,
    required this.children,
    this.duration = const Duration(milliseconds: 700),
    this.initialDelay = Duration.zero,
    this.curve = Curves.easeOut,
    this.staggerFraction = 0.16,
    this.beginOffset = const Offset(0, 0.06),
    this.beginScale = 0.985,
    this.animateOnce = true,
  }) : super(key: key);

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    if (widget.initialDelay == Duration.zero) {
      _play();
    } else {
      Future.delayed(widget.initialDelay, _play);
    }
  }

  void _play() {
    if (mounted && (!_played || !widget.animateOnce)) {
      _ctrl.forward(from: 0);
      _played = true;
    }
  }

  @override
  void didUpdateWidget(covariant StaggeredReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.animateOnce && mounted) _play();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.children.length;
    if (count == 0) return const SizedBox.shrink();

    // compute interval length per item (clamped)
    double frac = widget.staggerFraction.clamp(0.01, 0.9);
    // Each item gets an interval of size itemSpan, starting offset increases by step
    final double step = frac; // how much of the timeline each new item shifts
    final double itemSpan = (1.0 - step) + step; // roughly 1.0; we map intervals manually

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(count, (i) {
        // start and end in [0,1]
        final double start = (i * step).clamp(0.0, 1.0);
        final double end = (start + (1.0 - (count - 1) * step)).clamp(start, 1.0);
        // if many items and step small, end may equal start; ensure minimal interval
        final double minLen = 0.12;
        final double endFixed = (end - start) < minLen ? (start + minLen).clamp(0.0, 1.0) : end;

        final anim = CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, endFixed, curve: widget.curve),
        );

        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(anim);
        final slide = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero)
            .animate(anim);
        final scale = Tween<double>(begin: widget.beginScale, end: 1.0).animate(anim);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: AnimatedBuilder(
              animation: scale,
              builder: (context, child) =>
                  Transform.scale(scale: scale.value, child: child),
              child: widget.children[i],
            ),
          ),
        );
      }),
    );
  }
}

class ParallaxFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset offset; // e.g. Offset(-0.2, 0) for left, Offset(0.2,0) for right

  const ParallaxFadeIn({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.offset = const Offset(-0.5, 0),
  }) : super(key: key);

  @override
  State<ParallaxFadeIn> createState() => _ParallaxFadeInState();
}

class _ParallaxFadeInState extends State<ParallaxFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(parent: _ctrl, curve: widget.curve);
    _fade  = Tween(begin: 0.0, end: 1.0).animate(curved);
    _slide = Tween(begin: widget.offset, end: Offset.zero).animate(curved);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}

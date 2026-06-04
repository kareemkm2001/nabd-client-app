import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomSpeedDial extends StatefulWidget {
  final ScrollController scrollController;
  final List<SpeedDialChild> children;
  final Color backgroundColor;

  const CustomSpeedDial({
    super.key,
    required this.scrollController,
    required this.children,
    required this.backgroundColor,
  });

  @override
  State<CustomSpeedDial> createState() => _CustomSpeedDialState();
}

class _CustomSpeedDialState extends State<CustomSpeedDial> {
  bool _visible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      final offset = widget.scrollController.offset;

      if (offset > _lastOffset + 5) {
        if (_visible) setState(() => _visible = false);
      } else if (offset < _lastOffset - 5) {
        if (!_visible) setState(() => _visible = true);
      }

      _lastOffset = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: _visible ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _visible ? 1 : 0,
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,

          backgroundColor: widget.backgroundColor,
          foregroundColor: Colors.white,

          elevation: 8,
          shape: const CircleBorder(),

          direction: SpeedDialDirection.up,
          spaceBetweenChildren: 12,
          switchLabelPosition: true,

          overlayOpacity: 0.4,

          children: widget.children,
        ),
      ),
    );
  }
}
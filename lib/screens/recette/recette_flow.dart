import 'package:flutter/material.dart';
import 'recette.dart';
import 'recette_detail.dart';

class RecetteFlow extends StatefulWidget {
  final Function(String) onNavigate;

  const RecetteFlow({super.key, required this.onNavigate});

  @override
  State<RecetteFlow> createState() => _RecetteFlowState();
}

class _RecetteFlowState extends State<RecetteFlow> {
  String subPage = 'list';
  bool goingForward = true;

  void _navigateTo(String newSubPage, {bool forward = true}) {
    setState(() {
      goingForward = forward;
      subPage = newSubPage;
    });
  }

  Widget _buildSubScreen() {
    switch (subPage) {
      case 'detail':
        return RecetteDetail(
          key: const ValueKey('detail'),
          onNavigate: widget.onNavigate,
          onBack: () => _navigateTo('list', forward: false),
        );
      case 'list':
      default:
        return RecetteScreen(
          key: const ValueKey('list'),
          onNavigate: widget.onNavigate,
          onOpenDetail: () => _navigateTo('detail', forward: true),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final inSlide = Tween<Offset>(
            begin: Offset(goingForward ? 1 : -1, 0),
            end: Offset.zero,
          ).animate(animation);

          final outSlide = Tween<Offset>(
            begin: Offset.zero,
            end: Offset(goingForward ? -1 : 1, 0),
          ).animate(animation);

          return SlideTransition(
            position: animation.status == AnimationStatus.reverse
                ? outSlide
                : inSlide,
            child: child,
          );
        },
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: _buildSubScreen(),
      ),
    );
  }
}

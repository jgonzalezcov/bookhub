import 'package:bookhub/src/providers/view_state_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({super.key});

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  late Timer _animationTimer;
  double scale = 1.0; // Agrega una variable para la escala

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  _startAnimation() {
    setState(
      () {
        scale = 1.0;
      },
    );

    _animationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (!mounted) {
          return;
        }
        setState(
          () {
            scale += 0.1;
            if (scale > 1.5) {
              scale = 1.0;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(scale: scale);
  }
}

class AnimatedBackground extends StatelessWidget {
  final double scale;

  const AnimatedBackground({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    String title = Provider.of<ViewStateProvider>(context).topicSelect;
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      transform: Matrix4.diagonal3Values(scale, scale, 1.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imgs/$title.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

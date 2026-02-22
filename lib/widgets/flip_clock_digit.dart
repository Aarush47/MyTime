// ANIMATION & MOTION AGENT - Motion Designer
// Flip clock digit animation widget

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlipClockDigit extends StatefulWidget {
  final String value;
  final double size;

  const FlipClockDigit({
    super.key,
    required this.value,
    this.size = 80,
  });

  @override
  State<FlipClockDigit> createState() => _FlipClockDigitState();
}

class _FlipClockDigitState extends State<FlipClockDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _previousValue = '';
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlipClockDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _currentValue = widget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size * 1.4,
          child: Stack(
            children: [
              // Bottom half (static)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: _buildDigitCard(_currentValue, false),
                  ),
                ),
              ),
              
              // Top half (flipping)
              if (_animation.value < 0.5)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_animation.value * 3.14159),
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.5,
                        child: _buildDigitCard(_previousValue, true),
                      ),
                    ),
                  ),
                ),
              
              // New top half (flipping in)
              if (_animation.value >= 0.5)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.5,
                      child: _buildDigitCard(_currentValue, true),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDigitCard(String digit, bool isTop) {
    return Container(
      width: widget.size,
      height: widget.size * 1.4,
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          digit,
          style: GoogleFonts.openSans(
            fontSize: widget.size * 0.9,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

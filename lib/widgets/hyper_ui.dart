import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// --- Animated Background ---
class MorphicBackground extends StatefulWidget {
  const MorphicBackground({super.key});

  @override
  State<MorphicBackground> createState() => _MorphicBackgroundState();
}

class _MorphicBackgroundState extends State<MorphicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MorphicBackgroundPainter(animation: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _MorphicBackgroundPainter extends CustomPainter {
  final double animation;

  _MorphicBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base gradient
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF0F0F23),
        const Color(0xFF1A1A2E),
        const Color(0xFF16213E),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = baseGradient.createShader(rect));

    // Aurora waves
    for (int i = 0; i < 4; i++) {
      _drawAuroraWave(canvas, size, i, animation);
    }
  }

  void _drawAuroraWave(Canvas canvas, Size size, int index, double time) {
    final path = Path();
    final waveColors = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      [const Color(0xFFFF9800), const Color(0xFFFF5722)],
      [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
      [const Color(0xFFEC4899), const Color(0xFFDB2777)],
    ];

    final colors = waveColors[index % waveColors.length];
    final phase = time * 2 * math.pi + (index * math.pi / 2);
    final yOffset = size.height * (0.3 + index * 0.15);

    path.moveTo(0, yOffset);

    for (double x = 0; x <= size.width; x += 10) {
      final y =
          yOffset +
          math.sin((x / size.width * 2 * math.pi) + phase) * 50 +
          math.sin((x / size.width * 4 * math.pi) + phase * 1.5) * 30;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colors[0].withOpacity(0.15),
        colors[1].withOpacity(0.05),
        Colors.transparent,
      ],
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(Offset.zero & size)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
  }

  @override
  bool shouldRepaint(_MorphicBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

// --- Glass Container ---
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.1,
    this.color,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              border:
                  border ??
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              gradient:
                  gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(opacity + 0.05),
                      Colors.white.withOpacity(opacity),
                    ],
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// --- Glass Text Field ---
class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Function(String)? onChanged;

  const GlassTextField({
    super.key,
    this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: const Color(0xFFFF9800))
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

// --- Neon Button ---
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = const Color(0xFFFF9800),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }
}

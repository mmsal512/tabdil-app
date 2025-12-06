import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../models/currency.dart';
import 'admin_login_screen.dart';
import '../widgets/hyper_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Morphic Background
          const MorphicBackground(),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildGlassAppBar(),
                _buildStatusBar(),
                Expanded(child: _buildCurrencyList()),
                _buildGlassKeypad(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassAppBar() {
    return GlassContainer(
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: Border(
        bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo with Glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFFF9800,
                      ).withOpacity(0.3 + (_pulseController.value * 0.3)),
                      blurRadius: 20 + (_pulseController.value * 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  '💱 Tabdil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [Shadow(color: Color(0xFFFF9800), blurRadius: 10)],
                  ),
                ),
              );
            },
          ),

          // Action Buttons
          Row(
            children: [
              _buildGlassIconButton(
                icon: Icons.refresh,
                color: const Color(0xFFFF9800),
                onTap: () async {
                  final provider = Provider.of<CurrencyProvider>(
                    context,
                    listen: false,
                  );
                  final status = await provider.refreshRates();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: status.contains('✅')
                            ? const Color(0xFF22C55E) // Green
                            : status.contains('⚠️')
                            ? const Color(0xFFF59E0B) // Orange
                            : const Color(0xFF6366F1), // Purple
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
              _buildGlassIconButton(
                icon: Icons.settings,
                color: Colors.white70,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withOpacity(0.3),
                const Color(0xFF8B5CF6).withOpacity(0.2),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStatusIcon(provider.ratesSourceText),
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                provider.ratesSourceText,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              if (provider.lastUpdateText.isNotEmpty) ...[
                const SizedBox(width: 12),
                Text(
                  '|',
                  style: TextStyle(color: Colors.white.withOpacity(0.3)),
                ),
                const SizedBox(width: 12),
                Text(
                  provider.lastUpdateText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  IconData _getStatusIcon(String status) {
    if (status.contains('✅')) return Icons.cloud_done;
    if (status.contains('📦')) return Icons.inventory_2;
    if (status.contains('⚠️')) return Icons.warning_amber;
    return Icons.sync;
  }

  Widget _buildCurrencyList() {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF9800)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.currencies.length,
          itemBuilder: (context, index) {
            final currency = provider.currencies[index];
            final isSelected = provider.selectedCurrency?.code == currency.code;

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0, end: isSelected ? 1.0 : 0.0),
              builder: (context, value, child) {
                return _buildCurrencyCard(
                  currency: currency,
                  isSelected: isSelected,
                  selectionValue: value,
                  provider: provider,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCurrencyCard({
    required Currency currency,
    required bool isSelected,
    required double selectionValue,
    required CurrencyProvider provider,
  }) {
    final amount = provider.getCalculatedAmount(currency);

    return GestureDetector(
      onTap: () => provider.selectCurrency(currency),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          children: [
            // Glow Effect for Selected
            if (selectionValue > 0)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, _) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9800).withOpacity(
                              0.4 *
                                  selectionValue *
                                  (0.5 + _glowController.value * 0.5),
                            ),
                            blurRadius: 30 + (_glowController.value * 10),
                            spreadRadius: 5 * selectionValue,
                          ),
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(
                              0.3 *
                                  selectionValue *
                                  (0.5 + _glowController.value * 0.5),
                            ),
                            blurRadius: 40,
                            spreadRadius: 2,
                            offset: const Offset(-10, 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            // Glass Card
            GlassContainer(
              padding: const EdgeInsets.all(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [
                        const Color(0xFFFF9800).withOpacity(0.2),
                        const Color(0xFF6366F1).withOpacity(0.15),
                      ]
                    : [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
              ),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFF9800).withOpacity(0.5)
                    : Colors.white.withOpacity(0.15),
                width: isSelected ? 2 : 1,
              ),
              child: Row(
                children: [
                  // Flag with Glow
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF9800).withOpacity(0.4),
                                blurRadius: 15,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      currency.flag,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Currency Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currency.code,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: isSelected
                                ? [
                                    const Shadow(
                                      color: Color(0xFFFF9800),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        Text(
                          currency.name,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Text(
                    isSelected ? provider.inputAmount : amount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSelected ? 28 : 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: isSelected
                              ? const Color(0xFFFF9800)
                              : Colors.black,
                          blurRadius: isSelected ? 15 : 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', '⌫'],
    ];

    return GlassContainer(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.1), Colors.black.withOpacity(0.3)],
      ),
      border: Border(
        top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) => _buildKeypadButton(key)).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeypadButton(String value) {
    final isSpecial = value == 'C' || value == '⌫';

    return Consumer<CurrencyProvider>(
      builder: (context, provider, _) {
        return _PhotoReactiveButton(
          value: value,
          isSpecial: isSpecial,
          onTap: () => provider.onKeypadTap(value),
        );
      },
    );
  }
}

// Photo-reactive Button with Light Burst Effect
class _PhotoReactiveButton extends StatefulWidget {
  final String value;
  final bool isSpecial;
  final VoidCallback onTap;

  const _PhotoReactiveButton({
    required this.value,
    required this.isSpecial,
    required this.onTap,
  });

  @override
  State<_PhotoReactiveButton> createState() => _PhotoReactiveButtonState();
}

class _PhotoReactiveButtonState extends State<_PhotoReactiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _tapPosition = Offset.zero;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
      _isPressed = true;
    });
    _controller.forward(from: 0);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 75,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isSpecial
                    ? [
                        const Color(
                          0xFFFF9800,
                        ).withOpacity(_isPressed ? 0.4 : 0.2),
                        const Color(
                          0xFFFF5722,
                        ).withOpacity(_isPressed ? 0.3 : 0.1),
                      ]
                    : [
                        Colors.white.withOpacity(_isPressed ? 0.25 : 0.12),
                        Colors.white.withOpacity(_isPressed ? 0.15 : 0.05),
                      ],
              ),
              border: Border.all(
                color: widget.isSpecial
                    ? const Color(0xFFFF9800).withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                if (_isPressed || _controller.value > 0)
                  BoxShadow(
                    color:
                        (widget.isSpecial
                                ? const Color(0xFFFF9800)
                                : const Color(0xFF6366F1))
                            .withOpacity(0.5 * (1 - _controller.value)),
                    blurRadius: 20 + (_controller.value * 30),
                    spreadRadius: _controller.value * 10,
                  ),
              ],
            ),
            child: Stack(
              children: [
                // Light Ripple Effect
                if (_controller.value > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CustomPaint(
                      painter: RipplePainter(
                        center: _tapPosition,
                        progress: _controller.value,
                        color: widget.isSpecial
                            ? const Color(0xFFFF9800)
                            : Colors.white,
                      ),
                      size: const Size(75, 65),
                    ),
                  ),

                // Button Text
                Center(
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      color: widget.isSpecial
                          ? const Color(0xFFFF9800)
                          : Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color:
                              (widget.isSpecial
                                      ? const Color(0xFFFF9800)
                                      : Colors.white)
                                  .withOpacity(_isPressed ? 0.8 : 0.3),
                          blurRadius: _isPressed ? 15 : 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Ripple Painter for Light Burst Effect
class RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;
  final Color color;

  RipplePainter({
    required this.center,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    final currentRadius = maxRadius * progress;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.4 * (1 - progress)),
          color.withOpacity(0.1 * (1 - progress)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    canvas.drawCircle(center, currentRadius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

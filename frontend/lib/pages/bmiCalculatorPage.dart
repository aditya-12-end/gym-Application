import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Bmicalculatorpage extends StatefulWidget {
  const Bmicalculatorpage({super.key});

  @override
  State<Bmicalculatorpage> createState() => _BmicalculatorpageState();
}

class _BmicalculatorpageState extends State<Bmicalculatorpage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _result = '';
  String _bmiValue = '';
  bool _hasResult = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Needle angle for the gauge (–90° = leftmost, +90° = rightmost) ──
  double _needleAngle = -math.pi / 2; // starts at left

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _calcBMI() {
    FocusScope.of(context).unfocus();
    final double? w = double.tryParse(_weightController.text.trim());
    final double? h = double.tryParse(_heightController.text.trim());

    if (w == null || h == null || w <= 0 || h <= 0) {
      _showError("Please enter valid weight and height values.");
      return;
    }

    final double hMeters = h / 100;
    final double bmi = w / (hMeters * hMeters);

    String category;
    double angle; // –π/2 → left edge, +π/2 → right edge

    if (bmi < 18.5) {
      category = "Underweight";
      angle = -1.1;
    } else if (bmi < 25) {
      category = "Fit";
      angle = -0.35;
    } else if (bmi < 30) {
      category = "Overweight";
      angle = 0.35;
    } else {
      category = "Obese";
      angle = 1.1;
    }

    setState(() {
      _bmiValue = bmi.toStringAsFixed(1);
      _result = category;
      _hasResult = true;
      _needleAngle = angle;
    });

    _animController.forward(from: 0);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff2a1a1a),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _resultColor {
    switch (_result) {
      case "Underweight":
        return const Color(0xff60a5fa); // blue-400
      case "Fit":
        return const Color(0xff4ade80); // green-400
      case "Overweight":
        return const Color(0xfffbbf24); // amber-400
      case "Obese":
        return const Color(0xfff87171); // red-400
      default:
        return Colors.white54;
    }
  }

  String get _resultDescription {
    switch (_result) {
      case "Underweight":
        return "Consider increasing your caloric intake with nutrient-dense foods.";
      case "Fit":
        return "You're in a healthy range. Keep up your balanced lifestyle.";
      case "Overweight":
        return "Small lifestyle adjustments can bring you back to a healthy range.";
      case "Obese":
        return "Consult a healthcare professional for a personalised plan.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // ── Header ──────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.monitor_heart_rounded,
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "BMI Calculator",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          "Body Mass Index",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Input cards side by side ─────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: "Weight",
                        unit: "kg",
                        icon: Icons.fitness_center_rounded,
                        controller: _weightController,
                        hint: "70",
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MetricCard(
                        label: "Height",
                        unit: "cm",
                        icon: Icons.straighten_rounded,
                        controller: _heightController,
                        hint: "175",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ── Calculate button ─────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _calcBMI,
                    child: const Text(
                      "Calculate BMI",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ── Result card ──────────────────────────────────────────
                if (_hasResult)
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        children: [
                          // Gauge + number
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                            decoration: BoxDecoration(
                              color: const Color(0xff141414),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.07),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Semicircle gauge
                                SizedBox(
                                  height: 140,
                                  child: _BmiGauge(
                                    needleAngle: _needleAngle,
                                    resultColor: _resultColor,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // BMI number
                                Text(
                                  _bmiValue,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 64,
                                    fontWeight: FontWeight.w200,
                                    height: 1,
                                    letterSpacing: -2,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "kg/m²",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Category pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _resultColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: _resultColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    _result,
                                    style: TextStyle(
                                      color: _resultColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  _resultDescription,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13.5,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // BMI scale reference
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xff141414),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.06),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BMI Scale",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _ScaleRow(
                                  label: "Underweight",
                                  range: "< 18.5",
                                  color: const Color(0xff60a5fa),
                                  active: _result == "Underweight",
                                ),
                                const SizedBox(height: 10),
                                _ScaleRow(
                                  label: "Healthy",
                                  range: "18.5 – 24.9",
                                  color: const Color(0xff4ade80),
                                  active: _result == "Fit",
                                ),
                                const SizedBox(height: 10),
                                _ScaleRow(
                                  label: "Overweight",
                                  range: "25 – 29.9",
                                  color: const Color(0xfffbbf24),
                                  active: _result == "Overweight",
                                ),
                                const SizedBox(height: 10),
                                _ScaleRow(
                                  label: "Obese",
                                  range: "≥ 30",
                                  color: const Color(0xfff87171),
                                  active: _result == "Obese",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Metric Input Card ──────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final String unit;
  final IconData icon;
  final TextEditingController controller;
  final String hint;

  const _MetricCard({
    required this.label,
    required this.unit,
    required this.icon,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xff141414),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white38, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,3}\.?\d{0,1}'),
                    ),
                  ],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Semicircle BMI Gauge ───────────────────────────────────────────────────────

class _BmiGauge extends StatelessWidget {
  final double needleAngle; // in radians
  final Color resultColor;

  const _BmiGauge({required this.needleAngle, required this.resultColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GaugePainter(
        needleAngle: needleAngle,
        resultColor: resultColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double needleAngle;
  final Color resultColor;

  _GaugePainter({required this.needleAngle, required this.resultColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 12;
    final r = size.width * 0.42;

    const startAngle = math.pi; // left edge (180°)
    const sweepAngle = math.pi; // 180° sweep

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.07);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Coloured arc up to needle position
    final fraction = (needleAngle + math.pi / 2) / math.pi; // 0→1
    final colorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = resultColor.withOpacity(0.7);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startAngle,
      sweepAngle * fraction,
      false,
      colorPaint,
    );

    // Needle
    final needleLen = r * 0.72;
    final nx = cx + needleLen * math.cos(needleAngle);
    final ny = cy + needleLen * math.sin(needleAngle);

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy), Offset(nx, ny), needlePaint);

    // Centre dot
    canvas.drawCircle(Offset(cx, cy), 6, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = Colors.black);

    // Zone tick labels
    final labels = ['< 18.5', '25', '30', '40+'];
    final angles = [-1.45, -0.1, 0.5, 1.45];
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < labels.length; i++) {
      tp.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      tp.layout();
      final lx = cx + (r + 18) * math.cos(angles[i]) - tp.width / 2;
      final ly = cy + (r + 18) * math.sin(angles[i]) - tp.height / 2;
      tp.paint(canvas, Offset(lx, ly));
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.needleAngle != needleAngle || old.resultColor != resultColor;
}

// ── BMI Scale Row ──────────────────────────────────────────────────────────────

class _ScaleRow extends StatelessWidget {
  final String label;
  final String range;
  final Color color;
  final bool active;

  const _ScaleRow({
    required this.label,
    required this.range,
    required this.color,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? color.withOpacity(0.4) : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: active ? color : Colors.grey.shade500,
              fontSize: 14,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            range,
            style: TextStyle(
              color: active ? color.withOpacity(0.8) : Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

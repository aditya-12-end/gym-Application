import 'dart:async';

import 'package:flutter/material.dart';

class Meditationpage extends StatefulWidget {
  const Meditationpage({super.key});

  @override
  State<Meditationpage> createState() => _MeditationpageState();
}

class _MeditationpageState extends State<Meditationpage>
    with TickerProviderStateMixin {
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _timerActive = false;
  int _selectedMinutes = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void startTimer(int minutes) {
    _countdownTimer?.cancel();
    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _timerActive = true;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _timerActive = false;
          _remainingSeconds = 0;
        });
        _showCompletionDialog();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void stopTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _timerActive = false;
      _remainingSeconds = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff171717),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Session Complete",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Your meditation session has ended. Take a moment to return gently to the present.",
          style: TextStyle(color: Colors.white70, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Done", style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _timerProgress {
    if (_selectedMinutes == 0) return 0;
    return 1.0 - (_remainingSeconds / (_selectedMinutes * 60));
  }

  int currentIndex = 0;
  List<String> text = ["CALM", "EMOTIONAL", "ANXIOUS", "SAD", "ANGRY", "HAPPY"];
  List<IconData> icons = [
    Icons.spa,
    Icons.favorite_rounded,
    Icons.air,
    Icons.cloudy_snowing,
    Icons.local_fire_department,
    Icons.wb_sunny_rounded,
  ];
  List<Color> colors = [
    Colors.blue,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.blueGrey,
    Colors.red,
    Colors.yellow,
  ];
  final List<String> sessionType = [
    "Gratitude Practice",
    "Emotional Balance",
    "Breathing Exercise",
    "Self Compassion",
    "Anger Release",
    "Positive Reflection",
  ];

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % text.length;
    });
  }

  void previous() {
    setState(() {
      currentIndex = (currentIndex - 1 + text.length) % text.length;
    });
  }

  void showInstructions() {
    final List<String> titles = [
      "Feeling Calm",
      "Feeling Emotional",
      "Feeling Anxious",
      "Feeling Sad",
      "Feeling Angry",
      "Feeling Happy",
    ];
    final List<String> instructions = [
      "You are already in a balanced state of mind. Sit comfortably, focus on your breathing, and practice gratitude. Spend a few minutes appreciating the present moment and reinforcing this sense of peace.",
      "Allow yourself to feel your emotions without judgment. Close your eyes, take slow breaths, and observe your feelings as they come and go. Remember that emotions are temporary and do not define you.",
      "Focus on deep breathing. Inhale for 4 seconds, hold for 4 seconds, and exhale for 6 seconds. Bring your attention back to the present moment whenever your mind starts to wander.",
      "Be gentle with yourself. Take slow breaths and acknowledge your feelings. Imagine each exhale releasing a little bit of heaviness. You do not need to fix everything right now.",
      "Pause before reacting. Take several deep breaths and focus on relaxing your jaw, shoulders, and hands. Observe the sensation of anger without feeding it with additional thoughts.",
      "Enjoy this positive energy mindfully. Take a moment to notice what contributed to your happiness and cultivate gratitude. Let this feeling spread through your body with each breath.",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                titles[currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                instructions[currentIndex],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 47, 45, 45),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showTimerSelectionDialog();
                  },
                  child: const Text(
                    "Begin Meditation",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  void _showTimerSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xff171717),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xff4A148C), Color(0xff7B1FA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.timer_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Set Session Duration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Choose how long you'd like to meditate",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 24),
                // Timer options
                ...[5, 10, 15].map(
                  (minutes) => _TimerOption(
                    minutes: minutes,
                    onTap: () {
                      Navigator.pop(context);
                      startTimer(minutes);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: showInstructions,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 33, 33, 33),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            "Start Meditation Session",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: _timerActive ? 1.0 : 0.0,
                child: _timerActive
                    ? _FloatingTimerBar(
                        formattedTime: _formattedTime,
                        progress: _timerProgress,
                        pulseAnimation: _pulseAnimation,
                        accentColor: colors[currentIndex],
                        onStop: stopTimer,
                      )
                    : const SizedBox.shrink(),
              ),
            ),


            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff4A148C),
                                Color(0xff7B1FA2),
                                Color.fromARGB(255, 247, 37, 174),
                                Colors.pink,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.self_improvement_rounded,
                            color: Colors.white,
                            size: 85,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  "Daily Reflection",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              '"Meditation is not about escaping life,\nit is about learning to be fully present in it."',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              width: 60,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Take a few deep breaths. Let go of distractions and allow yourself to reconnect with the present moment. Even a few mindful minutes can bring clarity and calm.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "How are you feeling right now?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(height: 45),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: previous,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff171717),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: showInstructions,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                    colors: [
                                      colors[currentIndex].withOpacity(0.25),
                                      const Color(0xff171717),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: colors[currentIndex].withOpacity(
                                      0.5,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors[currentIndex].withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 35,
                                    horizontal: 20,
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Column(
                                      key: ValueKey(currentIndex),
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: colors[currentIndex]
                                              .withOpacity(0.2),
                                          child: Icon(
                                            icons[currentIndex],
                                            color: colors[currentIndex],
                                            size: 35,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          text[currentIndex],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          sessionType[currentIndex],
                                          style: TextStyle(
                                            color: colors[currentIndex],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          "Tap to view meditation guidance",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: nextCard,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff171717),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          text.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? colors[currentIndex]
                                  : Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _FloatingTimerBar extends StatelessWidget {
  final String formattedTime;
  final double progress;
  final Animation<double> pulseAnimation;
  final Color accentColor;
  final VoidCallback onStop;

  const _FloatingTimerBar({
    required this.formattedTime,
    required this.progress,
    required this.pulseAnimation,
    required this.accentColor,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff171717),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [

            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.linear,
                  widthFactor: progress,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff4A148C).withOpacity(0.45),
                          accentColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              child: Row(
                children: [
           
                  AnimatedBuilder(
                    animation: pulseAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: pulseAnimation.value,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purpleAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Label
                  const Text(
                    "MEDITATING",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),


                  Text(
                    formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(width: 14),

               
                  GestureDetector(
                    onTap: onStop,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: const Icon(
                        Icons.stop_rounded,
                        color: Colors.white60,
                        size: 16,
                      ),
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
}



class _TimerOption extends StatelessWidget {
  final int minutes;
  final VoidCallback onTap;

  const _TimerOption({required this.minutes, required this.onTap});

  String get _label {
    switch (minutes) {
      case 5:
        return "Quick Reset";
      case 10:
        return "Balanced Session";
      case 15:
        return "Deep Practice";
      default:
        return "$minutes Minutes";
    }
  }

  IconData get _icon {
    switch (minutes) {
      case 5:
        return Icons.bolt_rounded;
      case 10:
        return Icons.self_improvement_rounded;
      case 15:
        return Icons.nights_stay_rounded;
      default:
        return Icons.timer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xff4A148C), Color(0xff7B1FA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(_icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$minutes minutes",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

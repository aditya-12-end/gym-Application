import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/integration/wrokout.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Theme tokens
// The original dark theme (black background, #1A1A1A cards, white text) is
// preserved. Only two new colours were introduced: an accent for active /
// in-progress states, and a success colour for completed sets and exercises.
// ---------------------------------------------------------------------------
const Color kBackground = Colors.black;
const Color kCard = Color(0xFF1A1A1A);
const Color kCardAlt = Color(0xFF141414);
const Color kAccent = Color(0xFFFF6B35);
const Color kSuccess = Color(0xFF4ADE80);
const Color kMuted = Colors.white54;

class WorkoutDetailsPage extends StatefulWidget {
  final Map<String, dynamic> workout;

  const WorkoutDetailsPage({super.key, required this.workout});

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  // exerciseId -> number of sets completed today
  Map<String, int> _completedSets = {};
  bool _loadingProgress = true;

  late final String _dateKey;
  late final String _dataKey;

  @override
  void initState() {
    super.initState();
    final workoutId = (widget.workout["id"] ?? widget.workout["workout_name"])
        .toString();
    _dateKey = "workout_progress_date_$workoutId";
    _dataKey = "workout_progress_data_$workoutId";
    _loadProgress();
  }

  String get _todayKey {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  // Loads saved progress for this workout. If the stored date does not match
  // today, progress is wiped automatically - this is what makes the tracker
  // reset itself once a day is over.
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_dateKey);

    if (savedDate != _todayKey) {
      await prefs.setString(_dateKey, _todayKey);
      await prefs.remove(_dataKey);
      if (mounted) {
        setState(() {
          _completedSets = {};
          _loadingProgress = false;
        });
      }
      return;
    }

    final raw = prefs.getString(_dataKey);
    final Map<String, int> restored = {};
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        restored[key] = (value as num).toInt();
      });
    }

    if (mounted) {
      setState(() {
        _completedSets = restored;
        _loadingProgress = false;
      });
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateKey, _todayKey);
    await prefs.setString(_dataKey, jsonEncode(_completedSets));
  }

  int _totalSetsFor(Map exercise) {
    return int.tryParse(exercise["sets"].toString()) ?? 0;
  }

  int _completedSetsFor(String id) => _completedSets[id] ?? 0;

  bool _isFinished(Map exercise) {
    final total = _totalSetsFor(exercise);
    final id = exercise["id"].toString();
    return total > 0 && _completedSetsFor(id) >= total;
  }

  void _openExerciseSession(Map<String, dynamic> exercise) {
    final id = exercise["id"].toString();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: _ExerciseSessionSheet(
            exercise: exercise,
            initialCompletedSets: _completedSetsFor(id),
            onProgress: (completed) {
              setState(() {
                _completedSets[id] = completed;
              });
              _saveProgress();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercises = (widget.workout["exercises"] ?? []) as List;
    final totalCount = exercises.length;
    final completedCount = exercises.where((e) => _isFinished(e)).length;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: Text(
          widget.workout["workout_name"],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _loadingProgress
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.workout["workout_name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            widget.workout["targeted_muscle"],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Today's progress summary card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Progress",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "$completedCount/$totalCount completed",
                              style: const TextStyle(
                                color: kMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: totalCount == 0
                                ? 0
                                : completedCount / totalCount,
                            minHeight: 8,
                            backgroundColor: Colors.white12,
                            color: kAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Exercises",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...exercises.map<Widget>((exerciseRaw) {
                    final Map<String, dynamic> exercise =
                        Map<String, dynamic>.from(exerciseRaw as Map);
                    final id = exercise["id"].toString();
                    final totalSets = _totalSetsFor(exercise);
                    final completed = _completedSetsFor(id);
                    final finished = _isFinished(exercise);

                    return Dismissible(
                      key: Key(id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Exercise"),
                              content: Text(
                                "Delete ${exercise["exercise_name"]}?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (_) async {
                        try {
                          await WorkoutService().deleteExercise(exercise["id"]);
                          setState(() {
                            _completedSets.remove(id);
                          });
                          _saveProgress();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${exercise["exercise_name"]} deleted",
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(20),
                          border: finished
                              ? Border.all(
                                  color: kSuccess.withValues(alpha: 0.35),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: finished
                                      ? kSuccess.withValues(alpha: 0.15)
                                      : Colors.white12,
                                  child: Icon(
                                    finished
                                        ? Icons.check
                                        : Icons.fitness_center,
                                    color: finished ? kSuccess : Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise["exercise_name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        finished
                                            ? "Completed"
                                            : "$completed of $totalSets sets done",
                                        style: TextStyle(
                                          color: finished ? kSuccess : kMuted,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _metric("Sets", exercise["sets"].toString()),
                                _metric("Reps", exercise["reps"].toString()),
                                _metric("Rest", "${exercise["rest_time"]}s"),
                              ],
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: finished
                                    ? null
                                    : () => _openExerciseSession(exercise),
                                icon: Icon(
                                  finished
                                      ? Icons.check_circle
                                      : Icons.play_arrow_rounded,
                                ),
                                label: Text(
                                  finished
                                      ? "Completed"
                                      : (completed > 0
                                            ? "Continue Exercise"
                                            : "Start Exercise"),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: finished
                                      ? Colors.white12
                                      : kAccent,
                                  foregroundColor: finished
                                      ? kSuccess
                                      : Colors.black,
                                  disabledBackgroundColor: Colors.white12,
                                  disabledForegroundColor: kSuccess,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Exercise session bottom sheet
// Walks the user through each set: ready -> mark set complete -> rest timer
// -> next set -> ... -> finished. Progress is reported back to the parent
// page after every set so it survives the sheet being closed mid-exercise.
// ---------------------------------------------------------------------------
enum _SessionPhase { ready, resting, finished }

class _ExerciseSessionSheet extends StatefulWidget {
  final Map<String, dynamic> exercise;
  final int initialCompletedSets;
  final void Function(int completedSets) onProgress;

  const _ExerciseSessionSheet({
    required this.exercise,
    required this.initialCompletedSets,
    required this.onProgress,
  });

  @override
  State<_ExerciseSessionSheet> createState() => _ExerciseSessionSheetState();
}

class _ExerciseSessionSheetState extends State<_ExerciseSessionSheet> {
  late int _completedSets;
  late int _totalSets;
  late int _restSeconds;
  int _remaining = 0;
  Timer? _timer;
  late _SessionPhase _phase;

  @override
  void initState() {
    super.initState();
    _completedSets = widget.initialCompletedSets;
    _totalSets = int.tryParse(widget.exercise["sets"].toString()) ?? 1;
    _restSeconds = int.tryParse(widget.exercise["rest_time"].toString()) ?? 30;
    _phase = _completedSets >= _totalSets
        ? _SessionPhase.finished
        : _SessionPhase.ready;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _completeSet() {
    setState(() => _completedSets++);
    widget.onProgress(_completedSets);

    if (_completedSets >= _totalSets) {
      setState(() => _phase = _SessionPhase.finished);
      return;
    }
    _startRest();
  }

  void _startRest() {
    _timer?.cancel();
    setState(() {
      _phase = _SessionPhase.resting;
      _remaining = _restSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() {
          _remaining = 0;
          _phase = _SessionPhase.ready;
        });
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _skipRest() {
    _timer?.cancel();
    setState(() {
      _phase = _SessionPhase.ready;
      _remaining = 0;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.exercise["exercise_name"]?.toString() ?? "Exercise";
    final reps = widget.exercise["reps"]?.toString() ?? "-";

    return Container(
      decoration: const BoxDecoration(
        color: kCardAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Target: $reps reps per set",
                      style: const TextStyle(color: kMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Set progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalSets, (index) {
              final isDone = index < _completedSets;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? kAccent : Colors.white12,
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          SizedBox(width: 200, height: 200, child: _buildPhaseVisual()),

          const SizedBox(height: 32),

          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildPhaseVisual() {
    switch (_phase) {
      case _SessionPhase.ready:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAccent, width: 4),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Set ${_completedSets + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "of $_totalSets",
                style: const TextStyle(color: kMuted, fontSize: 15),
              ),
            ],
          ),
        );

      case _SessionPhase.resting:
        final progress = _restSeconds == 0 ? 0.0 : _remaining / _restSeconds;
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.white12,
                color: kAccent,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(_remaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Resting",
                  style: TextStyle(color: kMuted, fontSize: 14),
                ),
              ],
            ),
          ],
        );

      case _SessionPhase.finished:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kSuccess.withValues(alpha: 0.12),
            border: Border.all(color: kSuccess, width: 4),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: kSuccess, size: 44),
              SizedBox(height: 8),
              Text(
                "Exercise Done",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildActionButton() {
    switch (_phase) {
      case _SessionPhase.ready:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _completeSet,
            icon: const Icon(Icons.check),
            label: const Text("Mark Set Complete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );

      case _SessionPhase.resting:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _skipRest,
            icon: const Icon(Icons.skip_next, color: Colors.white),
            label: const Text(
              "Skip Rest",
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );

      case _SessionPhase.finished:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: kSuccess,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Done"),
          ),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/integration/wrokout.dart';
import 'package:frontend/myWidget/buildField.dart';
import 'package:frontend/myWidget/mySuggestedWotkout.dart';
import 'package:frontend/pages/createWorkoutPage.dart';
import 'package:frontend/pages/wrokoutDetailsPage.dart';

class Workoutplan extends StatefulWidget {
  const Workoutplan({super.key});

  @override
  State<Workoutplan> createState() => _WorkoutplanState();
}

class _WorkoutplanState extends State<Workoutplan> {
  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    try {
      final data = await WorkoutService().getMyWorkouts();

      setState(() {
        workouts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteWorkout(int workoutId) async {
    try {
      await WorkoutService().deleteWorkout(workoutId);

      loadWorkouts();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Workout deleted")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> showCreateWorkoutSheet() async {
    workoutNameController.clear();
    targetMuscleController.clear();
    exercises.clear();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1B1B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: workoutNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Workout Name",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: targetMuscleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Target Muscle",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () async {
                        final exercise = await showAddExerciseDialog();

                        if (exercise != null) {
                          setModalState(() {
                            exercises.add(exercise);
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add Exercise",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...exercises.map(
                      (exercise) => Card(
                        color: Colors.black,
                        child: ListTile(
                          title: Text(
                            exercise["exerciseName"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "${exercise["sets"]} Sets • ${exercise["reps"]} Reps",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setModalState(() {
                                exercises.remove(exercise);
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          print("Create button pressed");

                          try {
                            await WorkoutService().createWorkout(
                              workoutName: workoutNameController.text,
                              targetedMuscle: targetMuscleController.text,
                              exercises: exercises,
                            );

                            print("Workout created successfully");

                            Navigator.pop(context);

                            loadWorkouts();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Workout Created")),
                            );
                          } catch (e) {
                            print(e);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        child: const Text(
                          "Create Workout",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> showAddExerciseDialog() async {
    final nameController = TextEditingController();
    final setsController = TextEditingController();
    final repsController = TextEditingController();
    final restController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Add Exercise",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: SizedBox(
            width: 350,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Buildfield(
                    controller: nameController,
                    label: "Exercise Name",
                    icon: Icons.fitness_center,
                  ),

                  const SizedBox(height: 14),

                  Buildfield(
                    controller: setsController,
                    label: "Sets",
                    icon: Icons.repeat,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 14),

                  Buildfield(
                    controller: repsController,
                    label: "Reps",
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 14),

                  Buildfield(
                    controller: restController,
                    label: "Rest Time (sec)",
                    icon: Icons.timer_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, {
                  "exerciseName": nameController.text,
                  "sets": int.parse(setsController.text),
                  "reps": int.parse(repsController.text),
                  "restTime": int.parse(restController.text),
                });
              },
              child: const Text(
                "Add Exercise",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  List<dynamic> workouts = [];
  bool isLoading = true;
  final workoutNameController = TextEditingController();
  final targetMuscleController = TextEditingController();

  List<Map<String, dynamic>> exercises = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              children: [
                Text(
                  'Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(width: 200),
                GestureDetector(
                  onTap: () {
                    showCreateWorkoutSheet();
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add, color: Colors.black, size: 40),
                  ),
                ),
              ],
            ),
          ),
          workouts.isEmpty
              ? Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(221, 28, 27, 27),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 380,
                      height: 250,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            const Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Add your own workout',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 157, 155, 155),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Tap + to create your first workout',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 157, 155, 155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Text(
                      'Suggested workout for you',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Mysuggestedwotkout(
                      title: "Push,Pull,Legs",
                      subititle: "One of the most famous splits",
                      icon: Icons.fitness_center_rounded,
                    ),
                    Mysuggestedwotkout(
                      title: "BRO Split",
                      subititle:
                          "Routine that targets one distinct muscle group",
                      icon: FontAwesomeIcons.weightHanging,
                    ),
                    Mysuggestedwotkout(
                      title: "Wendler",
                      subititle:
                          "steady progression in the four compound lifts.",
                      icon: FontAwesomeIcons.dumbbell,
                    ),
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];

                      return Dismissible(
                        key: Key(workout["id"].toString()),
                        direction: DismissDirection.endToStart,

                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Delete Workout",
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
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Workout"),
                              content: Text(
                                "Delete ${workout["workout_name"]}?",
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
                            ),
                          );
                        },

                        onDismissed: (_) async {
                          try {
                            await deleteWorkout(workout["id"]);

                            setState(() {
                              workouts.removeAt(index);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${workout["workout_name"]} deleted",
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },

                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WorkoutDetailsPage(workout: workout),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: const Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(18),
                              title: Text(
                                workout["workout_name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  workout["targeted_muscle"],
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

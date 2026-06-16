import 'package:flutter/material.dart';

class Dietplan extends StatefulWidget {
  const Dietplan({super.key});

  @override
  State<Dietplan> createState() => _DietplanState();
}

class _DietplanState extends State<Dietplan> {
  final List<Map<String, dynamic>> _builtInPlans = [
    {
      'name': 'Lean Cut',
      'goal': 'Fat Loss',
      'calories': '1800 kcal',
      'meals': 4,
      'description':
          'High protein, low carb. Designed for steady fat loss while preserving muscle mass.',
      'tags': ['High Protein', 'Low Carb'],
      'meals_detail': [
        {'time': 'Breakfast', 'meal': 'Scrambled eggs (3), oats with berries'},
        {
          'time': 'Lunch',
          'meal': 'Grilled chicken breast, quinoa, steamed broccoli',
        },
        {'time': 'Snack', 'meal': 'Greek yogurt, almonds (20g)'},
        {'time': 'Dinner', 'meal': 'Baked salmon, sweet potato, mixed greens'},
      ],
    },
    {
      'name': 'Bulk Up',
      'goal': 'Muscle Gain',
      'calories': '3200 kcal',
      'meals': 5,
      'description':
          'Calorie surplus with balanced macros. Supports muscle growth and recovery.',
      'tags': ['High Calorie', 'Balanced'],
      'meals_detail': [
        {'time': 'Breakfast', 'meal': 'Oats, banana, 4 eggs, whole milk'},
        {'time': 'Mid-Morning', 'meal': 'Peanut butter toast, protein shake'},
        {'time': 'Lunch', 'meal': 'Rice, chicken thighs, lentils, avocado'},
        {'time': 'Snack', 'meal': 'Cottage cheese, walnuts, dates'},
        {'time': 'Dinner', 'meal': 'Pasta, ground beef, olive oil, vegetables'},
      ],
    },
    {
      'name': 'Clean Maintain',
      'goal': 'Maintenance',
      'calories': '2200 kcal',
      'meals': 3,
      'description':
          'Whole foods, no processed items. Keeps weight stable with clean nutrition.',
      'tags': ['Whole Foods', 'Balanced'],
      'meals_detail': [
        {'time': 'Breakfast', 'meal': 'Smoothie bowl, seeds, fresh fruit'},
        {
          'time': 'Lunch',
          'meal': 'Brown rice, tofu or fish, stir-fried vegetables',
        },
        {
          'time': 'Dinner',
          'meal': 'Grilled chicken, roasted veggies, whole grain bread',
        },
      ],
    },
    {
      'name': 'Plant Power',
      'goal': 'Vegan — Fat Loss',
      'calories': '1700 kcal',
      'meals': 4,
      'description':
          '100% plant-based. High in fiber and micronutrients, naturally low in saturated fat.',
      'tags': ['Vegan', 'High Fiber'],
      'meals_detail': [
        {
          'time': 'Breakfast',
          'meal': 'Overnight oats, chia seeds, almond butter',
        },
        {'time': 'Lunch', 'meal': 'Chickpea salad, quinoa, tahini dressing'},
        {'time': 'Snack', 'meal': 'Apple, pumpkin seeds, hummus'},
        {
          'time': 'Dinner',
          'meal': 'Black bean tacos, avocado, salsa, corn tortillas',
        },
      ],
    },
  ];

  void _openPlanDetail(Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PlanDetailSheet(plan: plan),
    );
  }

  void _openCreatePlan() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _CreatePlanSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diet Plans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose a plan or build your own',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Section label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'BUILT-IN PLANS',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Plan list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _builtInPlans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final plan = _builtInPlans[index];
                  return _PlanCard(
                    plan: plan,
                    onTap: () => _openPlanDetail(plan),
                  );
                },
              ),
            ),

            // Create your plan button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: GestureDetector(
                onTap: _openCreatePlan,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.black, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Create Your Plan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
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

// ---------- Plan Card ----------

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white30, size: 18),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              plan['goal'],
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatChip(label: plan['calories']),
                const SizedBox(width: 8),
                _StatChip(label: '${plan['meals']} meals/day'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              plan['description'],
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ---------- Plan Detail Sheet ----------

class _PlanDetailSheet extends StatelessWidget {
  final Map<String, dynamic> plan;
  const _PlanDetailSheet({required this.plan});

  @override
  Widget build(BuildContext context) {
    final meals = plan['meals_detail'] as List<Map<String, String>>;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              plan['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              plan['goal'],
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatChip(label: plan['calories']),
                const SizedBox(width: 8),
                _StatChip(label: '${plan['meals']} meals/day'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              plan['description'],
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'DAILY MEALS',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ...meals.map(
              (meal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        meal['time']!,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        meal['meal']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Use This Plan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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

// ---------- Create Plan Sheet ----------

class _CreatePlanSheet extends StatefulWidget {
  const _CreatePlanSheet();

  @override
  State<_CreatePlanSheet> createState() => _CreatePlanSheetState();
}

class _CreatePlanSheetState extends State<_CreatePlanSheet> {
  final _nameController = TextEditingController();
  String? _selectedGoal;
  int _mealCount = 3;

  final List<String> _goals = [
    'Fat Loss',
    'Muscle Gain',
    'Maintenance',
    'Vegan',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Your Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            // Plan name
            const Text(
              'Plan Name',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g. My Summer Cut',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Goal selection
            const Text(
              'Goal',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _goals.map((goal) {
                final selected = _selectedGoal == goal;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGoal = goal),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      goal,
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Meals per day
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meals per day',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        if (_mealCount > 1) _mealCount--;
                      }),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '$_mealCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        if (_mealCount < 6) _mealCount++;
                      }),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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

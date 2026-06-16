import 'package:flutter/material.dart';
import 'package:frontend/pages/aboutPage.dart';
import 'package:frontend/pages/bmiCalculatorPage.dart';
import 'package:frontend/pages/dietPlan.dart';
import 'package:frontend/pages/loginPage.dart';
import 'package:frontend/pages/meditationPage.dart';
import 'package:frontend/pages/profilePage.dart';
import 'package:frontend/pages/workoutPlan.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  // ── Design Tokens ──────────────────────────────────────────────
  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF111111);
  static const Color _surfaceHigh = Color(0xFF1A1A1A);
  static const Color _red = Color(0xFFE53935);
  static const Color _redGlow = Color(0xFFFF6F6F);
  static const Color _textPrimary = Colors.white;
  static const Color _textMuted = Color(0xFF9E9E9E);

  // ── Feature card data ──────────────────────────────────────────
  final List<_FeatureItem> _features = const [
    _FeatureItem(
      icon: Icons.sports_gymnastics,
      title: 'Custom Workout',
      subtitle: 'Build a plan tailored to your goals and schedule.',
      page: null, // replace with Workoutplan() or use onTap callback
    ),
    _FeatureItem(
      icon: Icons.local_fire_department,
      title: 'Calorie Tracker',
      subtitle: 'Log meals and activity to stay on target every day.',
      page: null,
    ),
    _FeatureItem(
      icon: Icons.self_improvement,
      title: 'Meditation',
      subtitle: 'Guided yoga and breathing sessions to reset your mind.',
      page: null,
    ),
    _FeatureItem(
      icon: Icons.restaurant,
      title: 'Diet Plans',
      subtitle: 'Expert-curated nutrition plans for every lifestyle.',
      page: null,
    ),
  ];

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            _buildQuickActions(context),
            _buildSectionHeader('Features'),
            _buildFeatureGrid(context),
            const SizedBox(height: 40),
            _buildStatsRow(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      iconTheme: const IconThemeData(color: _textPrimary),
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'GYM FIT',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: _textMuted,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Profilepage();
                  },
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surfaceHigh,
                shape: BoxShape.circle,
                border: Border.all(color: _red.withOpacity(0.5), width: 1.5),
              ),
              child: const Icon(
                Icons.person_outline,
                color: _textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _surfaceHigh),
      ),
    );
  }

  // ── Hero Section ───────────────────────────────────────────────
  Widget _buildHero() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 320,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gym.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 320,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0x00000000), Color(0xCC000000), Color(0xF5000000)],
            ),
          ),
        ),
        Positioned(
          bottom: 36,
          left: 28,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _red.withOpacity(0.5)),
                ),
                child: const Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    color: _redGlow,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Push Your\nLimits Today.',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your dashboard is ready — pick up where you left off.',
                style: TextStyle(color: _textMuted, fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Quick Actions Row ──────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        Icons.fitness_center_outlined,
        'Workout',
        () => _navigateTo(context, const Workoutplan()),
      ),
      _QuickAction(
        Icons.self_improvement,
        'Meditate',
        () => _navigateTo(context, const Meditationpage()),
      ),
      _QuickAction(
        Icons.monitor_heart_outlined,
        'BMI',
        () => _navigateTo(context, const Bmicalculatorpage()),
      ),
      _QuickAction(Icons.bar_chart_outlined, 'Progress', () {}),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((a) => _buildQuickActionChip(a)).toList(),
      ),
    );
  }

  Widget _buildQuickActionChip(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _surfaceHigh, width: 1),
            ),
            child: Icon(action.icon, color: _red, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Header ─────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        children: [
          Container(width: 3, height: 18, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Feature Grid ───────────────────────────────────────────────
  Widget _buildFeatureGrid(BuildContext context) {
    final tileData = [
      _TileData(
        Icons.sports_gymnastics,
        'Workout Plans',
        'Build your custom routine',
        () => _navigateTo(context, const Workoutplan()),
      ),
      _TileData(
        Icons.local_fire_department,
        'Calorie Tracker',
        'Log your daily intake',
        () {},
      ),
      _TileData(
        Icons.self_improvement,
        'Meditation',
        'Breathe, focus, recharge',
        () => _navigateTo(context, const Meditationpage()),
      ),
      _TileData(
        Icons.restaurant,
        'Diet Plans',
        'Expert nutrition guidance',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Dietplan();
              },
            ),
          );
        },
      ),
      _TileData(
        Icons.monitor_heart_outlined,
        'BMI Calculator',
        'Know your health score',
        () => _navigateTo(context, const Bmicalculatorpage()),
      ),
      _TileData(
        Icons.bar_chart_outlined,
        'Progress',
        'Track your milestones',
        () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tileData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, i) {
          final d = tileData[i];
          return _FeatureCard(
            icon: d.icon,
            title: d.title,
            subtitle: d.subtitle,
            onTap: d.onTap,
          );
        },
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _surfaceHigh),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _StatItem(value: '0', label: 'Workouts'),
            _StatDivider(),
            _StatItem(value: '0', label: 'Kcal Burned'),
            _StatDivider(),
            _StatItem(value: '0', label: 'Day Streak'),
          ],
        ),
      ),
    );
  }

  // ── Drawer ─────────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D0D0D),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _red.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'GYM FIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'Your fitness companion',
                        style: TextStyle(color: _textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.08), height: 1),
            const SizedBox(height: 8),

            _drawerGroupLabel('FEATURES'),
            _drawerItem(Icons.fitness_center_outlined, 'Workout Plans', () {
              Navigator.pop(context);
              _navigateTo(context, const Workoutplan());
            }),
            _drawerItem(Icons.restaurant_outlined, 'Diet Plans', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Dietplan();
                  },
                ),
              );
            }),

            _drawerItem(Icons.self_improvement, 'Meditation', () {
              Navigator.pop(context);
              _navigateTo(context, const Meditationpage());
            }),
            _drawerItem(Icons.bar_chart_outlined, 'Progress Tracker', () {}),
            _drawerItem(Icons.monitor_heart_outlined, 'BMI Calculator', () {
              Navigator.pop(context);
              _navigateTo(context, const Bmicalculatorpage());
            }),

            const Spacer(),
            Divider(color: Colors.white.withOpacity(0.06), height: 1),

            _drawerItem(Icons.settings_outlined, 'Settings', () {}),
            _drawerItem(Icons.help_outline, 'Help & Support', () {}),
            _drawerItem(Icons.info_outline, 'About App', () {
              Navigator.pop(context);
              _navigateTo(context, const Aboutpage());
            }),
            _drawerItem(Icons.logout, 'Logout', () {
              Navigator.pop(context);
              _navigateTo(context, const Loginpage());
            }, color: _red),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _drawerGroupLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF555555),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color color = _textMuted,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: color == _textMuted ? _textPrimary : color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

// ── Supporting Widgets ──────────────────────────────────────────

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? page;
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.page,
  });
}

class _TileData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _TileData(this.icon, this.title, this.subtitle, this.onTap);
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.onTap);
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color _surface = Color(0xFF111111);
  static const Color _red = Color(0xFFE53935);
  static const Color _textPrimary = Colors.white;
  static const Color _textMuted = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 22, 22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: _textMuted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Text(
                  'Open',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: Colors.white, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: const Color(0xFF1A1A1A));
  }
}

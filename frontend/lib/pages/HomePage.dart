import 'package:flutter/material.dart';
import 'package:frontend/pages/dietPlan.dart';
import 'package:frontend/pages/loginPage.dart';
import 'package:frontend/pages/meditationPage.dart';
import 'package:frontend/pages/registerPage.dart';
import 'package:frontend/pages/workoutPlan.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
    ),
    _FeatureItem(
      icon: Icons.local_fire_department,
      title: 'Calorie Tracker',
      subtitle: 'Log meals and activity to stay on target every day.',
    ),
    _FeatureItem(
      icon: Icons.self_improvement,
      title: 'Meditation',
      subtitle: 'Guided yoga and breathing sessions to reset your mind.',
    ),
    _FeatureItem(
      icon: Icons.restaurant,
      title: 'Diet Plans',
      subtitle: 'Expert-curated nutrition plans for every lifestyle.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            _buildSectionHeader('What We Offer'),
            _buildFeatureGrid(),
            const SizedBox(height: 40),
            _buildCtaBanner(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
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
            'GYM FIT ',
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
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: _textMuted),
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
        // Background image
        Container(
          width: double.infinity,
          height: 340,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gym.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          width: double.infinity,
          height: 340,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color.fromARGB(0, 28, 26, 26),
                Color(0xCC000000),
                Color(0xF5000000),
              ],
            ),
          ),
        ),
        // Hero copy
        Positioned(
          bottom: 36,
          left: 28,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _red.withValues(alpha: 0.5)),
                ),
                child: const Text(
                  'YOUR FITNESS JOURNEY',
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
                'Train Smarter.\nLive Better.',
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
                'Personalized plans, expert guidance, and real results — all in one place.',
                style: TextStyle(color: _textMuted, fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Section Header ─────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 20),
      child: Row(
        children: [
          Container(width: 3, height: 18, color: _red),
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
  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, i) => _FeatureCard(item: _features[i]),
      ),
    );
  }

  // ── CTA Banner ─────────────────────────────────────────────────
  Widget _buildCtaBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _red,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _red.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ready to start?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Create a free account and begin your transformation today.',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Registerpage();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Join Now',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
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
            // Header
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
                          color: _red.withValues(alpha: 0.4),
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
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            const SizedBox(height: 8),

            // Account group
            _drawerGroupLabel('ACCOUNT'),
            _drawerItem(Icons.login_outlined, 'Login', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Loginpage()),
              );
            }),
            _drawerItem(Icons.person_add_outlined, 'Register', () {}),

            const SizedBox(height: 8),
            Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),

            _drawerGroupLabel('FEATURES'),
            _drawerItem(Icons.fitness_center_outlined, 'Workout Plans', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Workoutplan();
                  },
                ),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Meditationpage();
                  },
                ),
              );
            }),
            _drawerItem(Icons.bar_chart_outlined, 'Progress Tracker', () {}),
            _drawerItem(Icons.monitor_heart_outlined, 'BMI Calculator', () {}),

            const Spacer(),
            Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),

            // Bottom group
            _drawerItem(Icons.settings_outlined, 'Settings', () {}),
            _drawerItem(Icons.help_outline, 'Help & Support', () {}),
            _drawerItem(Icons.info_outline, 'About App', () {}),
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

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: _textMuted, size: 20),
      title: Text(
        label,
        style: const TextStyle(
          color: _textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.white.withValues(alpha: 0.04),
    );
  }
}

// ── Feature Card Widget ─────────────────────────────────────────
class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;
  const _FeatureCard({required this.item});

  static const Color _surface = Color(0xFF111111);
  static const Color _surfaceHigh = Color(0xFF1A1A1A);

  static const Color _textPrimary = Colors.white;
  static const Color _textMuted = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: const Color.fromARGB(255, 18, 18, 18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: Colors.white, size: 22),
          ),
          const Spacer(),
          Text(
            item.title,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.subtitle,
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
                'Explore',
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
    );
  }
}

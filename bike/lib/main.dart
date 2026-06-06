import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/squad_provider.dart';
import 'providers/bike_provider.dart';
import 'providers/ride_provider.dart';
import 'screens/expenses_screen.dart';
import 'screens/squad_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SquadProvider()),
        ChangeNotifierProvider(create: (_) => BikeProvider()),
        ChangeNotifierProvider(create: (_) => RideSetup()),
      ],
      child: const BikeSquadApp(),
    ),
  );
}

class BikeSquadApp extends StatelessWidget {
  const BikeSquadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Squad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const _labels = ['Home', 'Map', 'Squad', 'Status', 'Settings'];
  static const _icons = [
    Icons.home_outlined,
    Icons.map_outlined,
    Icons.groups_outlined,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];
  static const _selectedIcons = [
    Icons.home,
    Icons.map,
    Icons.groups,
    Icons.bar_chart,
    Icons.settings,
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _HomeScreen(
        onSquadTap: () => setState(() => _selectedIndex = 2),
        onReportsTap: () => setState(() => _selectedIndex = 3),
      ),
      const _PlaceholderScreen(label: 'Map'),
      const SquadScreen(),
      const StatsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.orange, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: const Color.fromARGB(255, 247, 241, 241),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: List.generate(
            _labels.length,
            (i) => BottomNavigationBarItem(
              icon: Icon(_icons[i]),
              activeIcon: Icon(_selectedIcons[i]),
              label: _labels[i],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Home Screen ──────────────────────────────────────────────────────────────
class _HomeScreen extends StatelessWidget {
  final VoidCallback? onSquadTap;
  final VoidCallback? onReportsTap;

  const _HomeScreen({this.onSquadTap, this.onReportsTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bike Squad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Section ──
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orangeGlow,
                    border: Border.all(color: AppColors.orange, width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome buddy 🔥',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '3Bikers Squad',
                      style: TextStyle(color: AppColors.white, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Today's Ride Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      237,
                      190,
                      146,
                    ).withOpacity(0.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Today's Ride",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16),
                  _RideInfoRow(title: 'Distance', value: '128 KM'),
                  _RideInfoRow(title: 'Ride Time', value: '4h 20m'),
                  _RideInfoRow(title: 'Break Time', value: '35m'),
                  _RideInfoRow(title: 'Spent', value: '₹850'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Quick Actions ──
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                _ActionCard(
                  icon: Icons.play_arrow,
                  title: 'Start Ride',
                  onTap: () {},
                ),
                _ActionCard(
                  icon: Icons.groups,
                  title: 'Squad',
                  onTap: onSquadTap ?? () {},
                ),
                _ActionCard(
                  icon: Icons.currency_rupee,
                  title: 'Expenses',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                    );
                  },
                ),
                _ActionCard(
                  icon: Icons.bar_chart,
                  title: 'Reports',
                  onTap: onReportsTap ?? () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Recent Rides ──
            const Text(
              'Recent Rides',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const _RideHistoryCard(
              location: 'Ooty Ride',
              distance: '320 KM',
              expense: '₹2400',
            ),
            const SizedBox(height: 12),
            const _RideHistoryCard(
              location: 'Yelagiri Ride',
              distance: '210 KM',
              expense: '₹1500',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Ride Info Row ─────────────────────────────────────────────────────────────
class _RideInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _RideInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.white, fontSize: 15),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Card ───────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.orange, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 235, 191, 151).withOpacity(0.08),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 255, 255, 255),
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ride History Card ─────────────────────────────────────────────────────────
class _RideHistoryCard extends StatelessWidget {
  final String location;
  final String distance;
  final String expense;

  const _RideHistoryCard({
    required this.location,
    required this.distance,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RideExpense>>(
      valueListenable: rideExpensesNotifier,
      builder: (context, rides, _) {
        RideExpense? matchingRide;
        for (final ride in rides) {
          if (ride.rideName == location) {
            matchingRide = ride;
            break;
          }
        }
        final rideForDetails = matchingRide;

        return InkWell(
          onTap: rideForDetails == null
              ? null
              : () => showRideExpenseDetails(context, rideForDetails),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyDark, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 190, 190, 190),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      matchingRide == null
                          ? expense
                          : formatMoney(matchingRide.total),
                      style: const TextStyle(
                        color: AppColors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (matchingRide != null) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.orange,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Placeholder Screens ───────────────────────────────────────────────────────
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          label,
          style: const TextStyle(color: AppColors.grey, fontSize: 18),
        ),
      ),
    );
  }
}

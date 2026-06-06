import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/ride_provider.dart';
import 'ride_location_screen.dart';
import 'squad_selection_screen.dart';

class RideTypeScreen extends StatelessWidget {
  final VoidCallback onRideStarted;

  const RideTypeScreen({super.key, required this.onRideStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Start Ride'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Ride Type',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose solo, duo, or squad and continue your ride setup.',
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _RideTypeCard(
              icon: Icons.person,
              title: 'Solo Ride',
              description: 'Ride alone and track your journey',
              onTap: () {
                context.read<RideSetup>().setRideMode(RideMode.solo);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RideLocationScreen(onRideStarted: onRideStarted),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _RideTypeCard(
              icon: Icons.person_add,
              title: 'Duo Ride',
              description: 'Ride with one partner from your squad',
              onTap: () {
                context.read<RideSetup>().setRideMode(RideMode.duo);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SquadSelectionScreen(onRideStarted: onRideStarted),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _RideTypeCard(
              icon: Icons.groups,
              title: 'Squad Ride',
              description: 'Ride with your full squad team',
              onTap: () {
                context.read<RideSetup>().setRideMode(RideMode.squad);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SquadSelectionScreen(onRideStarted: onRideStarted),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _RideTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RideTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.1),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.orange, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.orange, size: 16),
          ],
        ),
      ),
    );
  }
}

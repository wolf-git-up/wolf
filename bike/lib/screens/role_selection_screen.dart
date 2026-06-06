import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rider_model.dart';
import '../providers/ride_provider.dart';
import '../theme/app_theme.dart';
import 'ride_location_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  final VoidCallback onRideStarted;

  const RoleSelectionScreen({super.key, required this.onRideStarted});

  @override
  Widget build(BuildContext context) {
    final roles = RiderRole.values;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Role'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: roles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final role = roles[index];

          return GestureDetector(
            onTap: () {
              context.read<RideSetup>().setSelectedRole(role);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RideLocationScreen(onRideStarted: onRideStarted),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.white, width: 1),
              ),
              child: Row(
                children: [
                  Text(role.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      role.displayName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.orange,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ride_provider.dart';
import '../theme/app_theme.dart';

class RideLocationScreen extends StatefulWidget {
  const RideLocationScreen({super.key});

  @override
  State<RideLocationScreen> createState() => _RideLocationScreenState();
}

class _RideLocationScreenState extends State<RideLocationScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _saveLocations() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter both start and destination')),
      );
      return;
    }

    final setup = context.read<RideSetup>();
    setup.setFromLocation(from);
    setup.setToLocation(to);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride setup saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ride Location'),
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
              'Route',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _LocationField(
              controller: _fromController,
              label: 'From',
              icon: Icons.trip_origin,
            ),
            const SizedBox(height: 12),
            _LocationField(
              controller: _toController,
              label: 'To',
              icon: Icons.location_on_outlined,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLocations,
                child: const Text('Save Route'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _LocationField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.orange),
      ),
    );
  }
}

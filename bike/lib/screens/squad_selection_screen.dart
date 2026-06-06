import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/rider_model.dart';
import '../providers/squad_provider.dart';
import '../providers/ride_provider.dart';
import 'role_selection_screen.dart';

class SquadSelectionScreen extends StatelessWidget {
  final VoidCallback onRideStarted;

  const SquadSelectionScreen({super.key, required this.onRideStarted});

  void _showCreateGroupDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Create Squad'),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.white),
            decoration: const InputDecoration(
              hintText: 'Squad name',
              hintStyle: TextStyle(color: AppColors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;
                final squadProvider = context.read<SquadProvider>();
                squadProvider.createGroup(name);
                final newGroup = squadProvider.activeGroup;
                if (newGroup != null) {
                  context.read<RideSetup>().setSelectedSquad(newGroup.id);
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RoleSelectionScreen(onRideStarted: onRideStarted),
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Join or Create Squad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SquadProvider>(
        builder: (context, squadProvider, _) {
          final squads = squadProvider.groups;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select an existing squad or create a new one to continue.',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _showCreateGroupDialog(context),
                      child: const Text('Create Squad'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (squads.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            size: 64,
                            color: AppColors.orange,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No squads yet',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a squad to start group rides',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      itemCount: squads.length,
                      itemBuilder: (context, index) {
                        final squad = squads[index];
                        return _SquadCard(
                          squad: squad,
                          onSelect: () {
                            context.read<RideSetup>().setSelectedSquad(
                              squad.id,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RoleSelectionScreen(
                                  onRideStarted: onRideStarted,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SquadCard extends StatelessWidget {
  final RiderGroup squad;
  final VoidCallback onSelect;

  const _SquadCard({required this.squad, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white, width: 1),
          boxShadow: [
            BoxShadow(color: AppColors.orange.withOpacity(0.08), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        squad.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${squad.members.length} members',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: squad.members.take(5).map((member) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    member.name,
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

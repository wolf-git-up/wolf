import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/squad_provider.dart';
import '../../models/rider_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/squad_widgets.dart';
import 'group_detail_screen.dart';

class SquadScreen extends StatefulWidget {
  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showCreateGroupDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.orange, width: 1.2),
        ),
        title: const Text(
          'Create New Group',
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Thunder Hawks',
            hintStyle: const TextStyle(color: AppColors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.greyDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.card,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                context.read<SquadProvider>().createGroup(ctrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Create',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog(BuildContext context, SquadProvider squad) {
    final groupName = squad.activeGroup?.name ?? 'Group';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Colors.red, width: 1.2),
        ),
        title: const Text(
          'Delete Group',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete "$groupName"? This action cannot be undone.',
          style: const TextStyle(color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (squad.activeGroup != null) {
                squad.deleteGroup(squad.activeGroup!.id);
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Squad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create Group',
            onPressed: () => _showCreateGroupDialog(context),
          ),
          Consumer<SquadProvider>(
            builder: (context, squad, _) {
              final canDelete =
                  squad.activeGroup != null &&
                  squad.activeGroup!.isLeader(squad.currentUserId);
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete Group',
                onPressed: canDelete
                    ? () => _showDeleteGroupDialog(context, squad)
                    : null,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<SquadProvider>(
        builder: (context, squad, _) {
          if (squad.groups.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: squad.groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final group = squad.groups[i];
              return _buildGroupCard(context, group, i);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.group_add),
        label: const Text(
          'New Group',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orangeGlow,
              border: Border.all(color: AppColors.orange, width: 1.5),
            ),
            child: const Icon(
              Icons.groups_outlined,
              color: AppColors.orange,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Groups Yet',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a group to manage your\nrider formation',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showCreateGroupDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'Create First Group',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, RiderGroup group, int index) {
    final isLeader =
        context.read<SquadProvider>().currentUserId == group.leaderId;

    return SlideTransition(
      position:
          Tween<Offset>(
            begin: Offset(0, 0.3 + index * 0.1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animController,
              curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(index * 0.1, 1.0),
          ),
        ),
        child: OrangeCard(
          onTap: () {
            context.read<SquadProvider>().setActiveGroup(group);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<SquadProvider>(),
                  child: GroupDetailScreen(groupId: group.id),
                ),
              ),
            );
          },
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.orangeGlow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups,
                      color: AppColors.orange,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${group.members.length} rider${group.members.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLeader)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangeGlow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.orange.withOpacity(0.5),
                        ),
                      ),
                      child: const Text(
                        '👑 LEADER',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: AppColors.grey),
                ],
              ),
              if (group.members.length > 1) ...[
                const SizedBox(height: 14),
                const Divider(color: AppColors.greyDark, height: 1),
                const SizedBox(height: 12),
                // Member avatar row
                SizedBox(
                  height: 40,
                  child: Stack(
                    children: [
                      for (int i = 0; i < group.members.length.clamp(0, 5); i++)
                        Positioned(
                          left: i * 28.0,
                          child: RiderAvatar(
                            rider: group.members[i],
                            size: 36,
                            showBadge: false,
                          ),
                        ),
                      if (group.members.length > 5)
                        Positioned(
                          left: 5 * 28.0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.greyDark,
                              border: Border.all(
                                color: AppColors.orange,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+${group.members.length - 5}',
                                style: const TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/squad_provider.dart';
import '../../models/rider_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/squad_widgets.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  RiderGroup? _getGroup(SquadProvider squad) {
    try {
      return squad.groups.firstWhere((g) => g.id == widget.groupId);
    } catch (_) {
      return null;
    }
  }

  void _showAddMemberDialog(BuildContext context) {
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
          'Add Rider',
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
            hintText: "Rider's name",
            hintStyle: const TextStyle(color: AppColors.grey),
            prefixIcon: const Icon(Icons.person_add, color: AppColors.orange),
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
                context.read<SquadProvider>().addMember(
                  widget.groupId,
                  ctrl.text.trim(),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showRolePickerSheet(
    BuildContext context,
    RiderGroup group,
    Rider rider,
  ) {
    final squad = context.read<SquadProvider>();
    final isCurrentUser = rider.id == squad.currentUserId;
    if (isCurrentUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are the group leader — your role cannot be changed.',
          ),
          backgroundColor: AppColors.surface,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.orange, width: 1),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  RiderAvatar(rider: rider, size: 44, showBadge: false),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rider.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Assign Position',
                          style: TextStyle(color: AppColors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.greyDark),
              const SizedBox(height: 12),
              // Role options (excluding leader which is reserved for current user)
              ...RiderRole.values
                  .where((r) => r != RiderRole.leader)
                  .map((role) => _roleOption(ctx, squad, group, rider, role)),
            ],
          ),
        );
      },
    );
  }

  Widget _roleOption(
    BuildContext ctx,
    SquadProvider squad,
    RiderGroup group,
    Rider rider,
    RiderRole role,
  ) {
    final isSelected = rider.role == role;
    return InkWell(
      onTap: () {
        squad.assignRole(group.id, rider.id, role);
        Navigator.pop(ctx);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangeGlow : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.greyDark,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(role.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.displayName,
                    style: TextStyle(
                      color: isSelected ? AppColors.orange : AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    _roleDescription(role),
                    style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.orange, size: 20),
          ],
        ),
      ),
    );
  }

  String _roleDescription(RiderRole role) {
    switch (role) {
      case RiderRole.leader:
        return 'Commands the group (reserved)';
      case RiderRole.coLeader:
        return 'Leads the front — position: LEAD';
      case RiderRole.guard:
        return 'Flanks after co-leader or before tail — GUARD';
      case RiderRole.midRider:
        return 'Rides in the middle of the pack — MID';
      case RiderRole.tail:
        return 'Closes the formation at the back — TAIL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SquadProvider>(
      builder: (context, squad, _) {
        final group = _getGroup(squad);
        if (group == null) {
          return const Scaffold(body: Center(child: Text('Group not found')));
        }
        final isLeader = squad.isCurrentUser(group.leaderId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(group.name),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.orange,
              labelColor: AppColors.orange,
              unselectedLabelColor: AppColors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              tabs: const [
                Tab(text: 'MEMBERS'),
                Tab(text: 'FORMATION'),
              ],
            ),
          ),
          floatingActionButton: isLeader
              ? FloatingActionButton(
                  onPressed: () => _showAddMemberDialog(context),
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.person_add),
                )
              : null,
          body: TabBarView(
            controller: _tabController,
            children: [
              _MembersTab(
                group: group,
                isLeader: isLeader,
                currentUserId: squad.currentUserId,
                onRoleTap: (rider) =>
                    _showRolePickerSheet(context, group, rider),
                onRemove: (rider) => squad.removeMember(group.id, rider.id),
              ),
              _FormationTab(group: group),
            ],
          ),
        );
      },
    );
  }
}

// Extension so we can call isCurrentUser on the provider
extension _SquadExt on SquadProvider {
  bool isCurrentUser(String id) => id == currentUserId;
}

// ─── Members Tab ──────────────────────────────────────────────────────────────

class _MembersTab extends StatelessWidget {
  final RiderGroup group;
  final bool isLeader;
  final String currentUserId;
  final void Function(Rider) onRoleTap;
  final void Function(Rider) onRemove;

  const _MembersTab({
    required this.group,
    required this.isLeader,
    required this.currentUserId,
    required this.onRoleTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (group.members.isEmpty) {
      return const Center(
        child: Text(
          'No members yet.',
          style: TextStyle(color: AppColors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: group.members.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final rider = group.members[i];
        final isSelf = rider.id == currentUserId;
        return OrangeCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              RiderAvatar(rider: rider, size: 50),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            rider.name,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelf) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orangeGlow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'YOU',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    RoleChip(role: rider.role, compact: true),
                  ],
                ),
              ),
              // Role change button — only leader, and not on self
              if (isLeader && !isSelf) ...[
                IconButton(
                  onPressed: () => onRoleTap(rider),
                  icon: const Icon(
                    Icons.swap_horiz,
                    color: AppColors.orange,
                    size: 22,
                  ),
                  tooltip: 'Change role',
                ),
                IconButton(
                  onPressed: () => _confirmRemove(context, rider),
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.danger.withOpacity(0.8),
                    size: 22,
                  ),
                  tooltip: 'Remove rider',
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _confirmRemove(BuildContext context, Rider rider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: AppColors.danger.withOpacity(0.5), width: 1),
        ),
        title: const Text(
          'Remove Rider?',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Remove ${rider.name} from the group?',
          style: const TextStyle(color: AppColors.grey),
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
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              onRemove(rider);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Remove',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Formation Tab ─────────────────────────────────────────────────────────

class _FormationTab extends StatelessWidget {
  final RiderGroup group;

  const _FormationTab({required this.group});

  @override
  Widget build(BuildContext context) {
    final formation = group.formationOrder;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Legend
          OrangeCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FORMATION LEGEND',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: RiderRole.values
                      .map((r) => RoleChip(role: r))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Direction arrow
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.greyDark)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.orangeGlow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.orange.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward, color: AppColors.orange, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'FRONT OF RIDE',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: Divider(color: AppColors.greyDark)),
            ],
          ),

          const SizedBox(height: 20),

          if (formation.isEmpty)
            const Text(
              'No riders in formation yet.',
              style: TextStyle(color: AppColors.grey),
            )
          else
            // Formation grid — 2 per row
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: formation.length,
              itemBuilder: (ctx, i) {
                final rider = formation[i];
                return OrangeCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '#${i + 1}',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RiderAvatar(rider: rider, size: 60),
                      const SizedBox(height: 10),
                      Text(
                        rider.name.split(' ').first,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      RoleChip(role: rider.role, compact: true),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 20),

          // Tail indicator
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.greyDark)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greyDark.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.greyDark, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_downward, color: AppColors.grey, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'BACK OF RIDE',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: Divider(color: AppColors.greyDark)),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/providers/kitchen_provider.dart';

class KitchenManagementSheet extends ConsumerWidget {
  const KitchenManagementSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final kitchensAsync = ref.watch(kitchensProvider);
    final activeKitchenId = ref.watch(activeKitchenIdProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getBackground(themeMode),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Kitchens",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(themeMode),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Display Loading/Error/Data
          Expanded(
            child: kitchensAsync.when(
              data: (kitchens) {
                if (kitchens.isEmpty) {
                  return const Center(child: Text("No kitchens found."));
                }
                return ListView.separated(
                  itemCount: kitchens.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final kitchen = kitchens[index];
                    final isActive = kitchen.id == activeKitchenId;
                    
                    return InkWell(
                      onTap: () {
                        ref.read(activeKitchenIdProvider.notifier).state = kitchen.id;
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isActive 
                              ? AppColors.getAccentTeal(themeMode).withOpacity(0.1) 
                              : AppColors.getCardBg(themeMode),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isActive 
                                ? AppColors.getAccentTeal(themeMode) 
                                : AppColors.getDivider(themeMode),
                            width: isActive ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.kitchen,
                                  color: isActive 
                                      ? AppColors.getAccentTeal(themeMode) 
                                      : AppColors.getTextSecondary(themeMode),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    kitchen.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.getTextPrimary(themeMode),
                                    ),
                                  ),
                                ),
                                if (isActive)
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.getAccentTeal(themeMode),
                                  )
                              ],
                            ),
                            if (isActive && kitchen.inviteCode != null) ...[
                              const SizedBox(height: 12),
                              Divider(color: AppColors.getDivider(themeMode)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "Invite Code: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.getTextSecondary(themeMode),
                                    ),
                                  ),
                                  Text(
                                    kitchen.inviteCode!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      color: AppColors.getTextPrimary(themeMode),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: kitchen.inviteCode!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invite code copied!')),
                                      );
                                    },
                                    icon: const Icon(Icons.copy, size: 14),
                                    label: const Text("Copy"),
                                  ),
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Show Join Dialog (To be implemented later if requested)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Join Kitchen coming soon')));
                  },
                  icon: const Icon(Icons.group_add),
                  label: const Text("Join"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // Show Create Dialog (To be implemented later if requested)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create Kitchen coming soon')));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create"),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.getAccentOrange(themeMode),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A single bottom-nav destination entry.
class AppShellDestination {
  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  const AppShellDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });
}

/// Shared scaffold: app bar + bottom nav bar.
/// Navigation logic is handled by the host app via callbacks.
class AppShell extends StatelessWidget {
  final Widget child;
  final String title;
  final List<AppShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback? onAboutTap;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onAboutTap != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'About',
              onPressed: onAboutTap,
            ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations.map((d) {
          return NavigationDestination(
            icon: d.icon,
            selectedIcon: d.selectedIcon ?? d.icon,
            label: d.label,
          );
        }).toList(),
      ),
    );
  }
}

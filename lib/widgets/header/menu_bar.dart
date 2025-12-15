// lib/widgets/menu_bar.dart (updated)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/app/app_routes.dart';
import 'package:my_app/utils/constants.dart';

class MenuBar extends StatefulWidget {
  final Function(String) onMenuSelect;
  final Function(Map<String, dynamic>)? onNotificationTap;
  final Function(String)? onSettingsAction;

  const MenuBar({
    super.key,
    required this.onMenuSelect,
    this.onNotificationTap,
    this.onSettingsAction,
  });

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  // Tracks which dropdown menu is open (if any). Not strictly required.
  final Map<String, LayerLink> _layerLinks = {};
  final Map<String, OverlayEntry?> _overlayEntries = {};
  final Map<String, Timer?> _hideTimers = {};

  // For notifications
  final LayerLink _notificationsLink = LayerLink();
  OverlayEntry? _notificationsOverlay;
  Timer? _notificationsHideTimer;
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Patient Ready',
      'message': 'Patient ANES-2025-001 is ready for surgery',
      'time': '10:30 AM',
      'read': false,
    },
    {
      'id': 2,
      'title': 'Lab Results',
      'message': 'Lab results for Patient ANES-2025-002 are available',
      'time': '09:45 AM',
      'read': false,
    },
    {
      'id': 3,
      'title': 'Drug Alert',
      'message': 'Propofol stock is running low (less than 10 vials)',
      'time': 'Yesterday',
      'read': true,
    },
    {
      'id': 4,
      'title': 'Schedule Update',
      'message': 'Emergency case added to OR 3 at 2:00 PM',
      'time': 'Yesterday',
      'read': true,
    },
  ];

  // For settings
  final LayerLink _settingsLink = LayerLink();
  OverlayEntry? _settingsOverlay;
  Timer? _settingsHideTimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Patient Menu
          _buildDropdownMenu(
            title: 'Patient',
            items: AppConstants.patientMenuItems,
          ),
          const SizedBox(width: 16),

          // Anaesthesia Menu
          _buildDropdownMenu(
            title: 'Anaesthesia',
            items: AppConstants.anesthesiaMenuItems,
          ),
          const SizedBox(width: 16),

          // Surgeon Menu
          _buildDropdownMenu(
            title: 'Surgeon',
            items: AppConstants.surgeonMenuItems,
          ),
          const SizedBox(width: 16),

          // Nurse Menu
          _buildDropdownMenu(
            title: 'Nurse',
            items: AppConstants.nurseMenuItems,
          ),

          const Spacer(),

          // Quick Actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  void _showOverlay(
    String title,
    List<Map<String, dynamic>> items,
    LayerLink link,
  ) {
    if (_overlayEntries[title] != null) return;

    final overlay = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 40.0),
          child: MouseRegion(
            onEnter: (_) {
              _cancelHideOverlay(title);
              setState(() {});
            },
            onExit: (_) => _scheduleHideOverlay(title),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 220,
                child: Material(
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: items.map((item) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.onMenuSelect(item['route'] as String);
                              _doHideOverlay(title);
                            },
                            onHover: (hovering) {
                              if (hovering) _cancelHideOverlay(title);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['label'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlay);
    _overlayEntries[title] = overlay;
    setState(() {});
  }

  void _showNotificationsOverlay() {
    if (_notificationsOverlay != null) return;

    _notificationsOverlay = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _notificationsLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0.0, 8.0), // Adjust position
          child: MouseRegion(
            onEnter: (_) => _cancelHideNotifications(),
            onExit: (_) => _scheduleHideNotifications(),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 320,
                child: Material(
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Notifications Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Badge.count(
                                count: _notifications
                                    .where((n) => !n['read'])
                                    .length,
                                textColor: Colors.white,
                                backgroundColor: Colors.red,
                                child: const SizedBox(width: 24),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  _markAllAsRead();
                                },
                                child: const Text(
                                  'Mark all read',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Notifications List
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              final notification = _notifications[index];
                              return Material(
                                color: notification['read']
                                    ? Colors.white
                                    : Colors.blue[50],
                                child: InkWell(
                                  onTap: () {
                                    _markAsRead(notification['id']);
                                    _showNotificationDetails(notification);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[100]!,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.only(top: 6),
                                          decoration: BoxDecoration(
                                            color: notification['read']
                                                ? Colors.transparent
                                                : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification['title'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      notification['read']
                                                      ? FontWeight.normal
                                                      : FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                notification['message'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                notification['time'],
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.more_vert,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            _showNotificationActions(
                                              notification['id'],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // View All Button
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey[100]!),
                            ),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                _hideNotificationsOverlay();
                                // Navigate to full notifications page
                              },
                              child: const Text('View All Notifications'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_notificationsOverlay!);
  }

  void _showSettingsOverlay() {
    if (_settingsOverlay != null) return;

    final settingsItems = [
      {
        'label': 'Preferences',
        'icon': Icons.settings,
        'route': AppRoutes.settings,
      },
      {
        'label': 'User Profile',
        'icon': Icons.person,
        'route': AppRoutes.profile,
      },
      {
        'label': 'Display Settings',
        'icon': Icons.display_settings,
        'route': AppRoutes.display,
      },
      {
        'label': 'Keyboard Shortcuts',
        'icon': Icons.keyboard,
        'route': AppRoutes.shortcuts,
      },
      {'label': 'About', 'icon': Icons.info, 'route': AppRoutes.about},
      {
        'label': 'Logout',
        'icon': Icons.logout,
        'route': AppRoutes.logout,
        'color': Colors.red,
      },
    ];

    _settingsOverlay = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _settingsLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0.0, 8.0), // Adjust position
          child: MouseRegion(
            onEnter: (_) => _cancelHideSettings(),
            onExit: (_) => _scheduleHideSettings(),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 200,
                child: Material(
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: settingsItems.map((item) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _hideSettingsOverlay();
                              widget.onMenuSelect(item['route'] as String);
                            },
                            onHover: (hovering) {
                              if (hovering) _cancelHideSettings();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item['icon'] as IconData?,
                                    size: 18,
                                    color:
                                        (item['color'] as Color?) ??
                                        Colors.grey[700],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item['label'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            (item['color'] as Color?) ??
                                            Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_settingsOverlay!);
  }

  void _hideNotificationsOverlay() {
    _notificationsOverlay?.remove();
    _notificationsOverlay = null;
    _cancelHideNotifications();
  }

  void _hideSettingsOverlay() {
    _settingsOverlay?.remove();
    _settingsOverlay = null;
    _cancelHideSettings();
  }

  void _scheduleHideNotifications() {
    _notificationsHideTimer?.cancel();
    _notificationsHideTimer = Timer(const Duration(milliseconds: 300), () {
      _hideNotificationsOverlay();
      _notificationsHideTimer = null;
    });
  }

  void _scheduleHideSettings() {
    _settingsHideTimer?.cancel();
    _settingsHideTimer = Timer(const Duration(milliseconds: 300), () {
      _hideSettingsOverlay();
      _settingsHideTimer = null;
    });
  }

  void _cancelHideNotifications() {
    _notificationsHideTimer?.cancel();
    _notificationsHideTimer = null;
  }

  void _cancelHideSettings() {
    _settingsHideTimer?.cancel();
    _settingsHideTimer = null;
  }

  void _markAsRead(int id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        _notifications[index]['read'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    _hideNotificationsOverlay();

    // Use callback if provided
    if (widget.onNotificationTap != null) {
      widget.onNotificationTap!(notification);
    } else {
      // Fallback to dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(notification['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['message']),
              const SizedBox(height: 16),
              Text(
                'Time: ${notification['time']}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  // Update settings action handlers
  void _handleSettingsItemTap(Map<String, dynamic> item) {
    _hideSettingsOverlay();

    // Use callback if provided
    if (widget.onSettingsAction != null) {
      widget.onSettingsAction!(item['route'] as String);
    } else {
      // Fallback to navigation
      widget.onMenuSelect(item['route'] as String);
    }
  }

  void _showNotificationActions(int id) {
    _hideNotificationsOverlay();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Actions'),
        content: const Text(
          'What would you like to do with this notification?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _markAsRead(id);
              Navigator.pop(context);
            },
            child: const Text('Mark as Read'),
          ),
          TextButton(
            onPressed: () {
              // Add to follow-up or other action
              Navigator.pop(context);
            },
            child: const Text('Follow Up'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownMenu({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    final link = _layerLinks.putIfAbsent(title, () => LayerLink());

    return MouseRegion(
      onEnter: (_) => _showOverlay(title, items, link),
      onExit: (_) => _scheduleHideOverlay(title),
      child: CompositedTransformTarget(
        link: link,
        child: TextButton(
          onPressed: () {
            _showOverlay(title, items, link);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            // Add shape property to control the background shape
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                4,
              ), // Slightly rounded corners
            ),
          ),
          child: Row(
            children: [
              Text(title),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _doHideOverlay(String title) {
    final entry = _overlayEntries.remove(title);
    if (entry != null) {
      entry.remove();
    }
    setState(() {});
  }

  // _hideOverlay alias removed; use _scheduleHideOverlay directly where needed.

  void _scheduleHideOverlay(
    String title, [
    Duration delay = const Duration(milliseconds: 300),
  ]) {
    _hideTimers[title]?.cancel();
    _hideTimers[title] = Timer(delay, () {
      _doHideOverlay(title);
      _hideTimers.remove(title);
    });
  }

  void _cancelHideOverlay(String title) {
    _hideTimers[title]?.cancel();
    _hideTimers.remove(title);
  }

  Widget _buildQuickActions() {
    final unreadCount = _notifications.where((n) => !n['read']).length;

    return Row(
      children: [
        // Notifications button with badge
        CompositedTransformTarget(
          link: _notificationsLink,
          child: MouseRegion(
            onEnter: (_) => _showNotificationsOverlay(),
            onExit: (_) => _scheduleHideNotifications(),
            child: IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, size: 22),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                if (_notificationsOverlay == null) {
                  _showNotificationsOverlay();
                } else {
                  _hideNotificationsOverlay();
                }
              },
              tooltip: 'Notifications',
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Settings button
        CompositedTransformTarget(
          link: _settingsLink,
          child: MouseRegion(
            onEnter: (_) => _showSettingsOverlay(),
            onExit: (_) => _scheduleHideSettings(),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 22),
              onPressed: () {
                if (_settingsOverlay == null) {
                  _showSettingsOverlay();
                } else {
                  _hideSettingsOverlay();
                }
              },
              tooltip: 'Settings',
            ),
          ),
        ),
        const SizedBox(width: 8),

        // User profile
        const CircleAvatar(
          radius: 14,
          backgroundColor: Color(0xFF4A90E2),
          child: Text(
            'DR',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. Myo Thiha',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              'Anaesthesiologist',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up all overlays
    for (final entry in _overlayEntries.values) {
      if (entry != null) entry.remove();
    }
    _overlayEntries.clear();

    _notificationsOverlay?.remove();
    _settingsOverlay?.remove();

    for (final timer in _hideTimers.values) {
      timer?.cancel();
    }
    _hideTimers.clear();

    super.dispose();
  }
}

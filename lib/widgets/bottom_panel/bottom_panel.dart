// lib/widgets/status_bar.dart (updated)
import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final String currentScreen;
  final DateTime lastUpdated;
  final bool isConnected;
  final String? userRole;

  const StatusBar({
    super.key,
    required this.currentScreen,
    required this.lastUpdated,
    this.isConnected = true,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Left side: Current screen info
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.desktop_windows,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Screen: $currentScreen',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (userRole != null) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRoleColor(userRole!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _getRoleColor(userRole!)),
                    ),
                    child: Text(
                      userRole!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getRoleColor(userRole!),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Right side: System status
          Row(
            children: [
              // Connection status
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isConnected ? 'Connected' : 'Disconnected',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              
              // System time
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    _formatTime(DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              
              // Version info
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.purple;
      case 'doctor':
        return Colors.blue;
      case 'nurse':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
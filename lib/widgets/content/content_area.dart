import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';
import 'anaesthesia_content.dart';
import 'intraop_content.dart';
import 'recovery_content.dart';
import 'notes_content.dart';

class ContentArea extends StatefulWidget {
  final String activeTab;

  const ContentArea({super.key, required this.activeTab});

  @override
  State<ContentArea> createState() => _ContentAreaState();
}

class _ContentAreaState extends State<ContentArea> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildTabNavigation(),
                Expanded(child: _buildActiveTabContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      color: Colors.white,
      child: Row(
        children: AppConstants.tabs.map((tab) {
          bool isActive = widget.activeTab == tab['id'];
          return Expanded(
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  // Handle tab change via parent
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isActive
                            ? const Color(0xFF4A90E2)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tab['label']!,
                      style: TextStyle(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF4A90E2)
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (widget.activeTab) {
      case 'anaesthesia':
        return const AnaesthesiaContent();
      case 'intraop':
        return const IntraopContent();
      case 'recovery':
        return const RecoveryContent();
      case 'notes':
        return const NotesContent();
      default:
        return const AnaesthesiaContent();
    }
  }
}

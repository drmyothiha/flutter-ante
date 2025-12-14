import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';

class ProgressSidebar extends StatefulWidget {
  const ProgressSidebar({super.key});

  @override
  State<ProgressSidebar> createState() => _ProgressSidebarState();
}

class _ProgressSidebarState extends State<ProgressSidebar> {
  String _selectedTab = 'Progress';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(child: _buildProgressTable()),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Properties',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          IconButton(
            icon: const Text('⋯'),
            onPressed: () => _showPropertiesMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTable() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: ListView.builder(
              itemCount: AppConstants.progressNotes.length,
              itemBuilder: (context, index) {
                final note = AppConstants.progressNotes[index];
                return Container(
                  decoration: BoxDecoration(
                    color: note['highlighted'] == true
                        ? const Color(0xFFFFF3CD)
                        : index.isEven
                        ? const Color(0xFFFAFAFA)
                        : Colors.white,
                    border: note['highlighted'] == true
                        ? const Border(
                            left: BorderSide(
                              color: Color(0xFFFFC107),
                              width: 3,
                            ),
                          )
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                note['id'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFFD0D0D0),
                              margin: const EdgeInsets.only(right: 10),
                            ),
                            Expanded(
                              child: Text(
                                note['text'],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    final List<String> tabs = ['Progress', 'Remark', 'ok', 'bb'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        border: const Border(bottom: BorderSide(color: Color(0xFFC0C0C0))),
      ),
      child: Row(
        children: tabs.map((tab) {
          bool isActive = _selectedTab == tab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF4A90E2) : Colors.transparent,
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF3A7BC8)
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                tab,
                style: TextStyle(color: isActive ? Colors.white : Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showPropertiesMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Properties Menu'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Properties'),
            Text('Configure Layout'),
            Text('Export Data'),
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

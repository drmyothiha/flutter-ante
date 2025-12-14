import 'package:flutter/material.dart';

class BottomPanel extends StatefulWidget {
  final Function(String) onEventAdded;
  final Function(String) onDrugLogged;

  const BottomPanel({
    super.key,
    required this.onEventAdded,
    required this.onDrugLogged,
  });

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _drugController = TextEditingController();
  final FocusNode _eventFocusNode = FocusNode();
  final FocusNode _drugFocusNode = FocusNode();

  @override
  void dispose() {
    _eventController.dispose();
    _drugController.dispose();
    _eventFocusNode.dispose();
    _drugFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark 
      ? const Color(0xFF1E1E1E) 
      : const Color(0xFFF5F5F7);
    final Color borderColor = isDark 
      ? const Color(0xFF383838) 
      : const Color(0xFFC7C7CC);
    final Color activeBorderColor = isDark 
      ? const Color(0xFF0A84FF) 
      : const Color(0xFF007AFF);
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color hintColor = isDark 
      ? Colors.white.withOpacity(0.4) 
      : Colors.black.withOpacity(0.3);

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Status Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              border: Border.all(
                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Recording',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Event Input
          Expanded(
            child: _buildInputField(
              controller: _eventController,
              focusNode: _eventFocusNode,
              label: 'Event',
              hintText: 'Enter event...',
              isDark: isDark,
              borderColor: borderColor,
              activeBorderColor: activeBorderColor,
              textColor: textColor,
              hintColor: hintColor,
              onSubmit: _addEvent,
              buttonLabel: 'Add',
              buttonColor: const Color(0xFF007AFF),
            ),
          ),
          const SizedBox(width: 12),

          // Drug Input
          Expanded(
            child: _buildInputField(
              controller: _drugController,
              focusNode: _drugFocusNode,
              label: 'Drug',
              hintText: 'Enter drug & dose...',
              isDark: isDark,
              borderColor: borderColor,
              activeBorderColor: const Color(0xFF34C759),
              textColor: textColor,
              hintColor: hintColor,
              onSubmit: _logDrug,
              buttonLabel: 'Log',
              buttonColor: const Color(0xFF34C759),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hintText,
    required bool isDark,
    required Color borderColor,
    required Color activeBorderColor,
    required Color textColor,
    required Color hintColor,
    required Function(String) onSubmit,
    required String buttonLabel,
    required Color buttonColor,
  }) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        border: Border.all(
          color: focusNode.hasFocus ? activeBorderColor : borderColor,
          width: focusNode.hasFocus ? 1.0 : 0.5,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: hintColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
                onSubmitted: onSubmit,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 16,
            color: focusNode.hasFocus ? activeBorderColor : borderColor,
          ),
          SizedBox(
            width: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSubmit(controller.text),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: focusNode.hasFocus 
                        ? buttonColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      buttonLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: focusNode.hasFocus 
                            ? buttonColor 
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addEvent(String value) {
    if (value.trim().isNotEmpty) {
      widget.onEventAdded(value);
      _eventController.clear();
      _eventFocusNode.unfocus();
      _showToast('Event recorded', icon: Icons.check);
    }
  }

  void _logDrug(String value) {
    if (value.trim().isNotEmpty) {
      widget.onDrugLogged(value);
      _drugController.clear();
      _drugFocusNode.unfocus();
      _showToast('Drug logged', icon: Icons.medication);
    }
  }

  void _showToast(String message, {required IconData icon}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: MediaQuery.of(context).size.width / 2 - 80,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
import 'package:flutter/material.dart';
import 'menu_bar.dart' as local_menu;
import 'package:my_app/services/local_storage_service.dart';

class AppHeader extends StatefulWidget {
  final Function(String) onMenuSelect;
  final String currentTime;

  const AppHeader({
    super.key,
    required this.onMenuSelect,
    required this.currentTime,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  String? _selectedButtonGroup = 'file';
  String? _selectedPatientButton;
  String? _selectedMedicalButton;
  String? _selectedDocumentButton;
  String? _selectedToolButton;
  bool _showMedicalToolbar = false;
  
  // Store active patient data
  Map<String, dynamic>? _activePatientData;
  String _patientName = 'No Active Patient';
  String _patientId = 'N/A';
  String _doctorName = 'N/A';
  String _procedure = 'N/A';
  String _surgeon = 'N/A';

  @override
  void initState() {
    super.initState();
    _loadActivePatientData();
  }

  void _loadActivePatientData() {
    // Get active patient from local storage
    final activePatient = LocalStorageService.getActivePatient();
    
    if (activePatient != null) {
      setState(() {
        _activePatientData = activePatient.patientData;
        _patientName = activePatient.patientName;
        _patientId = activePatient.patientId;
        _doctorName = activePatient.doctorName;
        _procedure = activePatient.procedureCode;
        
        // Extract surgeon from participants if available
        final participants = activePatient.patientData['participants'] as List?;
        if (participants != null) {
          for (var participant in participants) {
            if (participant is Map && 
                participant['actor'] is Map &&
                (participant['actor']['reference'] as String?)?.contains('Practitioner') == true) {
              _surgeon = participant['actor']['display']?.toString() ?? 'N/A';
              break;
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Window controls (optional for desktop)
        //_buildWindowControls(),
        // Menu bar
        local_menu.MenuBar(onMenuSelect: widget.onMenuSelect),
        // Single Toolbar Actions Row with everything combined
        _buildCombinedToolbar(),
        // Medical Toolbar buttons (hidden by default, shown on click)
        if (_showMedicalToolbar) _buildMedicalToolbar(),
      ],
    );
  }

  Widget _buildWindowControls() {
    return Container(
      height: 40,
      color: const Color(0xFFEEF1F4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5F57),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFFFBD2E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF2ECC71),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedToolbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCFD9DE)),
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.save,
                          label: 'Save',
                          color: Colors.green,
                          onTap: () => _performAction('file', 'save'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildInfoField(
                                label: 'PID',
                                value: _patientId,
                                showIcon: true,
                                icon: Icons.fingerprint_outlined,
                              ),
                              _buildInfoField(
                                label: 'Procedure',
                                value: _procedure,
                                showIcon: true,
                                icon: Icons.medical_services_outlined,
                                isProcedure: true,
                              ),
                              _buildInfoField(
                                label: 'Surgeon',
                                value: _surgeon,
                                showIcon: true,
                                icon: Icons.badge_outlined,
                              ),
                              _buildInfoField(
                                label: 'Patient',
                                value: _patientName,
                                showIcon: true,
                                icon: Icons.person_outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStartTimeField(),
                        const SizedBox(width: 16),
                        _buildToggleToolsButton(),
                        const SizedBox(width: 8),
                        _buildEmergencyButton(),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    // Save button
                    _buildActionButton(
                      icon: Icons.save,
                      label: 'Save',
                      color: Colors.green,
                      onTap: () => _performAction('file', 'save'),
                    ),
                    const SizedBox(width: 16),

                    // Patient ID
                    _buildInfoField(
                      label: 'PID',
                      value: _patientId,
                      showIcon: true,
                      icon: Icons.fingerprint_outlined,
                    ),
                    const SizedBox(width: 12),

                    // Procedure
                    _buildInfoField(
                      label: 'Procedure',
                      value: _procedure,
                      showIcon: true,
                      icon: Icons.medical_services_outlined,
                      isProcedure: true,
                    ),
                    const SizedBox(width: 12),

                    // Surgeon
                    _buildInfoField(
                      label: 'Surgeon',
                      value: _surgeon,
                      showIcon: true,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(width: 12),

                    // Patient Name
                    _buildInfoField(
                      label: 'Patient',
                      value: _patientName,
                      showIcon: true,
                      icon: Icons.person_outline,
                    ),

                    // Spacer
                    const Spacer(),

                    // Start Time (stuck to the right)
                    _buildStartTimeField(),

                    const SizedBox(width: 16),

                    // Refresh patient data button
                    if (_activePatientData != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Tooltip(
                          message: 'Refresh patient data',
                          child: IconButton(
                            icon: const Icon(Icons.refresh, size: 16),
                            onPressed: () {
                              _loadActivePatientData();
                              _showSnackbar('Patient data refreshed');
                            },
                            color: Colors.blue,
                          ),
                        ),
                      ),

                    // Toggle Tools Button
                    _buildToggleToolsButton(),

                    const SizedBox(width: 8),

                    // Emergency button
                    _buildEmergencyButton(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5),
            border: Border.all(color: const Color(0xFFCFD9DE)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    bool showIcon = false,
    IconData? icon,
    bool isProcedure = false,
  }) {
    // Highlight if no patient is selected
    final bool isEmpty = value == 'No Active Patient' || value == 'N/A';
    
    return Tooltip(
      message: isEmpty ? 'Click to select a patient from OT List' : '$label: $value',
      child: GestureDetector(
        onTap: isEmpty ? () => _navigateToOTList(context) : null,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isEmpty 
              ? const Color(0xFFF5F5F5)
              : isProcedure 
                ? const Color(0xFFFEF2F2) 
                : const Color(0xFFF8FAFF),
            border: Border.all(
              color: isEmpty
                ? const Color(0xFFE0E0E0)
                : isProcedure
                  ? const Color(0xFFFECACA)
                  : const Color(0xFFE3F2FD),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon && icon != null)
                Icon(
                  icon,
                  size: 12,
                  color: isEmpty
                    ? Colors.grey
                    : isProcedure
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF5C6B7A),
                ),
              if (showIcon && icon != null) const SizedBox(width: 6),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isEmpty
                        ? Colors.grey
                        : isProcedure
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF5C6B7A),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isEmpty
                        ? Colors.grey
                        : isProcedure
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
              if (isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.info_outline,
                    size: 10,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartTimeField() {
    // Get start time from active patient if available
    String displayTime = widget.currentTime;
    if (_activePatientData?['start'] != null) {
      try {
        final startTime = DateTime.parse(_activePatientData!['start'].toString());
        displayTime = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        print('Error parsing start time: $e');
      }
    }

    return Tooltip(
      message: 'Surgery Start Time',
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          border: Border.all(color: const Color(0xFFC8E6C9)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow, size: 14, color: Color(0xFF2E7D32)),
            const SizedBox(width: 6),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Start Time',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleToolsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _showMedicalToolbar = !_showMedicalToolbar;
          });
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _showMedicalToolbar
                ? const Color(0xFF4A90E2)
                : const Color(0xFFF0F2F5),
            border: Border.all(
              color: _showMedicalToolbar
                  ? const Color(0xFF3A7BC8)
                  : const Color(0xFFCFD9DE),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showMedicalToolbar
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                size: 16,
                color: _showMedicalToolbar ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 4),
              Text(
                _showMedicalToolbar ? 'Hide Tools' : 'Show Tools',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _showMedicalToolbar ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showEmergencyDialog,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            border: Border.all(color: const Color(0xFFFECACA)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, size: 14, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                'Emergency',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // File Operations Group
          _buildButtonGroup(
            title: 'File',
            isSelected: _selectedButtonGroup == 'file',
            onPressed: () => _selectButtonGroup('file'),
            buttons: [
              _buildToolbarButton(
                label: 'Save',
                icon: Icons.save,
                isSelected: _selectedPatientButton == 'save',
                onPressed: () => _handleButtonPress('save', 'file'),
                color: Colors.green,
              ),
              _buildToolbarButton(
                label: 'Export',
                icon: Icons.download,
                isSelected: _selectedPatientButton == 'export',
                onPressed: () => _handleButtonPress('export', 'file'),
                color: Colors.blue,
              ),
              _buildToolbarButton(
                label: 'Print',
                icon: Icons.print,
                isSelected: _selectedPatientButton == 'print',
                onPressed: () => _handleButtonPress('print', 'file'),
                color: Colors.purple,
              ),
              _buildToolbarButton(
                label: 'New',
                icon: Icons.note_add,
                isSelected: _selectedPatientButton == 'new',
                onPressed: () => _handleButtonPress('new', 'file'),
                color: Colors.teal,
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Patient Information Group
          _buildButtonGroup(
            title: 'Patient',
            isSelected: _selectedButtonGroup == 'patient',
            onPressed: () => _selectButtonGroup('patient'),
            buttons: [
              _buildToolbarButton(
                label: 'Info',
                icon: Icons.person,
                isSelected: _selectedPatientButton == 'info',
                onPressed: () => _handleButtonPress('info', 'patient'),
                color: Colors.blue[700]!,
              ),
              _buildToolbarButton(
                label: 'History',
                icon: Icons.history,
                isSelected: _selectedPatientButton == 'history',
                onPressed: () => _handleButtonPress('history', 'patient'),
                color: Colors.orange,
              ),
              _buildToolbarButton(
                label: 'Consent',
                icon: Icons.assignment,
                isSelected: _selectedPatientButton == 'consent',
                onPressed: () => _handleButtonPress('consent', 'patient'),
                color: Colors.deepPurple,
              ),
              _buildToolbarButton(
                label: 'Admission',
                icon: Icons.medical_services,
                isSelected: _selectedPatientButton == 'admission',
                onPressed: () => _handleButtonPress('admission', 'patient'),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Medical Data Group
          _buildButtonGroup(
            title: 'Medical',
            isSelected: _selectedButtonGroup == 'medical',
            onPressed: () => _selectButtonGroup('medical'),
            buttons: [
              _buildToolbarButton(
                label: 'Vitals',
                icon: Icons.monitor_heart,
                isSelected: _selectedMedicalButton == 'vitals',
                onPressed: () => _handleButtonPress('vitals', 'medical'),
                color: Colors.red,
              ),
              _buildToolbarButton(
                label: 'Lab',
                icon: Icons.science,
                isSelected: _selectedMedicalButton == 'lab',
                onPressed: () => _handleButtonPress('lab', 'medical'),
                color: Colors.orange,
              ),
              _buildToolbarButton(
                label: 'Imaging',
                icon: Icons.photo,
                isSelected: _selectedMedicalButton == 'imaging',
                onPressed: () => _handleButtonPress('imaging', 'medical'),
                color: Colors.green,
              ),
              _buildToolbarButton(
                label: 'ECG',
                icon: Icons.heart_broken,
                isSelected: _selectedMedicalButton == 'ecg',
                onPressed: () => _handleButtonPress('ecg', 'medical'),
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Documentation Group
          _buildButtonGroup(
            title: 'Document',
            isSelected: _selectedButtonGroup == 'document',
            onPressed: () => _selectButtonGroup('document'),
            buttons: [
              _buildToolbarButton(
                label: 'Notes',
                icon: Icons.note,
                isSelected: _selectedDocumentButton == 'notes',
                onPressed: () => _handleButtonPress('notes', 'document'),
                color: Colors.brown,
              ),
              _buildToolbarButton(
                label: 'Reports',
                icon: Icons.description,
                isSelected: _selectedDocumentButton == 'reports',
                onPressed: () => _handleButtonPress('reports', 'document'),
                color: Colors.indigo,
              ),
              _buildToolbarButton(
                label: 'Orders',
                icon: Icons.list_alt,
                isSelected: _selectedDocumentButton == 'orders',
                onPressed: () => _handleButtonPress('orders', 'document'),
                color: Colors.blueGrey,
              ),
              _buildToolbarButton(
                label: 'Charts',
                icon: Icons.bar_chart,
                isSelected: _selectedDocumentButton == 'charts',
                onPressed: () => _handleButtonPress('charts', 'document'),
                color: Colors.cyan,
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Tools Group
          _buildButtonGroup(
            title: 'Tools',
            isSelected: _selectedButtonGroup == 'tools',
            onPressed: () => _selectButtonGroup('tools'),
            buttons: [
              _buildToolbarButton(
                label: 'Calculator',
                icon: Icons.calculate,
                isSelected: _selectedToolButton == 'calculator',
                onPressed: () => _handleButtonPress('calculator', 'tools'),
                color: Colors.deepOrange,
              ),
              _buildToolbarButton(
                label: 'Timer',
                icon: Icons.timer,
                isSelected: _selectedToolButton == 'timer',
                onPressed: () => _handleButtonPress('timer', 'tools'),
                color: Colors.pink,
              ),
              _buildToolbarButton(
                label: 'Doses',
                icon: Icons.medication,
                isSelected: _selectedToolButton == 'doses',
                onPressed: () => _handleButtonPress('doses', 'tools'),
                color: Colors.green[700]!,
              ),
              _buildToolbarButton(
                label: 'Convert',
                icon: Icons.change_circle,
                isSelected: _selectedToolButton == 'convert',
                onPressed: () => _handleButtonPress('convert', 'tools'),
                color: Colors.lightBlue,
              ),
            ],
          ),

          const Spacer(),

          // Clear active patient button
          if (_activePatientData != null)
            Tooltip(
              message: 'Clear active patient',
              child: IconButton(
                icon: const Icon(Icons.person_remove, size: 18),
                onPressed: () {
                  _clearActivePatient();
                },
              ),
            ),

          // Close toolbar button
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              setState(() {
                _showMedicalToolbar = false;
              });
            },
            tooltip: 'Close toolbar',
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGroup({
    required String title,
    required bool isSelected,
    required VoidCallback onPressed,
    required List<Widget> buttons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.grey[50],
        border: Border.all(
          color: isSelected ? Colors.blue[200]! : Colors.grey[300]!,
          width: isSelected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Title
          InkWell(
            onTap: onPressed,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[100] : Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue[800] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: isSelected ? Colors.blue[800] : Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),
          // Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: buttons),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: isSelected ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? color : Colors.grey[700],
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? color : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectButtonGroup(String group) {
    setState(() {
      _selectedButtonGroup = group;
    });
  }

  void _handleButtonPress(String button, String group) {
    setState(() {
      _selectedButtonGroup = group;
      switch (group) {
        case 'file':
          _selectedPatientButton = button;
          break;
        case 'patient':
          _selectedPatientButton = button;
          break;
        case 'medical':
          _selectedMedicalButton = button;
          break;
        case 'document':
          _selectedDocumentButton = button;
          break;
        case 'tools':
          _selectedToolButton = button;
          break;
      }
    });

    // Handle button actions
    _performAction(group, button);
  }

  void _performAction(String group, String button) {
    String action = '';

    switch (group) {
      case 'file':
        switch (button) {
          case 'save':
            action = 'Saving patient data...';
            break;
          case 'export':
            action = 'Exporting patient records...';
            break;
          case 'print':
            action = 'Printing patient information...';
            break;
          case 'new':
            action = 'Creating new patient record...';
            break;
        }
        break;
      case 'patient':
        switch (button) {
          case 'info':
            action = 'Opening patient information...';
            break;
          case 'history':
            action = 'Loading medical history...';
            break;
          case 'consent':
            action = 'Viewing consent forms...';
            break;
          case 'admission':
            action = 'Checking admission details...';
            break;
        }
        break;
      case 'medical':
        switch (button) {
          case 'vitals':
            action = 'Showing vital signs...';
            break;
          case 'lab':
            action = 'Loading lab results...';
            break;
          case 'imaging':
            action = 'Opening imaging studies...';
            break;
          case 'ecg':
            action = 'Displaying ECG...';
            break;
        }
        break;
      case 'document':
        switch (button) {
          case 'notes':
            action = 'Opening clinical notes...';
            break;
          case 'reports':
            action = 'Viewing reports...';
            break;
          case 'orders':
            action = 'Showing medical orders...';
            break;
          case 'charts':
            action = 'Displaying charts...';
            break;
        }
        break;
      case 'tools':
        switch (button) {
          case 'calculator':
            action = 'Opening medical calculator...';
            break;
          case 'timer':
            action = 'Starting surgery timer...';
            break;
          case 'doses':
            action = 'Calculating drug doses...';
            break;
          case 'convert':
            action = 'Opening unit converter...';
            break;
        }
        break;
    }

    _showSnackbar(action);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Protocol'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_activePatientData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Patient: $_patientName', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('ID: $_patientId'),
                  const SizedBox(height: 12),
                ],
              ),
            const Text('Emergency actions available:'),
            const SizedBox(height: 8),
            const Text('• Call Code Blue Team'),
            const Text('• Request Emergency Drugs'),
            const Text('• Activate Rapid Response'),
            const Text('• Emergency Ventilation'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('Emergency team notified for $_patientName!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Call Code Blue'),
          ),
        ],
      ),
    );
  }

  void _clearActivePatient() {
    if (_activePatientData != null) {
      LocalStorageService.removeActivePatient(_patientId);
      setState(() {
        _activePatientData = null;
        _patientName = 'No Active Patient';
        _patientId = 'N/A';
        _doctorName = 'N/A';
        _procedure = 'N/A';
        _surgeon = 'N/A';
      });
      _showSnackbar('Active patient cleared');
    }
  }

  void _navigateToOTList(BuildContext context) {
    // Use the onMenuSelect callback to navigate to OT List
    widget.onMenuSelect('/ot-list');
  }

  // Call this method from other screens when patient is selected
  void updateActivePatient() {
    _loadActivePatientData();
  }
}
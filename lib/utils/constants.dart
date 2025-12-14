import '../app/app_routes.dart';

class AppConstants {
  // Progress notes data
  static const List<Map<String, dynamic>> progressNotes = [
    {
      'id': 1,
      'text':
          'Antibiotics : Flumarin iv, 500mg(Flomoxef)/1g/IV (AST : negative)',
    },
    {
      'id': 2,
      'text':
          'Multiple monitoring start (SPO2, ECG, NIBP, ETCO2, BIS) & Preoxygenation',
    },
    {
      'id': 3,
      'text': 'Remifentanil 2mg mix to N/S total 60mL via infusion pump',
    },
    {
      'id': 4,
      'text':
          'Endotracheal tube #8 (cuff+) orotracheal intubation, Forced-air warming system (3M Bair Hugger) apply',
    },
    {
      'id': 5,
      'text': 'Esophageal stethoscope insertion : body temperature monitoring',
    },
    {'id': 6, 'text': 'LT. external jugular vein cannulation 16G'},
    {'id': 7, 'text': 'Patient warming blanket (Gamar Medi-Therm III) apply'},
    {'id': 8, 'text': 'CVP monitoring start', 'highlighted': true},
    {'id': 9, 'text': 'VBG&Arf'},
    {
      'id': 10,
      'text': 'Dopamine 200mg mix to N/S total 50mL via infusion pump',
    },
    {
      'id': 11,
      'text':
          'Antibiotics : Flumarin iv, 500mg(Flomoxef)/1g/IV (AST : negative)',
    },
    {'id': 12, 'text': 'Methylprednisolone 250mg IV'},
    {'id': 13, 'text': 'Renal artery declamping at :'},
    {'id': 14, 'text': ''},
    {'id': 15, 'text': ''},
    {'id': 16, 'text': ''},
    {'id': 17, 'text': ''},
    {'id': 18, 'text': ''},
  ];

  // Tab definitions
  static const List<Map<String, String>> tabs = [
    {'id': 'anaesthesia', 'label': 'Anaesthesia Management'},
    {'id': 'intraop', 'label': 'Intraop Management'},
    {'id': 'recovery', 'label': 'Recovery'},
    {'id': 'notes', 'label': 'Surgical Notes'},
  ];

  // Menu items
  static const List<Map<String, dynamic>> patientMenuItems = [
    {'label': 'OT List', 'route': AppRoutes.otList},
    {'label': 'OT Information', 'route': AppRoutes.otInformation},
    {'label': 'Hand out form', 'route': AppRoutes.handOutForm},
  ];

  static const List<Map<String, dynamic>> anesthesiaMenuItems = [
    {'label': 'Preop Assessment', 'route': AppRoutes.preopAssessment},
    {'label': 'PreOP', 'route': '/'},
    {'label': 'Induction', 'route': AppRoutes.induction},
    {'label': 'Maintenance', 'route': AppRoutes.maintenance},
    {'label': 'Monitoring', 'route': AppRoutes.monitoring},
    {'label': 'Recovery', 'route': AppRoutes.recovery},
  ];

  static const List<Map<String, dynamic>> surgeonMenuItems = [
    {'label': 'Surgery Notes', 'route': AppRoutes.surgeryNotes},
    {'label': 'Treatments', 'route': AppRoutes.treatments},
  ];

  static const List<Map<String, dynamic>> nurseMenuItems = [
    {'label': 'WHO Checklist', 'route': AppRoutes.whoChecklist},
    {'label': 'Drugs List', 'route': AppRoutes.drugsList},
  ];
}
// Add this to your constants.dart file
class NotificationConstants {
  static List<Map<String, dynamic>> get demoNotifications => [
    {
      'id': 1,
      'title': 'Patient Ready',
      'message': 'Patient ANES-2025-001 is ready for surgery',
      'time': '10:30 AM',
      'read': false,
      'type': 'patient',
    },
    {
      'id': 2,
      'title': 'Lab Results',
      'message': 'Lab results for Patient ANES-2025-002 are available',
      'time': '09:45 AM',
      'read': false,
      'type': 'lab',
    },
    {
      'id': 3,
      'title': 'Drug Alert',
      'message': 'Propofol stock is running low (less than 10 vials)',
      'time': 'Yesterday',
      'read': true,
      'type': 'inventory',
    },
    {
      'id': 4,
      'title': 'Schedule Update',
      'message': 'Emergency case added to OR 3 at 2:00 PM',
      'time': 'Yesterday',
      'read': true,
      'type': 'schedule',
    },
    {
      'id': 5,
      'title': 'Equipment Maintenance',
      'message': 'Anesthesia machine #3 requires calibration',
      'time': '2 days ago',
      'read': true,
      'type': 'equipment',
    },
  ];
}
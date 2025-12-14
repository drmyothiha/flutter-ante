import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/anesthesia_tabs/preop_assessment.dart';
import '../screens/anesthesia_tabs/induction.dart';
import '../screens/anesthesia_tabs/maintenance.dart';
import '../screens/anesthesia_tabs/monitoring.dart';
import '../screens/anesthesia_tabs/recovery.dart';
import '../screens/surgeon_tabs/surgery_notes.dart';
import '../screens/surgeon_tabs/treatments.dart';
import '../screens/nurse_tabs/who_checklist.dart';
import '../screens/nurse_tabs/drugs_list.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/profile_screen.dart';
import '../screens/settings/display_screen.dart';
import '../screens/settings/shortcuts_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/logout_screen.dart';
import '../screens/patient/ot_list_screen.dart';
import '../screens/patient/ot_information_screen.dart';
import '../screens/patient/hand_out_form_screen.dart';

class AppRoutes {
  static const home = '/';
  static const preopAssessment = '/preop-assessment';
  static const induction = '/induction';
  static const maintenance = '/maintenance';
  static const monitoring = '/monitoring';
  static const recovery = '/recovery';
  static const surgeryNotes = '/surgery-notes';
  static const treatments = '/treatments';
  static const whoChecklist = '/who-checklist';
  static const drugsList = '/drugs-list';
  static const otList = '/ot-list';
  static const otInformation = '/ot-information';
  static const handOutForm = '/hand-out-form';
  static const settings = '/settings';
  static const profile = '/profile';
  static const display = '/display';
  static const shortcuts = '/shortcuts';
  static const about = '/about';
  static const logout = '/logout';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      preopAssessment: (context) => const PreopAssessmentScreen(),
      induction: (context) => const InductionScreen(),
      maintenance: (context) => const MaintenanceScreen(),
      monitoring: (context) => const MonitoringScreen(),
      recovery: (context) => const RecoveryScreen(),
      surgeryNotes: (context) => const SurgeryNotesScreen(),
      treatments: (context) => const TreatmentsScreen(),
      whoChecklist: (context) => const WhoChecklistScreen(),
      drugsList: (context) => const DrugsListScreen(),
      otList: (context) => const OtListScreen(),
      otInformation: (context) => const OtInformationScreen(),
      handOutForm: (context) => const HandOutFormScreen(),
      settings: (context) => const SettingsScreen(),
      profile: (context) => const ProfileScreen(),
      display: (context) => const DisplayScreen(),
      shortcuts: (context) => const ShortcutsScreen(),
      about: (context) => const AboutScreen(),
      logout: (context) => const LogoutScreen(),
    };
  }
}

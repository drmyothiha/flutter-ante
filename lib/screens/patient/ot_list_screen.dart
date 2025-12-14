// lib/screens/ot_list_screen.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/ot_list_model.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/local_storage_service.dart';
import 'package:my_app/screens/patient/active_patient_screen.dart';

class OtListScreen extends StatefulWidget {
  const OtListScreen({super.key});

  @override
  State<OtListScreen> createState() => _OtListScreenState();
}

class _OtListScreenState extends State<OtListScreen> {
  final ApiService _apiService = ApiService();
  late Future<OtListResponse> _otListFuture;
  
  @override
  void initState() {
    super.initState();
    _otListFuture = _fetchOtList();
  }

  Future<OtListResponse> _fetchOtList() async {
    return await _apiService.getOtList();
  }

  Future<void> _setPatientAsActive(OtAppointment appointment) async {
    try {
      // Convert appointment to JSON
      final appointmentJson = {
        'id': appointment.id,
        'resourceType': appointment.resourceType,
        'status': appointment.status,
        'start': appointment.start.toIso8601String(),
        'end': appointment.end.toIso8601String(),
        'patientName': appointment.patientName,
        'doctorName': appointment.doctorName,
        'diagnosis': appointment.diagnosis,
        'procedureCode': appointment.procedureCode,
        'participants': appointment.participants.map((p) => {
          'actor': {
            'reference': p.reference,
            'display': p.display,
          },
          'status': p.status,
          'required': p.required,
        }).toList(),
        'created_at': appointment.createdAt.toIso8601String(),
      };
      
      // Save to local storage
      await LocalStorageService.setPatientAsActive(appointmentJson);
      
      // Navigate to active patient screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ActivePatientScreen(
            patientData: appointmentJson,
          ),
        ),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${appointment.patientName} set as active patient'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set patient as active: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Build DataRow from appointment
  DataRow _buildDataRow(OtAppointment appointment) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            appointment.patientName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(Text(appointment.doctorName)),
        DataCell(Text(appointment.formattedDate)),
        DataCell(Text(appointment.formattedTime)),
        DataCell(
          Container(
            padding: const EdgeInsets.all(4),
            child: ElevatedButton.icon(
              onPressed: () => _setPatientAsActive(appointment),
              icon: const Icon(Icons.medical_services, size: 16),
              label: const Text('Set Active'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build table with DataRows
  Widget _buildDataTable(List<OtAppointment> appointments) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Patient Name')),
          DataColumn(label: Text('Doctor')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Action')),
        ],
        rows: appointments.map(_buildDataRow).toList(),
      ),
    );
  }

  // Alternative: Build ListView if you prefer
  Widget _buildListView(List<OtAppointment> appointments) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              appointment.patientName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor: ${appointment.doctorName}'),
                Text('Date: ${appointment.formattedDate}'),
                Text('Time: ${appointment.formattedTime}'),
                Text('Procedure: ${appointment.procedureCode}'),
              ],
            ),
            trailing: ElevatedButton.icon(
              onPressed: () => _setPatientAsActive(appointment),
              icon: const Icon(Icons.medical_services),
              label: const Text('Set Active'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OT List'),
        actions: [
          // Show active patient indicator in app bar
          FutureBuilder(
            future: Future.value(LocalStorageService.getActivePatient()),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final activePatient = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    avatar: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    label: Text(
                      activePatient.patientName,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.green[50],
                    onDeleted: () {
                      // Option to clear active patient
                      LocalStorageService.removeActivePatient(activePatient.patientId);
                      setState(() {});
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                  ),
                );
              }
              return Container();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _otListFuture = _fetchOtList();
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<OtListResponse>(
        future: _otListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _otListFuture = _fetchOtList();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'No appointments found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            final appointments = snapshot.data!.data;
            
            return Column(
              children: [
                // Summary cards
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Text(
                                  'Total Appointments',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointments.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointments
                                      .where((a) => a.start.day == DateTime.now().day)
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Table
                Expanded(
                  child: _buildDataTable(appointments),
                  // OR use list view: _buildListView(appointments),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
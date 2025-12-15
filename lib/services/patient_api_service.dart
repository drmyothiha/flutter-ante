// lib/services/patient_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/patient_medical_model.dart';

class PatientApiService {
  static const String _baseUrl = 'https://your-api-domain.com/api';
  static const Duration _timeout = Duration(seconds: 30);

  Future<PatientMedicalData> getPatientMedicalData(String patientId) async {
    // For demo purposes, return mock data
    // Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock JSON data
    final mockData = {
      'personalInfo': {
        'age': '45',
        'gender': 'Male',
        'dateOfBirth': '1978-05-15',
        'phone': '+95 123 456 789',
        'address': '123 Main St, Yangon, Myanmar',
      },
      'medicalInfo': {
        'bloodType': 'O+',
        'allergies': ['Penicillin', 'Sulfa drugs'],
        'medications': ['Metformin 500mg', 'Lisinopril 10mg'],
        'chronicConditions': ['Type 2 Diabetes', 'Hypertension'],
        'surgicalHistory': ['Appendectomy (2010)', 'Cholecystectomy (2015)'],
      },
      'emergencyContact': {
        'name': 'Daw Khin Khin',
        'relationship': 'Wife',
        'phone': '+95 987 654 321',
      },
      'medicalHistory': {
        'Family History': ['Father: Diabetes', 'Mother: Hypertension'],
        'Social History': ['Non-smoker', 'Occasional alcohol'],
        'Past Illnesses': ['Malaria (2012)', 'Typhoid (2015)'],
      },
      'visitHistory': [
        {
          'date': '2024-01-15',
          'reason': 'Follow-up for Diabetes',
          'doctor': 'Dr. Aung Thu',
          'notes': 'Blood sugar well controlled',
        },
        {
          'date': '2023-12-10',
          'reason': 'Hypertension check',
          'doctor': 'Dr. Myo Thiha',
          'notes': 'BP controlled with medication',
        },
      ],
      'vitalSigns': {
        'bloodPressure': '120/80 mmHg',
        'heartRate': 72,
        'temperature': 36.8,
        'respiratoryRate': 16,
        'spo2': 98,
        'weight': 75.5,
        'height': 175,
        'bmi': 24.7,
      },
      'physicalExam': {
        'General': 'Well-appearing, in no acute distress',
        'Cardiovascular': 'Regular rate and rhythm, no murmurs',
        'Respiratory': 'Clear to auscultation bilaterally',
        'Abdomen': 'Soft, non-tender, non-distended',
        'Extremities': 'No edema, pulses 2+ bilaterally',
      },
      'assessment': 'Controlled Type 2 Diabetes and Hypertension. Continue current management.',
      'labResults': [
        {
          'testName': 'Complete Blood Count',
          'date': '2024-01-15',
          'status': 'Normal',
          'results': {
            'WBC': '7.2 x10³/μL',
            'RBC': '4.8 x10⁶/μL',
            'Hemoglobin': '14.2 g/dL',
            'Hematocrit': '42%',
            'Platelets': '250 x10³/μL',
          },
          'notes': 'All within normal limits',
        },
        {
          'testName': 'Basic Metabolic Panel',
          'date': '2024-01-15',
          'status': 'Abnormal',
          'results': {
            'Glucose': '145 mg/dL',
            'BUN': '18 mg/dL',
            'Creatinine': '1.1 mg/dL',
            'Sodium': '140 mEq/L',
            'Potassium': '4.2 mEq/L',
          },
          'notes': 'Elevated glucose noted',
        },
      ],
      'imagingStudies': [
        {
          'modality': 'Chest X-ray',
          'date': '2023-12-10',
          'bodyPart': 'Chest',
          'status': 'Completed',
          'findings': 'Clear lung fields, normal heart size',
          'impression': 'Normal chest X-ray',
        },
        {
          'modality': 'Abdominal Ultrasound',
          'date': '2023-11-05',
          'bodyPart': 'Abdomen',
          'status': 'Completed',
          'findings': 'Normal liver, gallbladder, pancreas, and kidneys',
          'impression': 'Normal abdominal ultrasound',
        },
      ],
      'treatment': {
        'current': [
          {
            'medication': 'Metformin',
            'dose': '500 mg',
            'frequency': 'Twice daily',
            'route': 'Oral',
            'startDate': '2023-06-01',
            'status': 'Active',
          },
          {
            'medication': 'Lisinopril',
            'dose': '10 mg',
            'frequency': 'Once daily',
            'route': 'Oral',
            'startDate': '2023-06-01',
            'status': 'Active',
          },
        ],
        'past': [
          {
            'medication': 'Glibenclamide',
            'duration': '2 years',
            'stopDate': '2023-05-31',
            'reason': 'Switched to Metformin for better control',
          },
        ],
        'plan': 'Continue current medications. Follow-up in 3 months. Diet and exercise counseling provided.',
      },
    };

    return PatientMedicalData.fromJson(mockData);
    
    // Uncomment for real API call:
    /*
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/medical'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PatientMedicalData.fromJson(jsonData);
      } else {
        throw Exception('Failed to load medical data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching medical data: $e');
    }
    */
  }
}
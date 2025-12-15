// lib/models/patient_medical_model.dart
class PatientMedicalData {
  final PersonalInfo? personalInfo;
  final MedicalInfo? medicalInfo;
  final EmergencyContact? emergencyContact;
  final Map<String, dynamic>? medicalHistory;
  final List<VisitHistory>? visitHistory;
  final VitalSigns? vitalSigns;
  final Map<String, dynamic>? physicalExam;
  final String? assessment;
  final List<LabResult>? labResults;
  final List<ImagingStudy>? imagingStudies;
  final Treatment? treatment;

  PatientMedicalData({
    this.personalInfo,
    this.medicalInfo,
    this.emergencyContact,
    this.medicalHistory,
    this.visitHistory,
    this.vitalSigns,
    this.physicalExam,
    this.assessment,
    this.labResults,
    this.imagingStudies,
    this.treatment,
  });

  factory PatientMedicalData.fromJson(Map<String, dynamic> json) {
    return PatientMedicalData(
      personalInfo: json['personalInfo'] != null
          ? PersonalInfo.fromJson(json['personalInfo'])
          : null,
      medicalInfo: json['medicalInfo'] != null
          ? MedicalInfo.fromJson(json['medicalInfo'])
          : null,
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContact.fromJson(json['emergencyContact'])
          : null,
      medicalHistory: json['medicalHistory'] != null
          ? Map<String, dynamic>.from(json['medicalHistory'])
          : null,
      visitHistory: json['visitHistory'] != null
          ? (json['visitHistory'] as List)
              .map((e) => VisitHistory.fromJson(e))
              .toList()
          : null,
      vitalSigns: json['vitalSigns'] != null
          ? VitalSigns.fromJson(json['vitalSigns'])
          : null,
      physicalExam: json['physicalExam'] != null
          ? Map<String, dynamic>.from(json['physicalExam'])
          : null,
      assessment: json['assessment'],
      labResults: json['labResults'] != null
          ? (json['labResults'] as List)
              .map((e) => LabResult.fromJson(e))
              .toList()
          : null,
      imagingStudies: json['imagingStudies'] != null
          ? (json['imagingStudies'] as List)
              .map((e) => ImagingStudy.fromJson(e))
              .toList()
          : null,
      treatment: json['treatment'] != null
          ? Treatment.fromJson(json['treatment'])
          : null,
    );
  }
}

class PersonalInfo {
  final String? age;
  final String? gender;
  final String? dateOfBirth;
  final String? phone;
  final String? address;

  PersonalInfo({
    this.age,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.address,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      age: json['age'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}

class MedicalInfo {
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? medications;
  final List<String>? chronicConditions;
  final List<String>? surgicalHistory;

  MedicalInfo({
    this.bloodType,
    this.allergies,
    this.medications,
    this.chronicConditions,
    this.surgicalHistory,
  });

  factory MedicalInfo.fromJson(Map<String, dynamic> json) {
    return MedicalInfo(
      bloodType: json['bloodType'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      medications: json['medications'] != null
          ? List<String>.from(json['medications'])
          : null,
      chronicConditions: json['chronicConditions'] != null
          ? List<String>.from(json['chronicConditions'])
          : null,
      surgicalHistory: json['surgicalHistory'] != null
          ? List<String>.from(json['surgicalHistory'])
          : null,
    );
  }
}

class EmergencyContact {
  final String? name;
  final String? relationship;
  final String? phone;

  EmergencyContact({
    this.name,
    this.relationship,
    this.phone,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      relationship: json['relationship'],
      phone: json['phone'],
    );
  }
}

class VisitHistory {
  final String? date;
  final String? reason;
  final String? doctor;
  final String? notes;

  VisitHistory({
    this.date,
    this.reason,
    this.doctor,
    this.notes,
  });

  factory VisitHistory.fromJson(Map<String, dynamic> json) {
    return VisitHistory(
      date: json['date'],
      reason: json['reason'],
      doctor: json['doctor'],
      notes: json['notes'],
    );
  }
}

class VitalSigns {
  final String? bloodPressure;
  final int? heartRate;
  final double? temperature;
  final int? respiratoryRate;
  final int? spo2;
  final double? weight;
  final double? height;
  final double? bmi;

  VitalSigns({
    this.bloodPressure,
    this.heartRate,
    this.temperature,
    this.respiratoryRate,
    this.spo2,
    this.weight,
    this.height,
    this.bmi,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      bloodPressure: json['bloodPressure'],
      heartRate: json['heartRate'],
      temperature: json['temperature'],
      respiratoryRate: json['respiratoryRate'],
      spo2: json['spo2'],
      weight: json['weight'],
      height: json['height'],
      bmi: json['bmi'],
    );
  }
}

class LabResult {
  final String? testName;
  final String? date;
  final Map<String, String>? results;
  final String? status;
  final String? notes;

  LabResult({
    this.testName,
    this.date,
    this.results,
    this.status,
    this.notes,
  });

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      testName: json['testName'],
      date: json['date'],
      results: json['results'] != null
          ? Map<String, String>.from(json['results'])
          : null,
      status: json['status'],
      notes: json['notes'],
    );
  }
}

class ImagingStudy {
  final String? modality;
  final String? date;
  final String? bodyPart;
  final String? findings;
  final String? impression;
  final String? status;

  ImagingStudy({
    this.modality,
    this.date,
    this.bodyPart,
    this.findings,
    this.impression,
    this.status,
  });

  factory ImagingStudy.fromJson(Map<String, dynamic> json) {
    return ImagingStudy(
      modality: json['modality'],
      date: json['date'],
      bodyPart: json['bodyPart'],
      findings: json['findings'],
      impression: json['impression'],
      status: json['status'],
    );
  }
}

class Treatment {
  final List<CurrentTreatment>? current;
  final List<PastTreatment>? past;
  final String? plan;

  Treatment({
    this.current,
    this.past,
    this.plan,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      current: json['current'] != null
          ? (json['current'] as List)
              .map((e) => CurrentTreatment.fromJson(e))
              .toList()
          : null,
      past: json['past'] != null
          ? (json['past'] as List)
              .map((e) => PastTreatment.fromJson(e))
              .toList()
          : null,
      plan: json['plan'],
    );
  }
}

class CurrentTreatment {
  final String? medication;
  final String? dose;
  final String? frequency;
  final String? route;
  final String? startDate;
  final String? status;

  CurrentTreatment({
    this.medication,
    this.dose,
    this.frequency,
    this.route,
    this.startDate,
    this.status,
  });

  factory CurrentTreatment.fromJson(Map<String, dynamic> json) {
    return CurrentTreatment(
      medication: json['medication'],
      dose: json['dose'],
      frequency: json['frequency'],
      route: json['route'],
      startDate: json['startDate'],
      status: json['status'],
    );
  }
}

class PastTreatment {
  final String? medication;
  final String? duration;
  final String? stopDate;
  final String? reason;

  PastTreatment({
    this.medication,
    this.duration,
    this.stopDate,
    this.reason,
  });

  factory PastTreatment.fromJson(Map<String, dynamic> json) {
    return PastTreatment(
      medication: json['medication'],
      duration: json['duration'],
      stopDate: json['stopDate'],
      reason: json['reason'],
    );
  }
}
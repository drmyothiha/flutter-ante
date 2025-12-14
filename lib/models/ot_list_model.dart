import 'dart:ui';

import 'package:flutter/material.dart';

class OtListResponse {
  final bool success;
  final Pagination pagination;
  final List<OtAppointment> data;
  final int count;

  OtListResponse({
    required this.success,
    required this.pagination,
    required this.data,
    required this.count,
  });

  factory OtListResponse.fromJson(Map<String, dynamic> json) {
    return OtListResponse(
      success: json['success'] ?? false,
      pagination: Pagination.fromJson(json['pagination']),
      data: (json['data'] as List)
          .map((e) => OtAppointment.fromJson(e))
          .toList(),
      count: json['count'] ?? 0,
    );
  }
}

class Pagination {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  Pagination({
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      itemsPerPage: json['itemsPerPage'] ?? 10,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class OtAppointment {
  final String id;
  final String resourceType;
  final String status;
  final DateTime start;
  final DateTime end;
  final String patientName;
  final String doctorName;
  final String diagnosis;
  final String procedureCode;
  final List<Participant> participants;
  final DateTime createdAt;
  final String? location;

  OtAppointment({
    required this.id,
    required this.resourceType,
    required this.status,
    required this.start,
    required this.end,
    required this.patientName,
    required this.doctorName,
    required this.diagnosis,
    required this.procedureCode,
    required this.participants,
    required this.createdAt,
    this.location,
  });

  factory OtAppointment.fromJson(Map<String, dynamic> json) {
    // Extract location from participants
    String? location;
    for (var participant in json['participants']) {
      if (participant['actor']['reference'].toString().contains('Location')) {
        location = participant['actor']['display'];
        break;
      }
    }

    return OtAppointment(
      id: json['id'] ?? '',
      resourceType: json['resourceType'] ?? '',
      status: json['status'] ?? '',
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      patientName: json['patientName'] ?? '',
      doctorName: json['doctorName'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      procedureCode: json['procedureCode'] ?? '',
      participants: (json['participants'] as List)
          .map((e) => Participant.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      location: location,
    );
  }

  // Get duration in minutes
  int get durationInMinutes => end.difference(start).inMinutes;

  // Get formatted date
  String get formattedDate => start.toLocal().toString().split(' ')[0];

  // Get formatted time
  String get formattedTime {
    final startTime = start.toLocal();
    final endTime = end.toLocal();
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  // Get status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'booked':
        return Colors.blue;
      case 'in-progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Participant {
  final String reference;
  final String display;
  final String status;
  final String required;

  Participant({
    required this.reference,
    required this.display,
    required this.status,
    required this.required,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      reference: json['actor']['reference'] ?? '',
      display: json['actor']['display'] ?? '',
      status: json['status'] ?? '',
      required: json['required'] ?? '',
    );
  }
}
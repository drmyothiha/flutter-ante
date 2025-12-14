import 'package:flutter/material.dart';

class PreopAssessmentScreen extends StatefulWidget {
  const PreopAssessmentScreen({super.key});

  @override
  State<PreopAssessmentScreen> createState() => _PreopAssessmentScreenState();
}

class _PreopAssessmentScreenState extends State<PreopAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'patientHistory': '',
    'allergies': '',
    'medications': '',
    'physicalExam': '',
    'labResults': '',
    'asaClass': 'II',
    'airwayAssessment': 'Mallampati I',
    'cardiacRisk': 'Low',
    'fastingStatus': 'Yes',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preoperative Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Patient ID',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: 'ANES-2025-001',
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: 'John Doe',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Assessment Form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assessment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Medical History',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        onChanged: (value) => _formData['patientHistory'] = value,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Allergies',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _formData['allergies'] = value,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'ASA Class',
                          border: OutlineInputBorder(),
                        ),
                        value: _formData['asaClass'],
                        items: const [
                          DropdownMenuItem(value: 'I', child: Text('I - Healthy')),
                          DropdownMenuItem(value: 'II', child: Text('II - Mild Systemic Disease')),
                          DropdownMenuItem(value: 'III', child: Text('III - Severe Systemic Disease')),
                          DropdownMenuItem(value: 'IV', child: Text('IV - Severe Systemic Disease that is a constant threat')),
                          DropdownMenuItem(value: 'V', child: Text('V - Moribund')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _formData['asaClass'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Save assessment
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Assessment saved')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Save Assessment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
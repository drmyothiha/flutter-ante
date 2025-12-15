// lib/screens/patient/ot_list_screen.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/ot_list_model.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/local_storage_service.dart';

class OtListScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onPatientSelect;

  const OtListScreen({
    super.key,
    this.onPatientSelect,
  });

  @override
  State<OtListScreen> createState() => _OtListScreenState();
}

class _OtListScreenState extends State<OtListScreen> {
  final ApiService _apiService = ApiService();
  late Future<OtListResponse> _otListFuture;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _itemsPerPage = 10;
  List<OtAppointment> _appointments = [];

  // Search and filter states
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedDate = 'today';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otListFuture = _fetchOtList();
  }

  Future<OtListResponse> _fetchOtList({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> filters = {};
      
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        filters['search'] = _searchQuery;
      }
      
      // Apply status filter
      if (_selectedStatus != 'all') {
        filters['status'] = _selectedStatus;
      }
      
      // Apply date filter (you'll need to adjust this based on your API)
      if (_selectedDate != 'all') {
        filters['date_range'] = _selectedDate;
      }

      final response = await _apiService.getOtList(
        page: page,
        itemsPerPage: _itemsPerPage,
        filters: filters.isNotEmpty ? filters : null,
      );

      setState(() {
        _appointments = response.data;
        _totalPages = response.pagination.totalPages;
        _totalItems = response.pagination.totalItems;
        _isLoading = false;
      });

      return response;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  void _handlePatientSelect(OtAppointment appointment) async {
    try {
      // Convert appointment to JSON
      final appointmentJson = appointment.toJson();
      
      // Save to local storage
      await LocalStorageService.setPatientAsActive(appointmentJson);

      // Call the callback if provided
      if (widget.onPatientSelect != null) {
        widget.onPatientSelect!(appointmentJson);
      } else {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${appointment.patientName} selected'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting patient: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _refreshData() {
    setState(() {
      _currentPage = 1;
      _otListFuture = _fetchOtList(page: _currentPage);
    });
  }

  void _handleSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _currentPage = 1;
      _otListFuture = _fetchOtList(page: _currentPage);
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _currentPage = 1;
      _otListFuture = _fetchOtList(page: _currentPage);
    });
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by patient name or ID...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 13),
                      onSubmitted: (_) => _handleSearch(),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: _clearSearch,
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Status filter
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatus,
                items: [
                  DropdownMenuItem(
                    value: 'all',
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('All Status'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'scheduled',
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Scheduled'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'in-progress',
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('In Progress'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Completed'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'cancelled',
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Cancelled'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                    _currentPage = 1;
                    _otListFuture = _fetchOtList(page: _currentPage);
                  });
                },
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Date filter
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDate,
                items: const [
                  DropdownMenuItem(
                    value: 'today',
                    child: Text('Today'),
                  ),
                  DropdownMenuItem(
                    value: 'tomorrow',
                    child: Text('Tomorrow'),
                  ),
                  DropdownMenuItem(
                    value: 'this_week',
                    child: Text('This Week'),
                  ),
                  DropdownMenuItem(
                    value: 'all',
                    child: Text('All Dates'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDate = value!;
                    _currentPage = 1;
                    _otListFuture = _fetchOtList(page: _currentPage);
                  });
                },
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<OtAppointment> appointments) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 60, child: Text('Patient ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 120, child: Text('Patient Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 100, child: Text('Doctor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 80, child: Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 80, child: Text('Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 120, child: Text('Procedure', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 100, child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  SizedBox(width: 100, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                ],
              ),
            ),
            
            // Table rows
            ...appointments.map((appointment) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handlePatientSelect(appointment),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
                    ),
                    child: Row(
                      children: [
                        // Patient ID
                        SizedBox(
                          width: 60,
                          child: Text(
                            appointment.id.length > 8 
                              ? '${appointment.id.substring(0, 8)}...' 
                              : appointment.id,
                            style: const TextStyle(fontSize: 11, fontFamily: 'Monospace'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Patient Name
                        SizedBox(
                          width: 120,
                          child: Text(
                            appointment.patientName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Doctor Name
                        SizedBox(
                          width: 100,
                          child: Text(
                            appointment.doctorName,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Date
                        SizedBox(
                          width: 80,
                          child: Text(
                            appointment.formattedDate,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        
                        // Time
                        SizedBox(
                          width: 80,
                          child: Text(
                            appointment.formattedTime,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        
                        // Procedure
                        SizedBox(
                          width: 120,
                          child: Tooltip(
                            message: appointment.procedureCode,
                            child: Text(
                              appointment.procedureCode,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        
                        // Status
                        SizedBox(
                          width: 100,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: appointment.statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: appointment.statusColor),
                            ),
                            child: Text(
                              appointment.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: appointment.statusColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        
                        // Actions
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () => _handlePatientSelect(appointment),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: const Text('View Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    if (_totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_appointments.length} of $_totalItems appointments',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                          _otListFuture = _fetchOtList(page: _currentPage);
                        });
                      }
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: _currentPage > 1 ? Colors.blue[50] : Colors.grey[100],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Page $_currentPage of $_totalPages',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: _currentPage < _totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                          _otListFuture = _fetchOtList(page: _currentPage);
                        });
                      }
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: _currentPage < _totalPages ? Colors.blue[50] : Colors.grey[100],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.list_alt, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Operating Theater List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter bar
          _buildFilterBar(),
          const SizedBox(height: 16),

          // Data table
          Expanded(
            child: FutureBuilder<OtListResponse>(
              future: _otListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load OT List',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data!.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.list, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No appointments found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        if (_searchQuery.isNotEmpty || _selectedStatus != 'all' || _selectedDate != 'today')
                          ElevatedButton(
                            onPressed: _clearSearch,
                            child: const Text('Clear filters'),
                          ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  return Column(
                    children: [
                      // Data table
                      Expanded(child: _buildDataTable(snapshot.data!.data)),
                      const SizedBox(height: 16),
                      // Pagination
                      _buildPagination(),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
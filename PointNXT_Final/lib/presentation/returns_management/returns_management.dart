import 'package:pointnxt/presentation/returns_management/widgets/status_filter_chip_widget.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/returns_data_table_widget.dart';

class ReturnsManagement extends StatefulWidget {
  const ReturnsManagement({super.key});

  @override
  State<ReturnsManagement> createState() => _ReturnsState();
}

class _ReturnsState extends State<ReturnsManagement> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All';
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredReturns = [];
  bool _isLoading = false;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final Set<int> _selectedRows = {};
  bool _isMultiSelectMode = false;

  final List<String> _statusFilters = [
    'Pending',
    'Accepted',
    'AWB Created',
    'Ready to Ship',
    'Shipped',
    'Completed',
    'Cancelled',
    'All'
  ];

  final List<Map<String, dynamic>> _mockReturns = [
    {
      "id": 1,
      "channel": "Amazon",
      "orderNo": "AMZ-001234",
      "orderDate": "12/15/2023",
      "city": "New York",
      "customerName": "John Smith",
      "orderValue": "\$299.99",
      "deliveryDate": "12/20/2023",
      "status": "Pending",
      "channelStatus": "Return Requested",
      "operation": "Process"
    },
    {
      "id": 2,
      "channel": "Flipkart",
      "orderNo": "FLK-005678",
      "orderDate": "12/14/2023",
      "city": "Mumbai",
      "customerName": "Priya Sharma",
      "orderValue": "\$149.50",
      "deliveryDate": "12/19/2023",
      "status": "Accepted",
      "channelStatus": "Return Approved",
      "operation": "Ship"
    },
    {
      "id": 3,
      "channel": "Shopify",
      "orderNo": "SHP-009876",
      "orderDate": "12/13/2023",
      "city": "Los Angeles",
      "customerName": "Mike Johnson",
      "orderValue": "\$89.99",
      "deliveryDate": "12/18/2023",
      "status": "AWB Created",
      "channelStatus": "Label Generated",
      "operation": "Track"
    },
    {
      "id": 4,
      "channel": "eBay",
      "orderNo": "EBY-112233",
      "orderDate": "12/12/2023",
      "city": "Chicago",
      "customerName": "Sarah Wilson",
      "orderValue": "\$199.75",
      "deliveryDate": "12/17/2023",
      "status": "Ready to Ship",
      "channelStatus": "Ready for Pickup",
      "operation": "Dispatch"
    },
    {
      "id": 5,
      "channel": "Etsy",
      "orderNo": "ETS-445566",
      "orderDate": "12/11/2023",
      "city": "Austin",
      "customerName": "David Brown",
      "orderValue": "\$59.99",
      "deliveryDate": "12/16/2023",
      "status": "Shipped",
      "channelStatus": "In Transit",
      "operation": "Track"
    },
    {
      "id": 6,
      "channel": "Amazon",
      "orderNo": "AMZ-778899",
      "orderDate": "12/10/2023",
      "city": "Seattle",
      "customerName": "Lisa Davis",
      "orderValue": "\$349.99",
      "deliveryDate": "12/15/2023",
      "status": "Completed",
      "channelStatus": "Return Processed",
      "operation": "Refund"
    },
    {
      "id": 7,
      "channel": "Walmart",
      "orderNo": "WMT-334455",
      "orderDate": "12/09/2023",
      "city": "Dallas",
      "customerName": "Robert Miller",
      "orderValue": "\$79.99",
      "deliveryDate": "12/14/2023",
      "status": "Cancelled",
      "channelStatus": "Return Cancelled",
      "operation": "Close"
    },
    {
      "id": 8,
      "channel": "Target",
      "orderNo": "TGT-667788",
      "orderDate": "12/08/2023",
      "city": "Phoenix",
      "customerName": "Jennifer Garcia",
      "orderValue": "\$129.99",
      "deliveryDate": "12/13/2023",
      "status": "Pending",
      "channelStatus": "Return Requested",
      "operation": "Review"
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredReturns = List.from(_mockReturns);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterReturns();
    });
  }

  void _filterReturns() {
    List<Map<String, dynamic>> filtered = List.from(_mockReturns);

    if (_selectedStatus != 'All') {
      filtered = filtered
          .where((item) => (item['status'] as String) == _selectedStatus)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        final searchLower = _searchQuery.toLowerCase();
        return (item['orderNo'] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (item['customerName'] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (item['channel'] as String).toLowerCase().contains(searchLower) ||
            (item['city'] as String).toLowerCase().contains(searchLower);
      }).toList();
    }

    _filteredReturns = filtered;
  }

  void _onStatusFilterChanged(String status) {
    setState(() {
      _selectedStatus = status;
      _filterReturns();
      _selectedRows.clear();
      _isMultiSelectMode = false;
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      // ... sort implementation
    });
  }

  void _onRowLongPress(int index) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedRows.add(index);
    });
  }

  void _onRowTap(int index) {
    if (_isMultiSelectMode) {
      setState(() {
        _selectedRows.contains(index)
            ? _selectedRows.remove(index)
            : _selectedRows.add(index);

        if (_selectedRows.isEmpty) {
          _isMultiSelectMode = false;
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredReturns = List.from(_mockReturns);
      _filterReturns();
    });
  }

  void _onActionPressed(String action) {
    switch (action) {
      case 'Export':
        _showSnackBar('Exporting returns data...', isHighlighted: true);
        break;
      case 'Accept':
        if (_selectedRows.isNotEmpty) {
          _showSnackBar('${_selectedRows.length} returns accepted',
              isHighlighted: true);
          setState(() {
            _selectedRows.clear();
            _isMultiSelectMode = false;
          });
        } else {
          _showSnackBar('Please select returns to accept');
        }
        break;
      case 'Print':
        _showSnackBar('Printing returns report...', isHighlighted: true);
        break;
      case 'Create':
        _showSnackBar('Create new return functionality available',
            isHighlighted: true);
        break;
      case 'Refresh':
        _onRefresh();
        break;
    }
  }

  void _showSnackBar(String message, {bool isHighlighted = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isHighlighted ? AppTheme.secondaryLight : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _getStatusCount(String status) {
    if (status == 'All') return _mockReturns.length;
    return _mockReturns
        .where((item) => (item['status'] as String) == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer:
          NavigationDrawerWidget(currentRoute: '/returns-management-screen'),
      body: SafeArea(
        child: Column(
          children: [
            // Header with hamburger menu
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Builder(
                    builder: (innerContext) => InkWell(
                      onTap: () => Scaffold.of(innerContext).openDrawer(),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryLight.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.menu,
                          color: AppTheme.secondaryLight,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Returns',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredReturns.length}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Status Filter Chips
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _statusFilters.length,
                itemBuilder: (context, index) {
                  final status = _statusFilters[index];
                  final count = _getStatusCount(status);
                  return StatusFilterChipWidget(
                    status: status,
                    count: count,
                    isSelected: _selectedStatus == status,
                    onTap: () => _onStatusFilterChanged(status),
                  );
                },
              ),
            ),

            // Data Table or Empty State
            Expanded(
              child: _filteredReturns.isEmpty
                  ? EmptyStateWidget(
                      onClearFilters: () {
                        setState(() {
                          _selectedStatus = 'All';
                          _searchController.clear();
                          _searchQuery = '';
                          _filterReturns();
                        });
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppTheme.secondaryLight,
                      child: ReturnsDataTableWidget(
                        returns: _filteredReturns,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        selectedRows: _selectedRows,
                        isMultiSelectMode: _isMultiSelectMode,
                        onSort: _onSort,
                        onRowTap: _onRowTap,
                        onRowLongPress: _onRowLongPress,
                        isLoading: _isLoading,
                      ),
                    ),
            ),

            // Integrated Action Row
            if (_isMultiSelectMode)
              Container(
                padding: EdgeInsets.all(4.w),
                color: AppTheme.secondaryLight.withAlpha(26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.check_circle,
                      label: 'Accept',
                      onPressed: () => _onActionPressed('Accept'),
                    ),
                    _buildActionButton(
                      icon: Icons.print,
                      label: 'Print',
                      onPressed: () => _onActionPressed('Print'),
                    ),
                    _buildActionButton(
                      icon: Icons.file_download,
                      label: 'Export',
                      onPressed: () => _onActionPressed('Export'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onActionPressed('Create'),
        backgroundColor: AppTheme.secondaryLight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.secondaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            SizedBox(width: 1.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

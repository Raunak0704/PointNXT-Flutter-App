import '../../core/app_export.dart'; // Adjust as per your file structure

class ReturnsManagement extends StatefulWidget {
  const ReturnsManagement({super.key});

  @override
  State<ReturnsManagement> createState() => _ReturnsManagementState();
}

class _ReturnsManagementState extends State<ReturnsManagement>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _allReturns = [
    {
      'returnId': 'RET123',
      'orderId': 'ORD123',
      'channel': 'Amazon',
      'customerName': 'John Doe',
      'product': 'Wireless Mouse x1',
      'status': 'Pending',
      'requestedDate': '2025-07-12',
      'pickupDate': '2025-07-14',
      'refundAmount': '₹799',
      'reason': 'Defective item',
    },
    {
      'returnId': 'RET124',
      'orderId': 'ORD456',
      'channel': 'Flipkart',
      'customerName': 'Jane Smith',
      'product': 'Bluetooth Speaker x2',
      'status': 'Completed',
      'requestedDate': '2025-07-10',
      'pickupDate': '2025-07-11',
      'refundAmount': '₹2,499',
      'reason': 'Not as described',
    },
    {
      'returnId': 'RET125',
      'orderId': 'ORD789',
      'channel': 'Amazon',
      'customerName': 'Alice Roy',
      'product': 'Keyboard x1',
      'status': 'Pending',
      'requestedDate': '2025-07-13',
      'pickupDate': null,
      'refundAmount': null,
      'reason': 'Wrong item received',
    },
  ];

  List<Map<String, dynamic>> _filteredReturns = [];
  String _selectedStatusFilter = 'All';
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _filteredReturns = List.from(_allReturns);
    _tabController = TabController(length: 3, vsync: this);
  }

  void _filterReturns() {
    setState(() {
      _filteredReturns = _allReturns.where((item) {
        final statusMatch = _selectedStatusFilter == 'All' ||
            item['status'] == _selectedStatusFilter;
        final searchMatch = item['customerName']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            item['orderId'].toLowerCase().contains(_searchQuery.toLowerCase());
        return statusMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (innerContext) => IconButton(
            icon: CustomIconWidget(
              iconName: 'menu',
              color: AppTheme.darkTheme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: () => Scaffold.of(innerContext).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            SizedBox(width: 2.w),
            Text(
              'Returns',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.darkTheme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedStatusFilter = switch (index) {
                0 => 'All',
                1 => 'Pending',
                2 => 'Completed',
                _ => 'All',
              };
              _filterReturns();
            });
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      drawer:
          NavigationDrawerWidget(currentRoute: '/returns-management-screen'),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by Customer or Order ID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _filterReturns();
              },
            ),
            SizedBox(height: 1.5.h),
            DropdownButton<String>(
              value: _selectedStatusFilter,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatusFilter = newValue;
                    _filterReturns();
                  });
                }
              },
              items: ['All', 'Pending', 'Completed', 'Shipped', 'Cancelled']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: _filteredReturns.isEmpty
                  ? Center(child: Text("No returns match your filters."))
                  : ListView.builder(
                      itemCount: _filteredReturns.length,
                      itemBuilder: (context, index) {
                        final item = _filteredReturns[index];
                        return _buildReturnCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Return ID: ${item['returnId']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              _buildStatusChip(item['status']),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text('Order ID: ${item['orderId']}'),
              Spacer(),
              _buildChannelBadge(item['channel']),
            ],
          ),
          SizedBox(height: 1.h),
          Text('Customer: ${item['customerName']}'),
          Text('Product: ${item['product']}'),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Requested: ${item['requestedDate']}'),
              Text('Pickup: ${item['pickupDate'] ?? '—'}'),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Refund: ${item['refundAmount'] ?? '—'}'),
              Text('Reason: ${item['reason']}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelBadge(String channel) {
    final color = channel == "Amazon"
        ? Colors.orange
        : channel == "Flipkart"
            ? Colors.blue
            : Colors.grey;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        channel,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final colorMap = {
      'Pending': Colors.orange,
      'Accepted': Colors.blue,
      'AWB Created': Colors.teal,
      'Ready to Ship': Colors.indigo,
      'Shipped': Colors.purple,
      'Completed': Colors.green,
      'Cancelled': Colors.red,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: colorMap[status]?.withOpacity(0.2) ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorMap[status] ?? Colors.grey,
        ),
      ),
    );
  }
}

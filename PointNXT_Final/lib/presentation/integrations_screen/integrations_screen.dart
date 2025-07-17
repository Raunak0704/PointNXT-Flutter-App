import '../../core/app_export.dart';
import './widgets/integration_card_widget.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  State<IntegrationsScreen> createState() => _IntegrationsState();
}

class _IntegrationsState extends State<IntegrationsScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Integration platforms data
  final List<Map<String, dynamic>> _integrations = [
    {
      "id": 1,
      "name": "Amazon Seller Central",
      "description": "Manage your Amazon seller account and inventory",
      "logoUrl": "assets/images/amazon_logo.png",
      "isConnected": false,
    },
    {
      "id": 2,
      "name": "Amazon Vendor Central",
      "description": "Connect your Amazon vendor operations",
      "logoUrl": "assets/images/amazon_logo.png",
      "isConnected": true,
    },
    {
      "id": 3,
      "name": "Flipkart",
      "description": "Integrate with India's leading e-commerce platform",
      "logoUrl": "assets/images/Flipkart-logo.png",
      "isConnected": false,
    },
    {
      "id": 4,
      "name": "Shopify",
      "description": "Connect your Shopify store and manage orders",
      "logoUrl": "assets/images/Shopify_logo.png",
      "isConnected": true,
    },
    {
      "id": 5,
      "name": "WooCommerce",
      "description": "Sync with your WordPress WooCommerce store",
      "logoUrl": "assets/images/WooCommerce_logo.png",
      "isConnected": false,
    },
    {
      "id": 6,
      "name": "BigCommerce",
      "description": "Integrate with BigCommerce platform",
      "logoUrl": "assets/images/BigCommerce-Logo.png",
      "isConnected": false,
    },
    {
      "id": 7,
      "name": "WhatsApp",
      "description": "Connect WhatsApp Business for customer support",
      "logoUrl": "assets/images/WhatsApp_logo.webp",
      "isConnected": true,
    },
    {
      "id": 8,
      "name": "AJIO",
      "description": "Integrate with AJIO marketplace",
      "logoUrl": "assets/images/no-image.jpg",
      "isConnected": false,
    },
    {
      "id": 9,
      "name": "Magento",
      "description": "Connect your Magento e-commerce platform",
      "logoUrl": "assets/images/no-image.jpg",
      "isConnected": false,
    },
    {
      "id": 10,
      "name": "IGP",
      "description": "Integrate with IGP gifting platform",
      "logoUrl": "assets/images/no-image.jpg",
      "isConnected": false,
    },
    {
      "id": 11,
      "name": "FNP",
      "description": "Connect with Ferns N Petals platform",
      "logoUrl": "assets/images/no-image.jpg",
      "isConnected": false,
    },
    {
      "id": 12,
      "name": "FlowerAura",
      "description": "Integrate with FlowerAura marketplace",
      "logoUrl": "assets/images/no-image.jpg",
      "isConnected": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: NavigationDrawerWidget(
          currentRoute: '/integrations-screen'), // Add your Drawer widget here
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 2.0,
      shadowColor: AppTheme.lightTheme.colorScheme.shadow,
      leading: Builder(
        builder: (innerContext) => IconButton(
          icon: CustomIconWidget(
            iconName: 'menu',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          onPressed: () => Scaffold.of(innerContext).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Integrations',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRefreshButton(),
              SizedBox(width: 2.w),
              _buildFilterButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        onPressed: _handleRefresh,
        icon: AnimatedRotation(
          turns: _isRefreshing ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        tooltip: 'Refresh Integrations',
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        onPressed: _handleFilter,
        icon: CustomIconWidget(
          iconName: 'filter_list',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        tooltip: 'Filter Integrations',
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefreshIndicator,
      color: AppTheme.lightTheme.colorScheme.primary,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            )
          : _buildIntegrationsGrid(),
    );
  }

  Widget _buildIntegrationsGrid() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72, // Gives extra vertical space to each card
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.w,
        ),
        itemCount: _integrations.length,
        itemBuilder: (context, index) {
          final integration = _integrations[index];
          return IntegrationCardWidget(
            platformName: integration['name'],
            description: integration['description'],
            logoUrl: integration['logoUrl'],
            isConnected: integration['isConnected'],
            onConnect: () => _handleConnect(integration),
          );
        },
      ),
    );
  }

  void _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Integration status refreshed successfully',
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleRefreshIndicator() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Filter Integrations',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Show integrations by connection status',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _applyFilter('connected'),
                  icon: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Connected'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _applyFilter('disconnected'),
                  icon: CustomIconWidget(
                    iconName: 'radio_button_unchecked',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Not Connected'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _applyFilter('all'),
              icon: CustomIconWidget(
                iconName: 'view_list',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Show All'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _applyFilter(String filterType) {
    Navigator.pop(context);

    // Simulate filter application
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Filter applied: ${filterType == 'all' ? 'All integrations' : filterType == 'connected' ? 'Connected only' : 'Not connected only'}',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleConnect(Map<String, dynamic> integration) {
    if (integration['isConnected']) {
      _showDisconnectDialog(integration);
    } else {
      _showConnectDialog(integration);
    }
  }

  void _showConnectDialog(Map<String, dynamic> integration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'Connect ${integration['name']}',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Do you want to connect to ${integration['name']}? This will allow data synchronization between platforms.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performConnection(integration);
            },
            child: Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog(Map<String, dynamic> integration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'Disconnect ${integration['name']}',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to disconnect from ${integration['name']}? This will stop data synchronization.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performDisconnection(integration);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Disconnect'),
          ),
        ],
      ),
    );
  }

  void _performConnection(Map<String, dynamic> integration) {
    // Simulate connection process
    setState(() {
      integration['isConnected'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully connected to ${integration['name']}',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _performDisconnection(Map<String, dynamic> integration) {
    // Simulate disconnection process
    setState(() {
      integration['isConnected'] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Disconnected from ${integration['name']}',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ReturnsContentWidget extends StatefulWidget {
  const ReturnsContentWidget({Key? key}) : super(key: key);

  @override
  State<ReturnsContentWidget> createState() => _ReturnsContentWidgetState();
}

class _ReturnsContentWidgetState extends State<ReturnsContentWidget> {
  final List<Map<String, dynamic>> _mockReturns = [
    {
      "id": "RET001",
      "orderNo": "AMZ-001234",
      "customerName": "John Smith",
      "amount": "\$299.99",
      "status": "Pending",
      "date": "12/15/2023",
    },
    {
      "id": "RET002",
      "orderNo": "FLK-005678",
      "customerName": "Priya Sharma",
      "amount": "\$149.50",
      "status": "Approved",
      "date": "12/14/2023",
    },
    {
      "id": "RET003",
      "orderNo": "SHP-009876",
      "customerName": "Mike Johnson",
      "amount": "\$89.99",
      "status": "Completed",
      "date": "12/13/2023",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search returns...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.primaryLight,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
              ),
            ),
          ),
          SizedBox(height: 4.w),

          // Returns list
          Text(
            'Recent Returns',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.w),

          Expanded(
            child: ListView.builder(
              itemCount: _mockReturns.length,
              itemBuilder: (context, index) {
                final returnItem = _mockReturns[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 3.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            returnItem['orderNo'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryLight,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.w),
                            decoration: BoxDecoration(
                              color: _getStatusColor(returnItem['status'])
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(
                              returnItem['status'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(returnItem['status']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        returnItem['customerName'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(height: 1.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            returnItem['amount'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondaryLight,
                            ),
                          ),
                          Text(
                            returnItem['date'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningLight;
      case 'approved':
        return AppTheme.primaryLight;
      case 'completed':
        return AppTheme.successLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}

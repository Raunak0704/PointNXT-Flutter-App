import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ChartSectionWidget extends StatelessWidget {
  final String selectedPeriod;
  final List<FlSpot> chartData7Days;
  final List<FlSpot> chartData30Days;
  final Function(String) onPeriodChanged;

  const ChartSectionWidget({
    super.key,
    required this.selectedPeriod,
    required this.chartData7Days,
    required this.chartData30Days,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Order Trends',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Row(children: [
              _buildPeriodButton('7', '7 Days'),
              SizedBox(width: 2.w),
              _buildPeriodButton('30', '30 Days'),
            ]),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 25.h,
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: selectedPeriod == '7' ? 10 : 25,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: selectedPeriod == '7' ? 1 : 5,
                              getTitlesWidget: (value, meta) {
                                if (selectedPeriod == '7') {
                                  const days = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun'
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Text(days[value.toInt()],
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall);
                                  }
                                } else {
                                  return Text('${value.toInt()}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall);
                                }
                                return const Text('');
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: selectedPeriod == '7' ? 20 : 50,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              }))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: selectedPeriod == '7' ? 6 : 29,
                  minY: 0,
                  maxY: selectedPeriod == '7' ? 100 : 250,
                  lineBarsData: [
                    LineChartBarData(
                        spots: selectedPeriod == '7'
                            ? chartData7Days
                            : chartData30Days,
                        isCurved: true,
                        gradient: LinearGradient(colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ]),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              return LineTooltipItem(
                                  '${barSpot.y.toInt()} orders',
                                  AppTheme.lightTheme.textTheme.bodyMedium!
                                      .copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          fontWeight: FontWeight.w600));
                            }).toList();
                          }),
                      handleBuiltInTouches: true)))),
        ]));
  }

  Widget _buildPeriodButton(String value, String label) {
    final bool isSelected = selectedPeriod == value;

    return GestureDetector(
        onTap: () => onPeriodChanged(value),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 1)),
            child: Text(label,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500))));
  }
}

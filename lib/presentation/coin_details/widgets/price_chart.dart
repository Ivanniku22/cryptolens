import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/historical_price_model.dart';

class PriceChart extends StatelessWidget {
  final List<HistoricalPriceModel> prices;
  final String selectedRange;
  final List<String> timeRanges;
  final bool isLoading;
  final String errorMessage;
  final ValueChanged<String> onRangeChanged;

  const PriceChart({
    super.key,
    required this.prices,
    required this.selectedRange,
    required this.timeRanges,
    required this.isLoading,
    required this.errorMessage,
    required this.onRangeChanged,
  });

  static const Color _green = Color(0xFF00C853);
  static const Color _red = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF252D33)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Chart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          _buildRangeSelector(),
          const SizedBox(height: 24),
          SizedBox(height: 220, child: _buildChartContent()),
        ],
      ),
    );
  }

  Widget _buildRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: timeRanges.map((range) {
        final isSelected = selectedRange == range;

        return GestureDetector(
          onTap: () => onRangeChanged(range),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? _green.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              range,
              style: TextStyle(
                color: isSelected ? _green : Colors.white60,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChartContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: _green));
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    if (prices.isEmpty) {
      return const Center(
        child: Text(
          'No price data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return _buildLineChart();
  }

  Widget _buildLineChart() {
    final spots = prices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    final priceValues = prices.map((item) => item.price).toList();

    final minPrice = priceValues.reduce((a, b) => a < b ? a : b);

    final maxPrice = priceValues.reduce((a, b) => a > b ? a : b);

    final difference = maxPrice - minPrice;

    final padding = difference == 0 ? maxPrice * 0.01 : difference * 0.15;

    final chartMinY = (minPrice - padding).clamp(0, double.infinity).toDouble();

    final chartMaxY = maxPrice + padding;

    final isPositive = prices.last.price >= prices.first.price;

    final chartColor = isPositive ? _green : _red;

    final yInterval = difference == 0 ? 1.0 : difference / 4;

    final xInterval = prices.length <= 1
        ? 1.0
        : ((prices.length - 1) / 4).ceilToDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (prices.length - 1).toDouble(),
        minY: chartMinY,
        maxY: chartMaxY,

        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withValues(alpha: 0.08),
              strokeWidth: 1,
            );
          },
        ),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                // Hide the boundary labels to prevent overlap.
                if (value <= meta.min || value >= meta.max) {
                  return const SizedBox.shrink();
                }

                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _formatPrice(value),
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();

                if (index < 0 || index >= prices.length) {
                  return const SizedBox.shrink();
                }

                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _formatAxisDate(prices[index].timestamp),
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),

        borderData: FlBorderData(show: false),

        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final price = prices[index];

                return LineTooltipItem(
                  '\$${price.price.toStringAsFixed(4)}\n'
                  '${_formatDate(price.timestamp)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                );
              }).toList();
            },
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: chartColor,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: chartColor.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatPrice(double price) {
    if (price.abs() >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    }

    if (price.abs() >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    }

    if (price.abs() >= 1) {
      return '\$${price.toStringAsFixed(0)}';
    }

    return '\$${price.toStringAsFixed(3)}';
  }

  String _formatAxisDate(DateTime date) {
    if (selectedRange == '1D') {
      return '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    }

    return '${date.day}/${date.month}';
  }
}

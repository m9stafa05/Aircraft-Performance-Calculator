import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, double> results;

  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Results'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultsCard('Flight Parameters', [
              _buildResultRow(
                'Altitude',
                results['altitude'],
                'm',
              ),
              _buildResultRow(
                'Weight',
                results['weight'],
                'N',
              ),
              _buildResultRow(
                'Velocity',
                results['velocity'],
                'm/s',
              ),
            ]),
            const SizedBox(height: 16),
            _buildResultsCard('Forces', [
              _buildResultRow(
                'Lift (L)',
                results['lift'],
                'N',
              ),
              _buildResultRow(
                'Thrust Available (TA)',
                results['thrustAvailable'],
                'N',
              ),
              _buildResultRow(
                'Thrust Required (TR)',
                results['thrustRequired'],
                'N',
              ),
              _buildResultRow(
                'Excess Thrust (ET)',
                results['excessThrust'],
                'N',
              ),
            ]),
            const SizedBox(height: 16),
            _buildResultsCard('Drag Components', [
              _buildResultRow(
                'Parasite Drag (Do)',
                results['parasiteDrag'],
                'N',
              ),
              _buildResultRow(
                'Induced Drag (Di)',
                results['inducedDrag'],
                'N',
              ),
              _buildResultRow(
                'Total Drag (D)',
                results['totalDrag'],
                'N',
              ),
            ]),
            const SizedBox(height: 16),
            _buildResultsCard('Power', [
              _buildResultRow(
                'Power Available (PA)',
                results['powerAvailable'],
                'W',
              ),
              _buildResultRow(
                'Power Required (PR)',
                results['powerRequired'],
                'W',
              ),
              _buildResultRow(
                'Excess Power (EP)',
                results['excessPower'],
                'W',
              ),
            ]),
            const SizedBox(height: 16),
            _buildResultsCard('Performance', [
              _buildResultRow(
                'Rate of Climb (Thrust)',
                results['rateOfClimbThrust'],
                'm/s',
              ),
              _buildResultRow(
                'Rate of Climb (Power)',
                results['rateOfClimbPower'],
                'm/s',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(
    String title,
    List<Widget> rows,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    double? value,
    String unit,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${value?.toStringAsFixed(2) ?? "N/A"} $unit',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, double> results;

  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Data Results'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flight Performance Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                _buildResultSection(
                  title: 'Flight Conditions',
                  items: [
                    ResultItem(
                      'Altitude',
                      results['altitude'],
                      'm',
                    ),
                    ResultItem(
                      'Weight',
                      results['weight'],
                      'N',
                    ),
                  ],
                ),
                _buildResultSection(
                  title: 'Forces',
                  items: [
                    ResultItem(
                      'Lift (L)',
                      results['lift'],
                      'N',
                    ),
                    ResultItem(
                      'Parasite Drag (Do)',
                      results['parasiteDrag'],
                      'N',
                    ),
                    ResultItem(
                      'Induced Drag (Di)',
                      results['inducedDrag'],
                      'N',
                    ),
                    ResultItem(
                      'Total Drag (D)',
                      results['totalDrag'],
                      'N',
                    ),
                  ],
                ),
                _buildResultSection(
                  title: 'Performance',
                  items: [
                    ResultItem(
                      'Thrust Available (TA)',
                      results['thrustAvailable'],
                      'N',
                    ),
                    ResultItem(
                      'Power Available (PA)',
                      results['powerAvailable'],
                      'W',
                    ),
                    ResultItem(
                      'Thrust Required (TR)',
                      results['thrustRequired'],
                      'N',
                    ),
                    ResultItem(
                      'Power Required (PR)',
                      results['powerRequired'],
                      'W',
                    ),
                  ],
                ),
                _buildResultSection(
                  title: 'Excess Performance',
                  items: [
                    ResultItem(
                      'Excess Thrust (ET)',
                      results['excessThrust'],
                      'N',
                    ),
                    ResultItem(
                      'Excess Power (EP)',
                      results['excessPower'],
                      'W',
                    ),
                    ResultItem(
                      'Rate of Climb (Thrust)',
                      results['rateOfClimbThrust'],
                      'm/s',
                    ),
                    ResultItem(
                      'Rate of Climb (Power)',
                      results['rateOfClimbPower'],
                      'm/s',
                    ),
                  ],
                ),
                if (results.containsKey('liftCoefficient'))
                  _buildResultSection(
                    title: 'Coefficients',
                    items: [
                      ResultItem(
                        'Lift Coefficient (CL)',
                        results['liftCoefficient'],
                        '',
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Back to Calculator'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultSection({
    required String title,
    required List<ResultItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => _buildResultRow(item)),
          const Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildResultRow(ResultItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${item.value?.toStringAsFixed(2) ?? "N/A"} ${item.unit}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ResultItem {
  final String label;
  final double? value;
  final String unit;

  ResultItem(this.label, this.value, this.unit);
}

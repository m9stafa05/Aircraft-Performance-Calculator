import 'package:flutter/material.dart';
import 'package:flight_calc/widgets/footer.dart';
import 'package:share_plus/share_plus.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, double> results;
  final Map<String, double>? customParameters;

  const ResultsScreen({
    super.key,
    required this.results,
    this.customParameters,
  });

  String _formatResults() {
    final buffer = StringBuffer();
    buffer.writeln(
      'Aircraft Performance Calculation Results',
    );
    buffer.writeln(
      '=======================================',
    );

    if (customParameters != null) {
      buffer.writeln('\nCustom Parameters:');
      buffer.writeln('-----------------');
      buffer.writeln(
        'Velocity: ${customParameters!['velocity']?.toStringAsFixed(2)} m/s',
      );
      buffer.writeln(
        'Surface Area: ${customParameters!['surfaceArea']?.toStringAsFixed(2)} m²',
      );
      buffer.writeln(
        'Zero-lift Drag Coefficient: ${customParameters!['dragCoefficient']?.toStringAsFixed(4)}',
      );
      buffer.writeln(
        'Aspect Ratio: ${customParameters!['aspectRatio']?.toStringAsFixed(2)}',
      );
      buffer.writeln(
        'Oswald Efficiency Factor: ${customParameters!['oswaldFactor']?.toStringAsFixed(2)}',
      );
      buffer.writeln(
        'Weight: ${customParameters!['weight']?.toStringAsFixed(2)} N',
      );
      buffer.writeln(
        'Air Density: ${customParameters!['airDensity']?.toStringAsFixed(3)} kg/m³',
      );
    }

    buffer.writeln('\nFlight Parameters:');
    buffer.writeln('-----------------');
    buffer.writeln(
      'Altitude: ${results['altitude']?.toStringAsFixed(2)} m',
    );
    buffer.writeln(
      'Weight: ${results['weight']?.toStringAsFixed(2)} N',
    );
    buffer.writeln(
      'Velocity: ${results['velocity']?.toStringAsFixed(2)} m/s',
    );

    buffer.writeln('\nForces:');
    buffer.writeln('-------');
    buffer.writeln(
      'Lift (L): ${results['lift']?.toStringAsFixed(2)} N',
    );
    buffer.writeln(
      'Thrust Available (TA): ${results['thrustAvailable']?.toStringAsFixed(2)} N',
    );
    buffer.writeln(
      'Thrust Required (TR): ${results['thrustRequired']?.toStringAsFixed(2)} N',
    );
    buffer.writeln(
      'Excess Thrust (ET): ${results['excessThrust']?.toStringAsFixed(2)} N',
    );

    buffer.writeln('\nDrag Components:');
    buffer.writeln('---------------');
    buffer.writeln(
      'Parasite Drag (Do): ${results['parasiteDrag']?.toStringAsFixed(2)} N',
    );
    buffer.writeln(
      'Induced Drag (Di): ${results['inducedDrag']?.toStringAsFixed(2)} N',
    );
    buffer.writeln(
      'Total Drag (D): ${results['totalDrag']?.toStringAsFixed(2)} N',
    );

    buffer.writeln('\nPower:');
    buffer.writeln('------');
    buffer.writeln(
      'Power Available (PA): ${results['powerAvailable']?.toStringAsFixed(2)} W',
    );
    buffer.writeln(
      'Power Required (PR): ${results['powerRequired']?.toStringAsFixed(2)} W',
    );
    buffer.writeln(
      'Excess Power (EP): ${results['excessPower']?.toStringAsFixed(2)} W',
    );

    buffer.writeln('\nPerformance:');
    buffer.writeln('-----------');
    buffer.writeln(
      'Rate of Climb (Thrust): ${results['rateOfClimbThrust']?.toStringAsFixed(2)} m/s',
    );
    buffer.writeln(
      'Rate of Climb (Power): ${results['rateOfClimbPower']?.toStringAsFixed(2)} m/s',
    );

    return buffer.toString();
  }

  void _shareResults() {
    final resultsText = _formatResults();
    Share.share(
      resultsText,
      subject: 'Aircraft Performance Calculation Results',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Results'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResults,
            tooltip: 'Share Results',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (customParameters != null) ...[
              _buildResultsCard('Custom Parameters', [
                _buildResultRow(
                  'Velocity',
                  customParameters!['velocity'],
                  'm/s',
                ),
                _buildResultRow(
                  'Surface Area',
                  customParameters!['surfaceArea'],
                  'm²',
                ),
                _buildResultRow(
                  'Zero-lift Drag Coefficient',
                  customParameters!['dragCoefficient'],
                  '',
                ),
                _buildResultRow(
                  'Aspect Ratio',
                  customParameters!['aspectRatio'],
                  '',
                ),
                _buildResultRow(
                  'Oswald Efficiency Factor',
                  customParameters!['oswaldFactor'],
                  '',
                ),
                _buildResultRow(
                  'Weight',
                  customParameters!['weight'],
                  'N',
                ),
                _buildResultRow(
                  'Air Density',
                  customParameters!['airDensity'],
                  'kg/m³',
                ),
              ]),
              const SizedBox(height: 16),
            ],
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
      bottomNavigationBar: const Footer(),
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

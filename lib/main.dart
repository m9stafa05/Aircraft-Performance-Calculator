import 'package:flutter/material.dart';
import 'flight_calc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aircraft Performance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState
    extends State<CalculatorScreen> {
  final AircraftCalculator calculator =
      AircraftCalculator();
  bool useDefaultParameters = true;

  // Text controllers for input fields
  final velocityController = TextEditingController(
    text: '100',
  );
  final surfaceAreaController = TextEditingController(
    text: '30',
  );
  final dragCoefficientController = TextEditingController(
    text: '0.025',
  );
  final aspectRatioController = TextEditingController(
    text: '9.0',
  );
  final oswaldFactorController = TextEditingController(
    text: '0.82',
  );
  final weightController = TextEditingController(
    text: '40000',
  );
  final airDensityController = TextEditingController(
    text: '1.058',
  );
  final altitudeController = TextEditingController(
    text: '0',
  );
  final thrustAvailableController = TextEditingController(
    text: '0',
  );
  final powerAvailableController = TextEditingController(
    text: '0',
  );

  // Results
  Map<String, double> results = {};
  bool hasCalculated = false;

  void _calculatePerformance() {
    // Get values from text fields
    final double velocity =
        double.tryParse(velocityController.text) ?? 100;
    final double surfaceArea =
        double.tryParse(surfaceAreaController.text) ?? 30;
    final double dragCoefficient =
        double.tryParse(dragCoefficientController.text) ??
        0.025;
    final double aspectRatio =
        double.tryParse(aspectRatioController.text) ?? 9.0;
    final double oswaldFactor =
        double.tryParse(oswaldFactorController.text) ??
        0.82;
    final double weight =
        double.tryParse(weightController.text) ?? 40000;
    final double airDensity =
        double.tryParse(airDensityController.text) ?? 1.058;
    final double altitude =
        double.tryParse(altitudeController.text) ?? 0;
    final double thrustAvailable =
        double.tryParse(thrustAvailableController.text) ??
        0;
    final double powerAvailable =
        double.tryParse(powerAvailableController.text) ?? 0;

    // Update calculator parameters
    calculator.updateParameters(
      velocity: velocity,
      surfaceArea: surfaceArea,
      dragCoefficient: dragCoefficient,
      aspectRatio: aspectRatio,
      oswaldFactor: oswaldFactor,
      weight: weight,
      airDensity: airDensity,
    );

    // Calculate results
    results = calculator.calculatePerformance(
      altitude: altitude,
      thrustAvailable: thrustAvailable,
      powerAvailable: powerAvailable,
    );

    setState(() {
      hasCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aircraft Performance Calculator',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Parameters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text(
                              'Use Default Parameters',
                            ),
                            value: true,
                            groupValue:
                                useDefaultParameters,
                            onChanged: (value) {
                              setState(() {
                                useDefaultParameters =
                                    value!;
                                if (useDefaultParameters) {
                                  // Reset to default values
                                  velocityController.text =
                                      '100';
                                  surfaceAreaController
                                      .text = '30';
                                  dragCoefficientController
                                      .text = '0.025';
                                  aspectRatioController
                                      .text = '9.0';
                                  oswaldFactorController
                                      .text = '0.82';
                                  weightController.text =
                                      '40000';
                                  airDensityController
                                      .text = '1.058';
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text(
                              'Custom Parameters',
                            ),
                            value: false,
                            groupValue:
                                useDefaultParameters,
                            onChanged: (value) {
                              setState(() {
                                useDefaultParameters =
                                    value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (!useDefaultParameters)
                      Column(
                        children: [
                          _buildInputField(
                            'Velocity (m/s)',
                            velocityController,
                          ),
                          _buildInputField(
                            'Surface Area (m²)',
                            surfaceAreaController,
                          ),
                          _buildInputField(
                            'Zero-lift Drag Coefficient',
                            dragCoefficientController,
                          ),
                          _buildInputField(
                            'Aspect Ratio',
                            aspectRatioController,
                          ),
                          _buildInputField(
                            'Oswald Efficiency Factor',
                            oswaldFactorController,
                          ),
                          _buildInputField(
                            'Weight (N)',
                            weightController,
                          ),
                          _buildInputField(
                            'Air Density (kg/m³)',
                            airDensityController,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Required Inputs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Altitude (m)',
                      altitudeController,
                    ),
                    _buildInputField(
                      'Thrust Available (N)',
                      thrustAvailableController,
                    ),
                    _buildInputField(
                      'Power Available (W)',
                      powerAvailableController,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculatePerformance,
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Calculate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasCalculated) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildResultRow(
                        'Altitude',
                        results['altitude'],
                        'm',
                      ),
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
                        'Power Available (PA)',
                        results['powerAvailable'],
                        'W',
                      ),
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
                      _buildResultRow(
                        'Thrust Required (TR)',
                        results['thrustRequired'],
                        'N',
                      ),
                      _buildResultRow(
                        'Power Required (PR)',
                        results['powerRequired'],
                        'W',
                      ),
                      _buildResultRow(
                        'Excess Thrust (ET)',
                        results['excessThrust'],
                        'N',
                      ),
                      _buildResultRow(
                        'Excess Power (EP)',
                        results['excessPower'],
                        'W',
                      ),
                      _buildResultRow(
                        'Weight',
                        results['weight'],
                        'N',
                      ),
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
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
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

  @override
  void dispose() {
    // Dispose controllers when widget is disposed
    velocityController.dispose();
    surfaceAreaController.dispose();
    dragCoefficientController.dispose();
    aspectRatioController.dispose();
    oswaldFactorController.dispose();
    weightController.dispose();
    airDensityController.dispose();
    altitudeController.dispose();
    thrustAvailableController.dispose();
    powerAvailableController.dispose();
    super.dispose();
  }
}

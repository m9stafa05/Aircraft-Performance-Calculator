import 'package:flutter/material.dart';
import 'flight_calc.dart';
import 'results_screen.dart';

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
  bool showValidationErrors = false;

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
  final altitudeController = TextEditingController();
  final thrustAvailableController = TextEditingController();
  final powerAvailableController = TextEditingController();

  // Results
  Map<String, double> results = {};
  bool hasCalculated = false;

  String? _validateRequiredInput(String? value) {
    if (!showValidationErrors) return null;
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _calculatePerformance() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Set validation flag to true
    setState(() {
      showValidationErrors = true;
    });

    // Validate required inputs
    final altitudeError = _validateRequiredInput(
      altitudeController.text,
    );
    final thrustError = _validateRequiredInput(
      thrustAvailableController.text,
    );
    final powerError = _validateRequiredInput(
      powerAvailableController.text,
    );

    if (altitudeError != null ||
        thrustError != null ||
        powerError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields with valid numbers',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
    final double altitude = double.parse(
      altitudeController.text,
    );
    final double thrustAvailable = double.parse(
      thrustAvailableController.text,
    );
    final double powerAvailable = double.parse(
      powerAvailableController.text,
    );

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

    // Add velocity to results for display
    results['velocity'] = velocity;

    // Navigate to results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ResultsScreen(results: results),
      ),
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
                    _buildRequiredInputField(
                      'Altitude (m)',
                      altitudeController,
                    ),
                    _buildRequiredInputField(
                      'Thrust Available (N)',
                      thrustAvailableController,
                    ),
                    _buildRequiredInputField(
                      'Power Available (W)',
                      powerAvailableController,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _calculatePerformance,
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                hasCalculated = false;
                                results.clear();
                                showValidationErrors =
                                    false;
                                // Reset input fields to default values
                                velocityController.text =
                                    '100';
                                surfaceAreaController.text =
                                    '30';
                                dragCoefficientController
                                    .text = '0.025';
                                aspectRatioController.text =
                                    '9.0';
                                oswaldFactorController
                                    .text = '0.82';
                                weightController.text =
                                    '40000';
                                airDensityController.text =
                                    '1.058';
                                altitudeController.clear();
                                thrustAvailableController
                                    .clear();
                                powerAvailableController
                                    .clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Clear'),
                          ),
                        ),
                      ],
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

  Widget _buildRequiredInputField(
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
          errorText: _validateRequiredInput(
            controller.text,
          ),
          suffixIcon: const Icon(
            Icons.star,
            color: Colors.red,
            size: 12,
          ),
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

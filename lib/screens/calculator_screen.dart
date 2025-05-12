import 'package:flight_calc/flight_calc.dart';
import 'package:flight_calc/screens/custom_parameters_screen.dart';
import 'package:flight_calc/screens/results_screen.dart';
import 'package:flutter/material.dart';

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
  Map<String, double>? customParameters;

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

  void _openCustomParameters() {
    final defaultValues = {
      'velocity':
          double.tryParse(velocityController.text) ?? 100,
      'surfaceArea':
          double.tryParse(surfaceAreaController.text) ?? 30,
      'dragCoefficient':
          double.tryParse(dragCoefficientController.text) ??
          0.025,
      'aspectRatio':
          double.tryParse(aspectRatioController.text) ??
          9.0,
      'oswaldFactor':
          double.tryParse(oswaldFactorController.text) ??
          0.82,
      'weight':
          double.tryParse(weightController.text) ?? 40000,
      'airDensity':
          double.tryParse(airDensityController.text) ??
          1.058,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CustomParametersScreen(
              defaultValues: defaultValues,
              onParametersSaved: (parameters) {
                setState(() {
                  customParameters = parameters;
                  useDefaultParameters = false;
                  // Update the calculator with new parameters
                  calculator.updateParameters(
                    velocity: parameters['velocity']!,
                    surfaceArea: parameters['surfaceArea']!,
                    dragCoefficient:
                        parameters['dragCoefficient']!,
                    aspectRatio: parameters['aspectRatio']!,
                    oswaldFactor:
                        parameters['oswaldFactor']!,
                    weight: parameters['weight']!,
                    airDensity: parameters['airDensity']!,
                  );
                });
              },
            ),
      ),
    );
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
    // ignore: unused_local_variable
    final double surfaceArea =
        double.tryParse(surfaceAreaController.text) ?? 30;
    // ignore: unused_local_variable
    final double dragCoefficient =
        double.tryParse(dragCoefficientController.text) ??
        0.025;
    // ignore: unused_local_variable
    final double aspectRatio =
        double.tryParse(aspectRatioController.text) ?? 9.0;
    // ignore: unused_local_variable
    final double oswaldFactor =
        double.tryParse(oswaldFactorController.text) ??
        0.82;
    // ignore: unused_local_variable
    final double weight =
        double.tryParse(weightController.text) ?? 40000;
    // ignore: unused_local_variable
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
            (context) => ResultsScreen(
              results: results,
              customParameters: customParameters,
            ),
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
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Parameters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            if (customParameters != null)
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    customParameters = null;
                                    useDefaultParameters =
                                        true;
                                    // Reset to default values
                                    velocityController
                                        .text = '100';
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
                                  });
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Reset to Default',
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.red,
                                ),
                              ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed:
                                  _openCustomParameters,
                              icon: const Icon(
                                Icons.settings,
                              ),
                              label: Text(
                                customParameters != null
                                    ? 'Edit Parameters'
                                    : 'Custom Parameters',
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue,
                                    foregroundColor:
                                        Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (customParameters != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Current Custom Parameters:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildParameterRow(
                        'Velocity',
                        customParameters!['velocity'],
                        'm/s',
                      ),
                      _buildParameterRow(
                        'Surface Area',
                        customParameters!['surfaceArea'],
                        'm²',
                      ),
                      _buildParameterRow(
                        'Zero-lift Drag Coefficient',
                        customParameters!['dragCoefficient'],
                        '',
                      ),
                      _buildParameterRow(
                        'Aspect Ratio',
                        customParameters!['aspectRatio'],
                        '',
                      ),
                      _buildParameterRow(
                        'Oswald Efficiency Factor',
                        customParameters!['oswaldFactor'],
                        '',
                      ),
                      _buildParameterRow(
                        'Weight',
                        customParameters!['weight'],
                        'N',
                      ),
                      _buildParameterRow(
                        'Air Density',
                        customParameters!['airDensity'],
                        'kg/m³',
                      ),
                    ],
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
                                customParameters = null;
                                useDefaultParameters = true;
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

  // ignore: unused_element
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

  Widget _buildParameterRow(
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

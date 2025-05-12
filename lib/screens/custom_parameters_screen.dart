import 'package:flutter/material.dart';
import 'package:flight_calc/widgets/footer.dart';

class CustomParametersScreen extends StatefulWidget {
  final Map<String, double> defaultValues;
  final Function(Map<String, double>) onParametersSaved;

  const CustomParametersScreen({
    super.key,
    required this.defaultValues,
    required this.onParametersSaved,
  });

  @override
  State<CustomParametersScreen> createState() =>
      _CustomParametersScreenState();
}

class _CustomParametersScreenState
    extends State<CustomParametersScreen> {
  final velocityController = TextEditingController();
  final surfaceAreaController = TextEditingController();
  final dragCoefficientController = TextEditingController();
  final aspectRatioController = TextEditingController();
  final oswaldFactorController = TextEditingController();
  final weightController = TextEditingController();
  final airDensityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    velocityController.text =
        widget.defaultValues['velocity']?.toString() ??
        '100';
    surfaceAreaController.text =
        widget.defaultValues['surfaceArea']?.toString() ??
        '30';
    dragCoefficientController.text =
        widget.defaultValues['dragCoefficient']
            ?.toString() ??
        '0.025';
    aspectRatioController.text =
        widget.defaultValues['aspectRatio']?.toString() ??
        '9.0';
    oswaldFactorController.text =
        widget.defaultValues['oswaldFactor']?.toString() ??
        '0.82';
    weightController.text =
        widget.defaultValues['weight']?.toString() ??
        '40000';
    airDensityController.text =
        widget.defaultValues['airDensity']?.toString() ??
        '1.058';
  }

  void _saveParameters() {
    final parameters = {
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
    widget.onParametersSaved(parameters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Parameters'),
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
                      'Aircraft Parameters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveParameters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Parameters'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
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

  @override
  void dispose() {
    velocityController.dispose();
    surfaceAreaController.dispose();
    dragCoefficientController.dispose();
    aspectRatioController.dispose();
    oswaldFactorController.dispose();
    weightController.dispose();
    airDensityController.dispose();
    super.dispose();
  }
}

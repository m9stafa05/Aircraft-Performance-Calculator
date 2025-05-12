import 'dart:math';

class AircraftCalculator {
  // Default parameters
  double velocity = 100; // Velocity (m/s)
  double surfaceArea = 30; // Surface area (m²)
  double dragCoefficient =
      0.025; // Zero-lift[parasite] drag coefficient
  double aspectRatio = 9.0; // Aspect ratio
  double oswaldFactor = 0.82; // Oswald efficiency factor
  double weight = 40000; // Weight Of A/C (N)
  double airDensity = 1.058; // Air density (kg/m³)

  // Update the parameters
  void updateParameters({
    double? velocity,
    double? surfaceArea,
    double? dragCoefficient,
    double? aspectRatio,
    double? oswaldFactor,
    double? weight,
    double? airDensity,
  }) {
    this.velocity = velocity ?? this.velocity;
    this.surfaceArea = surfaceArea ?? this.surfaceArea;
    this.dragCoefficient =
        dragCoefficient ?? this.dragCoefficient;
    this.aspectRatio = aspectRatio ?? this.aspectRatio;
    this.oswaldFactor = oswaldFactor ?? this.oswaldFactor;
    this.weight = weight ?? this.weight;
    this.airDensity = airDensity ?? this.airDensity;
  }

  // Calculate performance values
  Map<String, double> calculatePerformance({
    required double altitude,
    required double thrustAvailable,
    required double powerAvailable,
  }) {
    // Calculate lift coefficient
    final double liftCoefficient =
        (2 * weight) /
        (airDensity * pow(velocity, 2) * surfaceArea);

    // Calculate lift
    final double lift =
        0.5 *
        airDensity *
        pow(velocity, 2) *
        surfaceArea *
        liftCoefficient;

    // Calculate parasite drag
    final double parasiteDrag =
        0.5 *
        airDensity *
        pow(velocity, 2) *
        surfaceArea *
        dragCoefficient;

    // Calculate induced drag coefficient
    final double inducedDragCoeff =
        pow(liftCoefficient, 2) /
        (pi * oswaldFactor * aspectRatio);

    // Calculate induced drag
    final double inducedDrag =
        0.5 *
        airDensity *
        pow(velocity, 2) *
        surfaceArea *
        inducedDragCoeff;

    // Calculate total drag
    final double totalDrag = parasiteDrag + inducedDrag;

    // Calculate thrust required
    final double thrustRequired = totalDrag;

    // Calculate power required
    final double powerRequired = thrustRequired * velocity;

    // Calculate excess thrust
    final double excessThrust =
        thrustAvailable - thrustRequired;

    // Calculate excess power
    final double excessPower =
        powerAvailable - powerRequired;

    // Calculate rate of climb using thrust
    final double rateOfClimbThrust =
        (excessThrust * velocity) / weight;

    // Calculate rate of climb using power
    final double rateOfClimbPower = excessPower / weight;

    // Return all the results in a map
    return {
      'altitude': altitude,
      'lift': lift,
      'thrustAvailable': thrustAvailable,
      'powerAvailable': powerAvailable,
      'parasiteDrag': parasiteDrag,
      'inducedDrag': inducedDrag,
      'totalDrag': totalDrag,
      'thrustRequired': thrustRequired,
      'powerRequired': powerRequired,
      'excessThrust': excessThrust,
      'excessPower': excessPower,
      'weight': weight,
      'rateOfClimbThrust': rateOfClimbThrust,
      'rateOfClimbPower': rateOfClimbPower,
      'liftCoefficient': liftCoefficient,
    };
  }
}

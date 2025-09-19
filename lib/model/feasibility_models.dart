import 'package:flutter/material.dart';

class FeasibilityRequest {
  final double roofArea;
  final String pincode;

  FeasibilityRequest({
    required this.roofArea,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'roof_area': roofArea,
      'pincode': pincode,
    };
  }
}

class FeasibilityResponse {
  final FeasibilityInput input;
  final LocationData location;
  final EnvironmentalData data;
  final FeasibilityScores feasibilityScores;
  final String? warning;

  FeasibilityResponse({
    required this.input,
    required this.location,
    required this.data,
    required this.feasibilityScores,
    this.warning,
  });

  factory FeasibilityResponse.fromJson(Map<String, dynamic> json) {
    return FeasibilityResponse(
      input: FeasibilityInput.fromJson(json['input']),
      location: LocationData.fromJson(json['location']),
      data: EnvironmentalData.fromJson(json['data']),
      feasibilityScores: FeasibilityScores.fromJson(json['feasibility_scores']),
      warning: json['warning'],
    );
  }

  // Get the best feasibility method
  MethodScore getBestMethod() {
    return feasibilityScores.getBestMethod();
  }
}

class FeasibilityInput {
  final double roofArea;
  final String pincode;

  FeasibilityInput({required this.roofArea, required this.pincode});

  factory FeasibilityInput.fromJson(Map<String, dynamic> json) {
    return FeasibilityInput(
      roofArea: json['roof_area'].toDouble(),
      pincode: json['pincode'],
    );
  }
}

class LocationData {
  final String district;
  final String state;

  LocationData({required this.district, required this.state});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      district: json['district'],
      state: json['state'],
    );
  }
}

class EnvironmentalData {
  final double avgMonsoon;
  final double maxMonsoon;
  final String soilType;
  final double gwDepthM;

  EnvironmentalData({
    required this.avgMonsoon,
    required this.maxMonsoon,
    required this.soilType,
    required this.gwDepthM,
  });

  factory EnvironmentalData.fromJson(Map<String, dynamic> json) {
    return EnvironmentalData(
      avgMonsoon: json['avg_monsoon'].toDouble(),
      maxMonsoon: json['max_monsoon'].toDouble(),
      soilType: json['soil_type'],
      gwDepthM: json['gw_depth_m'].toDouble(),
    );
  }
}

class FeasibilityScores {
  final double soakPit;
  final double rechargePit;
  final double trench;
  final double dugWell;
  final double shaft;

  FeasibilityScores({
    required this.soakPit,
    required this.rechargePit,
    required this.trench,
    required this.dugWell,
    required this.shaft,
  });

  factory FeasibilityScores.fromJson(Map<String, dynamic> json) {
    return FeasibilityScores(
      soakPit: json['soak_pit'].toDouble(),
      rechargePit: json['recharge_pit'].toDouble(),
      trench: json['trench'].toDouble(),
      dugWell: json['dug_well'].toDouble(),
      shaft: json['shaft'].toDouble(),
    );
  }

  List<MethodScore> toMethodScores() {
    return [
      MethodScore(
        name: 'Soak Pit',
        score: soakPit,
        description: 'Simple infiltration system for small areas',
        icon: Icons.water_drop,
        color: Colors.blue,
      ),
      MethodScore(
        name: 'Recharge Pit',
        score: rechargePit,
        description: 'Deep pit for groundwater recharge',
        icon: Icons.vertical_align_bottom,
        color: Colors.green,
      ),
      MethodScore(
        name: 'Trench',
        score: trench,
        description: 'Long channel for water collection',
        icon: Icons.linear_scale,
        color: Colors.orange,
      ),
      MethodScore(
        name: 'Dug Well',
        score: dugWell,
        description: 'Traditional well for water storage',
        icon: Icons.circle_outlined,
        color: Colors.brown,
      ),
      MethodScore(
        name: 'Shaft',
        score: shaft,
        description: 'Deep shaft for high-capacity recharge',
        icon: Icons.height,
        color: Colors.purple,
      ),
    ];
  }

  // Get the best feasibility method based on highest score
  MethodScore getBestMethod() {
    List<MethodScore> methods = toMethodScores();

    // Sort by score in descending order and return the first (highest)
    methods.sort((a, b) => b.score.compareTo(a.score));
    return methods.first;
  }

  // Get top N methods (optional - useful if you want top 2-3 methods)
  List<MethodScore> getTopMethods(int count) {
    List<MethodScore> methods = toMethodScores();
    methods.sort((a, b) => b.score.compareTo(a.score));
    return methods.take(count).toList();
  }

  // Get the highest score value only
  double getBestScore() {
    return [soakPit, rechargePit, trench, dugWell, shaft].reduce((a, b) => a > b ? a : b);
  }

  // Get the name of the best method
  String getBestMethodName() {
    double bestScore = getBestScore();

    if (bestScore == soakPit) return 'Soak Pit';
    if (bestScore == rechargePit) return 'Recharge Pit';
    if (bestScore == trench) return 'Trench';
    if (bestScore == dugWell) return 'Dug Well';
    if (bestScore == shaft) return 'Shaft';

    return 'Unknown';
  }
}

class MethodScore {
  final String name;
  final double score;
  final String description;
  final IconData icon;
  final Color color;

  MethodScore({
    required this.name,
    required this.score,
    required this.description,
    required this.icon,
    required this.color,
  });

  String get feasibilityText {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    if (score >= 20) return 'Poor';
    return 'Not Suitable';
  }

  Color get feasibilityColor {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    if (score >= 20) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  String toString() {
    return '$name: $score ($feasibilityText)';
  }
}
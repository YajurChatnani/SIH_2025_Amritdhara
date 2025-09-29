//schema
//Input:
//final rainfallIntensity = null;
//     final maxMonsoonRainfall = null;
//     final rainfallPrediction = null;
//     final soilTexture = null;
//     final gwl = null;
//roof area
// open area

//Output;
//"soak_pit": clamp(fSoak, 0, 100),
//       "recharge_pit": clamp(fPit, 0, 100),
//       "trench": clamp(fTrench, 0, 100),
//       "shaft": clamp(fShaft, 0, 100),
//       "garden_pit": clamp(fGarden, 0, 100),

// Define the clamp function as provided
double min(double x , double y){
  if(x>y) return y;
  else return x;
}
double clamp(double x, double low, double high) {
  return x.clamp(low, high); // Using Dart's built-in clamp method
}

// Define the computeFeasibility function as provided
Map<String, dynamic> computeFeasibility(double roofArea, double openArea, Map<String, dynamic> data) {
  // Soil score
  final soilScores = {
    "sand": 1.0,
    "sandy loam": 1.0,
    "loamy sand": 0.8,
    "loam": 0.8,
    "silt loam": 0.6,
    "silty": 0.6,
    "clay loam": 0.4,
    "sandy clay loam": 0.4,
    "clay": 0.2,
    "silty clay": 0.2,
  };
  double s = soilScores[data["soil_type"]?.toLowerCase()] ?? 0.5;
  double c = 1.0; // Hardcoded as per provided code
  double g = (data["gw_depth_m"] as num?)?.toDouble() ?? 0.0;

  // Rainfall factor
  double intensity = (data["rainfall intensity"] as num?)?.toDouble() ?? 0.0;
  double maxRainfall = (data["max_monsoon_rainfall"] as num?)?.toDouble() ?? 0.0;
  double annualRainfall = (data["annual_ranfall"] as num?)?.toDouble() ?? 0.0;
  double normInt = clamp((intensity - 50) / (300 - 50), 0.1, 1.0);
  double normMax = clamp((maxRainfall - 100) / (500 - 100), 0.1, 1.0);
  double normAnn = clamp((annualRainfall - 400) / (2000 - 400), 0.1, 1.0);
  double rf = clamp(0.4 * normInt + 0.3 * normMax + 0.3 * normAnn, 0.1, 1.0);

  // Groundwater factors
  double gfGeneric = g <= 15 ? clamp((g - 3) / (15 - 3), 0.2, 1.0) : clamp((30 - g) / (30 - 15), 0.2, 1.0);
  double gfDug = g <= 15 ? clamp((g - 3) / (15 - 3), 0.2, 1.0) : clamp((30 - g) / (30 - 15), 0.2, 0.7);
  double gfShaft = g <= 40 ? clamp((g - 8) / (40 - 8), 0.2, 1.0) : clamp((60 - g) / (60 - 40), 0.2, 0.5);

  // Roof area factors
  double raSoak = min(1.0, roofArea / 20);
  double raPit = min(1.0, roofArea / 50);
  double raTrench = min(1.0, roofArea / 100);
  double raShaft = min(1.0, roofArea / 30);
  double raGarden = min(1.0, roofArea / 40);

  // Feasibility scores
  double fSoak = 100 * (0.36 * s + 0.24 * rf + 0.20 * c + 0.20 * raSoak);
  if (g < 3) fSoak *= 0.4;
  if (openArea < 2 || s < 0.4 || annualRainfall < 600) {
    fSoak = s < 0.4 ? 0 : annualRainfall < 600 ? fSoak * 0.5 : fSoak;
  }

  double fPit = 100 * (0.30 * s + 0.25 * rf + 0.20 * gfGeneric + 0.15 * c + 0.10 * raPit);
  if (g < 3) fPit *= 0.35;
  if (g < 8) fPit *= 0.5;
  if (s < 0.6) fPit *= (s / 0.6);
  if (openArea < 4 || intensity < 50) fPit = 0;

  double fTrench = 100 * (0.28 * s + 0.28 * rf + 0.20 * raTrench + 0.14 * gfGeneric + 0.10 * c);
  if (intensity > 100) fTrench *= 0.8;
  if (openArea < 10 || s < 0.5 || roofArea < 200) fTrench = 0;

  double fShaft = 100 * (0.40 * gfShaft + 0.22 * rf + 0.15 * s + 0.10 * c + 0.10 * raShaft);
  if (s > 0.6) fShaft *= (1 - s + 0.4);
  if (openArea < 1 || g < 8 || annualRainfall < 200) fShaft = 0;
  if (maxRainfall < 100) fShaft *= 0.5;

  double fGarden = 100 * (0.32 * s + 0.25 * rf + 0.20 * gfDug + 0.13 * c + 0.10 * raGarden);
  if (g < 3) fGarden *= 0.35;
  if (g > 30) fGarden *= 0.5;
  if (openArea < 3 || s < 0.5 || annualRainfall < 1000) {
    fGarden = s < 0.5 ? 0 : annualRainfall < 1000 ? fGarden * (annualRainfall / 1000) : fGarden;
  }

  if (c == 0 || annualRainfall < 200 || (g < 2 && fShaft == 0)) {
    return {
      "result": {
        "soak_pit": 0.0,
        "recharge_pit": 0.0,
        "trench": 0.0,
        "shaft": 0.0,
        "garden_pit": 0.0,
      },
      "error": "Invalid conditions",
    };
  }

  return {
    "result": {
      "soak_pit": clamp(fSoak, 0, 100),
      "recharge_pit": clamp(fPit, 0, 100),
      "trench": clamp(fTrench, 0, 100),
      "shaft": clamp(fShaft, 0, 100),
      "garden_pit": clamp(fGarden, 0, 100),
    },
    "error": null,
  };
}

class FeasibilityResponse{
  final Map<String, double> feasibilityScores;

  FeasibilityResponse({
    required this.feasibilityScores,
  });
}

// Updated fetchFeasibilityData function
  Future<FeasibilityResponse> fetchFeasibilityData({
  required double? rainfallIntensity,
  required double? maxMonsoonRainfall,
  required double? rainfallPrediction,
  required String? soilTexture,
  required double? gwl,
  required double? roofArea,
  required double? openArea,
  }) async {
  // Prepare input data map for computeFeasibility
  Map<String, dynamic> data = {
    "soil_type": soilTexture,
    "gw_depth_m": gwl,
    "rainfall intensity": rainfallIntensity,
    "max_monsoon_rainfall": maxMonsoonRainfall,
    "annual_ranfall": rainfallPrediction, // Mapping rainfallPrediction to annual_ranfall
  };

  // Ensure non-null roofArea and openArea, default to 0 if null
  double effectiveRoofArea = roofArea ?? 0.0;
  double effectiveOpenArea = openArea ?? 0.0;

  // Call computeFeasibility
  Map<String, dynamic> feasibilityResult = computeFeasibility(effectiveRoofArea, effectiveOpenArea, data);

  // Check for error conditions
  if (feasibilityResult["error"] != null) {
    return FeasibilityResponse(
      feasibilityScores: {
        "soak_pit": 0.0,
        "recharge_pit": 0.0,
        "trench": 0.0,
        "shaft": 0.0,
        "garden_pit": 0.0,
      },
    );
  }

  // Extract result and return FeasibilityResponse
  Map<String, double> feasibilityScores = Map<String, double>.from(feasibilityResult["result"]);
  print(feasibilityResult["result"]);
  return FeasibilityResponse(
    feasibilityScores: feasibilityScores,
  );
  }




//
// class FeasibilityResponse{
//   final Map<String, double> feasibilityScores;
//
//   FeasibilityResponse({
//     required this.feasibilityScores,
//   });
// }
//
// Future <FeasibilityResponse> fetchFeasibilityData({
//   required double? rainfallIntensity,
//   required double? maxMonsoonRainfall,
//   required double? rainfallPrediction,
//   required String? soilTexture,
//   required double? gwl,
//   required double? roofArea,
//   required double? openArea,
// })
//
// async {
//   Map<String, double> feasiblityData = {
//     "Recharge pit": 55.0,
//     "Soak pit": 60.0,
//     "Recharge Shaft": 55.0,
//     "Recharge Trench": 70.0,
//     "Recharge Garden Pit": 40.0,
//   };
//
//   return FeasibilityResponse(
//     feasibilityScores: feasiblityData
//   );
// }


//
// #input lena hai from user_input screen
//
// # processing
//
// #outdena hai
//
// class Feasibility_Score{
//     final max_rainfall;
//     final annual_rainfall;
//     final monsoon_rainfall;
//     final groundwaterlevel;
//     final soil_type;
//     final roof_area;
// }

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

class FeasibilityResponse{
  final Map<String, double> feasibilityScores;

  FeasibilityResponse({
    required this.feasibilityScores,
  });
}

Future <FeasibilityResponse> fetchFeasibilityData({
  required double? rainfallIntensity,
  required double? maxMonsoonRainfall,
  required double? rainfallPrediction,
  required String? soilTexture,
  required double? gwl,
  required double? roofArea,
  required double? openArea,
})

async {
  Map<String, double> feasiblityData = {
    "Recharge pit": 55.0,
    "Soak pit": 60.0,
    "Recharge Shaft": 55.0,
    "Recharge Trench": 70.0,
    "Recharge Garden Pit": 40.0,
  };

  return FeasibilityResponse(
    feasibilityScores: feasiblityData
  );
}


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

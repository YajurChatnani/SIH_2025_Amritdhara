
// take input such as pincode, roofarea,open_area,no of dwelrres

//import all csv files

//pincode_of_india.csv se pincode match krke find out district and statename

//prediction_2025 mein district se waha ka
// rainfall_intensity = (Predicted_Avg_Above_Avg_2025)
// max_monsoon_rainfall = (Predicted_max_monsoon_2025)
// annual_monsoon_rainfall = (Predicted_annual_monsoon_2025)


//soil_texture.csv mein statename se waha ka
//soil_texture = (Dominant Soil Texture)

//gwl.csv mein statename se waha ka
//groundwaterlevel = (Post-Monsoon Depth (mbgl))


// lib/model/data_fetch.dart

/// Generic class to hold structured data returned by data_fetch.dart
class DataResponse {
  final Map<String, double> structureScores;
  final int costEstimate_low;
  final int costEstimate_high;// e.g., cost, maintenance, etc.
  final int annual_harvest_potential; // e.g., water harvest, yield, etc.

  DataResponse({
    required this.structureScores,
    required this.costEstimate_low,
    required this.costEstimate_high,
    required this.annual_harvest_potential,
  });
}

/// Generic function to simulate fetching data based on user input
DataResponse fetchData({
  required double roofArea,
  required String pincode,
  required String address,
  required String roofMaterial,
  required String locationType,
  required double openArea,
  required int dwellers,
}) {
  // For now, return predefined/dummy data
  Map<String, double> structures = {
    "Recharge pit": 55.0,
    "Soak pit": 60.0,
    "Recharge Shaft": 55.0,
    "Recharge Trench": 80.0,
    "Recharge Garden Pit": 40.0,
  };

  return DataResponse(
    structureScores : structures,
    costEstimate_low: 1000,
    costEstimate_high: 2000,
    annual_harvest_potential: 26000,
  );
}


// schema final fetchedData = (
// bestfeasibilityScore: 50.0,
// bestStructure : "Recharge pit",
// cost : 1000,
// annual_harvest_potential: 26000,
// );

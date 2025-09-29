// lib/model/data_fetch.dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'cost_and_harvest.dart';
import 'package:flutter/foundation.dart' show compute;
import 'feasibility_score.dart';

// Cache for CSV data
List<List<dynamic>>? _cachedCsvData;

// Initialize CSV data
Future<void> initializeCsvData() async {
  try {
    if (_cachedCsvData == null) {
      final csvString = await rootBundle.loadString('lib/rainwater_backend/pincodes_of_india.csv');
      _cachedCsvData = await compute(CsvToListConverter().convert, csvString);
    }
  } catch (e) {
    print('Error loading CSV: $e');
    _cachedCsvData = []; // Fallback to empty list
  }
}

/// Generic class to hold structured data returned by data_fetch.dart
class DataResponse {
  final Map<String, double> structureScores;
  final int costEstimateLow;
  final int costEstimateHigh;// e.g., cost, maintenance, etc.
  final int annualHarvestPotential; // e.g., water harvest, yield, etc.
  final int waterSustainabilityDays;

  DataResponse({
    required this.structureScores,
    required this.costEstimateLow,
    required this.costEstimateHigh,
    required this.annualHarvestPotential,
    required this.waterSustainabilityDays,
  });
}

Future<Map<String, String>?> getLocationFromPincode(String pincode) async {
// Existing getLocationFromPincode function (using cached data)
  if (_cachedCsvData == null) {
    await initializeCsvData();
  }
  final csvData = _cachedCsvData!;

  // final csvString =
  // await rootBundle.loadString('lib/rainwater_backend/pincodes_of_india.csv');
  // final csvData = const CsvToListConverter().convert(csvString);
  if (csvData.isEmpty) return null;

  final header = csvData[0];
  final indexes = {
    'pincode': header.indexOf('pincode'),
    'district': header.indexOf('district'),
    'state': header.indexOf('statename'),
  };

  // for (int i = 1; i < csvData.length; i++) {
  //   final row = csvData[i];
  //   if (row[indexes['pincode']!].toString() == pincode) {
  //     return {
  //       'district': row[indexes['district']!].toString(),
  //       'state': row[indexes['state']!].toString(),
  //     };
  //   }
  // }
  //
  // return null;

  int left = 1;
  int right = csvData.length - 1;

  while (left <= right) {
    int mid = (left + right) ~/ 2;
    var row = csvData[mid];
    String midPincode =  row[indexes['pincode']!].toString();

    if (midPincode == pincode) {
      return {
        'district': row[indexes['district']!].toString(),
        'state': row[indexes['state']!].toString(),
      };
    } else if (midPincode.compareTo(pincode) < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return null;
}

Future<Map<String, String>?> getPredictionsFromDistrict(String district) async {

  final csvString =
  await rootBundle.loadString('lib/rainwater_backend/predictions_2025.csv');
  final csvData = const CsvToListConverter().convert(csvString);

  if (csvData.isEmpty) return null;

  final header = csvData[0];
  final indexes = {
    'DIST': header.indexOf('DIST'),
    'Predicted_Avg_Above_Avg_2025': header.indexOf('Predicted_Avg_Above_Avg_2025'),
    'Predicted_max_monsoon_2025': header.indexOf('Predicted_max_monsoon_2025'),
    'Predicted_annual_monsoon_2025': header.indexOf('Predicted_annual_monsoon_2025'),
  };

  for (int i = 1; i < csvData.length; i++) {
    final row = csvData[i];
    if (row[indexes['DIST']!].toString().trim().toUpperCase() == district.trim().toUpperCase()) {
      return {
        'rainfall_intensity' : row[indexes['Predicted_Avg_Above_Avg_2025']!].toString(),
        'max_monsoon_rainfall' : row[indexes['Predicted_max_monsoon_2025']!].toString(),
        'annual_monsoon_rainfall' : row[indexes['Predicted_annual_monsoon_2025']!].toString(),
      };
    }
  }

  return null;
//
//   int left = 1;
//   int right = csvData.length - 1;
//
//   while (left <= right) {
//     int mid = (left + right) ~/ 2;
//     var row = csvData[mid];
//     String midDist =  row[indexes['DIST']!].toString();
//
//     if (midDist == district) {
//       return {
//         'rainfall_intensity' : row[indexes['Predicted_Avg_Above_Avg_2025']!].toString(),
//         'max_monsoon_rainfall' : row[indexes['Predicted_max_monsoon_2025']!].toString(),
//         'annual_monsoon_rainfall' : row[indexes['Predicted_annual_monsoon_2025']!].toString(),
//       };
//     } else if (midDist.compareTo(district) < 0) {
//       left = mid + 1;
//     } else {
//       right = mid - 1;
//     }
//   }
//   return null;
}

Future<Map<String, String>?> getSoilTextureFromState(String state) async {

  final csvString =
  await rootBundle.loadString('lib/rainwater_backend/soil_texture.csv');
  final csvData = const CsvToListConverter().convert(csvString);

  if (csvData.isEmpty) return null;

  final header = csvData[0];
  final indexes = {
    'State/UT': header.indexOf('State/UT'),
    'Dominant Soil Texture': header.indexOf('Dominant Soil Texture'),
  };

  // for (int i = 1; i < csvData.length; i++) {
  //   final row = csvData[i];
  //   if (row[indexes['DIST']!].toString().trim().toUpperCase() == district.trim().toUpperCase()) {
  //     return {
  //       'rainfall_intensity' : row[indexes['Predicted_Avg_Above_Avg_2025']!].toString(),
  //       'max_monsoon_rainfall' : row[indexes['Predicted_max_monsoon_2025']!].toString(),
  //       'annual_monsoon_rainfall' : row[indexes['Predicted_annual_monsoon_2025']!].toString(),
  //     };
  //   }
  // }
  //
  // return null;

  int left = 1;
  int right = csvData.length - 1;

  while (left <= right) {
    int mid = (left + right) ~/ 2;
    var row = csvData[mid];
    String midState =  row[indexes['State/UT']!].toString().trim().toUpperCase();

    if (midState == state.toUpperCase()) {
      return {
        'soil_texture' : row[indexes['Dominant Soil Texture']!].toString(),
      };
    } else if (midState.compareTo(state.toUpperCase()) < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return null;
}

Future<Map<String, String>?> getGwlFromState(String state) async {
  final csvString = await rootBundle.loadString(
      'lib/rainwater_backend/gwl.csv');
  final csvData = const CsvToListConverter().convert(csvString);

  final header = csvData[0];
  final indexes = {
    'State/UT': header.indexOf('State/UT'),
    'Post-Monsoon Depth (mbgl)': header.indexOf('Post-Monsoon Depth (mbgl)'),
  };

  final dataRows = csvData.sublist(1);

  int left = 0;
  int right = dataRows.length - 1;

  final searchState = state.toUpperCase();

  while (left <= right) {
    int mid = (left + right) ~/ 2;
    final row = dataRows[mid];
    String midstate = row[indexes['State/UT']!].toString().toUpperCase();

    if (midstate == searchState) {
      return {
        'gwl': row[indexes['Post-Monsoon Depth (mbgl)']!].toString(),
      };
    } else if (midstate.compareTo(searchState) < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return null;
}

/// Generic function to simulate fetching data based on user input
Future <DataResponse> fetchData({
  required double roofArea,
  required String pincode,
  required String address,
  required String roofMaterial,
  required String locationType,
  required double openArea,
  required int dwellers,
})
  async {
    double? rainfallIntensity;
    double? maxMonsoonRainfall;
    double? rainfallPrediction;
    String? soilTexture;
    double? gwl;

    final location = await getLocationFromPincode(pincode);

    if (location != null) {
      print("✅District: ${location['district']}");
      print("State: ${location['state']}");

      final rainfall_prediction = await getPredictionsFromDistrict(location['district'].toString());

      if (rainfall_prediction != null) {
        rainfallIntensity = double.tryParse(rainfall_prediction['rainfall_intensity']?? "");
        maxMonsoonRainfall = double.tryParse(rainfall_prediction['max_monsoon_rainfall'] ?? "");
        rainfallPrediction = double.tryParse(rainfall_prediction['annual_monsoon_rainfall'] ?? "");
        // print("✅Rainfall Intensity: ${rainfall_prediction['rainfall_intensity']}");
        // print("Max Monsoon Rainfall: ${rainfall_prediction['max_monsoon_rainfall']}");
        // print("Annual Monsoon Rainfall: ${rainfall_prediction['annual_monsoon_rainfall']}");
      }
      else {
        print("❌District Data not found!");
      }

      final texture = await getSoilTextureFromState(location['state'].toString());
      if(texture != null){
        soilTexture = texture['soil_texture'];
        print("✅Soil texture: ${texture['soil_texture']}");
      }
      else{
        print("❌Soil Data not found!");
      }

      final GWLevel = await getGwlFromState(location['state'].toString());
      if(GWLevel != null){
        gwl = double.tryParse(GWLevel['gwl'] ?? "");
        print("✅gwl: ${GWLevel['gwl']}");
      }
      else{
        print("❌gwl Data not found!");
      }

    }
    else {
      print("❌Pincode not found!");
    }

    //Get Feasibility Scores

      final FeasibilityResponse response = await fetchFeasibilityData(
          rainfallIntensity: rainfallIntensity,
          maxMonsoonRainfall: maxMonsoonRainfall,
          rainfallPrediction: rainfallPrediction,
          soilTexture: soilTexture,
          gwl: gwl,
          roofArea: roofArea,
          openArea: openArea
      );

      final Map<String,double> structures = response.feasibilityScores;
      final String bestStructure = getBestStructure(structures);
      final List<int> costs = getCostEstimates(bestStructure);
      final int costLow = costs[0];
      final int costHigh = costs.isNotEmpty && costs.length > 1 ? costs[1] : costs[0];
      print('low cost = ${costLow}');
      print('high cost = ${costHigh}');
      final double annualRainfall = rainfallPrediction ?? 0.0;
      final int harvest = calculateAnnualHarvestPotential(roofArea, annualRainfall, roofMaterial);
      print('annual harvest potential = ${harvest}');
      final int sustainabilityDays = calculateWaterSustainabilityDays(harvest, dwellers);
      print('No of days water is sustainabile = ${sustainabilityDays}');

  // For now, return predefined/dummy data
  // Map<String, double> structures = {
  //   "Recharge pit": 55.0,
  //   "Soak pit": 60.0,
  //   "Recharge Shaft": 55.0,
  //   "Recharge Trench": 80.0,
  //   "Recharge Garden Pit": 40.0,
  // };

  return DataResponse(
    structureScores : structures,
    costEstimateLow: costLow,
    costEstimateHigh: costHigh,
    annualHarvestPotential: harvest,
    waterSustainabilityDays: sustainabilityDays,
  );
}



// schema final fetchedData = (
// bestfeasibilityScore: 50.0,
// bestStructure : "Recharge pit",
// cost : 1000,
// annual_harvest_potential: 26000,
// );





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

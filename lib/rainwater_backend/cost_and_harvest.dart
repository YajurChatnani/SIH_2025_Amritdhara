//import the roofArea,roofMaterial,annualRainfall from data_fetch
//efficiency_cofficient of roofMaterial : tin,tiles,concrete,other
//cost of each structure:
//"soak pit": 1500, 4000
// "recharge pit": 4000, 8000
// "recharge trench": 8000, 16000
// "recharge shaft": 12000, 25000
// "recharge garden pit (with filter)": 4000, 12000
// calculate the annualHarvestPotential=roofArea*annualRainfall*efficiency(roofMaterial)

// lib/model/cost_harvest.dart

//import 'feasibility_score.dart'; // Assuming this is where FeasibilityResponse is defined
//import 'data_fetch.dart'; // To access types like DataResponse if needed

// Efficiency coefficients for different roof materials
const Map<String, double> efficiencyCoefficients = {
  'tin': 0.95,
  'tiles': 0.85,
  'concrete': 0.90,
  'other': 0.75,
};

// Cost estimates for each structure (low, high in INR)
const Map<String, List<int>> structureCosts = {
  'soak_pit': [1500, 4000],
  'recharge_pit': [4000, 8000],
  'trench': [8000, 16000],
  'shaft': [12000, 25000],
  'garden_pit': [4000, 12000],
};

// Daily water consumption per person in liters (assumed for sustainability calculation, adjustable)
const double dailyPerPerson = 75.0;

// Calculate annual harvest potential in liters
int calculateAnnualHarvestPotential(double roofArea, double annualRainfall, String roofMaterial) {
  final String materialKey = roofMaterial.toLowerCase();
  final double efficiency = efficiencyCoefficients[materialKey] ?? 0.75;
  final double harvest = roofArea * annualRainfall * efficiency;
  return harvest.round();
}

// Get cost estimates for a given structure
List<int> getCostEstimates(String structure) {
  final String key = structure.toLowerCase();
  return structureCosts[key] ?? [0, 0];
}

// Calculate water sustainability days
int calculateWaterSustainabilityDays(int annualHarvest, int dwellers) {
  if (dwellers <= 0) return 0;
  final double dailyConsumption = dwellers * dailyPerPerson;
  final double days = annualHarvest / dailyConsumption;
  return days.round();
}

// Helper to get the best structure based on feasibility scores
String getBestStructure(Map<String, double> structureScores) {
  if (structureScores.isEmpty) return '';

  print(structureScores.entries.reduce((a, b) => a.value > b.value ? a : b).key);
  return structureScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
}
from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
from typing import Dict, Tuple, Optional
import os
import re

app = Flask(__name__)

# Global variables to store datasets
pincodes_df = None
predictions_df = None
soil_df = None
gwl_df = None

# District name mapping - maps pincode districts to prediction districts
DISTRICT_MAPPING = {
    # Delhi variations
    'NEW DELHI': ['DELHI', 'New Delhi', 'CENTRAL DELHI', 'NORTH DELHI', 'SOUTH DELHI', 'EAST DELHI', 'WEST DELHI'],
    'CENTRAL DELHI': ['DELHI', 'New Delhi'],
    'NORTH DELHI': ['DELHI', 'New Delhi'],
    'SOUTH DELHI': ['DELHI', 'New Delhi'],
    'EAST DELHI': ['DELHI', 'New Delhi'],
    'WEST DELHI': ['DELHI', 'New Delhi'],
    'NORTH WEST DELHI': ['DELHI', 'New Delhi'],
    'SOUTH WEST DELHI': ['DELHI', 'New Delhi'],

    # Mumbai variations
    'MUMBAI': ['MUMBAI', 'Mumbai', 'GREATER MUMBAI', 'MUMBAI SUBURBAN'],
    'MUMBAI SUBURBAN': ['MUMBAI', 'Mumbai', 'GREATER MUMBAI'],
    'THANE': ['THANE', 'Thane'],

    # Bangalore variations
    'BENGALURU URBAN': ['BANGALORE', 'Bangalore', 'BENGALURU', 'Bengaluru', 'BANGALORE URBAN'],
    'BANGALORE': ['BANGALORE', 'Bangalore', 'BENGALURU', 'Bengaluru'],
    'BANGALORE URBAN': ['BANGALORE', 'Bangalore', 'BENGALURU', 'Bengaluru'],

    # Chennai variations
    'CHENNAI': ['CHENNAI', 'Chennai', 'MADRAS'],
    'KANCHEEPURAM': ['KANCHEEPURAM', 'Kancheepuram'],

    # Kolkata variations
    'KOLKATA': ['KOLKATA', 'Kolkata', 'CALCUTTA'],
    'NORTH 24 PARGANAS': ['NORTH 24 PARGANAS', 'North 24 Parganas'],
    'SOUTH 24 PARGANAS': ['SOUTH 24 PARGANAS', 'South 24 Parganas'],

    # Hyderabad variations
    'HYDERABAD': ['HYDERABAD', 'Hyderabad', 'RANGAREDDY', 'MEDCHAL MALKAJGIRI'],
    'RANGAREDDY': ['HYDERABAD', 'Hyderabad', 'RANGAREDDY'],
    'MEDCHAL MALKAJGIRI': ['HYDERABAD', 'Hyderabad'],

    # Pune variations
    'PUNE': ['PUNE', 'Pune'],

    # Ahmedabad variations
    'AHMEDABAD': ['AHMEDABAD', 'Ahmedabad'],

    # Gurgaon/Gurugram variations
    'GURGAON': ['GURGAON', 'Gurgaon', 'GURUGRAM', 'Gurugram'],
    'GURUGRAM': ['GURGAON', 'Gurgaon', 'GURUGRAM', 'Gurugram'],

    # Noida variations
    'GAUTAM BUDDHA NAGAR': ['NOIDA', 'Noida', 'GAUTAM BUDDHA NAGAR', 'Gautam Buddha Nagar'],

    # Add more mappings as needed
}

def find_matching_district(pincode_district: str, predictions_df: pd.DataFrame) -> Optional[str]:
    """Find matching district name in predictions dataset"""
    if pincode_district is None:
        return None

    pincode_district = str(pincode_district).strip()

    # Get the district column name from predictions dataset
    possible_district_cols = ['district', 'District', 'DISTRICT', 'DIST', 'dist', 'district_name', 'District_Name']
    district_col = None

    for col in predictions_df.columns:
        if col in possible_district_cols:
            district_col = col
            break

    if not district_col:
        print(f"No district column found in predictions dataset")
        return None

    # Get all district names from predictions dataset
    prediction_districts = predictions_df[district_col].str.strip().tolist()

    # 1. Try exact match (case insensitive)
    for pred_dist in prediction_districts:
        if str(pred_dist).lower() == pincode_district.lower():
            print(f"Exact match found: {pincode_district} -> {pred_dist}")
            return pred_dist

    # 2. Try mapping from DISTRICT_MAPPING
    if pincode_district.upper() in DISTRICT_MAPPING:
        possible_matches = DISTRICT_MAPPING[pincode_district.upper()]
        for pred_dist in prediction_districts:
            for possible_match in possible_matches:
                if str(pred_dist).lower() == possible_match.lower():
                    print(f"Mapping match found: {pincode_district} -> {pred_dist}")
                    return pred_dist

    # 3. Try partial matching (contains)
    for pred_dist in prediction_districts:
        # Check if pincode district is contained in prediction district
        if pincode_district.lower() in str(pred_dist).lower():
            print(f"Partial match found: {pincode_district} -> {pred_dist}")
            return pred_dist
        # Check if prediction district is contained in pincode district
        if str(pred_dist).lower() in pincode_district.lower():
            print(f"Reverse partial match found: {pincode_district} -> {pred_dist}")
            return pred_dist

    # 4. Try removing common suffixes and prefixes
    pincode_clean = re.sub(r'\b(DISTRICT|URBAN|RURAL|CITY)\b', '', pincode_district.upper(), flags=re.IGNORECASE).strip()
    for pred_dist in prediction_districts:
        pred_clean = re.sub(r'\b(DISTRICT|URBAN|RURAL|CITY)\b', '', str(pred_dist).upper(), flags=re.IGNORECASE).strip()

        if pincode_clean.lower() == pred_clean.lower():
            print(f"Clean match found: {pincode_district} -> {pred_dist}")
            return pred_dist

    # If no match found, return None
    print(f"No matching district found for: {pincode_district}")
    print(f"Available districts in predictions: {prediction_districts[:10]}...")
    return None

def load_datasets():
    """Load all required datasets into global variables"""
    global pincodes_df, predictions_df, soil_df, gwl_df

    try:
        # Load pincode dataset
        pincodes_df = pd.read_csv("pincodes_of_india.csv")
        print(f"Loaded pincodes dataset: {len(pincodes_df)} records")
        print(f"Pincode columns: {list(pincodes_df.columns)}")

        # Load predictions dataset
        predictions_df = pd.read_csv("predictions_2025 (1).csv")
        print(f"Loaded predictions dataset: {len(predictions_df)} records")
        print(f"Predictions columns: {list(predictions_df.columns)}")

        # Load soil texture dataset
        soil_df = pd.read_csv("soil_texture.csv")
        print(f"Loaded soil texture dataset: {len(soil_df)} records")
        print(f"Soil columns: {list(soil_df.columns)}")

        # Load groundwater level dataset
        gwl_df = pd.read_csv("gwl.csv")
        print(f"Loaded GWL dataset: {len(gwl_df)} records")
        print(f"GWL columns: {list(gwl_df.columns)}")

        return True
    except Exception as e:
        print(f"Error loading datasets: {e}")
        return False

def get_location_data(pincode: str) -> Tuple[Optional[str], Optional[str]]:
    """Get district and state from pincode"""
    try:
        # Convert pincode to string and handle different column name possibilities
        pincode = str(pincode).strip()

        # Common column names for pincode datasets
        possible_pincode_cols = ['pincode', 'Pincode', 'PINCODE', 'pin_code', 'PIN_CODE']
        possible_district_cols = ['district', 'District', 'DISTRICT', 'district_name', 'District_Name']
        possible_state_cols = ['state', 'State', 'STATE', 'statename', 'State_Name']

        pincode_col = None
        district_col = None
        state_col = None

        # Find the correct column names
        for col in pincodes_df.columns:
            if col in possible_pincode_cols:
                pincode_col = col
            elif col in possible_district_cols:
                district_col = col
            elif col in possible_state_cols:
                state_col = col

        if not all([pincode_col, district_col, state_col]):
            print(f"Required columns not found. Available columns: {list(pincodes_df.columns)}")
            return None, None

        # Search for the pincode
        result = pincodes_df[pincodes_df[pincode_col].astype(str).str.strip() == pincode]

        if result.empty:
            print(f"Pincode {pincode} not found")
            return None, None

        district = result.iloc[0][district_col]
        state = result.iloc[0][state_col]

        return str(district).strip(), str(state).strip()

    except Exception as e:
        print(f"Error getting location data: {e}")
        return None, None

def get_rainfall_data(district: str) -> Tuple[Optional[float], Optional[float]]:
    """Get avg_monsoon and max_monsoon from district"""
    try:
        # Find matching district in predictions dataset
        matched_district = find_matching_district(district, predictions_df)

        if not matched_district:
            return None, None

        # Handle different possible column names
        possible_district_cols = ['district', 'District', 'DISTRICT', 'DIST', 'district_name', 'District_Name']
        possible_avg_cols = ['Predicted_Avg_Above_Avg_2025', 'Avg_Monsoon', 'AVG_MONSOON', 'average_monsoon']
        possible_max_cols = ['Predicted_max_monsoon_2025', 'Max_Monsoon', 'MAX_MONSOON', 'maximum_monsoon']

        district_col = None
        avg_col = None
        max_col = None

        for col in predictions_df.columns:
            if col in possible_district_cols:
                district_col = col
            elif col in possible_avg_cols:
                avg_col = col
            elif col in possible_max_cols:
                max_col = col

        if not all([district_col, avg_col, max_col]):
            print(f"Required columns not found in predictions. Available: {list(predictions_df.columns)}")
            return None, None

        result = predictions_df[predictions_df[district_col].str.strip() == matched_district]

        if result.empty:
            print(f"Matched district {matched_district} not found in predictions")
            return None, None

        avg_monsoon = float(result.iloc[0][avg_col])
        max_monsoon = float(result.iloc[0][max_col])

        print(f"Found rainfall data for {matched_district}: avg={avg_monsoon}, max={max_monsoon}")
        return avg_monsoon, max_monsoon

    except Exception as e:
        print(f"Error getting rainfall data: {e}")
        return None, None

def get_soil_type(state: str) -> Optional[str]:
    """Get soil type from state"""
    try:
        possible_state_cols = ['state', 'State', 'STATE', 'state_name', 'State_Name', 'State/UT']
        possible_soil_cols = ['Dominant Soil Texture', 'Soil_Type', 'SOIL_TYPE', 'soil_texture', 'Soil_Texture']

        state_col = None
        soil_col = None

        for col in soil_df.columns:
            if col in possible_state_cols:
                state_col = col
            elif col in possible_soil_cols:
                soil_col = col

        if not all([state_col, soil_col]):
            print(f"Required columns not found in soil data. Available: {list(soil_df.columns)}")
            return None

        # Try exact match first
        result = soil_df[soil_df[state_col].str.strip().str.lower() == state.lower()]

        # If no exact match, try partial match
        if result.empty:
            result = soil_df[soil_df[state_col].str.strip().str.lower().str.contains(state.lower(), na=False)]

        if result.empty:
            print(f"State {state} not found in soil data")
            print(f"Available states: {soil_df[state_col].tolist()}")
            return None

        return str(result.iloc[0][soil_col]).strip().lower()

    except Exception as e:
        print(f"Error getting soil type: {e}")
        return None

def get_groundwater_depth(state: str) -> Optional[float]:
    """Get groundwater depth from state"""
    try:
        possible_state_cols = ['state', 'State', 'STATE', 'state_name', 'State_Name', 'State/UT']
        possible_gw_cols = ['gw_depth_m', 'GW_Depth_m', 'GW_DEPTH_M', 'groundwater_depth', 'Maximum Depth (mbgl)']

        state_col = None
        gw_col = None

        for col in gwl_df.columns:
            if col in possible_state_cols:
                state_col = col
            elif col in possible_gw_cols:
                gw_col = col

        if not all([state_col, gw_col]):
            print(f"Required columns not found in GWL data. Available: {list(gwl_df.columns)}")
            return None

        # Try exact match first
        result = gwl_df[gwl_df[state_col].str.strip().str.lower() == state.lower()]

        # If no exact match, try partial match
        if result.empty:
            result = gwl_df[gwl_df[state_col].str.strip().str.lower().str.contains(state.lower(), na=False)]

        if result.empty:
            print(f"State {state} not found in GWL data")
            print(f"Available states: {gwl_df[state_col].tolist()}")
            return None

        depth_value = result.iloc[0][gw_col]
        return float(depth_value) if pd.notna(depth_value) else None

    except Exception as e:
        print(f"Error getting groundwater depth: {e}")
        return None

def clamp(x: float, low: float, high: float) -> float:
    """Clamp value between low and high"""
    return max(low, min(x, high))

def soil_score(soil_type: str) -> float:
    """Calculate soil score based on soil type"""
    soil_type = soil_type.lower().strip()

    if soil_type in ["sand", "sandy loam"]:
        return 1.0
    elif soil_type in ["loamy sand", "loam"]:
        return 0.8
    elif soil_type in ["silt loam", "silty"]:
        return 0.6
    elif soil_type in ["clay loam", "sandy clay loam"]:
        return 0.4
    elif soil_type in ["clay", "silty clay"]:
        return 0.2
    else:
        return 0.5

def map_G_to_Gf(G: float) -> float:
    """Map groundwater depth to generic feasibility factor"""
    if G < 3:
        return 0.2
    elif 3 <= G <= 15:
        return 1.0
    elif 15 < G <= 30:
        return 0.8
    elif 30 < G <= 50:
        return 0.6
    else:
        return 0.4

def map_G_for_dug(G: float) -> float:
    """Map groundwater depth for dug well feasibility"""
    if 3 <= G <= 15:
        return 1.0
    elif 15 < G <= 30:
        return 0.7
    elif 30 < G <= 50:
        return 0.5
    else:
        return 0.2

def map_G_for_shaft(G: float) -> float:
    """Map groundwater depth for shaft feasibility"""
    if G < 8:
        return 0.25
    elif 8 <= G <= 40:
        return 0.8 + (G - 8) / (40 - 8) * 0.2  # linear scale 0.8 → 1.0
    elif 40 < G <= 60:
        return 0.5
    else:
        return 0.3

def compute_feasibility(roof_area: float, data: Dict) -> Tuple[Dict[str, float], Optional[str]]:
    """
    Compute feasibility scores for different rainwater harvesting methods
    """
    try:
        # Extract inputs
        avg_monsoon = data['avg_monsoon']
        max_monsoon = data['max_monsoon']
        soil_type = data['soil_type']
        gw_depth = data['gw_depth_m']

        # Assume good runoff quality (can be made configurable)
        runoff_quality = 0.8  # C factor

        # Reference rainfall (can be adjusted based on regional standards)
        R_ref = 100.0  # mm

        # Step 2: Rainfall Factor
        # Using monsoon data as proxy for June-September rainfall
        AvgMon = avg_monsoon
        MaxMon = max_monsoon

        Rf = 0.7 * (AvgMon / R_ref) + 0.3 * (MaxMon / R_ref)
        Rf = clamp(Rf, 0.1, 1.0)

        # Step 3: Other Scores
        S = soil_score(soil_type)
        C = runoff_quality
        Gf_generic = map_G_to_Gf(gw_depth)
        Gf_dug = map_G_for_dug(gw_depth)
        Gf_shaft = map_G_for_shaft(gw_depth)

        # Step 4: Feasibility Scores
        F_soak = 100 * (0.36*S + 0.24*Rf + 0.20*C + 0.20)
        if gw_depth < 3:
            F_soak = F_soak * 0.4

        F_pit = 100 * (0.30*S + 0.25*Rf + 0.20*Gf_generic + 0.15*C + 0.10)
        if gw_depth < 3:
            F_pit = F_pit * 0.35

        F_trench = 100 * (0.28*S + 0.28*Rf + 0.20 + 0.14*Gf_generic + 0.10*C)

        F_dug = 100 * (0.35*Gf_dug + 0.25*Rf + 0.20*S + 0.10*C + 0.10)

        F_shaft = 100 * (0.40*Gf_shaft + 0.22*Rf + 0.18*S + 0.10*C + 0.10)

        # Step 5: Quality Check
        warning = None
        if C == 0:
            return {
                'soak_pit': 0,
                'recharge_pit': 0,
                'trench': 0,
                'dug_well': 0,
                'shaft': 0
            }, "Warning: Poor water quality"

        # Step 6: Clamp Scores to [0,100]
        scores = {
            'soak_pit': clamp(F_soak, 0, 100),
            'recharge_pit': clamp(F_pit, 0, 100),
            'trench': clamp(F_trench, 0, 100),
            'dug_well': clamp(F_dug, 0, 100),
            'shaft': clamp(F_shaft, 0, 100)
        }

        return scores, warning

    except Exception as e:
        print(f"Error in feasibility computation: {e}")
        return {}, f"Error in computation: {str(e)}"

@app.route('/api/feasibility', methods=['POST'])
def calculate_feasibility():
    """API endpoint to calculate rainwater harvesting feasibility"""
    try:
        # Get input data
        data = request.json
        roof_area = data.get('roof_area')
        pincode = data.get('pincode')

        if not roof_area or not pincode:
            return jsonify({
                'error': 'Both roof_area and pincode are required'
            }), 400

        # Get location data from pincode
        district, state = get_location_data(pincode)
        if not district or not state:
            return jsonify({
                'error': f'Could not find location data for pincode {pincode}'
            }), 404

        # Get rainfall data from district
        avg_monsoon, max_monsoon = get_rainfall_data(district)
        if avg_monsoon is None or max_monsoon is None:
            return jsonify({
                'error': f'Could not find rainfall data for district {district}'
            }), 404

        # Get soil type from state
        soil_type = get_soil_type(state)
        if not soil_type:
            return jsonify({
                'error': f'Could not find soil type for state {state}'
            }), 404

        # Get groundwater depth from state
        gw_depth = get_groundwater_depth(state)
        if gw_depth is None:
            return jsonify({
                'error': f'Could not find groundwater depth for state {state}'
            }), 404

        # Prepare data for feasibility computation
        feasibility_data = {
            'avg_monsoon': avg_monsoon,
            'max_monsoon': max_monsoon,
            'soil_type': soil_type,
            'gw_depth_m': gw_depth
        }

        # Compute feasibility scores
        scores, warning = compute_feasibility(roof_area, feasibility_data)

        # Prepare response
        response = {
            'input': {
                'roof_area': roof_area,
                'pincode': pincode
            },
            'location': {
                'district': district,
                'state': state
            },
            'data': feasibility_data,
            'feasibility_scores': scores
        }

        if warning:
            response['warning'] = warning

        return jsonify(response)

    except Exception as e:
        return jsonify({
            'error': f'Internal server error: {str(e)}'
        }), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'datasets_loaded': all([
            pincodes_df is not None,
            predictions_df is not None,
            soil_df is not None,
            gwl_df is not None
        ])
    })

@app.route('/api/dataset-info', methods=['GET'])
def dataset_info():
    """Get information about loaded datasets"""
    info = {}

    if pincodes_df is not None:
        info['pincodes'] = {
            'rows': len(pincodes_df),
            'columns': list(pincodes_df.columns)
        }

    if predictions_df is not None:
        info['predictions'] = {
            'rows': len(predictions_df),
            'columns': list(predictions_df.columns)
        }

    if soil_df is not None:
        info['soil'] = {
            'rows': len(soil_df),
            'columns': list(soil_df.columns)
        }

    if gwl_df is not None:
        info['gwl'] = {
            'rows': len(gwl_df),
            'columns': list(gwl_df.columns)
        }

    return jsonify(info)

# Add debug endpoint to see district matching
@app.route('/api/debug/districts', methods=['GET'])
def debug_districts():
    """Debug endpoint to see district names and matching"""
    try:
        pincode = request.args.get('pincode', '110001')

        # Get district from pincode
        district, state = get_location_data(pincode)

        # Get available districts from predictions
        district_col = None
        for col in predictions_df.columns:
            if col in ['district', 'District', 'DISTRICT', 'DIST']:
                district_col = col
                break

        available_districts = predictions_df[district_col].tolist() if district_col else []

        # Try to find match
        matched_district = find_matching_district(district, predictions_df) if district else None

        return jsonify({
            'pincode': pincode,
            'pincode_district': district,
            'state': state,
            'matched_district': matched_district,
            'available_districts': available_districts[:20],  # First 20 for brevity
            'total_available': len(available_districts)
        })

    except Exception as e:
        return jsonify({'error': str(e)})

# CORS support (for web browsers)
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
    return response

if __name__ == '__main__':
    print("Loading datasets...")
    if load_datasets():
        print("All datasets loaded successfully!")
        print("Starting Flask server...")
        app.run(debug=True, host='0.0.0.0', port=5000)
    else:
        print("Failed to load datasets. Please check file paths and formats.")
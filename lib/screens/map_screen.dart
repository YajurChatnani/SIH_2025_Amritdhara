import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

// Data Models
class CityData {
  final String cityName;
  final List<LatLng> polygonPoints;
  final double rainfall; // mm
  final String soilTexture; // Clay, Sand, Loam, etc.
  final double groundwaterLevel; // meters below ground
  final LatLng centerPoint;

  CityData({
    required this.cityName,
    required this.polygonPoints,
    required this.rainfall,
    required this.soilTexture,
    required this.groundwaterLevel,
    required this.centerPoint,
  });
}

enum DataType { rainfall, soilTexture, groundwaterLevel }

class PolygonMapScreen extends StatefulWidget {
  const PolygonMapScreen({Key? key}) : super(key: key);

  @override
  State<PolygonMapScreen> createState() => _PolygonMapScreenState();
}

class _PolygonMapScreenState extends State<PolygonMapScreen> {
  GoogleMapController? mapController;
  bool _isLocationPermissionGranted = false;
  bool _isMapReady = false;
  DataType _selectedDataType = DataType.rainfall;

  // Initial camera position centered on Bhopal (your location)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.2599, 77.4126), // Bhopal coordinates
    zoom: 6.0,
  );

  // Sample city data - Replace with your actual data
  late List<CityData> _cityData;
  Set<Polygon> _polygons = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeCityData();
    _requestLocationPermission();
    _updatePolygons();
  }

  void _initializeCityData() {
    _cityData = [
      // Delhi
      CityData(
        cityName: 'Delhi',
        centerPoint: const LatLng(28.6139, 77.2090),
        polygonPoints: const [
          LatLng(28.8833, 76.8342), // Northwest
          LatLng(28.8833, 77.3478), // Northeast
          LatLng(28.4044, 77.3478), // Southeast
          LatLng(28.4044, 76.8342), // Southwest
        ],
        rainfall: 650.5,
        soilTexture: 'Sandy Loam',
        groundwaterLevel: 12.5,
      ),
      // Mumbai
      CityData(
        cityName: 'Mumbai',
        centerPoint: const LatLng(19.0760, 72.8777),
        polygonPoints: const [
          LatLng(19.2700, 72.8000),
          LatLng(19.2700, 72.9500),
          LatLng(18.8900, 72.9500),
          LatLng(18.8900, 72.8000),
        ],
        rainfall: 2450.0,
        soilTexture: 'Clay',
        groundwaterLevel: 8.2,
      ),
      // Bhopal (Your location)
      CityData(
        cityName: 'Bhopal',
        centerPoint: const LatLng(23.2599, 77.4126),
        polygonPoints: const [
          LatLng(23.454800, 77.494000),
          LatLng(23.451200, 77.494300),
          LatLng(23.440900, 77.489000),
          LatLng(23.431100, 77.487900),
          LatLng(23.429300, 77.500100),
          LatLng(23.418400, 77.506600),
          LatLng(23.417100, 77.509700),
          LatLng(23.427700, 77.514400),
          LatLng(23.431000, 77.522800),
          LatLng(23.430600, 77.548600),
          LatLng(23.427700, 77.554500),
          LatLng(23.417500, 77.557200),
          LatLng(23.411700, 77.549100),
          LatLng(23.407900, 77.546800),
          LatLng(23.395300, 77.545900),
          LatLng(23.392600, 77.549300),
          LatLng(23.393100, 77.554900),
          LatLng(23.384100, 77.553800),
          LatLng(23.380100, 77.556400),
          LatLng(23.377800, 77.571000),
          LatLng(23.373400, 77.572500),
          LatLng(23.366600, 77.580200),
          LatLng(23.357200, 77.578800),
          LatLng(23.359300, 77.614100),
          LatLng(23.358000, 77.623500),
          LatLng(23.352200, 77.625200),
          LatLng(23.350300, 77.622700),
          LatLng(23.344000, 77.619900),
          LatLng(23.340800, 77.623300),
          LatLng(23.337700, 77.623800),
          LatLng(23.332900, 77.621100),
          LatLng(23.324400, 77.605700),
          LatLng(23.309600, 77.588500),
          LatLng(23.303100, 77.585400),
          LatLng(23.300100, 77.586700),
          LatLng(23.288600, 77.580200),
          LatLng(23.279700, 77.587500),
          LatLng(23.276900, 77.591700),
          LatLng(23.259000, 77.588700),
          LatLng(23.248300, 77.594300),
          LatLng(23.239500, 77.593700),
          LatLng(23.232900, 77.596000),
          LatLng(23.230800, 77.592400),
          LatLng(23.211400, 77.585600),
          LatLng(23.207400, 77.581700),
          LatLng(23.205900, 77.577300),
          LatLng(23.199200, 77.576600),
          LatLng(23.195400, 77.582200),
          LatLng(23.191900, 77.582700),
          LatLng(23.190000, 77.581500),
          LatLng(23.183600, 77.562100),
          LatLng(23.177200, 77.561500),
          LatLng(23.171300, 77.564900),
          LatLng(23.168000, 77.564700),
          LatLng(23.165800, 77.569600),
          LatLng(23.148300, 77.563600),
          LatLng(23.148500, 77.552100),
          LatLng(23.144800, 77.543100),
          LatLng(23.140700, 77.540700),
          LatLng(23.131600, 77.539100),
          LatLng(23.127900, 77.529400),
          LatLng(23.127100, 77.516400),
          LatLng(23.125700, 77.513300),
          LatLng(23.109900, 77.501900),
          LatLng(23.104600, 77.483500),
          LatLng(23.107100, 77.476100),
          LatLng(23.103600, 77.469100),
          LatLng(23.103600, 77.462000),
          LatLng(23.098000, 77.456500),
          LatLng(23.096300, 77.449900),
          LatLng(23.097200, 77.439300),
          LatLng(23.100000, 77.434000),
          LatLng(23.097900, 77.413300),
          LatLng(23.100900, 77.403700),
          LatLng(23.094500, 77.399300),
          LatLng(23.095100, 77.386300),
          LatLng(23.093100, 77.379400),
          LatLng(23.095800, 77.374800),
          LatLng(23.098800, 77.358700),
          LatLng(23.097800, 77.337800),
          LatLng(23.100200, 77.328900),
          LatLng(23.109400, 77.327500),
          LatLng(23.112000, 77.323300),
          LatLng(23.110800, 77.302100),
          LatLng(23.105100, 77.290200),
          LatLng(23.105800, 77.282600),
          LatLng(23.117100, 77.283400),
          LatLng(23.140200, 77.276100),
          LatLng(23.144500, 77.267600),
          LatLng(23.147900, 77.255300),
          LatLng(23.156600, 77.256800),
          LatLng(23.160400, 77.255500),
          LatLng(23.162500, 77.253800),
          LatLng(23.163200, 77.248200),
          LatLng(23.183400, 77.240800),
          LatLng(23.188900, 77.234900),
          LatLng(23.198200, 77.237400),
          LatLng(23.201300, 77.232200),
          LatLng(23.207200, 77.213400),
          LatLng(23.219200, 77.222700),
          LatLng(23.224900, 77.217000),
          LatLng(23.230700, 77.217100),
          LatLng(23.225300, 77.196400),
          LatLng(23.226500, 77.191300),
          LatLng(23.238000, 77.185700),
          LatLng(23.244700, 77.184700),
          LatLng(23.246300, 77.186300),
          LatLng(23.248400, 77.196700),
          LatLng(23.252800, 77.197100),
          LatLng(23.254900, 77.199500),
          LatLng(23.259400, 77.210800),
          LatLng(23.261900, 77.213400),
          LatLng(23.265400, 77.211100),
          LatLng(23.275300, 77.210100),
          LatLng(23.279000, 77.211200),
          LatLng(23.286600, 77.217900),
          LatLng(23.300500, 77.219600),
          LatLng(23.302700, 77.217100),
          LatLng(23.304600, 77.194400),
          LatLng(23.313300, 77.188300),
          LatLng(23.314500, 77.178700),
          LatLng(23.311700, 77.176600),
          LatLng(23.320800, 77.177700),
          LatLng(23.326100, 77.175400),
          LatLng(23.335700, 77.182800),
          LatLng(23.353600, 77.180700),
          LatLng(23.360500, 77.183300),
          LatLng(23.363700, 77.186000),
          LatLng(23.365600, 77.191300),
          LatLng(23.363600, 77.200100),
          LatLng(23.337000, 77.208500),
          LatLng(23.331200, 77.211700),
          LatLng(23.332100, 77.223300),
          LatLng(23.353800, 77.228000),
          LatLng(23.360700, 77.227000),
          LatLng(23.365200, 77.229900),
          LatLng(23.374700, 77.240900),
          LatLng(23.380200, 77.241800),
          LatLng(23.383300, 77.245100),
          LatLng(23.388300, 77.257900),
          LatLng(23.391100, 77.258200),
          LatLng(23.399300, 77.247800),
          LatLng(23.400200, 77.234000),
          LatLng(23.410100, 77.241000),
          LatLng(23.413200, 77.240900),
          LatLng(23.412800, 77.250300),
          LatLng(23.415200, 77.254500),
          LatLng(23.411400, 77.269500),
          LatLng(23.412300, 77.277100),
          LatLng(23.435600, 77.294200),
          LatLng(23.454000, 77.282900),
          LatLng(23.463600, 77.284000),
          LatLng(23.472700, 77.290400),
          LatLng(23.481100, 77.293800),
          LatLng(23.482900, 77.292900),
          LatLng(23.486400, 77.283500),
          LatLng(23.495700, 77.282600),
          LatLng(23.506200, 77.287000),
          LatLng(23.510400, 77.293700),
          LatLng(23.518300, 77.295000),
          LatLng(23.522700, 77.293300),
          LatLng(23.526400, 77.287700),
          LatLng(23.534700, 77.289100),
          LatLng(23.542600, 77.287700),
          LatLng(23.549900, 77.289700),
          LatLng(23.569800, 77.281500),
          LatLng(23.573100, 77.282800),
          LatLng(23.581900, 77.293900),
          LatLng(23.586200, 77.294100),
          LatLng(23.596000, 77.281400),
          LatLng(23.597100, 77.273100),
          LatLng(23.607000, 77.272600),
          LatLng(23.611700, 77.275600),
          LatLng(23.614600, 77.271800),
          LatLng(23.616400, 77.261800),
          LatLng(23.624500, 77.251000),
          LatLng(23.626500, 77.245300),
          LatLng(23.627600, 77.229200),
          LatLng(23.630200, 77.224900),
          LatLng(23.637100, 77.220800),
          LatLng(23.652200, 77.227000),
          LatLng(23.661700, 77.223800),
          LatLng(23.670400, 77.218000),
          LatLng(23.673500, 77.211200),
          LatLng(23.672300, 77.205200),
          LatLng(23.663000, 77.199600),
          LatLng(23.663700, 77.195500),
          LatLng(23.668000, 77.190100),
          LatLng(23.676400, 77.186500),
          LatLng(23.679100, 77.182300),
          LatLng(23.676800, 77.172400),
          LatLng(23.683800, 77.171300),
          LatLng(23.685200, 77.168400),
          LatLng(23.693100, 77.165400),
          LatLng(23.697000, 77.166100),
          LatLng(23.704100, 77.173100),
          LatLng(23.719500, 77.180500),
          LatLng(23.753800, 77.191900),
          LatLng(23.758300, 77.190200),
          LatLng(23.772500, 77.197600),
          LatLng(23.783100, 77.199000),
          LatLng(23.793800, 77.209600),
          LatLng(23.798100, 77.211100),
          LatLng(23.805900, 77.206700),
          LatLng(23.808800, 77.207200),
          LatLng(23.824800, 77.217800),
          LatLng(23.829800, 77.218700),
          LatLng(23.838900, 77.217400),
          LatLng(23.847000, 77.208200),
          LatLng(23.854800, 77.218100),
          LatLng(23.870200, 77.217500),
          LatLng(23.891400, 77.220500),
          LatLng(23.900200, 77.223200),
          LatLng(23.898400, 77.235400),
          LatLng(23.899200, 77.244300),
          LatLng(23.896100, 77.252600),
          LatLng(23.894100, 77.266000),
          LatLng(23.895000, 77.278900),
          LatLng(23.899900, 77.289200),
          LatLng(23.895500, 77.298200),
          LatLng(23.895600, 77.307300),
          LatLng(23.889600, 77.315300),
          LatLng(23.898100, 77.314100),
          LatLng(23.897500, 77.332600),
          LatLng(23.891200, 77.362700),
          LatLng(23.888300, 77.370200),
          LatLng(23.873200, 77.373900),
          LatLng(23.865300, 77.379500),
          LatLng(23.858900, 77.395700),
          LatLng(23.844000, 77.395800),
          LatLng(23.845000, 77.391500),
          LatLng(23.843400, 77.389800),
          LatLng(23.837400, 77.390100),
          LatLng(23.833200, 77.403500),
          LatLng(23.818900, 77.406600),
          LatLng(23.809000, 77.413100),
          LatLng(23.808200, 77.426800),
          LatLng(23.800700, 77.443100),
          LatLng(23.799100, 77.442700),
          LatLng(23.794900, 77.430800),
          LatLng(23.787700, 77.431400),
          LatLng(23.783700, 77.434100),
          LatLng(23.785800, 77.441600),
          LatLng(23.783400, 77.447100),
          LatLng(23.777100, 77.451500),
          LatLng(23.769300, 77.452900),
          LatLng(23.764700, 77.466500),
          LatLng(23.768800, 77.477100),
          LatLng(23.778700, 77.493700),
          LatLng(23.781800, 77.495400),
          LatLng(23.782500, 77.498900),
          LatLng(23.781500, 77.502800),
          LatLng(23.777600, 77.507500),
          LatLng(23.774400, 77.508000),
          LatLng(23.771600, 77.511100),
          LatLng(23.767700, 77.533000),
          LatLng(23.761900, 77.545500),
          LatLng(23.761600, 77.550600),
          LatLng(23.763700, 77.555800),
          LatLng(23.771700, 77.561100),
          LatLng(23.772800, 77.569500),
          LatLng(23.762100, 77.584500),
          LatLng(23.754100, 77.609000),
          LatLng(23.741300, 77.604600),
          LatLng(23.740300, 77.601100),
          LatLng(23.734700, 77.599800),
          LatLng(23.733900, 77.605900),
          LatLng(23.730100, 77.614700),
          LatLng(23.721400, 77.613400),
          LatLng(23.719400, 77.615500),
          LatLng(23.717600, 77.624100),
          LatLng(23.721300, 77.630700),
          LatLng(23.717900, 77.636200),
          LatLng(23.722200, 77.645100),
          LatLng(23.709500, 77.644300),
          LatLng(23.702500, 77.645900),
          LatLng(23.668400, 77.629500),
          LatLng(23.666200, 77.627200),
          LatLng(23.668000, 77.618300),
          LatLng(23.664400, 77.592500),
          LatLng(23.663100, 77.588500),
          LatLng(23.659400, 77.585600),
          LatLng(23.656800, 77.575200),
          LatLng(23.653400, 77.568800),
          LatLng(23.650600, 77.571200),
          LatLng(23.638900, 77.569500),
          LatLng(23.635600, 77.566400),
          LatLng(23.624800, 77.563600),
          LatLng(23.601900, 77.553100),
          LatLng(23.598400, 77.549300),
          LatLng(23.599300, 77.544600),
          LatLng(23.598000, 77.540100),
          LatLng(23.587300, 77.523500),
          LatLng(23.587600, 77.513700),
          LatLng(23.585200, 77.508500),
          LatLng(23.580000, 77.504600),
          LatLng(23.576900, 77.504300),
          LatLng(23.562400, 77.509000),
          LatLng(23.560400, 77.503300),
          LatLng(23.558000, 77.502000),
          LatLng(23.552200, 77.503500),
          LatLng(23.545100, 77.502400),
          LatLng(23.536200, 77.505600),
          LatLng(23.535200, 77.509800),
          LatLng(23.521600, 77.517500),
          LatLng(23.518100, 77.512500),
          LatLng(23.514700, 77.511000),
          LatLng(23.506500, 77.510900),
          LatLng(23.500200, 77.501600),
          LatLng(23.491100, 77.504100),
          LatLng(23.486400, 77.500700),
          LatLng(23.477500, 77.499200),
          LatLng(23.473200, 77.495400),
          LatLng(23.468000, 77.496800),
          LatLng(23.459600, 77.492100),
          LatLng(23.454800, 77.494000),
    ],
        rainfall: 1150.0,
        soilTexture: 'Black Cotton',
        groundwaterLevel: 22.3,
      ),
      // Bangalore
      CityData(
        cityName: 'Bangalore',
        centerPoint: const LatLng(12.9716, 77.5946),
        polygonPoints: const [
          LatLng(13.1400, 77.4500),
          LatLng(13.1400, 77.7400),
          LatLng(12.8000, 77.7400),
          LatLng(12.8000, 77.4500),
        ],
        rainfall: 950.0,
        soilTexture: 'Red Loam',
        groundwaterLevel: 15.8,
      ),
      // Chennai
      CityData(
        cityName: 'Chennai',
        centerPoint: const LatLng(13.0827, 80.2707),
        polygonPoints: const [
          LatLng(13.2500, 80.1500),
          LatLng(13.2500, 80.3900),
          LatLng(12.9100, 80.3900),
          LatLng(12.9100, 80.1500),
        ],
        rainfall: 1200.0,
        soilTexture: 'Sandy Clay',
        groundwaterLevel: 6.5,
      ),
      // Kolkata
      CityData(
        cityName: 'Kolkata',
        centerPoint: const LatLng(22.5726, 88.3639),
        polygonPoints: const [
          LatLng(22.7500, 88.2500),
          LatLng(22.7500, 88.4800),
          LatLng(22.3900, 88.4800),
          LatLng(22.3900, 88.2500),
        ],
        rainfall: 1580.0,
        soilTexture: 'Alluvial',
        groundwaterLevel: 4.2,
      ),
      // Hyderabad
      CityData(
        cityName: 'Hyderabad',
        centerPoint: const LatLng(17.3850, 78.4867),
        polygonPoints: const [
          LatLng(17.5500, 78.3500),
          LatLng(17.5500, 78.6200),
          LatLng(17.2200, 78.6200),
          LatLng(17.2200, 78.3500),
        ],
        rainfall: 750.0,
        soilTexture: 'Black Cotton',
        groundwaterLevel: 18.5,
      ),
      // Indore (Nearby MP city)
      CityData(
        cityName: 'Indore',
        centerPoint: const LatLng(22.7196, 75.8577),
        polygonPoints: const [
          LatLng(22.8000, 75.7500),
          LatLng(22.8000, 75.9700),
          LatLng(22.6400, 75.9700),
          LatLng(22.6400, 75.7500),
        ],
        rainfall: 980.0,
        soilTexture: 'Black Cotton',
        groundwaterLevel: 25.4,
      ),
      // Jabalpur (Another MP city)
      CityData(
        cityName: 'Jabalpur',
        centerPoint: const LatLng(23.1815, 79.9864),
        polygonPoints: const [
          LatLng(23.2500, 79.8800),
          LatLng(23.2500, 80.0900),
          LatLng(23.1100, 80.0900),
          LatLng(23.1100, 79.8800),
        ],
        rainfall: 1320.0,
        soilTexture: 'Red Sandy',
        groundwaterLevel: 19.8,
      ),
    ];
  }

  Future<void> _requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      setState(() {
        _isLocationPermissionGranted = status == PermissionStatus.granted;
      });
    } catch (e) {
      print('Error requesting location permission: $e');
      setState(() {
        _isLocationPermissionGranted = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mapController == null) {
      mapController = controller;
      setState(() {
        _isMapReady = true;
      });
    }
  }

  Color _getPolygonColor(CityData cityData) {
    switch (_selectedDataType) {
      case DataType.rainfall:
        return _getRainfallColor(cityData.rainfall);
      case DataType.soilTexture:
        return _getSoilTextureColor(cityData.soilTexture);
      case DataType.groundwaterLevel:
        return _getGroundwaterColor(cityData.groundwaterLevel);
    }
  }

  Color _getRainfallColor(double rainfall) {
    if (rainfall < 500) return Colors.red.withOpacity(0.6);
    if (rainfall < 1000) return Colors.orange.withOpacity(0.6);
    if (rainfall < 1500) return Colors.yellow.withOpacity(0.6);
    if (rainfall < 2000) return Colors.lightGreen.withOpacity(0.6);
    return Colors.blue.withOpacity(0.6);
  }

  Color _getSoilTextureColor(String soilTexture) {
    switch (soilTexture.toLowerCase()) {
      case 'clay':
      case 'sandy clay':
        return Colors.brown.withOpacity(0.6);
      case 'sandy loam':
      case 'sand':
        return Colors.yellow.withOpacity(0.6);
      case 'loam':
      case 'red loam':
        return Colors.green.withOpacity(0.6);
      case 'alluvial':
        return Colors.grey.withOpacity(0.6);
      case 'black cotton':
        return Colors.black.withOpacity(0.6);
      default:
        return Colors.purple.withOpacity(0.6);
    }
  }

  Color _getGroundwaterColor(double level) {
    if (level < 5) return Colors.blue.withOpacity(0.8);
    if (level < 10) return Colors.lightBlue.withOpacity(0.6);
    if (level < 15) return Colors.orange.withOpacity(0.6);
    return Colors.red.withOpacity(0.6);
  }

  void _updatePolygons() {
    Set<Polygon> newPolygons = {};
    Set<Marker> newMarkers = {};

    for (int i = 0; i < _cityData.length; i++) {
      final cityData = _cityData[i];

      // Create polygon
      newPolygons.add(
        Polygon(
          polygonId: PolygonId('city_$i'),
          points: cityData.polygonPoints,
          fillColor: _getPolygonColor(cityData),
          strokeColor: _getPolygonColor(cityData).withOpacity(1.0),
          strokeWidth: 2,
          consumeTapEvents: true,
          onTap: () => _showCityDetails(cityData),
        ),
      );

      // Create marker with data info
      newMarkers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: cityData.centerPoint,
          infoWindow: InfoWindow(
            title: cityData.cityName,
            snippet: _getMarkerSnippet(cityData),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerHue(cityData),
          ),
          onTap: () => _showCityDetails(cityData),
        ),
      );
    }

    setState(() {
      _polygons = newPolygons;
      _markers = newMarkers;
    });
  }

  String _getMarkerSnippet(CityData cityData) {
    switch (_selectedDataType) {
      case DataType.rainfall:
        return 'Rainfall: ${cityData.rainfall.toStringAsFixed(1)} mm';
      case DataType.soilTexture:
        return 'Soil: ${cityData.soilTexture}';
      case DataType.groundwaterLevel:
        return 'Groundwater: ${cityData.groundwaterLevel.toStringAsFixed(1)} m';
    }
  }

  double _getMarkerHue(CityData cityData) {
    Color color = _getPolygonColor(cityData);
    if (color.red > color.blue && color.red > color.green) return BitmapDescriptor.hueRed;
    if (color.blue > color.red && color.blue > color.green) return BitmapDescriptor.hueBlue;
    if (color.green > color.red && color.green > color.blue) return BitmapDescriptor.hueGreen;
    return BitmapDescriptor.hueOrange;
  }

  void _showCityDetails(CityData cityData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCityDetailsSheet(cityData),
    );
  }

  Widget _buildCityDetailsSheet(CityData cityData) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // City name
          Text(
            cityData.cityName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Data cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 4,
              children: [
                _buildDataCard(
                  'Rainfall',
                  '${cityData.rainfall.toStringAsFixed(1)} mm',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildDataCard(
                  'Soil Texture',
                  cityData.soilTexture,
                  Icons.landscape,
                  Colors.brown,
                ),
                _buildDataCard(
                  'Groundwater Level',
                  '${cityData.groundwaterLevel.toStringAsFixed(1)} m below ground',
                  Icons.vertical_align_bottom,
                  Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 300),
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getLegendIcon(),
                    size: 16,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _getLegendTitle(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ..._getLegendItems(),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getLegendIcon() {
    switch (_selectedDataType) {
      case DataType.rainfall:
        return Icons.water_drop;
      case DataType.soilTexture:
        return Icons.landscape;
      case DataType.groundwaterLevel:
        return Icons.vertical_align_bottom;
    }
  }

  String _getLegendTitle() {
    switch (_selectedDataType) {
      case DataType.rainfall:
        return 'Rainfall (mm)';
      case DataType.soilTexture:
        return 'Soil Texture';
      case DataType.groundwaterLevel:
        return 'Groundwater (m)';
    }
  }

  List<Widget> _getLegendItems() {
    switch (_selectedDataType) {
      case DataType.rainfall:
        return [
          _buildLegendItem('< 500 mm', Colors.red),
          _buildLegendItem('500-1000 mm', Colors.orange),
          _buildLegendItem('1000-1500 mm', Colors.yellow),
          _buildLegendItem('1500-2000 mm', Colors.lightGreen),
          _buildLegendItem('> 2000 mm', Colors.blue),
        ];
      case DataType.soilTexture:
        return [
          _buildLegendItem('Clay/Sandy Clay', Colors.brown),
          _buildLegendItem('Sandy/Sandy Loam', Colors.yellow),
          _buildLegendItem('Loam/Red Loam', Colors.green),
          _buildLegendItem('Alluvial', Colors.grey),
          _buildLegendItem('Black Cotton', Colors.black),
        ];
      case DataType.groundwaterLevel:
        return [
          _buildLegendItem('< 5 m (High)', Colors.blue),
          _buildLegendItem('5-10 m (Good)', Colors.lightBlue),
          _buildLegendItem('10-15 m (Moderate)', Colors.orange),
          _buildLegendItem('> 15 m (Low)', Colors.red),
        ];
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 14,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              border: Border.all(color: color, width: 1.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Environmental Data'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Top 10% - Data type selector
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDataTypeButton('Rainfall', DataType.rainfall, Icons.water_drop),
                  _buildDataTypeButton('Soil', DataType.soilTexture, Icons.landscape),
                  _buildDataTypeButton('Groundwater', DataType.groundwaterLevel, Icons.vertical_align_bottom),
                ],
              ),
            ),
          ),

          // Map section - 80% of screen
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: _initialPosition,
                      polygons: _polygons,
                      markers: _markers,
                      myLocationEnabled: _isLocationPermissionGranted,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: true,
                      buildingsEnabled: true,
                      trafficEnabled: false,
                      mapType: MapType.normal,
                    ),
                  ),
                ),

                // Legend overlay
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildLegend(),
                ),

                // Enhanced zoom and navigation controls
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: Column(
                    children: [
                      // Zoom to Bhopal button
                      FloatingActionButton(
                        mini: true,
                        heroTag: "bhopal_zoom",
                        backgroundColor: Colors.green,
                        onPressed: () {
                          mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              const CameraPosition(
                                target: LatLng(23.2599, 77.4126), // Bhopal
                                zoom: 11.0,
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.my_location, color: Colors.white),
                      ),
                      const SizedBox(height: 8),

                      // Zoom In button
                      FloatingActionButton(
                        mini: true,
                        heroTag: "zoom_in",
                        backgroundColor: Colors.blue,
                        onPressed: () => mapController?.animateCamera(CameraUpdate.zoomIn()),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(height: 6),

                      // Zoom Out button
                      FloatingActionButton(
                        mini: true,
                        heroTag: "zoom_out",
                        backgroundColor: Colors.blue,
                        onPressed: () => mapController?.animateCamera(CameraUpdate.zoomOut()),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                      const SizedBox(height: 8),

                      // Reset view button
                      FloatingActionButton(
                        mini: true,
                        heroTag: "reset_view",
                        backgroundColor: Colors.orange,
                        onPressed: () {
                          mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(_initialPosition),
                          );
                        },
                        child: const Icon(Icons.center_focus_strong, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom 10% - Summary info
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Cities: ${_cityData.length}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Mode: ${_getDataTypeName()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Row(
                      children: [
                        Icon(Icons.touch_app, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Tap polygons for details',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Row(
                      children: [
                        Icon(Icons.my_location, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Green: Focus Bhopal',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTypeButton(String label, DataType type, IconData icon) {
    bool isSelected = _selectedDataType == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _selectedDataType = type;
            });
            _updatePolygons();
          },
          icon: Icon(icon, size: 16),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.green : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  String _getDataTypeName() {
    switch (_selectedDataType) {
      case DataType.rainfall:
        return 'Rainfall';
      case DataType.soilTexture:
        return 'Soil Texture';
      case DataType.groundwaterLevel:
        return 'Groundwater Level';
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

// Usage in main.dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Environmental Data Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const PolygonMapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
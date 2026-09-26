import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class DetectedObjectData {
  final String label;
  final double confidence;
  final double left;
  final double top;
  final double right;
  final double bottom;

  DetectedObjectData({
    required this.label,
    required this.confidence,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });
}

class ObjectDetectorService {
  late ObjectDetector _objectDetector;
  bool _isInitialized = false;

  Future<void> initialize() async {
    final mode = DetectionMode.stream;
    final options = ObjectDetectorOptions(
      mode: mode,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
    _isInitialized = true;
  }

  Future<List<DetectedObjectData>> processImage(dynamic inputImage) async {
    if (!_isInitialized || inputImage is! InputImage) return [];
    
    try {
      final objects = await _objectDetector.processImage(inputImage);
      
      // OPTION 1: Filter to only include items classified as 'Food'
      final foodObjects = objects.where((obj) {
        return obj.labels.isNotEmpty && obj.labels.first.text == 'Food';
      }).toList();

      return foodObjects.map((obj) {
        final label = obj.labels.first.text;
        final confidence = obj.labels.first.confidence;

        return DetectedObjectData(
          label: label,
          confidence: confidence,
          left: obj.boundingBox.left,
          top: obj.boundingBox.top,
          right: obj.boundingBox.right,
          bottom: obj.boundingBox.bottom,
        );
      }).toList();
    } catch (e) {
      print('Object detection error: $e');
      return [];
    }
  }

  void dispose() {
    if (_isInitialized) {
      _objectDetector.close();
    }
  }
}

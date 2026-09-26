// Stub for Web where MLKit is not supported

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
  Future<void> initialize() async {}

  Future<List<DetectedObjectData>> processImage(dynamic inputImage) async {
    return [];
  }

  void dispose() {}
}

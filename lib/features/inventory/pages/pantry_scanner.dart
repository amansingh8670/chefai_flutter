import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import '../providers/scanner_state.dart';
import '../widgets/detected_item_card.dart';
import '../services/mlkit_service.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';
import 'package:chef_ai_mobile/providers/kitchen_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class PantryScannerScreen extends ConsumerStatefulWidget {
  const PantryScannerScreen({super.key});

  @override
  ConsumerState<PantryScannerScreen> createState() => _PantryScannerScreenState();
}

class _PantryScannerScreenState extends ConsumerState<PantryScannerScreen> {
  CameraController? _cameraController;
  ObjectDetectorService? _objectDetector;
  bool _isCameraInitialized = false;
  int _selectedTab = 0; // 0: Scan Food, 1: Barcode, 2: Add Manually
  bool _isProcessing = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      _objectDetector = ObjectDetectorService();
      await _objectDetector!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    setState(() { _isFlashOn = !_isFlashOn; });
    await _cameraController!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      await _analyzeImageBytes(bytes);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _objectDetector?.dispose();
    super.dispose();
  }

  void _showAddManuallyDialog() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final categoryController = TextEditingController(text: 'Other');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2228),
        title: const Text('Add Manually', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Item Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            TextField(
              controller: qtyController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            TextField(
              controller: categoryController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryOrange),
            onPressed: () {
              final qty = int.tryParse(qtyController.text) ?? 1;
              ref.read(scannerQueueProvider.notifier).addItem(
                nameController.text,
                category: categoryController.text,
                quantity: qty,
              );
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    
    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      await _analyzeImageBytes(bytes);
    } catch (e) {
      print('Capture error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take picture: $e'))
        );
      }
    }
  }

  Future<void> _analyzeImageBytes(List<int> bytes) async {
    setState(() { _isProcessing = true; });
    
    try {
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analyzing image... Please wait.'), duration: Duration(seconds: 2))
        );
      }
      
      final apiClient = ref.read(apiClientProvider);
      final userId = Supabase.instance.client.auth.currentUser?.id ?? 'demo';
      
      // Upload using multipart
      var request = http.MultipartRequest('POST', Uri.parse('${apiClient.baseUrl}/upload/?user_id=$userId&upload_type=stock'));
      
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        request.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
      
      request.files.add(http.MultipartFile.fromBytes(
        'file', 
        bytes, 
        filename: 'scan.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
      
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      
      if (response.statusCode >= 400) {
        throw Exception('Server Error ${response.statusCode}: $respStr');
      }
      
      var json = jsonDecode(respStr);
      
      if (json['job_id'] != null) {
         // Poll for job status
         String jobId = json['job_id'];
         bool done = false;
         while(!done) {
            await Future.delayed(const Duration(seconds: 2));
            try {
              var statusResp = await apiClient.get('/upload/status/$jobId');
              if (statusResp['status'] == 'completed') {
                 final result = statusResp['data'];
                 if (result is Map) {
                    if (result.containsKey('error')) {
                       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI Error: ${result['error']}')));
                    } else if (result['items'] != null) {
                       final itemsList = result['items'] as List;
                       if (itemsList.isEmpty) {
                         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI could not find any food items in this image.')));
                       } else {
                         for (var item in itemsList) {
                            ref.read(scannerQueueProvider.notifier).addItem(
                              item['item_name'] ?? 'Unknown Item',
                              category: item['category'] ?? 'Other',
                              quantity: item['quantity'] != null ? int.tryParse(item['quantity'].toString()) ?? 1 : 1,
                            );
                         }
                       }
                    }
                 }
                 done = true;
              } else if (statusResp['status'] == 'error') {
                 done = true;
                 if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI Error: ${statusResp['error']}')));
              }
            } catch (pollError) {
              print('Polling error: $pollError');
              done = true;
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Server lost the job or polling failed: $pollError'))
                );
              }
            }
         }
      } else {
        throw Exception('Invalid response: missing job_id');
      }
    } catch (e) {
      print('Capture error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    } finally {
      if (mounted) setState(() { _isProcessing = false; });
    }
  }

  Future<void> _addAllToPantry() async {
    final items = ref.read(scannerQueueProvider);
    if (items.isEmpty) return;
    
    setState(() { _isProcessing = true; });
    
    try {
      final apiClient = ref.read(apiClientProvider);
      final activeKitchenId = ref.read(activeKitchenIdProvider);
      
      final payload = items.map((e) => {
        "kitchen_id": activeKitchenId,
        "item_name": e.name,
        "quantity": "${e.quantity} ${e.unit}",
        "category": e.category,
      }).toList();
      
      await apiClient.post('/stock/batch', body: payload);
      
      ref.read(scannerQueueProvider.notifier).clear();
      if (mounted) Navigator.pop(context);
      
    } catch (e) {
      print('Batch add error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding items: $e')));
      }
    } finally {
      if (mounted) setState(() { _isProcessing = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(scannerQueueProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview Background
          if (_isCameraInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
            
          // Top Bar Overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.help_outline, size: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Removed center reticle in favor of bottom shutter button
            
          // Bottom Panel Area (Shutter + Panel)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shutter Button
                if (_selectedTab == 0 || _selectedTab == 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _isProcessing ? null : _pickFromGallery,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.photo_library_outlined, color: Colors.white),
                          ),
                        ),
                        
                        GestureDetector(
                          onTap: _isProcessing ? null : _captureAndAnalyze,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Center(
                              child: _isProcessing 
                                ? const SizedBox(
                                    width: 32, 
                                    height: 32, 
                                    child: CircularProgressIndicator(color: AppColors.primaryOrange, strokeWidth: 3)
                                  )
                                : Container(
                                    width: 54,
                                    height: 54,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        
                        GestureDetector(
                          onTap: _toggleFlash,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isFlashOn ? Colors.white : Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isFlashOn ? Icons.flash_on : Icons.flash_off, 
                              color: _isFlashOn ? Colors.black : Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                // Animated Bottom Panel
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF111418),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Segmented Tabs
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              _buildTab(0, 'SCAN FOOD', Icons.camera_alt_outlined),
                              _buildTab(1, 'BILL SCAN', Icons.receipt_long),
                              _buildTab(2, 'ADD MANUALLY', Icons.add),
                            ],
                          ),
                        ),
                        
                        // Queue Area (Only shows if items exist)
                        if (queue.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          // Queue Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DETECTED ITEMS QUEUE (${queue.length})',
                                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'TAP TO EDIT',
                                style: TextStyle(color: Colors.white38, fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Horizontal Queue List
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: queue.length,
                              itemBuilder: (context, index) {
                                return DetectedItemCard(item: queue[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Add All Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: _isProcessing ? null : _addAllToPantry,
                              child: const Text('ADD ALL TO PANTRY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() { _selectedTab = index; });
          if (index == 2) {
            _showAddManuallyDialog();
            setState(() { _selectedTab = 0; }); // Revert after opening modal
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.white54),
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

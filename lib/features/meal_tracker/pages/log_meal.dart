import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/providers/auth_provider.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';
import 'package:chef_ai_mobile/providers/user_provider.dart';
import 'package:chef_ai_mobile/providers/meal_scanner_state.dart';
import 'package:chef_ai_mobile/providers/meals_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class LogMealScreen extends ConsumerStatefulWidget {
  const LogMealScreen({super.key});

  @override
  ConsumerState<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends ConsumerState<LogMealScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  int _selectedTab = 0; // 0: Scan Food, 1: Add Manually
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
    super.dispose();
  }

  void _showAddManuallyDialog() {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController(text: '300');
    final categoryController = TextEditingController(text: 'DINNER');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2228),
        title: const Text('Add Meal Manually', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Meal Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            TextField(
              controller: caloriesController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories (kcal)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            TextField(
              controller: categoryController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Category (LUNCH, DINNER, etc)',
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
              final cals = int.tryParse(caloriesController.text) ?? 300;
              ref.read(mealScannerQueueProvider.notifier).addItem(
                DetectedMealItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.isNotEmpty ? nameController.text : 'Unknown Meal',
                  category: categoryController.text.toUpperCase(),
                  calories: cals,
                  carbs: (cals * 0.4 / 4).round(),
                  protein: (cals * 0.3 / 4).round(),
                  fat: (cals * 0.3 / 9).round(),
                  tags: ['HOME COOKED'],
                )
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
      final user = ref.read(currentUserProvider);
      final userId = user?.id ?? 'demo';
      
      // Upload using multipart
      var request = http.MultipartRequest('POST', Uri.parse('${apiClient.baseUrl}/upload/?user_id=$userId&upload_type=meal'));
      
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
                    } else if (result['name'] != null) {
                       final nutrition = result['nutrition'] ?? {};
                       ref.read(mealScannerQueueProvider.notifier).addItem(
                         DetectedMealItem(
                           id: DateTime.now().millisecondsSinceEpoch.toString(),
                           name: result['name'] ?? 'Unknown Meal',
                           category: (result['meal_type'] ?? 'OTHER').toString().toUpperCase(),
                           calories: int.tryParse(nutrition['calories']?.toString() ?? '0') ?? 0,
                           carbs: int.tryParse(nutrition['carbs_g']?.toString() ?? '0') ?? 0,
                           protein: int.tryParse(nutrition['protein_g']?.toString() ?? '0') ?? 0,
                           fat: int.tryParse(nutrition['fat_g']?.toString() ?? '0') ?? 0,
                           tags: ['SCANNED', 'AI RECOGNIZED'],
                         )
                       );
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

  Future<void> _addAllToMeals() async {
    final items = ref.read(mealScannerQueueProvider);
    if (items.isEmpty) return;
    
    setState(() { _isProcessing = true; });
    
    try {
      final apiClient = ref.read(apiClientProvider);
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception("User not logged in");
      
      for (var item in items) {
        for (var i = 0; i < item.quantity; i++) {
          await apiClient.post('/meals/${user.id}', body: {
            "name": item.name,
            "calories": item.calories,
          });
        }
      }
      
      // Refresh the meals provider
      ref.refresh(mealsProvider);
      
      ref.read(mealScannerQueueProvider.notifier).clear();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meals logged successfully!'))
        );
      }
      
    } catch (e) {
      print('Batch add error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding meals: $e')));
      }
    } finally {
      if (mounted) setState(() { _isProcessing = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(mealScannerQueueProvider);
    
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
          
          // Overlay UI (Crosshairs etc can go here if needed)
          
          // Bottom Panel Area
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Camera controls row
                if (_selectedTab == 0)
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
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF111418), // Very dark background from mockup
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Segmented Tabs
                      Container(
                        height: 48,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            _buildTab(0, 'SCAN FOOD', Icons.camera_alt_outlined),
                            _buildTab(1, 'ADD MANUALLY', Icons.add),
                          ],
                        ),
                      ),
                      
                      // Queue Area
                      if (queue.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        // Queue Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DETECTED ITEMS QUEUE (${queue.length})',
                              style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            const Text(
                              'TAP TO EDIT / FOCUS',
                              style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Horizontal Queue List
                        SizedBox(
                          height: 190,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: queue.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return _buildDetectedItemCard(queue[index]);
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Add All Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: _isProcessing ? null : _addAllToMeals,
                            child: const Text('ADD ALL TO MEALS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ),
                      ],
                    ],
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
          if (index == 1) {
            _showAddManuallyDialog();
            setState(() { _selectedTab = 0; });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.white54),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetectedItemCard(DetectedMealItem item) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2228),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Image, Name, Subtitle, Close
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category,
                      style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => ref.read(mealScannerQueueProvider.notifier).removeItem(item.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 12, color: Colors.white54),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Macros Row
          Row(
            children: [
              Text('${item.calories} kcal', style: const TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold)),
              const Spacer(),
              _buildMacroText('C', '${item.carbs}g', Colors.white),
              const SizedBox(width: 12),
              _buildMacroText('P', '${item.protein}g', Colors.tealAccent),
              const SizedBox(width: 12),
              _buildMacroText('F', '${item.fat}g', Colors.redAccent),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Tags Row
          Row(
            children: item.tags.take(3).map((tag) => _buildTag(tag)).toList(),
          ),
          
          const Spacer(),
          
          // Footer: QTY and Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('QTY', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 14, color: Colors.white),
                          onPressed: () => ref.read(mealScannerQueueProvider.notifier).updateQuantity(item.id, -1),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32),
                        ),
                        Text('${item.quantity}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add, size: 14, color: Colors.white),
                          onPressed: () => ref.read(mealScannerQueueProvider.notifier).updateQuantity(item.id, 1),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('portion', style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('EDIT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroText(String label, String value, Color valueColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/user_provider.dart';

class ProfileSheet extends ConsumerStatefulWidget {
  const ProfileSheet({super.key});

  @override
  ConsumerState<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends ConsumerState<ProfileSheet> {
  // Local state for editing
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  
  String _dietaryPref = 'Standard';
  String _activityLevel = 'Moderate';
  late TextEditingController _allergiesController;
  late TextEditingController _regionalController;

  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;

  bool _isSaving = false;
  
  // Accordion state: 0=Personal, 1=Body, 2=Diet, 3=Goals, -1=none
  int _expandedSection = 0;

  // Regional Preferences
  final List<String> _globalRegions = [
    'Italian', 'Mexican',
    'Chinese', 'Thai',
    'Japanese', 'American',
    'Mediterranean', 'French'
  ];

  final List<String> _indianRegions = [
    'North Indian', 'South Indian',
    'Punjabi', 'Gujarati',
    'Bengali', 'Maharashtrian',
    'Rajasthani', 'Kerala',
    'Chettinad'
  ];

  final Set<String> _selectedRegions = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _ageController = TextEditingController();
    _allergiesController = TextEditingController();
    _regionalController = TextEditingController();
    _caloriesController = TextEditingController();
    _proteinController = TextEditingController();
    _carbsController = TextEditingController();
    _fatController = TextEditingController();
    
    // Load initial values from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(userProfileProvider);
      final profile = profileState.value;
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name;
          _heightController.text = profile.height?.toString() ?? '';
          _weightController.text = profile.weight?.toString() ?? '';
          _ageController.text = profile.age?.toString() ?? '';
          _activityLevel = profile.activityLevel;
          _dietaryPref = profile.dietaryPreferences;
          _allergiesController.text = profile.allergies;
          
          final regionParts = profile.regionalPreferences.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
          List<String> customRegions = [];
          for (final part in regionParts) {
            if (_globalRegions.contains(part) || _indianRegions.contains(part)) {
              _selectedRegions.add(part);
            } else {
              customRegions.add(part);
            }
          }
          _regionalController.text = customRegions.join(', ');
          
          _caloriesController.text = profile.dailyCalories?.toString() ?? '';
          _proteinController.text = profile.dailyProtein?.toString() ?? '';
          _carbsController.text = profile.dailyCarbs?.toString() ?? '';
          _fatController.text = profile.dailyFat?.toString() ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _allergiesController.dispose();
    _regionalController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    
    final currentProfile = ref.read(userProfileProvider).value;
    if (currentProfile == null) {
      setState(() => _isSaving = false);
      return;
    }
    
    final List<String> allRegions = _selectedRegions.toList();
    if (_regionalController.text.trim().isNotEmpty) {
      allRegions.add(_regionalController.text.trim());
    }
    final regionalPrefString = allRegions.join(', ');
    
    final newProfile = UserProfile(
      userId: currentProfile.userId,
      name: _nameController.text.trim(),
      height: int.tryParse(_heightController.text.trim()),
      weight: int.tryParse(_weightController.text.trim()),
      age: int.tryParse(_ageController.text.trim()),
      activityLevel: _activityLevel,
      dietaryPreferences: _dietaryPref,
      allergies: _allergiesController.text.trim(),
      regionalPreferences: regionalPrefString,
      dailyCalories: int.tryParse(_caloriesController.text.trim()),
      dailyProtein: int.tryParse(_proteinController.text.trim()),
      dailyCarbs: int.tryParse(_carbsController.text.trim()),
      dailyFat: int.tryParse(_fatController.text.trim()),
    );
    
    final success = await ref.read(userProfileProvider.notifier).updateProfile(newProfile);
    setState(() => _isSaving = false);
    
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isExpanded, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white54,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.isNotEmpty ? value : items.first,
                isExpanded: true,
                dropdownColor: AppColors.surfaceDark,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                onChanged: onChanged,
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionCheckboxes(List<String> regions) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: regions.map((region) {
        final isSelected = _selectedRegions.contains(region);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedRegions.remove(region);
              } else {
                _selectedRegions.add(region);
              }
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 48 - 12) / 2, // 2 columns minus padding and spacing
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryOrange : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primaryOrange : Colors.white54,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected 
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    region,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F1012),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // PERSONAL
                    _buildSectionHeader('Personal Details', Icons.person_outline, _expandedSection == 0, () => setState(() => _expandedSection = _expandedSection == 0 ? -1 : 0)),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity, height: 0),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTextField('Full Name', _nameController),
                      ),
                      crossFadeState: _expandedSection == 0 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                    
                    Divider(color: Colors.white.withOpacity(0.05)),
                    
                    // BODY STATS
                    _buildSectionHeader('Body Stats', Icons.monitor_weight_outlined, _expandedSection == 1, () => setState(() => _expandedSection = _expandedSection == 1 ? -1 : 1)),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity, height: 0),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildTextField('Height (cm)', _heightController, isNumber: true)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTextField('Weight (kg)', _weightController, isNumber: true)),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: _buildTextField('Age', _ageController, isNumber: true)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDropdown(
                                    'Activity Level', 
                                    _activityLevel, 
                                    ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active'], 
                                    (v) => setState(() => _activityLevel = v!)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: _expandedSection == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),

                    Divider(color: Colors.white.withOpacity(0.05)),

                    // DIET & REGIONAL
                    _buildSectionHeader('Diet & Region', Icons.restaurant_menu, _expandedSection == 2, () => setState(() => _expandedSection = _expandedSection == 2 ? -1 : 2)),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity, height: 0),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            _buildDropdown(
                              'Dietary Preference', 
                              _dietaryPref, 
                              ['Standard', 'Vegetarian', 'Vegan', 'Keto', 'Paleo', 'Pescatarian'], 
                              (v) => setState(() => _dietaryPref = v!)
                            ),
                            _buildTextField('Allergies (comma separated)', _allergiesController),
                            
                            const SizedBox(height: 8),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('SELECT REGIONS YOU ENJOY. THE AI WILL PRIORITIZE THESE CUISINES.', 
                                style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildRegionCheckboxes(_globalRegions),
                            
                            const SizedBox(height: 24),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('INDIAN REGIONS', 
                                style: TextStyle(color: AppColors.primaryOrange, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildRegionCheckboxes(_indianRegions),
                            
                            const SizedBox(height: 24),
                            _buildTextField('Custom / Other (e.g. Korean, Lebanese...)', _regionalController),
                          ],
                        ),
                      ),
                      crossFadeState: _expandedSection == 2 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),

                    Divider(color: Colors.white.withOpacity(0.05)),

                    // NUTRITION GOALS
                    _buildSectionHeader('Nutrition Goals', Icons.flag_outlined, _expandedSection == 3, () => setState(() => _expandedSection = _expandedSection == 3 ? -1 : 3)),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity, height: 0),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            _buildTextField('Daily Calories', _caloriesController, isNumber: true),
                            Row(
                              children: [
                                Expanded(child: _buildTextField('Protein (g)', _proteinController, isNumber: true)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildTextField('Carbs (g)', _carbsController, isNumber: true)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildTextField('Fat (g)', _fatController, isNumber: true)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: _expandedSection == 3 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
            
            ElevatedButton(
              onPressed: _isSaving ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: _isSaving 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
            const SizedBox(height: 12),
            
            // Connect to Swiggy Button
            OutlinedButton(
              onPressed: () {
                // TODO: Implement Swiggy connection logic
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryOrange,
                side: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/swiggy_logo.png',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text('Connect to Swiggy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

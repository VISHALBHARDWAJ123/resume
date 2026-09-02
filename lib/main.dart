import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'utils/printer.dart' as printer;
import 'models/resume_data.dart';
import 'data/default_resume.dart';
import 'theme/resume_theme.dart';
import 'widgets/premium_widgets.dart';
import 'widgets/resume_templates.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vishal Bhardwaj — Resume',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent ,//,
      ),
      home: const ResumePage(),
    );
  }
}

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> with TickerProviderStateMixin {
  bool _isDark = false;
  bool _isEditMode = false;
  late ResumeData _resumeData;
  bool _isLoading = true;
  ResumeTemplateType _selectedTemplate = ResumeTemplateType.modern;

  // Controllers for general editing
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _githubController;
  late TextEditingController _linkedinController;
  late TextEditingController _websiteController;
  late TextEditingController _imageController;

  // Raw JSON controller for import/export
  final TextEditingController _jsonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resumeData = defaultResumeData;
    _initControllers();
    _loadData();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: _resumeData.personalInfo.name);
    _titleController = TextEditingController(text: _resumeData.personalInfo.title);
    _bioController = TextEditingController(text: _resumeData.personalInfo.bio);
    _emailController = TextEditingController(text: _resumeData.personalInfo.email);
    _phoneController = TextEditingController(text: _resumeData.personalInfo.phone);
    _locationController = TextEditingController(text: _resumeData.personalInfo.location);
    _githubController = TextEditingController(text: _resumeData.personalInfo.github);
    _linkedinController = TextEditingController(text: _resumeData.personalInfo.linkedin);
    _websiteController = TextEditingController(text: _resumeData.personalInfo.website);
    _imageController = TextEditingController(text: _resumeData.personalInfo.imageUrl);
    _jsonController.text = _resumeData.toJson();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _websiteController.dispose();
    _imageController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString('resume_data_v1');
      if (savedJson != null) {
        setState(() {
          _resumeData = ResumeData.fromJson(savedJson);
          _isDark = prefs.getBool('is_dark_v1') ?? false;
          final templateIndex = prefs.getInt('selected_template_v1') ?? 0;
          _selectedTemplate = ResumeTemplateType.values[templateIndex];
          _initControllers();
        });
      }
    } catch (e) {
      debugPrint('Error loading saved resume data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('resume_data_v1', _resumeData.toJson());
      await prefs.setBool('is_dark_v1', _isDark);
      await prefs.setInt('selected_template_v1', _selectedTemplate.index);
    } catch (e) {
      debugPrint('Error saving resume data: $e');
    }
  }

  void _updatePersonalInfo() {
    setState(() {
      _resumeData = _resumeData.copyWith(
        personalInfo: PersonalInfo(
          name: _nameController.text,
          title: _titleController.text,
          bio: _bioController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          location: _locationController.text,
          github: _githubController.text,
          linkedin: _linkedinController.text,
          website: _websiteController.text,
          imageUrl: _imageController.text,
        ),
      );
      _jsonController.text = _resumeData.toJson();
    });
    _saveData();
  }

  void _resetToDefault() {
    setState(() {
      _resumeData = defaultResumeData;
      _initControllers();
    });
    _saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reset to default profile successfully.'),
        backgroundColor: ResumeTheme(isDark: _isDark).accentColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _importJson(String jsonStr) {
    try {
      final parsed = ResumeData.fromJson(jsonStr);
      setState(() {
        _resumeData = parsed;
        _initControllers();
      });
      _saveData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Resume imported successfully!'),
          backgroundColor: ResumeTheme(isDark: _isDark).accentColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid JSON format: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _triggerPrint() {
    final theme = ResumeTheme(isDark: _isDark);
    printer.printResume(_resumeData, _selectedTemplate, theme);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final theme = ResumeTheme(isDark: _isDark);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 950;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Fixed Mesh Gradients background (Ethereal Glass feel in dark mode)
            if (_isDark)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 0.8,
                    colors: [Color(0xFF1B3127), Colors.transparent],
                  ),
                ),
              ),
            if (_isDark)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomLeft,
                    radius: 0.7,
                    colors: [Color(0xFF2C2219), Colors.transparent],
                  ),
                ),
              ),

            // Main Contents Row
            Row(
              children: [
                // Scrollable main content view
                Expanded(
                  child: Column(
                    children: [
                      // Elegant Floating Navbar
                      _buildNavbar(theme),

                      // Main Resume body
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 60.0 : 20.0,
                            vertical: 30.0,
                          ),
                          child: _buildSelectedLayout(theme, isDesktop),
                        ),
                      ),
                    ],
                  ),
                ),

                // Slide-out Side Customizer Dashboard
                if (_isEditMode)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: const Cubic(0.16, 1, 0.3, 1),
                    width: isDesktop ? 450 : width,
                    decoration: BoxDecoration(
                      color: theme.surfaceColor,
                      border: Border(
                        left: BorderSide(color: theme.borderColor, width: 1),
                      ),
                    ),
                    child: _buildEditorPanel(theme),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedLayout(ResumeTheme theme, bool isDesktop) {
    switch (_selectedTemplate) {
      case ResumeTemplateType.modern:
        return ModernLayout(data: _resumeData, theme: theme, isDesktop: isDesktop);
      case ResumeTemplateType.professional:
        return ProfessionalLayout(data: _resumeData, theme: theme, isDesktop: isDesktop);
      case ResumeTemplateType.creative:
        return CreativeLayout(data: _resumeData, theme: theme, isDesktop: isDesktop);
    }
  }

  // --- main content rendering ---

  Widget _buildTemplateSelector(ResumeTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.shellColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: theme.borderColor, width: 0.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ResumeTemplateType>(
          value: _selectedTemplate,
          icon: Icon(Icons.style, size: 16, color: theme.accentColor),
          dropdownColor: theme.surfaceColor,
          items: ResumeTemplateType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type.name.toUpperCase(),
                style: theme.label.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedTemplate = val);
              _saveData();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNavbar(ResumeTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.85),
        border: Border(bottom: BorderSide(color: theme.borderColor, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                _resumeData.personalInfo.name.split(' ').first.toUpperCase(),
                style: theme.label.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 2.0,
                  color: theme.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PORTFOLIO',
                style: theme.label.copyWith(fontSize: 9),
              ),
            ],
          ),
          Row(
            children: [
              // Template Selector
              _buildTemplateSelector(theme),
              const SizedBox(width: 16),
              // Theme Toggle Icon Button
              IconButton(
                icon: Icon(
                  _isDark ? Icons.light_mode : Icons.dark_mode,
                  color: theme.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isDark = !_isDark;
                  });
                  _saveData();
                },
                tooltip: _isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              ),
              const SizedBox(width: 8),
              // PDF / Print button
              IconButton(
                icon: Icon(
                  Icons.print_outlined,
                  color: theme.textSecondary,
                  size: 20,
                ),
                onPressed: _triggerPrint,
                tooltip: 'Export as PDF / Print',
              ),
              const SizedBox(width: 12),
              // Interactive Editor Trigger Button
              ButtonInButton(
                text: _isEditMode ? 'Close Builder' : 'Open Builder',
                icon: _isEditMode ? Icons.close : Icons.tune,
                theme: theme,
                isSecondary: true,
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- sliding builder control panel panel ---

  Widget _buildEditorPanel(ResumeTheme theme) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.borderColor, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RESUME BUILDER',
                  style: theme.label.copyWith(fontWeight: FontWeight.bold, color: theme.textPrimary),
                ),
                TextButton(
                  onPressed: _resetToDefault,
                  child: Text(
                    'Reset Default',
                    style: theme.bodySecondary.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.secondaryAccent,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: theme.label.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
            unselectedLabelColor: theme.textSecondary,
            labelColor: theme.accentColor,
            indicatorColor: theme.accentColor,
            dividerColor: theme.borderColor,
            tabs: const [
              Tab(text: 'PERSONAL'),
              Tab(text: 'SKILLS'),
              Tab(text: 'EXPERIENCE'),
              Tab(text: 'PROJECTS'),
              Tab(text: 'RAW DATA'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPersonalTab(theme),
                _buildSkillsTab(theme),
                _buildExperienceTab(theme),
                _buildProjectsTab(theme),
                _buildRawDataTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(ResumeTheme theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Full Name', _nameController, theme),
          _buildTextField('Professional Title', _titleController, theme),
          _buildTextField('Bio / Statement', _bioController, theme, maxLines: 4),
          _buildTextField('Email Address', _emailController, theme),
          _buildTextField('Phone Number', _phoneController, theme),
          _buildTextField('Location (City, ST)', _locationController, theme),
          _buildTextField('Website Link', _websiteController, theme),
          _buildTextField('GitHub URL', _githubController, theme),
          _buildTextField('LinkedIn URL', _linkedinController, theme),
          _buildTextField('Profile Image URL', _imageController, theme),
        ],
      ),
    );
  }

  Widget _buildSkillsTab(ResumeTheme theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SKILL CATEGORIES',
            style: theme.label.copyWith(color: theme.accentColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._resumeData.skillCategories.asMap().entries.map((entry) {
            final idx = entry.key;
            final cat = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: cat.categoryName,
                          onChanged: (val) {
                            setState(() {
                              final updated = List<SkillCategory>.from(_resumeData.skillCategories);
                              updated[idx] = cat.copyWith(categoryName: val);
                              _resumeData = _resumeData.copyWith(skillCategories: updated);
                              _jsonController.text = _resumeData.toJson();
                            });
                            _saveData();
                          },
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: theme.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            final updated = List<SkillCategory>.from(_resumeData.skillCategories)..removeAt(idx);
                            _resumeData = _resumeData.copyWith(skillCategories: updated);
                            _jsonController.text = _resumeData.toJson();
                          });
                          _saveData();
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 8),
                  const SizedBox(height: 6),
                  Text('Skills (comma separated)', style: theme.caption.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: cat.skills.join(', '),
                    onChanged: (val) {
                      setState(() {
                        final skillsList = val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                        final updated = List<SkillCategory>.from(_resumeData.skillCategories);
                        updated[idx] = cat.copyWith(skills: skillsList);
                        _resumeData = _resumeData.copyWith(skillCategories: updated);
                        _jsonController.text = _resumeData.toJson();
                      });
                      _saveData();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                    style: theme.bodySecondary,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Skill Category'),
            onPressed: () {
              setState(() {
                final updated = List<SkillCategory>.from(_resumeData.skillCategories)
                  ..add(SkillCategory(categoryName: 'New Category', skills: ['Skill A', 'Skill B']));
                _resumeData = _resumeData.copyWith(skillCategories: updated);
                _jsonController.text = _resumeData.toJson();
              });
              _saveData();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.accentColor,
              side: BorderSide(color: theme.borderColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTab(ResumeTheme theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WORK HISTORY',
            style: theme.label.copyWith(color: theme.accentColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._resumeData.experiences.asMap().entries.map((entry) {
            final idx = entry.key;
            final exp = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Role #${idx + 1}', style: theme.label),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            final updated = List<WorkExperience>.from(_resumeData.experiences)..removeAt(idx);
                            _resumeData = _resumeData.copyWith(experiences: updated);
                            _jsonController.text = _resumeData.toJson();
                          });
                          _saveData();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildInlineTextField('Company Name', exp.company, (val) {
                    final updated = List<WorkExperience>.from(_resumeData.experiences);
                    updated[idx] = exp.copyWith(company: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(experiences: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme),
                  _buildInlineTextField('Role Title', exp.role, (val) {
                    final updated = List<WorkExperience>.from(_resumeData.experiences);
                    updated[idx] = exp.copyWith(role: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(experiences: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme),
                  _buildInlineTextField('Duration/Period', exp.period, (val) {
                    final updated = List<WorkExperience>.from(_resumeData.experiences);
                    updated[idx] = exp.copyWith(period: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(experiences: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme),
                  _buildInlineTextField('Location', exp.location, (val) {
                    final updated = List<WorkExperience>.from(_resumeData.experiences);
                    updated[idx] = exp.copyWith(location: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(experiences: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme),
                  const SizedBox(height: 10),
                  Text('Key Highlights / Bullets (One per line)', style: theme.caption.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: exp.highlights.join('\n'),
                    maxLines: 4,
                    onChanged: (val) {
                      final lines = val.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                      final updated = List<WorkExperience>.from(_resumeData.experiences);
                      updated[idx] = exp.copyWith(highlights: lines);
                      setState(() {
                        _resumeData = _resumeData.copyWith(experiences: updated);
                        _jsonController.text = _resumeData.toJson();
                      });
                      _saveData();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                    style: theme.bodySecondary,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Role'),
            onPressed: () {
              setState(() {
                final updated = List<WorkExperience>.from(_resumeData.experiences)
                  ..add(WorkExperience(
                    company: 'New Corporation',
                    role: 'Software Engineer',
                    period: '2024 - Present',
                    location: 'City, ST',
                    highlights: ['Successfully completed system overhaul.', 'Improved UI latency by 20%.'],
                  ));
                _resumeData = _resumeData.copyWith(experiences: updated);
                _jsonController.text = _resumeData.toJson();
              });
              _saveData();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.accentColor,
              side: BorderSide(color: theme.borderColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsTab(ResumeTheme theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROJECT PORTFOLIO',
            style: theme.label.copyWith(color: theme.accentColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._resumeData.projects.asMap().entries.map((entry) {
            final idx = entry.key;
            final proj = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Project #${idx + 1}', style: theme.label),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            final updated = List<Project>.from(_resumeData.projects)..removeAt(idx);
                            _resumeData = _resumeData.copyWith(projects: updated);
                            _jsonController.text = _resumeData.toJson();
                          });
                          _saveData();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildInlineTextField('Project Title', proj.title, (val) {
                    final updated = List<Project>.from(_resumeData.projects);
                    updated[idx] = proj.copyWith(title: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(projects: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme),
                  _buildInlineTextField('Project Link / GitHub', proj.link, (val) {
                    final updated = List<Project>.from(_resumeData.projects);
                    updated[idx] = proj.copyWith(link: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(projects: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme),
                  _buildInlineTextField('Description', proj.description, (val) {
                    final updated = List<Project>.from(_resumeData.projects);
                    updated[idx] = proj.copyWith(description: val);
                    setState(() {
                      _resumeData = _resumeData.copyWith(projects: updated);
                      _jsonController.text = _resumeData.toJson();
                    });
                    _saveData();
                  }, theme, maxLines: 2),
                  const SizedBox(height: 10),
                  Text('Technologies (comma separated)', style: theme.caption.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: proj.technologies.join(', '),
                    onChanged: (val) {
                      final tags = val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                      final updated = List<Project>.from(_resumeData.projects);
                      updated[idx] = proj.copyWith(technologies: tags);
                      setState(() {
                        _resumeData = _resumeData.copyWith(projects: updated);
                        _jsonController.text = _resumeData.toJson();
                      });
                      _saveData();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                    style: theme.bodySecondary,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Project'),
            onPressed: () {
              setState(() {
                final updated = List<Project>.from(_resumeData.projects)
                  ..add(Project(
                    title: 'New Project',
                    description: 'A brief description of your project accomplishments and metrics.',
                    technologies: ['Flutter', 'Firebase'],
                    link: 'https://github.com/',
                  ));
                _resumeData = _resumeData.copyWith(projects: updated);
                _jsonController.text = _resumeData.toJson();
              });
              _saveData();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.accentColor,
              side: BorderSide(color: theme.borderColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRawDataTab(ResumeTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'JSON DATABASE SCHEMA',
            style: theme.label.copyWith(color: theme.accentColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You can fully customize your profile by copy-pasting the raw JSON below. Store this JSON on your disk to load different profiles instantly.',
            style: theme.bodySecondary.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _jsonController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.spaceMono(fontSize: 11, color: theme.textPrimary),
              decoration: InputDecoration(
                fillColor: theme.shellColor,
                filled: true,
                border: OutlineInputBorder(borderSide: BorderSide(color: theme.borderColor)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ButtonInButton(
                  text: 'Apply JSON',
                  icon: Icons.check,
                  theme: theme,
                  onPressed: () {
                    _importJson(_jsonController.text);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // General field builder
  Widget _buildTextField(String label, TextEditingController controller, ResumeTheme theme, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.label.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            onChanged: (val) => _updatePersonalInfo(),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: theme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: theme.accentColor, width: 1.5),
              ),
              fillColor: theme.shellColor,
              filled: true,
            ),
            style: theme.body,
          ),
        ],
      ),
    );
  }

  // Inline field builder for list editing
  Widget _buildInlineTextField(
      String label, String initialValue, ValueChanged<String> onChanged, ResumeTheme theme,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.caption.copyWith(fontSize: 10, color: theme.textSecondary)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: initialValue,
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(8),
            ),
            style: theme.bodySecondary,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WorkerTypeScreen extends StatefulWidget {
  const WorkerTypeScreen({
    super.key,
    required this.onBack,
    required this.onSelectCategory,
    required this.language,
    required this.currentTheme,
    required this.favoriteCategories,
    required this.onToggleFavorite,
    required this.getCategoryCount,
  });

  final VoidCallback onBack;
  final void Function(String categoryName) onSelectCategory;
  final String language; // en | si | ta
  final String currentTheme; // light | dark
  final List<String> favoriteCategories;
  final void Function(String categoryName) onToggleFavorite;
  final int Function(String categoryName) getCategoryCount;

  @override
  State<WorkerTypeScreen> createState() => _WorkerTypeScreenState();
}

class _WorkerTypeScreenState extends State<WorkerTypeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isDark => widget.currentTheme == 'dark';

  _UiTheme get _theme {
    if (_isDark) {
      return const _UiTheme(
        background: Color(0xFF121212),
        card: Color(0xFF1E1E1E),
        textPrimary: Colors.white,
        textSecondary: Color(0xFFAAAAAA),
        border: Color(0xFF333333),
        iconBg: Color(0xFF2A2A2A),
        accent: Color(0xFF4A90E2),
      );
    }
    return const _UiTheme(
      background: Color(0xFFF4F7FB),
      card: Colors.white,
      textPrimary: Color(0xFF2A2A2A),
      textSecondary: Color(0xFF6D7A8A),
      border: Color(0xFFE3EAF5),
      iconBg: Color(0xFFF4F7FB),
      accent: Color(0xFF4A90E2),
    );
  }

  String _txt(String en, String si, String ta) {
    switch (widget.language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  String _translateCategory(String category) {
    switch (category) {
      case 'Plumber':
        return _txt('Plumber', 'ජලනල කාර්මිකයා', 'குழாய் பழுதுபார்ப்பவர்');
      case 'Electrician':
        return _txt('Electrician', 'විදුලි කාර්මිකයා', 'மின்சார தொழிலாளர்');
      case 'Mason':
        return _txt('Mason', 'ගොඩනැගිලි කාර්මිකයා', 'கட்டிட தொழிலாளர்');
      case 'Carpenter':
        return _txt('Carpenter', 'වඩු කාර්මිකයා', 'தச்சர்');
      case 'Painter':
        return _txt('Painter', 'පින්තාරුකරු', 'ஓவியர்');
      case 'Gardener':
        return _txt('Gardener', 'වත්තකරු', 'தோட்டக்காரர்');
      case 'Cleaner':
        return _txt('Cleaner', 'පිරිසිදුකරු', 'சுத்தப்படுத்துபவர்');
      case 'AC Technician':
        return _txt('AC Technician', 'AC කාර්මිකයා', 'ஏசி தொழில்நுட்ப நிபுணர்');
      case 'Mechanic':
        return _txt('Mechanic', 'යාන්ත්‍රික කාර්මිකයා', 'இயந்திர நிபுணர்');
      case 'Welder':
        return _txt('Welder', 'වෙල්ඩර්', 'வேல்டர்');
      case 'Tiler':
        return _txt('Tiler', 'ටයිල් කාර්මිකයා', 'டைலர்');
      case 'Roofer':
        return _txt('Roofer', 'වහල කාර්මිකයා', 'கூரை அமைப்பவர்');
      default:
        return category;
    }
  }

  List<_WorkerCategory> get _categories => [
    _WorkerCategory(
      id: 1,
      name: 'Plumber',
      icon: Icons.plumbing,
      color: const Color(0xFF3498DB),
    ),
    _WorkerCategory(
      id: 2,
      name: 'Electrician',
      icon: Icons.electrical_services,
      color: const Color(0xFFF39C12),
    ),
    _WorkerCategory(
      id: 3,
      name: 'Mason',
      icon: Icons.handyman,
      color: const Color(0xFFE74C3C),
    ),
    _WorkerCategory(
      id: 4,
      name: 'Carpenter',
      icon: Icons.carpenter,
      color: const Color(0xFF9B59B6),
    ),
    _WorkerCategory(
      id: 5,
      name: 'Painter',
      icon: Icons.brush,
      color: const Color(0xFF1ABC9C),
    ),
    _WorkerCategory(
      id: 6,
      name: 'Gardener',
      icon: Icons.energy_savings_leaf,
      color: const Color(0xFF27AE60),
    ),
    _WorkerCategory(
      id: 7,
      name: 'Cleaner',
      icon: Icons.cleaning_services,
      color: const Color(0xFF3498DB),
    ),
    _WorkerCategory(
      id: 8,
      name: 'AC Technician',
      icon: Icons.ac_unit,
      color: const Color(0xFF16A085),
    ),
    _WorkerCategory(
      id: 9,
      name: 'Mechanic',
      icon: Icons.build,
      color: const Color(0xFF34495E),
    ),
    _WorkerCategory(
      id: 10,
      name: 'Welder',
      icon: Icons.construction,
      color: const Color(0xFFE67E22),
    ),
    _WorkerCategory(
      id: 11,
      name: 'Tiler',
      icon: Icons.grid_view_rounded,
      color: const Color(0xFF8E44AD),
    ),
    _WorkerCategory(
      id: 12,
      name: 'Roofer',
      icon: Icons.roofing,
      color: const Color(0xFFC0392B),
    ),
  ];

  Future<void> _handleCategoryTap(_WorkerCategory category) async {
    setState(() => _selectedId = category.id);
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted) {
      return;
    }
    setState(() => _selectedId = null);
    widget.onSelectCategory(category.name);
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _categories
        .where((category) => category.name.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      backgroundColor: _theme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: _theme.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E5BFF).withValues(alpha: 0.08),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _theme.iconBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: _theme.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _txt('Worker Types', 'සේවක වර්ග', 'பணியாளர் வகைகள்'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _theme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 46),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: _theme.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _theme.border, width: 1.5),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: _theme.accent,
                    ),
                    hintText: _txt(
                      'Search worker type...',
                      'වැඩකරු වර්ගය සොයන්න...',
                      'வேலைவகையைத் தேடு...',
                    ),
                    hintStyle: TextStyle(color: _theme.textSecondary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: filtered.map((category) {
                    final isFavorite = widget.favoriteCategories.contains(
                      category.name,
                    );
                    final isSelected = _selectedId == category.id;

                    return AnimatedScale(
                      duration: const Duration(milliseconds: 120),
                      scale: isSelected ? 1.06 : 1,
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 52) / 2,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _theme.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _theme.border, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2E5BFF,
                              ).withValues(alpha: 0.10),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () =>
                                    widget.onToggleFavorite(category.name),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _theme.iconBg,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    isFavorite
                                        ? Icons.star
                                        : Icons.star_outline,
                                    color: isFavorite
                                        ? const Color(0xFFFFD700)
                                        : const Color(0xFFB0BEC5),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _handleCategoryTap(category),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 78,
                                      height: 78,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: category.color.withValues(
                                          alpha: 0.13,
                                        ),
                                        border: Border.all(
                                          color: category.color,
                                          width: 2.5,
                                        ),
                                      ),
                                      child: Icon(
                                        category.icon,
                                        size: 34,
                                        color: category.color,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _translateCategory(category.name),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: _theme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          color: _theme.accent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.getCategoryCount(category.name)} ${_txt('available', 'ලබා ගත හැක', 'கிடைக்கும்')}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _theme.accent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerCategory {
  const _WorkerCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final int id;
  final String name;
  final IconData icon;
  final Color color;
}

class _UiTheme {
  const _UiTheme({
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.iconBg,
    required this.accent,
  });

  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color iconBg;
  final Color accent;
}

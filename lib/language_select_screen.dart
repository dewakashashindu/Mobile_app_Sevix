import 'package:flutter/material.dart';

class LanguageSelectScreen extends StatefulWidget {
  final void Function(String) onSelect;

  const LanguageSelectScreen({super.key, required this.onSelect});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen>
    with SingleTickerProviderStateMixin {
  String _selectedLanguage = '';

  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<_LanguageOption> get _languages => const [
    _LanguageOption(code: 'si', name: 'සිංහල', nameEn: 'Sinhala'),
    _LanguageOption(code: 'en', name: 'English', nameEn: 'English'),
    _LanguageOption(code: 'ta', name: 'தமிழ்', nameEn: 'Tamil'),
  ];

  String _continueText(String code) {
    switch (code) {
      case 'si':
        return 'ඉදිරියට යන්න';
      case 'ta':
        return 'தொடரவும்';
      case 'en':
      default:
        return 'Continue to App';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B1533),
                  Color(0xFF1A2951),
                  Color(0xFF0D1A3D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Decorative circles
          Positioned(top: -150, right: -100, child: _decorativeCircle(300)),
          Positioned(bottom: 100, left: -80, child: _decorativeCircle(200)),
          Positioned(top: 200, left: 50, child: _decorativeCircle(150)),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeController,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - 32).clamp(
                          0.0,
                          double.infinity,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          _buildHeader(),
                          const SizedBox(height: 20),
                          _buildSubtitle(),
                          const SizedBox(height: 28),
                          _buildLanguageList(),
                          const SizedBox(height: 16),
                          _buildFooter(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(1000),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.language, color: Colors.white, size: 44),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sevix',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Begin Your Journey',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      children: const [
        Text(
          'Choose Your Language',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ඔබගේ භාෂාව තෝරන්න • உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்',
            style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageList() {
    return Column(
      children: _languages
          .map(
            (lang) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _LanguageCard(
                option: lang,
                selected: _selectedLanguage == lang.code,
                onTap: () {
                  setState(() => _selectedLanguage = lang.code);
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFooter() {
    final hasSelection = _selectedLanguage.isNotEmpty;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 200),
            child: InkWell(
              onTap: hasSelection
                  ? () => widget.onSelect(_selectedLanguage)
                  : null,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 28,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: hasSelection
                      ? const LinearGradient(
                          colors: [Color(0xFFE7F4FF), Color(0xFFCFE2FB)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: hasSelection
                      ? null
                      : const Color.fromRGBO(233, 244, 255, 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        hasSelection ? 0.22 : 0.15,
                      ),
                      offset: const Offset(0, 6),
                      blurRadius: hasSelection ? 14 : 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!hasSelection)
                      const Icon(
                        Icons.language_outlined,
                        size: 24,
                        color: Colors.white70,
                      ),
                    if (!hasSelection) const SizedBox(width: 10),
                    Text(
                      hasSelection
                          ? _continueText(_selectedLanguage)
                          : 'Select Your Language',
                      style: TextStyle(
                        fontSize: hasSelection ? 19 : 17,
                        fontWeight: FontWeight.w800,
                        color: hasSelection
                            ? const Color(0xFF20324A)
                            : const Color.fromRGBO(32, 50, 74, 0.6),
                        letterSpacing: 1,
                      ),
                    ),
                    if (hasSelection) const SizedBox(width: 14),
                    if (hasSelection)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color.fromRGBO(201, 218, 238, 1),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 22,
                          color: Color(0xFF355C8A),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '✨ You can change this anytime in settings',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _LanguageOption {
  final String code;
  final String name;
  final String nameEn;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.nameEn,
  });
}

class _LanguageCard extends StatelessWidget {
  final _LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected
        ? const Color.fromRGBO(231, 244, 255, 0.98)
        : const Color.fromRGBO(233, 244, 255, 0.98);

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: selected ? 1.0 : 0.99,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: const Color.fromRGBO(225, 238, 252, 0.95),
              border: Border.all(
                color: Colors.white.withOpacity(selected ? 1.0 : 0.9),
                width: selected ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(selected ? 0.25 : 0.15),
                  offset: Offset(0, selected ? 6 : 4),
                  blurRadius: selected ? 16 : 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: bgColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withOpacity(selected ? 0.35 : 0.25),
                  border: Border.all(
                    color: Colors.white.withOpacity(selected ? 0.9 : 0.6),
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    _buildIcon(),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTexts()),
                    if (selected) _buildCheck(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: selected
              ? [
                  Colors.white.withOpacity(0.9),
                  const Color.fromRGBO(231, 244, 255, 0.95),
                ]
              : [
                  const Color.fromRGBO(233, 244, 255, 0.9),
                  Colors.white.withOpacity(0.95),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.language_outlined,
            size: 24,
            color: selected ? const Color(0xFF20324A) : const Color(0xFF355C8A),
          ),
          const SizedBox(height: 4),
          Text(
            option.code.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF4A5B73),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0B1533),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          option.nameEn,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF4A5B73) : const Color(0xFF666666),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCheck() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            const Color.fromRGBO(230, 244, 255, 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: const Icon(Icons.check_circle, color: Color(0xFF355C8A), size: 28),
    );
  }
}

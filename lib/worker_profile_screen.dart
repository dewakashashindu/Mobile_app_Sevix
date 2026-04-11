import 'package:flutter/material.dart';

class WorkerProfileScreen extends StatelessWidget {
  final dynamic theme;
  final String language;
  final String workerName;
  final String workerType;
  final String workerImage;
  final double rating;
  final int completedJobs;
  final int trustScore;
  final List<String> skills;
  final List<String> certifications;
  final List<String> portfolioPhotos;
  final List<RatingBreakdown> ratingBreakdown;
  final List<BidHistoryItem> bidHistory;
  final VoidCallback onBack;

  const WorkerProfileScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.workerName,
    required this.workerType,
    required this.workerImage,
    required this.rating,
    required this.completedJobs,
    required this.trustScore,
    required this.skills,
    required this.certifications,
    required this.portfolioPhotos,
    required this.ratingBreakdown,
    required this.bidHistory,
    required this.onBack,
  });

  String _txt(String en, String si, String ta) {
    switch (language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  Color _trustColor() {
    if (trustScore >= 90) return const Color(0xFF16A34A);
    if (trustScore >= 75) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'W';
    if (parts.length == 1)
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : 'W';
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  List<String> _defaultSkills() {
    switch (workerType.toLowerCase()) {
      case 'plumber':
        return ['Pipe Repair', 'Leak Fixing', 'Bathroom Fittings'];
      case 'electrician':
        return ['Wiring', 'Fan Installation', 'Safety Checks'];
      case 'mason':
        return ['Brickwork', 'Cement Work', 'Wall Repair'];
      case 'carpenter':
        return ['Wood Work', 'Furniture Repair', 'Door Fitting'];
      default:
        return [workerType, 'On-site Service', 'Fast Response'];
    }
  }

  List<String> _defaultCertifications() {
    return ['${workerType} Certified', 'Verified ID', 'On-time Service Award'];
  }

  List<String> _defaultPortfolioPhotos() {
    return [
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80',
    ];
  }

  List<RatingBreakdown> _defaultRatings() {
    final total = rating.clamp(3.8, 5.0);
    return [
      RatingBreakdown(
        stars: 5,
        count: (total * 42).round(),
        ratio: (total / 5).clamp(0.0, 1.0),
      ),
      RatingBreakdown(
        stars: 4,
        count: ((5 - total) * 20).round(),
        ratio: (0.25 + (total - 4) / 4).clamp(0.0, 0.9),
      ),
      RatingBreakdown(stars: 3, count: 8, ratio: 0.12),
      RatingBreakdown(stars: 2, count: 3, ratio: 0.05),
      RatingBreakdown(stars: 1, count: 1, ratio: 0.02),
    ];
  }

  List<BidHistoryItem> _defaultBidHistory() {
    final averageBid = completedJobs == 0 ? 0 : (rating * 480).round();
    return [
      BidHistoryItem(
        label: _txt('Won bids', 'ජයගත් ලංසු', 'வென்ற ஏலங்கள்'),
        value: '${(completedJobs * 0.62).round()}',
      ),
      BidHistoryItem(
        label: _txt('Accepted bids', 'පිළිගත් ලංසු', 'ஏற்றுக்கொண்ட ஏலங்கள்'),
        value: '${(completedJobs * 0.41).round()}',
      ),
      BidHistoryItem(
        label: _txt('Avg. bid', 'සාමාන්‍ය ලංසුව', 'சராசரி ஏலம்'),
        value: 'LKR $averageBid',
      ),
      BidHistoryItem(
        label: _txt('Response time', 'ප්‍රතිචාර කාලය', 'பதில் நேரம்'),
        value: _txt('12 min', 'විනා 12', '12 நிமி'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = portfolioPhotos.isEmpty
        ? _defaultPortfolioPhotos()
        : portfolioPhotos;
    final skillsToShow = skills.isEmpty ? _defaultSkills() : skills;
    final certsToShow = certifications.isEmpty
        ? _defaultCertifications()
        : certifications;
    final ratings = ratingBreakdown.isEmpty
        ? _defaultRatings()
        : ratingBreakdown;
    final bidStats = bidHistory.isEmpty ? _defaultBidHistory() : bidHistory;
    final trustColor = _trustColor();

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(
          _txt('Worker Profile', 'සේවක පැතිකඩ', 'பணியாளர் சுயவிவரம்'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.border),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(
                        0xFF0B1533,
                      ).withOpacity(0.08),
                      backgroundImage: workerImage.startsWith('http')
                          ? NetworkImage(workerImage)
                          : null,
                      child: workerImage.startsWith('http')
                          ? null
                          : Text(
                              _initials(workerName),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0B1533),
                              ),
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: trustColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${trustScore}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  workerName,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  workerType,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MetricPill(
                      label: _txt('Rating', 'ඇගයීම', 'மதிப்பீடு'),
                      value: rating.toStringAsFixed(1),
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                    _MetricPill(
                      label: _txt('Jobs', 'රැකියා', 'வேலைகள்'),
                      value: '$completedJobs',
                      icon: Icons.work_history_outlined,
                      color: const Color(0xFF0B1533),
                    ),
                    _MetricPill(
                      label: _txt('Trust', 'විශ්වාසය', 'நம்பிக்கை'),
                      value: '$trustScore%',
                      icon: Icons.verified,
                      color: trustColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: _txt(
              'Skills & Services',
              'කුසලතා සහ සේවා',
              'திறன்கள் மற்றும் சேவைகள்',
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skillsToShow
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      backgroundColor: const Color(
                        0xFF0B1533,
                      ).withOpacity(0.08),
                      labelStyle: const TextStyle(
                        color: Color(0xFF0B1533),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: _txt('Certifications', 'සහතික', 'சான்றிதழ்கள்'),
            child: Column(
              children: certsToShow
                  .map(
                    (cert) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.verified_outlined,
                        color: Color(0xFF16A34A),
                      ),
                      title: Text(
                        cert,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: _txt('Portfolio', 'පෝට්ෆෝලියෝ', 'போர்ட்ஃபோலியோ'),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: portfolio.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  portfolio[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.background,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.background,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.photo_outlined,
                      color: theme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: _txt(
              'Ratings Breakdown',
              'ඇගයීම් බෙදාහැරීම',
              'மதிப்பீட்டு பிரிவு',
            ),
            child: Column(
              children: ratings
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(width: 28, child: Text('${item.stars}★')),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: item.ratio,
                                backgroundColor: theme.border,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  item.stars >= 4
                                      ? Colors.amber
                                      : const Color(0xFF0B1533),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 44,
                            child: Text(
                              '${item.count}',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: theme.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: _txt(
              'Bid History Stats',
              'ලංසු ඉතිහාස සංඛ්‍යාලේඛන',
              'ஏல வரலாறு புள்ளிவிவரங்கள்',
            ),
            child: Column(
              children: bidStats
                  .map(
                    (item) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        item.value,
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final dynamic theme;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.theme,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class RatingBreakdown {
  final int stars;
  final int count;
  final double ratio;

  const RatingBreakdown({
    required this.stars,
    required this.count,
    required this.ratio,
  });
}

class BidHistoryItem {
  final String label;
  final String value;

  const BidHistoryItem({required this.label, required this.value});
}

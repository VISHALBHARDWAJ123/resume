import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/resume_data.dart';
import '../theme/resume_theme.dart';
import 'premium_widgets.dart';

enum ResumeTemplateType { modern, professional, creative }

abstract class ResumeLayout extends StatelessWidget {
  final ResumeData data;
  final ResumeTheme theme;
  final bool isDesktop;

  const ResumeLayout({
    super.key,
    required this.data,
    required this.theme,
    required this.isDesktop,
  });

  Widget animateItem({required int index, required Widget child}) {
    return child.animate()
        .fade(duration: 800.ms, delay: (index * 100).ms, curve: const Cubic(0.16, 1, 0.3, 1))
        .slideY(begin: 20, end: 0, duration: 800.ms, delay: (index * 100).ms, curve: const Cubic(0.16, 1, 0.3, 1));
  }
}

class ModernLayout extends ResumeLayout {
  const ModernLayout({
    super.key,
    required super.data,
    required super.theme,
    required super.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildLeftColumn(context),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: _buildRightColumn(context),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeftColumn(context),
                  const SizedBox(height: 30),
                  _buildRightColumn(context),
                ],
              ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    final personal = data.personalInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        animateItem(
          index: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderBadge(label: 'Available for contracts', theme: theme),
              const SizedBox(height: 16),
              Text(personal.name, style: theme.h1),
              const SizedBox(height: 12),
              Text(
                personal.title,
                style: theme.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.accentColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        animateItem(
          index: 1,
          child: BentoCard(
            theme: theme,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ABOUT', style: theme.label),
                const SizedBox(height: 12),
                Text(personal.bio, style: theme.body.copyWith(fontSize: 14, height: 1.6)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        animateItem(
          index: 2,
          child: BentoCard(
            theme: theme,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTACT & NETWORK', style: theme.label),
                const SizedBox(height: 16),
                ClickToCopyTile(label: 'EMAIL', value: personal.email, icon: Icons.alternate_email, theme: theme),
                const SizedBox(height: 10),
                ClickToCopyTile(label: 'TELEPHONE', value: personal.phone, icon: Icons.phone_android, theme: theme),
                const SizedBox(height: 10),
                ClickToCopyTile(label: 'LOCATION', value: personal.location, icon: Icons.place_outlined, theme: theme),
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 16),
                SocialLinkPill(
                  label: 'PERSONAL SITE',
                  value: personal.website.replaceAll('https://', ''),
                  icon: Icons.language,
                  url: personal.website,
                  theme: theme,
                ),
                const SizedBox(height: 10),
                SocialLinkPill(
                  label: 'GITHUB PROFILE',
                  value: personal.github.replaceAll('https://github.com/', ''),
                  icon: Icons.code,
                  url: personal.github,
                  theme: theme,
                ),
                const SizedBox(height: 10),
                SocialLinkPill(
                  label: 'LINKEDIN',
                  value: personal.linkedin.replaceAll('https://linkedin.com/in/', ''),
                  icon: Icons.polyline,
                  url: personal.linkedin,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        animateItem(
          index: 3,
          child: BentoCard(
            theme: theme,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TECHNICAL EXPERTISE', style: theme.label),
                const SizedBox(height: 16),
                ...data.skillCategories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.categoryName.toUpperCase(),
                          style: theme.label.copyWith(fontSize: 9, fontWeight: FontWeight.bold, color: theme.accentColor),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: category.skills.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: theme.shellColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.borderColor, width: 0.5),
                              ),
                              child: Text(
                                skill,
                                style: theme.bodySecondary.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: theme.textPrimary),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        animateItem(
          index: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HeaderBadge(label: 'Chronology', theme: theme),
                  const SizedBox(width: 10),
                  Text('EXPERIENCE', style: theme.h2),
                ],
              ),
              const SizedBox(height: 24),
              ...data.experiences.asMap().entries.map((entry) {
                final idx = entry.key;
                final job = entry.value;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: theme.accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.backgroundColor, width: 2),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 1.5,
                              color: idx == data.experiences.length - 1 ? Colors.transparent : theme.borderColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: DoubleBezelCard(
                            theme: theme,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(job.role, style: theme.h3.copyWith(fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text(
                                            job.company,
                                            style: theme.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: theme.accentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(job.period, style: theme.label.copyWith(fontSize: 9, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(job.location, style: theme.caption.copyWith(fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ...job.highlights.map((bullet) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                                            child: Container(
                                              width: 4,
                                              height: 4,
                                              decoration: BoxDecoration(color: theme.textSecondary, shape: BoxShape.circle),
                                            ),
                                          ),
                                          Expanded(child: Text(bullet, style: theme.bodySecondary.copyWith(height: 1.5))),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),
        animateItem(
          index: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HeaderBadge(label: 'Creations', theme: theme),
                  const SizedBox(width: 10),
                  Text('PROJECTS', style: theme.h2),
                ],
              ),
              const SizedBox(height: 24),
              ...data.projects.map((proj) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: BentoCard(
                    theme: theme,
                    padding: const EdgeInsets.all(20),
                    onTap: () async {
                      final uri = Uri.parse(proj.link);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(proj.title, style: theme.h3.copyWith(fontSize: 16)),
                            Icon(Icons.arrow_outward, size: 14, color: theme.textMuted),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(proj.description, style: theme.bodySecondary.copyWith(height: 1.5)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: proj.technologies.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: theme.accentLight, borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                tech,
                                style: theme.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: theme.accentColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (data.education.isNotEmpty)
          animateItem(
            index: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    HeaderBadge(label: 'Academics', theme: theme),
                    const SizedBox(width: 10),
                    Text('EDUCATION', style: theme.h2),
                  ],
                ),
                const SizedBox(height: 24),
                ...data.education.map((edu) {
                  return BentoCard(
                    theme: theme,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(edu.degree, style: theme.h3.copyWith(fontSize: 15)),
                                  const SizedBox(height: 4),
                                  Text(
                                    edu.institution,
                                    style: theme.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: theme.accentColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(edu.period, style: theme.label.copyWith(fontSize: 9, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(edu.location, style: theme.caption.copyWith(fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}

class ProfessionalLayout extends ResumeLayout {
  const ProfessionalLayout({
    super.key,
    required super.data,
    required super.theme,
    required super.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 850),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: theme.cardShadow,
        ),
        child: Column(
          children: [
            // Top Accent Bar
            Container(height: 12, color: Colors.orange.shade800),
            Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.personalInfo.name.toUpperCase(), 
                              style: theme.h1.copyWith(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.black)),
                            const SizedBox(height: 20),
                            const Divider(thickness: 2, color: Colors.black),
                            const SizedBox(height: 20),
                            _buildProfessionalSummary(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Profile Pic Placeholder
                      _buildProfilePic(),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Content
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('EXPERIENCE'),
                            ...data.experiences.map((exp) => _buildExperienceItem(exp)),
                            const SizedBox(height: 24),
                            _buildSectionHeader('EDUCATION'),
                            ...data.education.map((edu) => _buildEducationItem(edu)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Sidebar
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('CONTACT'),
                            _buildContactInfo(),
                            const SizedBox(height: 24),
                            _buildSectionHeader('CORE QUALIFICATIONS'),
                            ...data.skillCategories.map((cat) => _buildSkillCategory(cat)),
                            const SizedBox(height: 24),
                            _buildSectionHeader('PROJECTS'),
                            ...data.projects.take(3).map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.title, style: theme.body.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(p.description, style: theme.bodySecondary.copyWith(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePic() {

    return Container(
      width: 160,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black, width: 1),
        image: data.personalInfo.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(data.personalInfo.imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: data.personalInfo.imageUrl.isEmpty
          ? const Center(child: Icon(Icons.person, size: 80, color: Colors.black26))
          : null,
    );
  }

  Widget _buildProfessionalSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PROFESSIONAL SUMMARY', style: theme.label.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 11)),
        const SizedBox(height: 8),
        Text(data.personalInfo.bio, style: theme.bodySecondary.copyWith(color: Colors.black87, height: 1.5)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.label.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 12)),
        const SizedBox(height: 6),
        const Divider(thickness: 1.5, color: Colors.black),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildExperienceItem(WorkExperience exp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('${exp.company} — ${exp.location}', style: theme.body.copyWith(fontWeight: FontWeight.bold, color: Colors.black))),
              Text(exp.period, style: theme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
          Text(exp.role, style: theme.bodySecondary.copyWith(fontStyle: FontStyle.italic, color: Colors.black54)),
          const SizedBox(height: 8),
          ...exp.highlights.map((h) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                Expanded(child: Text(h, style: theme.bodySecondary.copyWith(color: Colors.black87))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEducationItem(Education edu) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(edu.degree, style: theme.body.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
          Text(edu.institution, style: theme.bodySecondary.copyWith(color: Colors.black87)),
          Text('${edu.location} | ${edu.period}', style: theme.caption.copyWith(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactItem(Icons.place, 'Address', data.personalInfo.location),
        _buildContactItem(Icons.phone, 'Phone', data.personalInfo.phone),
        _buildContactItem(Icons.email, 'Email', data.personalInfo.email),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
          Text(value, style: theme.bodySecondary.copyWith(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(SkillCategory cat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cat.categoryName.toUpperCase(), style: theme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 9)),
          const SizedBox(height: 4),
          ...cat.skills.map((s) => Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 2),
            child: Text('• $s', style: theme.bodySecondary.copyWith(color: Colors.black87, fontSize: 11)),
          )),
        ],
      ),
    );
  }
}

class CreativeLayout extends ResumeLayout {
  const CreativeLayout({
    super.key,
    required super.data,
    required super.theme,
    required super.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: theme.cardShadow,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sidebar
              Container(
                width: 260,
                color: const Color(0xFFF4F4F4),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Red Logo/Icon Box
                    Container(
                      width: 70,
                      height: 70,
                      color: const Color(0xFF9E3E3E),
                      child: const Center(child: Icon(Icons.architecture, color: Colors.white, size: 36)),
                    ),
                    const SizedBox(height: 50),
                    _buildSidebarSection('CORE QUALIFICATIONS', 
                      data.skillCategories.expand((c) => c.skills).map((s) => '• $s').toList()),
                    const SizedBox(height: 35),
                    _buildSidebarSection('EDUCATION', 
                      data.education.map((e) => '${e.degree}\n${e.institution}').toList()),
                    const SizedBox(height: 35),
                    _buildSidebarSection('LANGUAGES', ['• Hindi: native', '• English: fluent', '• Bengali: intermediate']),
                    const SizedBox(height: 35),
                    _buildSidebarSection('INTERESTS', ['• Recreational Football', '• Team Captain', '• Community Theater']),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                      color: const Color(0xFFFAF0F0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.personalInfo.name.toUpperCase(), 
                            style: theme.h1.copyWith(fontSize: 38, letterSpacing: 3, color: const Color(0xFF333333), fontWeight: FontWeight.w900)),
                          const SizedBox(height: 25),
                          Container(height: 1, width: double.infinity, color: Colors.black26),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _headerInfoItem(data.personalInfo.location),
                              _headerInfoItem(data.personalInfo.phone),
                              _headerInfoItem(data.personalInfo.email),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('PROFESSIONAL SUMMARY'),
                          Text(data.personalInfo.bio, style: theme.bodySecondary.copyWith(color: Colors.black87, height: 1.6)),
                          const SizedBox(height: 35),
                          _buildSectionTitle('EXPERIENCE'),
                          ...data.experiences.map((exp) => _buildExperienceItem(exp)),
                          const SizedBox(height: 35),
                          _buildSectionTitle('PROJECTS'),
                          ...data.projects.map((proj) => _buildProjectItem(proj)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectItem(Project proj) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(proj.title.toUpperCase(), style: theme.body.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 13)),
              const Icon(Icons.arrow_outward, size: 12, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 4),
          Text(proj.description, style: theme.bodySecondary.copyWith(color: Colors.black87, fontSize: 11)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: proj.technologies.map((t) => Text('#$t', style: theme.caption.copyWith(fontSize: 10, color: const Color(0xFF9E3E3E), fontWeight: FontWeight.bold))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _headerInfoItem(String text) {
    return Text(text, style: theme.label.copyWith(fontSize: 9, color: Colors.black87, letterSpacing: 0.5));
  }

  Widget _buildSidebarSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.label.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 10)),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(item, style: theme.bodySecondary.copyWith(fontSize: 11, color: Colors.black87)),
        )),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.label.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 13)),
        const SizedBox(height: 8),
        const Divider(thickness: 2, color: Colors.black),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildExperienceItem(WorkExperience exp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exp.role.toUpperCase(), style: theme.body.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 14)),
          const SizedBox(height: 4),
          Text('${exp.company} — ${exp.location} | ${exp.period}', 
            style: theme.bodySecondary.copyWith(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 12),
          ...exp.highlights.map((h) => Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                ),
                Expanded(child: Text(h, style: theme.bodySecondary.copyWith(color: Colors.black87, height: 1.5))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

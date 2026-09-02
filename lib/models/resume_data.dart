import 'dart:convert';

class PersonalInfo {
  final String name;
  final String title;
  final String bio;
  final String email;
  final String phone;
  final String location;
  final String github;
  final String linkedin;
  final String website;
  final String imageUrl;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    required this.github,
    required this.linkedin,
    required this.website,
    required this.imageUrl,
  });

  PersonalInfo copyWith({
    String? name,
    String? title,
    String? bio,
    String? email,
    String? phone,
    String? location,
    String? github,
    String? linkedin,
    String? website,
    String? imageUrl,
  }) {
    return PersonalInfo(
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
      'bio': bio,
      'email': email,
      'phone': phone,
      'location': location,
      'github': github,
      'linkedin': linkedin,
      'website': website,
      'imageUrl': imageUrl,
    };
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      bio: map['bio'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      github: map['github'] ?? '',
      linkedin: map['linkedin'] ?? '',
      website: map['website'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class SkillCategory {
  final String categoryName;
  final List<String> skills;

  SkillCategory({
    required this.categoryName,
    required this.skills,
  });

  SkillCategory copyWith({
    String? categoryName,
    List<String>? skills,
  }) {
    return SkillCategory(
      categoryName: categoryName ?? this.categoryName,
      skills: skills ?? this.skills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'skills': skills,
    };
  }

  factory SkillCategory.fromMap(Map<String, dynamic> map) {
    return SkillCategory(
      categoryName: map['categoryName'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}

class WorkExperience {
  final String company;
  final String role;
  final String period;
  final String location;
  final List<String> highlights;

  WorkExperience({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.highlights,
  });

  WorkExperience copyWith({
    String? company,
    String? role,
    String? period,
    String? location,
    List<String>? highlights,
  }) {
    return WorkExperience(
      company: company ?? this.company,
      role: role ?? this.role,
      period: period ?? this.period,
      location: location ?? this.location,
      highlights: highlights ?? this.highlights,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role,
      'period': period,
      'location': location,
      'highlights': highlights,
    };
  }

  factory WorkExperience.fromMap(Map<String, dynamic> map) {
    return WorkExperience(
      company: map['company'] ?? '',
      role: map['role'] ?? '',
      period: map['period'] ?? '',
      location: map['location'] ?? '',
      highlights: List<String>.from(map['highlights'] ?? []),
    );
  }
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String link;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.link,
  });

  Project copyWith({
    String? title,
    String? description,
    List<String>? technologies,
    String? link,
  }) {
    return Project(
      title: title ?? this.title,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'technologies': technologies,
      'link': link,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
      link: map['link'] ?? '',
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String period;
  final String location;

  Education({
    required this.institution,
    required this.degree,
    required this.period,
    required this.location,
  });

  Education copyWith({
    String? institution,
    String? degree,
    String? period,
    String? location,
  }) {
    return Education(
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      period: period ?? this.period,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'period': period,
      'location': location,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      period: map['period'] ?? '',
      location: map['location'] ?? '',
    );
  }
}

class ResumeData {
  final PersonalInfo personalInfo;
  final List<SkillCategory> skillCategories;
  final List<WorkExperience> experiences;
  final List<Project> projects;
  final List<Education> education;

  ResumeData({
    required this.personalInfo,
    required this.skillCategories,
    required this.experiences,
    required this.projects,
    required this.education,
  });

  ResumeData copyWith({
    PersonalInfo? personalInfo,
    List<SkillCategory>? skillCategories,
    List<WorkExperience>? experiences,
    List<Project>? projects,
    List<Education>? education,
  }) {
    return ResumeData(
      personalInfo: personalInfo ?? this.personalInfo,
      skillCategories: skillCategories ?? this.skillCategories,
      experiences: experiences ?? this.experiences,
      projects: projects ?? this.projects,
      education: education ?? this.education,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personalInfo': personalInfo.toMap(),
      'skillCategories': skillCategories.map((x) => x.toMap()).toList(),
      'experiences': experiences.map((x) => x.toMap()).toList(),
      'projects': projects.map((x) => x.toMap()).toList(),
      'education': education.map((x) => x.toMap()).toList(),
    };
  }

  factory ResumeData.fromMap(Map<String, dynamic> map) {
    return ResumeData(
      personalInfo: PersonalInfo.fromMap(map['personalInfo'] ?? {}),
      skillCategories: List<SkillCategory>.from(
        (map['skillCategories'] ?? []).map((x) => SkillCategory.fromMap(x)),
      ),
      experiences: List<WorkExperience>.from(
        (map['experiences'] ?? []).map((x) => WorkExperience.fromMap(x)),
      ),
      projects: List<Project>.from(
        (map['projects'] ?? []).map((x) => Project.fromMap(x)),
      ),
      education: List<Education>.from(
        (map['education'] ?? []).map((x) => Education.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResumeData.fromJson(String source) => ResumeData.fromMap(json.decode(source));
}

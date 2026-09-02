import '../models/resume_data.dart';

final defaultResumeData = ResumeData(
  personalInfo: PersonalInfo(
    name: 'Vishal Bhardwaj',
    title: 'Flutter Developer',
    bio:
    'Flutter Developer with ~4 years of experience building scalable, high-performance mobile applications across enterprise and consumer domains. Specialized in state management (BLoC, GetX), offline-first architecture, and complex business workflows including logistics, ecommerce, and ERP systems.',
    email: 'devb7647@gmail.com',
    phone: '+91 9350911847',
    location: 'Sonipat, India',
    github: 'https://github.com/VISHALBHARDWAJ123',
    linkedin: 'https://www.linkedin.com/in/vishal-bhardwaj-574385200',
    website: '',
    imageUrl:   'https://raw.githubusercontent.com/VISHALBHARDWAJ123/resume/main/IMG_2242.JPG',
  ),

  skillCategories: [
    SkillCategory(
      categoryName: 'Strong',
      skills: [
        'Flutter',
        'Dart',
        'BLoC',
        'REST APIs',
        'SQLite',
        'App Architecture',
      ],
    ),
    SkillCategory(
      categoryName: 'Intermediate',
      skills: [
        'Firebase',
        'Supabase',
        'GetX',
        'Background Sync',
      ],
    ),
    SkillCategory(
      categoryName: 'Familiar',
      skills: [
        'Kotlin',
        'Java',
      ],
    ),
    SkillCategory(
      categoryName: 'Tools',
      skills: [
        'Android Studio',
        'VS Code',
        'Git',
      ],
    ),
  ],

  experiences: [
    WorkExperience(
      company: 'Softcore Infotech Pvt. Ltd',
      role: 'Flutter Developer',
      period: 'April 2025 - Present',
      location: 'India',
      highlights: [
        'Developed enterprise-grade Flutter applications for business workflows.',
        'Implemented scalable architecture, API integrations, and offline-first systems.',
        'Improved application performance through optimized state management and caching.',
        'Built admin panels, product systems, and ledger tracking solutions.',
        'Developed Janak, a product and order management system with filtering and admin workflows.',
        'Developed Radhee Bilty, a logistics document management system.',
        'Built a geo-location based attendance system with tracking capabilities.',
        'Developed Sumitra, an internal enterprise workflow platform.',
        'Built RTC, a customer order and ledger tracking system.',
      ],
    ),

    WorkExperience(
      company: 'Nexever Pvt Ltd',
      role: 'Flutter Developer',
      period: 'June 2024 - August 2024',
      location: 'Mohali, India',
      highlights: [
        'Developed cross-platform applications ensuring smooth UX and performance.',
        'Collaborated with UI/UX and backend teams for timely delivery.',
        'Developed ImmiNex, an immigration services platform.',
        'Worked on a scalable ecommerce platform.',
        'Developed G’Day Talk, a real-time chat application.',
        'Built Tasty Punjab, a food delivery application.',
      ],
    ),

    WorkExperience(
      company: 'Matrid Technologies',
      role: 'Flutter Developer',
      period: 'April 2021 - June 2024',
      location: 'Mohali, India',
      highlights: [
        'Built and deployed Flutter applications for Android and iOS.',
        'Implemented offline caching and Firebase integrations.',
        'Published applications on Google Play Store and Apple App Store.',
        'Improved application stability and reduced crashes.',
        'Developed THE One, a multi-country ecommerce application.',
        'Worked on an ecommerce application for a BBQ outlet system.',
        'Developed MSP, a price analysis tool.',
        'Built Loccam, a tracking device integration application.',
      ],
    ),
  ],

  projects: [
    Project(
      title: 'Anime Library',
      description:
      'An anime browsing application designed for exploring and discovering anime content.',
      technologies: [
        'Flutter',
        'Dart',
        'REST APIs',
      ],
      link: '',
    ),

    Project(
      title: 'NexImage',
      description:
      'An image rendering toolkit focused on efficient image handling and rendering within Flutter applications.',
      technologies: [
        'Flutter',
        'Dart',
        'Image Rendering',
      ],
      link: '',
    ),

    Project(
      title: 'Flutter Package - Dominant Color UI',
      description:
      'A Flutter package for extracting dominant colors from images and using them to dynamically theme user interfaces.',
      technologies: [
        'Flutter',
        'Dart',
        'Image Processing',
        'UI Theming',
      ],
      link: '',
    ),

    Project(
      title: 'WidgetRebirth',
      description:
      'A Flutter utility that provides the ability to restart or rebuild widgets from anywhere within an application.',
      technologies: [
        'Flutter',
        'Dart',
        'Widget Lifecycle',
        'State Management',
      ],
      link: '',
    ),
  ],

  education: [
    Education(
      institution:
      'Guru Bharmanand Government Polytechnic Institute',
      degree: 'Diploma in Computer and Information Sciences',
      period: '2020',
      location: 'Nilokheri, India',
    ),
  ],
);

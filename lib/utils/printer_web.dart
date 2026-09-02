import 'package:printing/printing.dart';
import 'pdf_generator.dart';
import '../models/resume_data.dart';
import '../widgets/resume_templates.dart';
import '../theme/resume_theme.dart';

Future<void> printResume(ResumeData data, ResumeTemplateType type, ResumeTheme theme) async {
  try {
    await Printing.layoutPdf(
      onLayout: (format) => generateResumePdf(format, data, type, theme),
      name: '${data.personalInfo.name}_Resume',
    );
  } catch (e) {
    // Fail silently or log
  }
}

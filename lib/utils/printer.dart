import 'printer_stub.dart' if (dart.library.html) 'printer_web.dart' as impl;
import '../models/resume_data.dart';
import '../widgets/resume_templates.dart';
import '../theme/resume_theme.dart';

Future<void> printResume(ResumeData data, ResumeTemplateType type, ResumeTheme theme) async {
  await impl.printResume(data, type, theme);
}

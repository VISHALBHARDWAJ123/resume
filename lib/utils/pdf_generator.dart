import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_data.dart';
import '../widgets/resume_templates.dart';
import '../theme/resume_theme.dart';

Future<Uint8List> generateResumePdf(
  PdfPageFormat format,
  ResumeData data,
  ResumeTemplateType type,
  ResumeTheme theme,
) async {
  final doc = pw.Document(
    title: '${data.personalInfo.name} - Resume',
    author: data.personalInfo.name,
  );

  // Load fonts for PDF
  final fontRegular = await PdfGoogleFonts.plusJakartaSansRegular();
  final fontBold = await PdfGoogleFonts.plusJakartaSansBold();
  final fontItalic = await PdfGoogleFonts.plusJakartaSansItalic();
  final fontSerif = await PdfGoogleFonts.instrumentSerifRegular();

  switch (type) {
    case ResumeTemplateType.modern:
      _buildModernPdf(doc, data, fontRegular, fontBold, fontItalic, fontSerif);
      break;
    case ResumeTemplateType.professional:
      _buildProfessionalPdf(doc, data, fontRegular, fontBold, fontItalic, fontSerif);
      break;
    case ResumeTemplateType.creative:
      _buildCreativePdf(doc, data, fontRegular, fontBold, fontItalic, fontSerif);
      break;
  }

  return doc.save();
}

void _buildModernPdf(pw.Document doc, ResumeData data, pw.Font reg, pw.Font bold, pw.Font italic, pw.Font serif) {
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(30),
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(data.personalInfo.name, style: pw.TextStyle(font: serif, fontSize: 32)),
              pw.Text(data.personalInfo.title, style: pw.TextStyle(font: bold, fontSize: 14, color: PdfColors.teal)),
              pw.SizedBox(height: 10),
            ],
          ),
        ),
        _sectionTitle('ABOUT', bold),
        pw.Paragraph(text: data.personalInfo.bio, style: pw.TextStyle(font: reg, fontSize: 10)),
        _sectionTitle('EXPERIENCE', bold),
        ...data.experiences.map((e) => _expItem(e, reg, bold, italic)),
        _sectionTitle('PROJECTS', bold),
        ...data.projects.map((p) => _projItem(p, reg, bold)),
        _sectionTitle('EDUCATION', bold),
        ...data.education.map((e) => _eduItem(e, reg, bold)),
      ],
    ),
  );
}

void _buildProfessionalPdf(pw.Document doc, ResumeData data, pw.Font reg, pw.Font bold, pw.Font italic, pw.Font serif) {
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.orange800, width: 8))),
          child: pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 20),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(data.personalInfo.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 28)),
                      pw.Divider(thickness: 1),
                      pw.Text('PROFESSIONAL SUMMARY', style: pw.TextStyle(font: bold, fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Text(data.personalInfo.bio, style: pw.TextStyle(font: reg, fontSize: 9)),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(data.personalInfo.location, style: pw.TextStyle(font: reg, fontSize: 9)),
                    pw.Text(data.personalInfo.phone, style: pw.TextStyle(font: reg, fontSize: 9)),
                    pw.Text(data.personalInfo.email, style: pw.TextStyle(font: reg, fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
        ),
        _sectionTitle('EXPERIENCE', bold),
        ...data.experiences.map((e) => _expItem(e, reg, bold, italic)),
        _sectionTitle('EDUCATION', bold),
        ...data.education.map((e) => _eduItem(e, reg, bold)),
        _sectionTitle('PROJECTS', bold),
        ...data.projects.map((p) => _projItem(p, reg, bold)),
        _sectionTitle('SKILLS', bold),
        ...data.skillCategories.map((s) => pw.Bullet(text: '${s.categoryName}: ${s.skills.join(", ")}', style: pw.TextStyle(font: reg, fontSize: 9))),
      ],
    ),
  );
}

void _buildCreativePdf(pw.Document doc, ResumeData data, pw.Font reg, pw.Font bold, pw.Font italic, pw.Font serif) {
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (pw.Context context) => [
        pw.Partitions(
          children: [
            pw.Partition(
              width: 180,
              child: pw.Container(
                color: PdfColors.grey200,
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(width: 50, height: 50, color: PdfColors.red800),
                    pw.SizedBox(height: 30),
                    _sectionTitle('SKILLS', bold),
                    ...data.skillCategories.expand((c) => c.skills).map((s) => pw.Text('• $s', style: pw.TextStyle(font: reg, fontSize: 8))),
                    pw.SizedBox(height: 20),
                    _sectionTitle('EDUCATION', bold),
                    ...data.education.map((e) => pw.Text('${e.degree}\n${e.institution}', style: pw.TextStyle(font: reg, fontSize: 8))),
                  ],
                ),
              ),
            ),
            pw.Partition(
              child: pw.Column(
                children: [
                  pw.Container(
                    color: PdfColors.red50,
                    padding: const pw.EdgeInsets.all(30),
                    width: double.infinity,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(data.personalInfo.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 24, letterSpacing: 2)),
                        pw.Divider(),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(data.personalInfo.location, style: pw.TextStyle(fontSize: 8)),
                            pw.Text(data.personalInfo.phone, style: pw.TextStyle(fontSize: 8)),
                            pw.Text(data.personalInfo.email, style: pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(30),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('SUMMARY', bold),
                        pw.Text(data.personalInfo.bio, style: pw.TextStyle(font: reg, fontSize: 9)),
                        pw.SizedBox(height: 20),
                        _sectionTitle('EXPERIENCE', bold),
                        ...data.experiences.map((e) => _expItem(e, reg, bold, italic)),
                        _sectionTitle('PROJECTS', bold),
                        ...data.projects.map((p) => _projItem(p, reg, bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _sectionTitle(String title, pw.Font bold) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 12)),
        pw.Divider(thickness: 0.5),
      ],
    ),
  );
}

pw.Widget _expItem(WorkExperience exp, pw.Font reg, pw.Font bold, pw.Font italic) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(exp.company, style: pw.TextStyle(font: bold, fontSize: 10)),
            pw.Text(exp.period, style: pw.TextStyle(font: reg, fontSize: 9)),
          ],
        ),
        pw.Text(exp.role, style: pw.TextStyle(font: italic, fontSize: 9, color: PdfColors.grey700)),
        ...exp.highlights.map((h) => pw.Bullet(text: h, style: pw.TextStyle(font: reg, fontSize: 9), bulletSize: 2)),
      ],
    ),
  );
}

pw.Widget _projItem(Project proj, pw.Font reg, pw.Font bold) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(proj.title, style: pw.TextStyle(font: bold, fontSize: 10)),
        pw.Text(proj.description, style: pw.TextStyle(font: reg, fontSize: 9)),
      ],
    ),
  );
}

pw.Widget _eduItem(Education edu, pw.Font reg, pw.Font bold) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(edu.institution, style: pw.TextStyle(font: bold, fontSize: 10)),
        pw.Text('${edu.degree} | ${edu.period}', style: pw.TextStyle(font: reg, fontSize: 9)),
      ],
    ),
  );
}

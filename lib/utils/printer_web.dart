import 'dart:html' as html;

void printResume() {
  try {
    html.window.print();
  } catch (e) {
    // Fail silently or log
  }
}

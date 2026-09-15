import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/resume_theme.dart';

class TileZoomManager extends ChangeNotifier {
  static final TileZoomManager instance = TileZoomManager._();
  TileZoomManager._();

  void reset() {
    notifyListeners();
  }
}

class ZoomWrapper extends StatefulWidget {
  final Widget child;
  final double scale;
  final double translateY;
  final VoidCallback? onTap;
  final bool useScale;
  final bool useTranslate;

  const ZoomWrapper({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.translateY = -8.0,
    this.onTap,
    this.useScale = true,
    this.useTranslate = true,
  });

  @override
  State<ZoomWrapper> createState() => _ZoomWrapperState();
}

class _ZoomWrapperState extends State<ZoomWrapper> {
  bool _isHovered = false;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
    TileZoomManager.instance.addListener(_handleReset);
  }

  @override
  void dispose() {
    TileZoomManager.instance.removeListener(_handleReset);
    super.dispose();
  }

  void _handleReset() {
    if (mounted && _isClicked) {
      setState(() {
        _isClicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _isHovered || _isClicked;
    final double currentScale = isActive && widget.useScale ? widget.scale : 1.0;
    final double currentTranslateY = isActive && widget.useTranslate ? widget.translateY : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          setState(() => _isClicked = true);
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: const Cubic(0.16, 1, 0.3, 1),
          transform: Matrix4.identity()
            ..translate(0.0, currentTranslateY)
            ..scale(currentScale),
          child: widget.child,
        ),
      ),
    );
  }
}

class DoubleBezelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ResumeTheme theme;
  final bool isZoomable;

  const DoubleBezelCard({
    super.key,
    required this.child,
    required this.theme,
    this.padding,
    this.isZoomable = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: theme.outerShellDecoration(),
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: theme.innerCoreDecoration(),
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );

    if (isZoomable) {
      return ZoomWrapper(
        translateY: -4.0,
        child: card,
      );
    }
    return card;
  }
}

class BentoCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ResumeTheme theme;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.child,
    required this.theme,
    this.padding,
    this.onTap,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // We'll use the ZoomWrapper inside BentoCard's build or just replace BentoCard's logic
    // Actually, BentoCard has its own complex decoration animation. 
    // Let's keep the logic inside BentoCard but use the shared state if possible? 
    // No, let's just keep the implementation I just wrote for BentoCard as it handles shadows too.
    
    // Wait, I should probably use the ZoomWrapper for BentoCard too to be consistent with the click behavior.
    
    return ZoomWrapper(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          decoration: widget.theme.outerShellDecoration().copyWith(
            border: Border.all(
              color: _isHovered && widget.onTap != null
                  ? widget.theme.accentColor.withOpacity(0.4)
                  : widget.theme.borderColor,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: const Cubic(0.16, 1, 0.3, 1),
            decoration: widget.theme.innerCoreDecoration().copyWith(
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.theme.accentColor.withOpacity(widget.theme.isDark ? 0.08 : 0.05),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      )
                    ]
                  : widget.theme.cardShadow,
            ),
            padding: widget.padding ?? const EdgeInsets.all(28),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ButtonInButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final ResumeTheme theme;
  final bool isSecondary;

  const ButtonInButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.theme,
    this.isSecondary = false,
  });

  @override
  State<ButtonInButton> createState() => _ButtonInButtonState();
}

class _ButtonInButtonState extends State<ButtonInButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final accentBg = widget.isSecondary ? widget.theme.secondaryAccent : widget.theme.accentColor;
    final accentLight = widget.isSecondary ? widget.theme.secondaryAccentLight : widget.theme.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: const Cubic(0.16, 1, 0.3, 1),
          transform: Matrix4.identity()
            ..scale(_isPressed ? 0.96 : (_isHovered ? 1.01 : 1.0)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? accentLight : widget.theme.surfaceColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered ? accentBg : widget.theme.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: widget.theme.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: _isHovered ? accentBg : widget.theme.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: const Cubic(0.16, 1, 0.3, 1),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _isHovered ? accentBg : widget.theme.shellColor,
                  shape: BoxShape.circle,
                ),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  curve: const Cubic(0.16, 1, 0.3, 1),
                  turns: _isHovered && widget.icon == Icons.arrow_outward ? 0.125 : 0,
                  child: Icon(
                    widget.icon,
                    size: 14,
                    color: _isHovered ? Colors.white : widget.theme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderBadge extends StatelessWidget {
  final String label;
  final ResumeTheme theme;
  final bool isSecondary;

  const HeaderBadge({
    super.key,
    required this.label,
    required this.theme,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSecondary ? theme.secondaryAccentLight : theme.accentLight;
    final textCol = isSecondary ? theme.secondaryAccent : theme.accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: textCol.withOpacity(0.15), width: 0.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.label.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: textCol,
        ),
      ),
    );
  }
}

class SocialLinkPill extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final String url;
  final ResumeTheme theme;

  const SocialLinkPill({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.url,
    required this.theme,
  });

  @override
  State<SocialLinkPill> createState() => _SocialLinkPillState();
}

class _SocialLinkPillState extends State<SocialLinkPill> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomWrapper(
      onTap: _launchUrl,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? widget.theme.accentColor.withOpacity(0.5) : widget.theme.borderColor,
              width: 0.5,
            ),
            color: widget.theme.surfaceColor,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.theme.accentColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.theme.shellColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, size: 16, color: widget.theme.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: widget.theme.label.copyWith(fontSize: 8, color: widget.theme.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: widget.theme.body.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.theme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_outward, size: 14, color: widget.theme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class ClickToCopyTile extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final ResumeTheme theme;

  const ClickToCopyTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  State<ClickToCopyTile> createState() => _ClickToCopyTileState();
}

class _ClickToCopyTileState extends State<ClickToCopyTile> {
  bool _isHovered = false;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "${widget.value}" to clipboard.'),
        duration: const Duration(seconds: 2),
        backgroundColor: widget.theme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZoomWrapper(
      onTap: () => _copyToClipboard(context),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? widget.theme.accentColor.withOpacity(0.5) : widget.theme.borderColor,
              width: 0.5,
            ),
            color: widget.theme.surfaceColor,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.theme.accentColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.theme.shellColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, size: 16, color: widget.theme.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: widget.theme.label.copyWith(fontSize: 8, color: widget.theme.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: widget.theme.body.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.theme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy, size: 13, color: widget.theme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

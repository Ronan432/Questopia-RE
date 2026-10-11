import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'qsp_media.dart';
import 'qsp_path_resolver.dart';

class QspHtmlView extends StatelessWidget {
  const QspHtmlView({
    super.key,
    required this.html,
    required this.resolver,
    this.textStyle,
    this.backgroundColor,
    this.onTapLink,
    this.disableImages = false,
    this.muteVideos = false,
    this.imageWidthOverride,
    this.imageHeightOverride,
    this.linkColor,
  });

  final String html;
  final QspPathResolver resolver;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final FutureOr<bool> Function(String url)? onTapLink;

  /// Drops every embedded image, honouring the "Disable images" preference.
  final bool disableImages;

  /// Forces embedded video to play without sound.
  final bool muteVideos;

  /// Explicit width applied to media when automatic sizing is turned off.
  final int? imageWidthOverride;

  /// Explicit height applied to media when automatic sizing is turned off.
  final int? imageHeightOverride;

  /// Overrides the colour of every hyperlink in the story text.
  final Color? linkColor;

  /// QSP games frequently ship hardcoded `bgcolor` and font colors in their
  /// own markup. Those must never win over the app theme, so the legacy
  /// presentational attributes are stripped before rendering.
  static final RegExp _legacyColorAttrs = RegExp(
    r'''\s(?:\bbgcolor|background|text|vlink|link|alink|color)\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+)''',
    caseSensitive: false,
  );

  static final RegExp _bodyTag = RegExp(
    r'<body[^>]*>',
    caseSensitive: false,
  );

  static String _applyAppStyling(String source) {
    var result = source;

    result = result.replaceAll(_bodyTag, '');
    result = result.replaceAll(_legacyColorAttrs, '');

    // The parser builds a body wrapper, so an explicit neutral body keeps the
    // rendered surface free of Material color scheme bleed-through.
    const neutralBody = '<body style="background-color:transparent;'
        'color:inherit;margin:0;padding:0">';
    if (RegExp(r'<body', caseSensitive: false).hasMatch(result)) {
      result = result.replaceAll(
          RegExp(r'<body[^>]*>', caseSensitive: false), neutralBody);
    } else {
      result = '$neutralBody$result</body>';
    }

    return result;
  }

  double? _parseDimension(String? v) {
    if (v == null || v.isEmpty) return null;
    final clean = v.replaceAll('px', '').replaceAll('%', '').trim();
    return double.tryParse(clean);
  }

  String _hexColor(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final styledHtml = _applyAppStyling(html);
    final roots = resolver.basePaths;
    return ExcludeSemantics(
      child: Container(
        color: backgroundColor ?? Colors.transparent,
        child: HtmlWidget(
          styledHtml,
          textStyle: textStyle,
          onTapUrl: onTapLink != null
              ? (url) async {
                  return await onTapLink!(url);
                }
              : null,
          customStylesBuilder: linkColor != null
              ? (element) => element.localName == 'a'
                  ? {'color': _hexColor(linkColor!)}
                  : null
              : null,
          customWidgetBuilder: (element) {
            final tag = element.localName?.toLowerCase();
            if (tag != 'img' && tag != 'video') return null;

            // "Disable images" removes pictures but keeps the surrounding text.
            if (tag == 'img' && disableImages) return const SizedBox.shrink();

            var src = element.attributes['src'];
            if ((src == null || src.isEmpty) && tag == 'video') {
              final source = element.querySelector('source');
              src = source?.attributes['src'];
            }
            if (src == null || src.isEmpty) return null;

            // An explicit size from the settings wins over the markup, which is
            // what "automatic width and height" being switched off means.
            final w = imageWidthOverride?.toDouble() ??
                _parseDimension(element.attributes['width']);
            final h = imageHeightOverride?.toDouble() ??
                _parseDimension(element.attributes['height']);
            final isVideo = tag == 'video';

            return QspMedia(
              resolver: resolver,
              src: src,
              width: w,
              height: h,
              allowedRoots: roots,
              autoplay: true,
              loop: element.attributes.containsKey('loop') || isVideo,
              muted: muteVideos || element.attributes.containsKey('muted'),
            );
          },
        ),
      ),
    );
  }
}

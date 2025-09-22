import 'dart:io';

import 'package:flutter/material.dart';

class CustomAlert {
  static Future<void> show({
    required BuildContext context,
    bool disableBackBtn = false,
    bool? resizeToAvoidBottomInset,
    CustomAlertImage image = const CustomAlertImage(),
    Text? title,
    double titleOffset = 10,
    Widget? content,
    double contentOffset = 10,
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
    CustomAlertActions? actionWidget,
    MainAxisAlignment actionAlignment = MainAxisAlignment.end,
    bool showCancelBtn = false,
    String cancelBtnText = 'Cancel',
    String confirmBtnText = 'Ok',
    Color confirmBtnColor = Colors.blue,
    Color confirmBtnTextColor = Colors.white,
    double borderRadius = 12,
    void Function()? onCancelBtnTap,
    void Function()? onConfirmBtnTap,
    Curve curve = Curves.elasticOut,
    Curve reverseCurve = Curves.easeOutExpo,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: !disableBackBtn,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      image._build(borderRadius),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: alignment,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: title == null ? 0 : titleOffset,
                              ),
                              child:
                                  title ??
                                  SizedBox(
                                    child: content == null
                                        ? Text(
                                            'Title',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                            ),

                            SizedBox(
                              height: (title == null && content== null) || (title != null && content != null) ? contentOffset : 0,
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    content is Text ||
                                        (title == null && content == null)
                                    ? 20
                                    : 0,
                              ),
                              child:
                                  content ??
                                  SizedBox(
                                    child: title == null
                                        ? Text('alert content')
                                        : null,
                                  ),
                            ),

                            actionWidget ??
                                CustomAlertActions(
                                  alignment: actionAlignment,
                                  actions: [
                                    showCancelBtn
                                        ? TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.grey,
                                            ),
                                            onPressed:
                                                onCancelBtnTap ??
                                                () {
                                                  Navigator.of(context).pop();
                                                },
                                            child: Text(cancelBtnText),
                                          )
                                        : const SizedBox(),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: confirmBtnColor,
                                        foregroundColor: confirmBtnTextColor,
                                      ),
                                      onPressed:
                                          onConfirmBtnTap ??
                                          () {
                                            Navigator.of(context).pop();
                                          },
                                      child: Text(confirmBtnText),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Add scaling effect
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: curve,
            reverseCurve: reverseCurve,
          ),
          child: child,
        );
      },
    );
  }
}

class CustomAlertActions extends StatelessWidget {
  final double topSpacing;
  final double bottomSpacing;
  final MainAxisAlignment alignment;
  final List<Widget>? actions;
  final double actionSpacing;
  const CustomAlertActions({
    super.key,
    this.topSpacing = 20,
    this.bottomSpacing = 0,
    this.alignment = MainAxisAlignment.end,
    this.actions,
    this.actionSpacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: bottomSpacing, bottom: bottomSpacing),
      child: actions == null
          ? null
          : Row(
              mainAxisAlignment: alignment,
              children: [
                Wrap(
                  spacing: actionSpacing,
                  runSpacing: actionSpacing,
                  children: actions!,
                ),
              ],
            ),
    );
  }
}

class CustomAlertImage {
  final ImageSrc? src;
  final Color? color;
  final double borderRadius;
  final Alignment alignment;
  final Size imageSize;
  final EdgeInsetsGeometry imageMargin;
  const CustomAlertImage({
    this.src,
    this.color,
    this.borderRadius = 0,
    this.alignment = Alignment.center,
    this.imageSize = const Size(100, 100),
    this.imageMargin = const EdgeInsets.only(top: 20),
  });

  Widget _build(double borderRadius) {
    return _hasImage
        ? Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
            alignment: alignment,
            child: Padding(
              padding: imageMargin,
              child: SizedBox(
                width: imageSize.width,
                height: imageSize.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(this.borderRadius),
                  child: src!.assetPath != null
                      ? Image.asset(src!.assetPath!, package: src!.package,)
                      : src!.filePath != null
                      ? Image.file(File(src!.filePath!))
                      : Image.network(src!.url!),
                ),
              ),
            ),
          )
        : SizedBox();
  }

  bool get _hasImage =>
      src != null && (src?.assetPath != null || src?.filePath != null || src?.url != null);
}

class ImageSrc {
  final String? assetPath;
  final String? filePath;
  final String? url;
  final String? package;
  const ImageSrc({this.assetPath, this.filePath, this.url, this.package});

  static ImageSrc get confirm => ImageSrc(assetPath: _p('confirm.gif'), package: 'custom_alert');
  static ImageSrc get delete => ImageSrc(assetPath: _p('delete.gif'), package: 'custom_alert');
  static ImageSrc get donot => ImageSrc(assetPath: _p('do_not.gif'), package: 'custom_alert');
  static ImageSrc get error404 => ImageSrc(assetPath: _p('error_404.gif'), package: 'custom_alert');
  static ImageSrc get error => ImageSrc(assetPath: _p('error.gif'), package: 'custom_alert');
  static ImageSrc get info => ImageSrc(assetPath: _p('info.gif'), package: 'custom_alert');
  static ImageSrc get nodata => ImageSrc(assetPath: _p('no_data.gif'), package: 'custom_alert');
  static ImageSrc get success => ImageSrc(assetPath: _p('success.gif'), package: 'custom_alert');
  static ImageSrc get warning => ImageSrc(assetPath: _p('warning.gif'), package: 'custom_alert');

  static String _p(String name) => 'images/$name';
}

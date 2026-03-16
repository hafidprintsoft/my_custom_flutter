// pubspec.yaml dependencies:
// flutter:
//   sdk: flutter
// lottie: ^3.1.2
// flutter_animate: ^4.5.0

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:versa_mobile/constants/contstants.dart';

enum DialogType {
  success,
  error,
  warning,
  info,
  question,
  noHeader,
}

enum AnimType {
  scale,
  leftSlide,
  rightSlide,
  topSlide,
  bottomSlide,
  rotate,
}

enum DismissType {
  btnOk,
  btnCancel,
  autoHide,
  outsideClick,
  backKeyPress,
}

class AwesomeDialog {
  final BuildContext context;
  final DialogType dialogType;
  final String? title;
  final String? desc;
  final Widget? body;
  final String? btnOkText;
  final String? btnCancelText;
  final VoidCallback? btnOkOnPress;
  final VoidCallback? btnCancelOnPress;
  final Function(DismissType)? onDismissCallback;
  final AnimType animType;
  final bool autoHide;
  final Duration? autoHideDelay;
  final bool showCloseIcon;
  final bool dismissOnTouchOutside;
  final bool dismissOnBackKeyPress;
  final bool headerAnimationLoop;
  final double? width;
  final Color? btnOkColor;
  final Color? btnCancelColor;
  final Widget? btnOk;
  final Widget? btnCancel;
  final Alignment? alignment;
  final bool isDense;
  final bool showHeader;

  AwesomeDialog({
    required this.context,
    this.dialogType = DialogType.info,
    this.title,
    this.desc,
    this.body,
    this.btnOkText = 'OK',
    this.btnCancelText = 'Cancel',
    this.btnOkOnPress,
    this.btnCancelOnPress,
    this.onDismissCallback,
    this.animType = AnimType.scale,
    this.autoHide = false,
    this.autoHideDelay = const Duration(seconds: 3),
    this.showCloseIcon = false,
    this.dismissOnTouchOutside = true,
    this.dismissOnBackKeyPress = true,
    this.headerAnimationLoop = false,
    this.width,
    this.btnOkColor,
    this.btnCancelColor,
    this.btnOk,
    this.btnCancel,
    this.alignment,
    this.isDense = false,
    bool? showHeader,
  }) : showHeader = showHeader ?? (dialogType != DialogType.noHeader);

  Future<void> show() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return PopScope(
          canPop: dismissOnBackKeyPress,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              onDismissCallback?.call(DismissType.backKeyPress);
            }
          },
          child: _AwesomeDialogWidget(
            dialogType: dialogType,
            title: title,
            desc: desc,
            body: body,
            btnOkText: btnOkText,
            btnCancelText: btnCancelText,
            btnOkOnPress: btnOkOnPress,
            btnCancelOnPress: btnCancelOnPress,
            onDismissCallback: onDismissCallback,
            dismissOnTouchOutside: dismissOnTouchOutside,
            animType: animType,
            autoHide: autoHide,
            autoHideDelay: autoHideDelay,
            showCloseIcon: showCloseIcon,
            headerAnimationLoop: headerAnimationLoop,
            width: width,
            btnOkColor: btnOkColor,
            btnCancelColor: btnCancelColor,
            btnOk: btnOk,
            btnCancel: btnCancel,
            alignment: alignment,
            isDense: isDense,
            showHeader: showHeader,
          ),
        );
      },
    );
  }
}

class _AwesomeDialogWidget extends StatefulWidget {
  final DialogType dialogType;
  final String? title;
  final String? desc;
  final Widget? body;
  final String? btnOkText;
  final String? btnCancelText;
  final VoidCallback? btnOkOnPress;
  final VoidCallback? btnCancelOnPress;
  final Function(DismissType)? onDismissCallback;
  final bool dismissOnTouchOutside;
  final AnimType animType;
  final bool autoHide;
  final Duration? autoHideDelay;
  final bool showCloseIcon;
  final bool headerAnimationLoop;
  final double? width;
  final Color? btnOkColor;
  final Color? btnCancelColor;
  final Widget? btnOk;
  final Widget? btnCancel;
  final Alignment? alignment;
  final bool isDense;
  final bool showHeader;

  const _AwesomeDialogWidget({
    required this.dialogType,
    this.title,
    this.desc,
    this.body,
    this.btnOkText,
    this.btnCancelText,
    this.btnOkOnPress,
    this.btnCancelOnPress,
    this.onDismissCallback,
    this.dismissOnTouchOutside = true,
    required this.animType,
    required this.autoHide,
    this.autoHideDelay,
    required this.showCloseIcon,
    this.headerAnimationLoop = true,
    this.width,
    this.btnOkColor,
    this.btnCancelColor,
    this.btnOk,
    this.btnCancel,
    this.alignment,
    required this.isDense,
    required this.showHeader,
  });

  @override
  State<_AwesomeDialogWidget> createState() => _AwesomeDialogWidgetState();
}

class _AwesomeDialogWidgetState extends State<_AwesomeDialogWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: _getSlideOffset(),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

    if (widget.autoHide) {
      Future.delayed(widget.autoHideDelay ?? const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pop();
          widget.onDismissCallback?.call(DismissType.autoHide);
        }
      });
    }
  }

  Offset _getSlideOffset() {
    switch (widget.animType) {
      case AnimType.leftSlide:
        return const Offset(-1.0, 0.0);
      case AnimType.rightSlide:
        return const Offset(1.0, 0.0);
      case AnimType.topSlide:
        return const Offset(0.0, -1.0);
      case AnimType.bottomSlide:
        return const Offset(0.0, 1.0);
      default:
        return Offset.zero;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimation({required Widget child}) {
    switch (widget.animType) {
      case AnimType.scale:
        return ScaleTransition(scale: _scaleAnimation, child: child);
      case AnimType.leftSlide:
      case AnimType.rightSlide:
      case AnimType.topSlide:
      case AnimType.bottomSlide:
        return SlideTransition(position: _slideAnimation, child: child);
      case AnimType.rotate:
        return RotationTransition(turns: _rotateAnimation, child: child);
    }
  }

  String _getLottieAsset() {
    switch (widget.dialogType) {
      case DialogType.success:
        return 'assets/lottie/success.json'; // Animasi success
      case DialogType.error:
        return 'assets/lottie/error.json'; // Animasi error
      case DialogType.warning:
        return 'assets/lottie/warning.json'; // Animasi warning
      case DialogType.info:
        return 'assets/lottie/info.json'; // Animasi info
      case DialogType.question:
        return 'assets/lottie/question.json'; // Animasi question
      default:
        return 'assets/lottie/info.json';
    }
  }

  // Fallback untuk online Lottie URLs (jika tidak ada asset lokal)
  String _getLottieUrl() {
    switch (widget.dialogType) {
      case DialogType.success:
        return 'https://lottie.host/4c7c4c4e-8c4b-4b4a-8c4b-4b4a8c4b4b4a/4c7c4c4e.json';
      case DialogType.error:
        return 'https://lottie.host/error-animation.json';
      case DialogType.warning:
        return 'https://lottie.host/warning-animation.json';
      case DialogType.info:
        return 'https://lottie.host/info-animation.json';
      case DialogType.question:
        return 'https://lottie.host/question-animation.json';
      default:
        return 'https://lottie.host/info-animation.json';
    }
  }

  Color _getHeaderColor() {
    switch (widget.dialogType) {
      case DialogType.success:
        return Colors.green.shade50;
      case DialogType.error:
        return Colors.red.shade50;
      case DialogType.warning:
        return Colors.orange.shade50;
      case DialogType.info:
        return Colors.blue.shade50;
      case DialogType.question:
        return Colors.purple.shade50;
      default:
        return Colors.blue.shade50;
    }
  }

  Color _getBtnColor() {
    switch (widget.dialogType) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.info:
        return Colors.blue;
      case DialogType.question:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  void _dismiss({DismissType dismissType = DismissType.outsideClick}) {
    Navigator.of(context).pop();
    widget.onDismissCallback?.call(dismissType);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.dismissOnTouchOutside
                  ? () => _dismiss(dismissType: DismissType.outsideClick)
                  : null,
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: Dialog(
              alignment: widget.alignment ?? Alignment.center,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: GestureDetector(
                onTap: () {}, // Prevent dialog dismissal when tapping inside
                child: _buildAnimation(
                  child: Container(
                    width: widget.width ??
                        MediaQuery.of(context).size.width * 0.85,
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 280,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with Lottie Animation
                        if (widget.showHeader) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _getHeaderColor(),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: widget.isDense ? 20 : 30,
                                    horizontal: 20,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: widget.isDense ? 60 : 80,
                                      height: widget.isDense ? 60 : 80,
                                      child: Lottie.asset(
                                        _getLottieAsset(),
                                        // repeat: widget.headerAnimationLoop,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Fallback ke network jika asset tidak ada
                                          return Lottie.network(
                                            _getLottieUrl(),
                                            // repeat: widget.headerAnimationLoop,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              // Fallback ke icon statis
                                              return _buildFallbackIcon();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.showCloseIcon)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () => _dismiss(
                                        dismissType: DismissType.outsideClick,
                                      ),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],

                        // Content
                        Padding(
                          padding: EdgeInsets.all(widget.isDense ? 16 : 24),
                          child: Column(
                            children: [
                              // Title
                              if (widget.title != null &&
                                  widget.title!.isNotEmpty) ...[
                                Text(
                                  widget.title!,
                                  style: TextStyle(
                                    fontSize: widget.isDense ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: widget.isDense ? 8 : 12),
                              ],

                              // Description
                              if (widget.desc != null &&
                                  widget.desc!.isNotEmpty) ...[
                                Text(
                                  widget.desc!,
                                  style: TextStyle(
                                    fontSize: widget.isDense ? 14 : 16,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: widget.isDense ? 16 : 20),
                              ],

                              // Custom body
                              if (widget.body != null) ...[
                                widget.body!,
                              ],

                              // Buttons - hanya tampilkan jika ada callback atau custom widget
                              if ((widget.btnOkOnPress != null ||
                                  widget.btnCancelOnPress != null ||
                                  widget.btnOk != null ||
                                  widget.btnCancel != null)) ...[
                                SizedBox(height: widget.isDense ? 16 : 16),
                                _buildButtons(),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIcon() {
    IconData iconData;
    Color iconColor;

    switch (widget.dialogType) {
      case DialogType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case DialogType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      case DialogType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case DialogType.question:
        iconData = Icons.help;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.blue;
    }

    return Icon(
      iconData,
      size: widget.isDense ? 60 : 80,
      color: iconColor,
    ).animate().scale(
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildButtons() {
    List<Widget> buttons = [];

    // Cancel button
    if (widget.btnCancel != null || widget.btnCancelText != null) {
      buttons.add(
        Expanded(
          child: widget.btnCancel ??
              OutlinedButton(
                onPressed: () {
                  _dismiss(dismissType: DismissType.btnCancel);
                  widget.btnCancelOnPress?.call();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: widget.isDense ? 12 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: widget.btnCancelColor ?? Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  widget.btnCancelText ?? 'Cancel',
                  style: TextStyle(
                    color: widget.btnCancelColor ?? Colors.grey.shade700,
                    fontSize: widget.isDense ? 14 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        ),
      );
    }

    // OK button
    if (widget.btnOk != null || widget.btnOkText != null) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 12));
      }

      buttons.add(
        Expanded(
          child: widget.btnOk ??
              ElevatedButton(
                onPressed: () {
                  _dismiss(dismissType: DismissType.btnOk);
                  widget.btnOkOnPress?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.btnOkColor ?? _getBtnColor(),
                  padding: EdgeInsets.symmetric(
                    vertical: widget.isDense ? 12 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.btnOkText ?? 'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isDense ? 14 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        ),
      );
    }

    return Row(children: buttons);
  }
}

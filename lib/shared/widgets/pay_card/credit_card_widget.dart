// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:math';

import 'package:flutter/material.dart';

import 'credit_card_animation.dart';
import 'credit_card_background.dart';
import 'credit_card_brand.dart';

const Map<CardType, String> cardTypeIconAsset = <CardType, String>{
  CardType.visa: 'assets/visa.png',
  CardType.americanExpress: 'assets/amex.png',
  CardType.mastercard: 'assets/mastercard.png',
  CardType.discover: 'assets/discover.png',
};

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.animationDuration = const Duration(milliseconds: 500),
    this.height,
    this.width,
    this.textStyle,
    this.cardBgColor = const Color(0xff1b447b),
    this.obscureCardNumber = true,
    this.labelCardHolder = 'Nome',
    this.labelExpiredDate = 'MM/AA',
    this.cardType,
    this.backgroundImage,
    this.isChipVisible = true,
    this.isSwipeGestureEnabled = true,
    required this.onCreditCardWidgetChange,
    this.textStyleCvv,
  });

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final TextStyle? textStyle;
  final TextStyle? textStyleCvv;
  final Color cardBgColor;
  final bool showBackView;
  final Duration animationDuration;
  final double? height;
  final double? width;
  final bool obscureCardNumber;
  final void Function(CreditCardBrand) onCreditCardWidgetChange;
  final String? backgroundImage;
  final bool isChipVisible;
  final bool isSwipeGestureEnabled;

  final String labelCardHolder;
  final String labelExpiredDate;

  final CardType? cardType;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  late Gradient backgroundGradientColor;
  late bool isFrontVisible = true;
  late bool isGestureUpdate = false;

  bool isAmex = false;

  @override
  void initState() {
    super.initState();

    ///initialize the animation controller
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _gradientSetup();
    _updateRotations(false);
  }

  void _gradientSetup() {
    backgroundGradientColor = LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: const <double>[0.1, 0.4, 0.7, 0.9],
      colors: <Color>[
        widget.cardBgColor.withValues(alpha: 1),
        widget.cardBgColor.withValues(alpha: 0.97),
        widget.cardBgColor.withValues(alpha: 0.90),
        widget.cardBgColor.withValues(alpha: 0.86),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// Se o UER adiciona CVV, em seguida, alternar o cartão da frente para trás ..
    /// Controller Forward inicia animação e mostra layout de volta.
    /// O controlador reverso inicia a animação e mostra layout frontal.
    ///
    if (!isGestureUpdate) {
      _updateRotations(false);
      if (widget.showBackView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    } else {
      isGestureUpdate = false;
    }

    final CardType cardType =
        widget.cardType ?? detectCCType(widget.cardNumber);
    widget.onCreditCardWidgetChange(CreditCardBrand(cardType));

    return Stack(
      children: <Widget>[
        _cardGesture(
          child: AnimationCard(
            animation: _frontRotation,
            child: _buildFrontContainer(),
          ),
        ),
        _cardGesture(
          child: AnimationCard(
            animation: _backRotation,
            child: _buildBackContainer(),
          ),
        ),
      ],
    );
  }

  void _leftRotation() {
    _toggleSide(false);
  }

  void _rightRotation() {
    _toggleSide(true);
  }

  void _toggleSide(bool isRightTap) {
    _updateRotations(!isRightTap);
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }

  void _updateRotations(bool isRightSwipe) {
    setState(() {
      final bool rotateToLeft =
          (isFrontVisible && !isRightSwipe) || !isFrontVisible && isRightSwipe;

      ///Initialize the Front to back rotation tween sequence.
      _frontRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 0.0,
              end: rotateToLeft ? (pi / 2) : (-pi / 2),
            ).chain(CurveTween(curve: Curves.linear)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(rotateToLeft ? (-pi / 2) : (pi / 2)),
            weight: 50.0,
          ),
        ],
      ).animate(controller);

      ///Initialize the Back to Front rotation tween sequence.
      _backRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(rotateToLeft ? (pi / 2) : (-pi / 2)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: rotateToLeft ? (-pi / 2) : (pi / 2),
              end: 0.0,
            ).chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 50.0,
          ),
        ],
      ).animate(controller);
    });
  }

  Widget _buildFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.titleLarge!.merge(
              const TextStyle(
                color: Colors.white,
                package: 'mega_commons',
                fontSize: 16,
              ),
            );

    final String number = widget.cardNumber;
    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      height: widget.height,
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: widget.isChipVisible ? 2 : 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (widget.isChipVisible)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/chip.png',
                          package: 'mega_commons',
                          scale: 1,
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          'assets/nfc.png',
                          package: 'mega_commons',
                          height: 22,
                          color: Colors.white,
                          scale: 1,
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: widget.cardType != null
                        ? getCardTypeImage(widget.cardType)
                        : getCardTypeIcon(widget.cardNumber),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.cardNumber.isEmpty ? 'XXXX XXXX XXXX XXXX' : number,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Validade',
                    style: widget.textStyle ??
                        defaultTextStyle.copyWith(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.expiryDate.isEmpty
                        ? widget.labelExpiredDate
                        : widget.expiryDate,
                    style: widget.textStyle ?? defaultTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                widget.cardHolderName.isEmpty
                    ? widget.labelCardHolder
                    : widget.cardHolderName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.titleLarge!.merge(
              const TextStyle(
                color: Colors.black,
                fontSize: 16,
                package: 'mega_commons',
              ),
            );

    final String cvv = widget.cvvCode;

    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      height: widget.height,
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              height: 48,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Container(
                      height: 48,
                      color: Colors.white70,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.cvvCode.isEmpty
                              ? isAmex
                                  ? 'XXXX'
                                  : 'XXX'
                              : cvv,
                          maxLines: 1,
                          style: widget.textStyleCvv ?? defaultTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: widget.cardType != null
                    ? getCardTypeImage(widget.cardType)
                    : getCardTypeIcon(widget.cardNumber),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardGesture({required Widget child}) {
    bool isRightSwipe = true;
    return widget.isSwipeGestureEnabled
        ? GestureDetector(
            onPanEnd: (_) {
              isGestureUpdate = true;
              if (isRightSwipe) {
                _leftRotation();
              } else {
                _rightRotation();
              }
            },
            onPanUpdate: (DragUpdateDetails details) {
              // Swiping in right direction.
              if (details.delta.dx > 0) {
                isRightSwipe = true;
              }

              // Swiping in left direction.
              if (details.delta.dx < 0) {
                isRightSwipe = false;
              }
            },
            child: child,
          )
        : child;
  }

  /// Padrões de prefixo de cartão de crédito em março de 2019
  /// A [lista <string>] representa um intervalo.
  /// i.e. ['51', '55'] representa a gama de cartões começando com '51' para aqueles que começam com '55'
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65'],
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  /// Esta função determina o tipo de cartão de crédito com base nos CardPatterns
  /// e retorna.
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (final List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  Widget getCardTypeImage(CardType? cardType) => Image.asset(
        cardTypeIconAsset[cardType]!,
        height: 48,
        width: 48,
        package: 'mega_commons',
      );

  // This method returns the icon for the visa card type if found
  // else will return the empty container
  Widget getCardTypeIcon(String cardNumber) {
    Widget icon;
    switch (detectCCType(cardNumber)) {
      case CardType.visa:
        icon = Image.asset(
          'assets/visa.png',
          height: 48,
          width: 48,
          package: 'mega_commons',
        );
        isAmex = false;
        break;

      case CardType.americanExpress:
        icon = Image.asset(
          'assets/amex.png',
          height: 48,
          width: 48,
          package: 'mega_commons',
        );
        isAmex = true;
        break;

      case CardType.mastercard:
        icon = Image.asset(
          'assets/mastercard.png',
          height: 48,
          width: 48,
          package: 'mega_commons',
        );
        isAmex = false;
        break;

      case CardType.discover:
        icon = Image.asset(
          'assets/discover.png',
          height: 48,
          width: 48,
          package: 'mega_commons',
        );
        isAmex = false;
        break;

      default:
        icon = const SizedBox(
          height: 48,
          width: 48,
        );
        isAmex = false;
        break;
    }

    return icon;
  }
}

class MaskedTextController extends TextEditingController {
  MaskedTextController({
    super.text,
    required this.mask,
    Map<String, RegExp>? translator,
  }) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (beforeChange(previous, text)) {
        updateText(text);
        afterChange(previous, text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(text);
  }

  String mask;

  late Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text.isNotEmpty) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp('[A-Za-z]'),
      '0': RegExp('[0-9]'),
      '@': RegExp('[A-Za-z0-9]'),
      '*': RegExp('.*'),
    };
  }

  String _applyMask(String? mask, String value) {
    final StringBuffer result = StringBuffer();

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask!.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result.write(maskChar);
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
          result.write(valueChar);
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      result.write(maskChar);
      maskCharIndex += 1;
      continue;
    }

    return result.toString();
  }
}

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}

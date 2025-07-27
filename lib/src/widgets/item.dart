import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;
  final Widget? trailingWidget;
  final String locale;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
    this.trailingWidget,
    this.locale = 'en',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = country?.dialCode ?? '';
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showFlag ?? true) ...[
            SizedBox(width: leadingPadding),
            _Flag(
              country: country,
              showFlag: showFlag,
              useEmoji: useEmoji,
            ),
          ],
          const SizedBox(width: 12.0),
          Text(
            dialCode,
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),
          if (trailingWidget != null) ...[
            trailingWidget!,
          ],
          if (withCountryNames &&
              (country!.nameTranslations?[locale] != null ||
                  country?.name != null)) ...[
            const SizedBox(width: 12.0),
            Text(
              country!.nameTranslations?[locale] ?? country?.name ?? '',
              textDirection: TextDirection.ltr,
              style: textStyle,
            ),
          ]
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag({this.country, this.showFlag, this.useEmoji});
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      country!.flagUri,
                      width: 32.0,
                      fit: BoxFit.cover,
                      package: 'intl_phone_number_input',
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
          )
        : const SizedBox.shrink();
  }
}

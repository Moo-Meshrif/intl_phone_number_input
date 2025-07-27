import 'dart:ui';

import 'package:flutter/cupertino.dart';

Future<T?> showCustomCupertinoModalPopup<T>(
  BuildContext context, {
  required List<T> items,
  required Widget Function(T item) itemChildBuilder,
  T? currentItem,
  T? allOptionItem,
  String doneText = 'Done',
  String cancelText = 'Cancel',
}) {
  return showCupertinoModalPopup<T?>(
    context: context,
    builder: (context) => _CupertinoModalPopupWidget(
      items: items,
      currentItem: currentItem,
      itemChildBuilder: itemChildBuilder,
      allOptionItem: allOptionItem,
      cancelText: cancelText,
      doneText: doneText,
    ),
  );
}

class _CupertinoModalPopupWidget<T> extends StatefulWidget {
  const _CupertinoModalPopupWidget({
    super.key,
    required List<T> items,
    required Widget Function(T item) itemChildBuilder,
    T? currentItem,
    T? allOptionItem,
    this.doneText = 'done',
    this.cancelText = 'cancel',
    this.doneTextStyle,
    this.cancelTextStyle,
    this.backgroundColor,
  })  : _items = items,
        _itemChildBuilder = itemChildBuilder,
        _currentItem = currentItem,
        _allOptionItem = allOptionItem;

  final List<T> _items;
  final T? _currentItem;
  final T? _allOptionItem;
  final Widget Function(T item) _itemChildBuilder;
  final String doneText, cancelText;
  final TextStyle? doneTextStyle, cancelTextStyle;
  final Color? backgroundColor;

  @override
  State<_CupertinoModalPopupWidget<T>> createState() =>
      _CupertinoModalPopupWidgetState<T>();
}

class _CupertinoModalPopupWidgetState<T>
    extends State<_CupertinoModalPopupWidget<T>> {
  T? _currentItem;
  @override
  void initState() {
    _currentItem = widget._currentItem ??
        (widget._allOptionItem != null ? null : widget._items.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    var items = [
      if (widget._allOptionItem != null) widget._allOptionItem,
      ...widget._items
    ];
    return SizedBox(
      height: 250,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Color(0xCCFFFFFF)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              DecoratedBox(
                decoration:
                     BoxDecoration(color: widget.backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        widget.cancelText,
                        style: widget.cancelTextStyle,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: Text(
                        widget.doneText,
                        style: widget.doneTextStyle,
                      ),
                      onPressed: () => Navigator.of(context).pop(_currentItem),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                      initialItem: _currentItem == null
                          ? 0
                          : items.indexOf(_currentItem as T)),
                  onSelectedItemChanged: (index) {
                    if (index == 0 && widget._allOptionItem != null)
                      setState(() => _currentItem = null);
                    else
                      setState(() => _currentItem = items[index]);
                  },
                  children: items.where((element) => element != null).map((item) {
                    return widget._itemChildBuilder(item!);
                  }).toList(),
                ),
              ),
              SizedBox(height: bottomPadding)
            ],
          ),
        ),
      ),
    );
  }
}

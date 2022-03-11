import 'package:flutter/material.dart';

class AdaptativeGrid extends StatelessWidget {
  final List<Widget>? children;
  final EdgeInsetsGeometry? margin;
  final Color? backgroudColor;

  /// Use this to return a scrollable widget ([ListView]).
  final ScrollController? scrollController;

  /// Limit of cross axes.
  final int? maxNumberOfCrossAxis;

  /// The thickness of all the cross axes.
  final double? crossAxisThickness;

  /// Main axis separator between children.
  final double mainAxisSpacing;

  /// Cross axis separator between children.
  final double crossAxisSpacing;

  /// Enforce the cross axis length.
  final int? crossAxisLength;

  /// It will be used to show a children quantity according to the available size.
  /// 
  /// When [mainAxisDirection] is [Axis.vertical], the size will be compared with the max width.
  /// If it is [Axis.horizontal], the size will be compared with the max height.
  /// 
  /// When the item [double] is compared with the size, it will represents the children quantity per cross axis.
  /// 
  /// Comparing if the available size is less than each item:
  /// 1. size < childrenPerCrossAxisAccordingToSize[0] => 1 child per cross axis
  /// 2. size < childrenPerCrossAxisAccordingToSize[1] => 2 children per cross axis
  /// 3. size < childrenPerCrossAxisAccordingToSize[2] => 3 children per cross axis
  /// 4. size >= the last [double] => children per cross axis will be [childrenPerCrossAxisAccordingToSize.length] + 1
  final List<double> childrenPerCrossAxisAccordingToSize;

  /// Expands the in main axis children acording to its flex.
  ///
  /// Ex: [1, 2] =>
  /// 1. main axis: flex = 1
  /// 2. main axis: flex = 2
  /// 3. main axis: flex = 1 (null)
  final List<int?>? flexMainAxis;

  /// The thickness of each main axis.
  ///
  /// Ex: [100, 200] =>
  /// 1. main axis: thickness = 100
  /// 2. main axis: thickness = 200
  /// 3. main axis: thickness = the thickness to fill the cross axis (null)
  ///
  /// It can be used with [expandLastMainAxis] to a better layout.
  ///
  /// Be careful with [thicknessOfEachMainAxis] and [childrenPerCrossAxisAccordingToSize] values.
  /// If the thickness sum is bigger than the case ([childrenPerCrossAxisAccordingToSize]), it will get an overflow.
  final List<double?>? thicknessOfEachMainAxis;

  /// The thickness of each cross axis.
  ///
  /// Ex: [100, 50] =>
  /// 1. cross axis: thickness = 100
  /// 2. cross axis: thickness = 50
  /// 3. cross axis: thickness = its children size (null)
  final List<double?>? thicknessOfEachCrossAxis;

  /// It can be used to costumize the layout of each case in [childrenPerCrossAxisAccordingToSize].
  ///
  /// The lists will be read according to the [childrenPerCrossAxisAccordingToSize] case, where the first case
  /// (available size less the first number of [childrenPerCrossAxisAccordingToSize]) will read the first list and so on.
  ///
  /// The numbers will be used to compose the number of children in each cross axis. The first number of the
  /// first list (1) indicates to the first cross axis to use only 1 child.
  ///
  /// Ex: [[1, 2], [2, 1]] =>
  /// 1. first case [1, 2]: 1° cross axis with 1 child; 2° cross axis with 2 children; the others will not be specified
  /// 2. second case [2, 1]: 1° cross axis with 2 children; 2° cross axis with 1 child; the others will not be specified
  /// 3. the other cases will not be specified
  ///
  /// The lists inside the [gridLayout] can be null to skip some case (ex: [null, [1, 2]]).
  final List<List<int?>?>? gridLayout;

  /// Expands the last cross axis children to fill it.
  final bool fillLastCrossAxis;

  /// While using [thicknessOfEachMainAxis], there may be a case where the last main axis is setted to a specifc size.
  /// In this case, the children in the last main axis will not expand to fill the cross axis properly.
  /// In this specifc case, when [expandLastMainAxis] is true, the children in the last main axis will be forced
  /// to fill the cross axis properly.
  final bool expandLastMainAxis;

  /// Children builder.
  final Widget Function(BuildContext context, int index)? itemBuilder;

  /// Children builder length.
  final int? itemCount;

  /// The maximum length of children shown.
  final int? maxLength;

  /// The axis along which the grid grows.
  final Axis mainAxisDirection;

  /// If true, the children will begin from right to left of the cross axis.
  /// 
  /// Ex:
  /// 2. true (from right to left): ... [3] [2] [1]
  /// 1. false (from left to right): [1] [2] [3] ...
  final bool reversedCrossAxisChildren;

  /// A grid that adapts itself according to the available size.
  const AdaptativeGrid({
    Key? key,
    required this.children,
    required this.childrenPerCrossAxisAccordingToSize,
    this.mainAxisDirection = Axis.vertical,
    this.scrollController,
    this.margin,
    this.crossAxisThickness,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.crossAxisLength,
    this.maxNumberOfCrossAxis,
    this.flexMainAxis,
    this.thicknessOfEachMainAxis,
    this.thicknessOfEachCrossAxis,
    this.gridLayout,
    this.fillLastCrossAxis = false,
    this.expandLastMainAxis = true,
    this.reversedCrossAxisChildren = false,
    this.backgroudColor,
  })  : maxLength = null,
        itemBuilder = null,
        itemCount = null,
        super(key: key);

  const AdaptativeGrid.builder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.childrenPerCrossAxisAccordingToSize,
    this.mainAxisDirection = Axis.vertical,
    this.scrollController,
    this.margin,
    this.backgroudColor,
    this.crossAxisThickness,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.crossAxisLength,
    this.maxNumberOfCrossAxis,
    this.flexMainAxis,
    this.thicknessOfEachMainAxis,
    this.thicknessOfEachCrossAxis,
    this.gridLayout,
    this.fillLastCrossAxis = false,
    this.expandLastMainAxis = true,
    this.reversedCrossAxisChildren = false,
    this.maxLength,
  })  : children = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return scrollController == null
          ? _container(context, constraints)
          : _scrollWidget(context, constraints);
    });
  }

  Widget _scrollWidget(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return ListView(
      controller: scrollController,
      scrollDirection: mainAxisDirection,
      children: [
        _container(context, constraints),
      ],
    );
  }

  Widget _container(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Container(
      color: backgroudColor,
      alignment: Alignment.topLeft,
      padding: margin,
      child: _gridView(context, constraints),
    );
  }

  Widget _gridView(BuildContext context, BoxConstraints constraints) {
    return isVertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: _mainAxisWidgets(context, constraints),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: _mainAxisWidgets(context, constraints),
          );
  }

  Widget _getChild(BuildContext context, int index) {
    if (children != null) return children![index];
    return itemBuilder!(context, index);
  }

  int get _childrenLength {
    if (children != null) return children!.length;
    return maxLength == null || itemCount! < maxLength!
        ? itemCount!
        : maxLength!;
  }

  List<Widget> _mainAxisWidgets(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    double _totalCrossAxisSize =
        isVertical ? constraints.maxWidth : constraints.maxHeight;
    int _case = 0;

    int i = 0;
    for (; i < childrenPerCrossAxisAccordingToSize.length; i++) {
      if (_totalCrossAxisSize <= childrenPerCrossAxisAccordingToSize[i]) {
        break;
      }
    }
    _case = i;

    List<int?>? _alignment;
    if (gridLayout != null && gridLayout!.length > _case) {
      _alignment = gridLayout![_case];
    }

    List<Widget> _crossAxisWidgets(int index, int crossAxisIndex) {
      int? _crossAxisLength;
      if (_alignment != null && _alignment.length > crossAxisIndex) {
        _crossAxisLength = _alignment[crossAxisIndex];
      }

      _crossAxisLength ??= crossAxisLength ?? _case + 1;
      if (fillLastCrossAxis && _crossAxisLength > _childrenLength - index) {
        _crossAxisLength = _childrenLength - index;
      }

      double? _crossAxisThickness;
      if (thicknessOfEachCrossAxis != null &&
          thicknessOfEachCrossAxis!.length > crossAxisIndex) {
        _crossAxisThickness = thicknessOfEachCrossAxis![crossAxisIndex];
      }
      _crossAxisThickness ??= crossAxisThickness;

      bool _hasFlex = false;
      if (_crossAxisLength > 1) {
        for (int i = 0; i < _crossAxisLength; i++) {
          int childIndex = index + i;
          if (_childrenLength > childIndex) {
            if (thicknessOfEachMainAxis == null ||
                thicknessOfEachMainAxis!.length <= i ||
                thicknessOfEachMainAxis![i] == null) {
              _hasFlex = true;
            }
          }
        }
      }

      List<Widget> _widgetsInCrossAxis = [];
      int mainAxisIndex = 0;
      for (int i = index; mainAxisIndex < _crossAxisLength; i++) {
        if (fillLastCrossAxis && i >= _childrenLength) break;

        Widget? child;
        if (i >= _childrenLength) {
          child = null;
        } else {
          child = _getChild(context, i);
        }

        if (_widgetsInCrossAxis.isNotEmpty) {
          _widgetsInCrossAxis.add(
            SizedBox(
              width: isVertical ? crossAxisSpacing : null,
              height: isVertical ? null : crossAxisSpacing,
            ),
          );
        }

        double? _mainAxisThickness;
        if (_hasFlex ||
            (!_hasFlex && mainAxisIndex + 1 < _crossAxisLength) ||
            (!expandLastMainAxis && mainAxisIndex + 1 == _crossAxisLength)) {
          if (thicknessOfEachMainAxis != null &&
              thicknessOfEachMainAxis!.length > mainAxisIndex &&
              thicknessOfEachMainAxis![mainAxisIndex] != null) {
            _mainAxisThickness = thicknessOfEachMainAxis![mainAxisIndex];
          }
        }

        int? _flex;
        if (_mainAxisThickness == null) {
          if (flexMainAxis != null && flexMainAxis!.length > mainAxisIndex) {
            _flex = flexMainAxis![mainAxisIndex];
          }
          _flex ??= 1;
        }

        if (_flex != null) {
          child = Expanded(
            flex: _flex,
            child: SizedBox(
              height: isVertical ? _crossAxisThickness : null,
              width: isVertical ? null : _crossAxisThickness,
              child: child,
            ),
          );
        } else {
          child = SizedBox(
            width: isVertical ? _mainAxisThickness : _crossAxisThickness,
            height: isVertical ? _crossAxisThickness : _mainAxisThickness,
            child: child,
          );
        }

        _widgetsInCrossAxis.add(child);
        mainAxisIndex++;
      }

      return _widgetsInCrossAxis;
    }

    List<Widget> _mainAxisChildren = [];

    int _crossAxisIndex = 0;
    for (int i = 0;
        i < _childrenLength &&
            (maxNumberOfCrossAxis == null ||
                _crossAxisIndex < maxNumberOfCrossAxis!);) {
      if (_mainAxisChildren.isNotEmpty) {
        _mainAxisChildren.add(
          SizedBox(
            height: isVertical ? mainAxisSpacing : null,
            width: isVertical ? null : mainAxisSpacing,
          ),
        );
      }

      List<Widget> _crossAxisChildren = _crossAxisWidgets(i, _crossAxisIndex);
      if (reversedCrossAxisChildren) {
        _crossAxisChildren = _crossAxisChildren.reversed.toList();
      }

      _mainAxisChildren.add(
        isVertical
            ? Row(children: _crossAxisChildren)
            : Column(children: _crossAxisChildren),
      );

      i += (_crossAxisChildren.length / 2).ceil();
      _crossAxisIndex++;
    }

    return _mainAxisChildren;
  }

  bool get isVertical => mainAxisDirection == Axis.vertical;
}

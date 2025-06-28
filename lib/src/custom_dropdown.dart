import 'package:flutter/material.dart';
import 'common_listview_widget.dart';

class DropDownDataModel {
  final String? id;
  final String? title;

  DropDownDataModel({this.id, this.title});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DropDownDataModel && runtimeType == other.runtimeType && id == other.id && title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

class CustomDropdown extends StatefulWidget {
  final List<DropDownDataModel> items;
  final DropDownDataModel? selectedItem;
  final ValueChanged<DropDownDataModel> onChanged;
  final String hintText;
  final bool isSearch;
  final Color? borderColor;
  final double? textSize;
  final double? selectedFontSize;
  final Color? dropdownIconColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? buttonBackgroundColor;
  final Color? searchTextColor;
  final Color? searchBackgroundColor;
  final Color? searchIconColor;
  final Color? dropdownTextColor;
  final Color? dropdownBackgroundColor;
  final Color? selectedDataColor;
  final Color? selectedDataBgColor;
  final double? radius;
  final double? menuRadius;
  final double? searchTextFieldRadius;
  final EdgeInsetsGeometry? searchTextFieldPadding;
  final EdgeInsetsGeometry? buttonPadding;
  final EdgeInsetsGeometry? menuPadding;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final double? dropdownIconSize;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.hintText = "Select an option",
    this.isSearch = false,
    this.borderColor,
    this.textSize,
    this.selectedFontSize,
    this.dropdownIconColor,
    this.textColor,
    this.hintTextColor,
    this.buttonBackgroundColor,
    this.searchTextColor,
    this.searchBackgroundColor,
    this.searchIconColor,
    this.dropdownTextColor,
    this.dropdownBackgroundColor,
    this.selectedDataColor,
    this.selectedDataBgColor,
    this.radius,
    this.menuRadius,
    this.buttonPadding,
    this.menuPadding,
    this.searchTextFieldRadius,
    this.searchTextFieldPadding,
    this.separatorBuilder,
    this.dropdownIconSize,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with WidgetsBindingObserver {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  DropDownDataModel? selectedValue;
  List<DropDownDataModel> filteredItems = [];
  final TextEditingController searchController = TextEditingController();
  bool _showAbove = false;
  bool _showAboveLocal = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedItem != null) {
      try {
        selectedValue = widget.items.firstWhere((element) => element.title == widget.selectedItem!.title && element.id == widget.selectedItem!.id);
      } catch (e) {
        print(e);
      }
    }
    filteredItems = widget.items;
    searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_isDropdownOpen) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);

      const dropdownHeight = 250.0;
      final dropdownBottom = position.dy + size.height + 5 + dropdownHeight;
      final visibleHeight = MediaQuery.of(context).size.height - keyboardHeight;

      final cutOffHeight = dropdownBottom - visibleHeight;
      final percentCut = cutOffHeight / dropdownHeight;

      final shouldShowAbove = percentCut > 0.3;

      if (shouldShowAbove != _showAbove) {
        setState(() {
          _showAbove = shouldShowAbove;
        });
        _overlayEntry?.markNeedsBuild();
      }
    }
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      setState(() {
        try {
          selectedValue = widget.items.firstWhere((element) => element.title == widget.selectedItem!.title && element.id == widget.selectedItem!.id);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items.where((item) => (item.title ?? "").toLowerCase().contains(query)).toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
    searchController.clear();
    setState(() {});
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    const dropdownHeight = 250.0; // same as BoxConstraints in overlay
    final spaceBelow = screenHeight - position.dy - size.height;
    final spaceAbove = position.dy;

    _showAboveLocal = spaceBelow < dropdownHeight && spaceAbove > dropdownHeight;
    _showAbove = spaceBelow < dropdownHeight && spaceAbove > dropdownHeight;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
    setState(() {});
  }

  void _selectItem(DropDownDataModel value) {
    widget.onChanged(value);
    setState(() {
      selectedValue = value;
    });
    _removeOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    const dropdownHeight = 250.0;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeOverlay,
            child: Container(color: Colors.transparent, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: _showAboveLocal
                  ? Offset(
                      0,
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? -dropdownHeight - 5
                          : -MediaQuery.of(context).viewInsets.bottom - (size.height + 5),
                    )
                  : _showAbove
                  ? Offset(0, -dropdownHeight - 5)
                  : Offset(0.0, size.height + 5),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(widget.menuRadius ?? 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: widget.dropdownBackgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: widget.borderColor == null ? null : Border.all(color: widget.borderColor!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isSearch)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: widget.searchTextColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: widget.searchBackgroundColor ?? Colors.white,
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: widget.searchTextColor?.withValues(alpha: 0.6)),
                              prefixIcon: Icon(Icons.search, color: widget.searchIconColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget.searchTextFieldRadius ?? 8),
                                borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget.searchTextFieldRadius ?? 8),
                                borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
                              ),
                              contentPadding: widget.searchTextFieldPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                      if (filteredItems.isEmpty)
                        const Padding(padding: EdgeInsets.all(8), child: Text('No items found'))
                      else
                        Flexible(
                          child: CommonListViewWidget(
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder: widget.separatorBuilder,
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _selectItem(item),
                                child: Container(
                                  padding: widget.menuPadding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: selectedValue == item
                                      ? widget.selectedDataBgColor ?? widget.dropdownBackgroundColor
                                      : widget.dropdownBackgroundColor,
                                  child: Text(
                                    item.title ?? '',
                                    style: TextStyle(
                                      fontSize: widget.selectedFontSize ?? 16,
                                      color: selectedValue == item ? widget.selectedDataColor ?? widget.dropdownTextColor : widget.dropdownTextColor,
                                      fontWeight: selectedValue == item ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: widget.buttonPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.buttonBackgroundColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
            border: widget.borderColor == null ? null : Border.all(color: widget.borderColor!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedValue?.title ?? widget.hintText,
                  maxLines: selectedValue?.title == null ? 1 : null,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: widget.textSize ?? 16,
                    color: selectedValue == null ? widget.hintTextColor ?? Colors.grey : widget.textColor ?? Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  selectedValue?.title != null
                      ? GestureDetector(
                          onTap: () {
                            selectedValue = DropDownDataModel();
                            widget.onChanged(DropDownDataModel());
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.close, size: widget.dropdownIconSize, color: widget.dropdownIconColor),
                          ),
                        )
                      : SizedBox.shrink(),
                  Icon(
                    _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: widget.dropdownIconColor,
                    size: widget.dropdownIconSize,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

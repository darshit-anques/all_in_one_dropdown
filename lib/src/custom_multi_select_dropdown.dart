import 'package:flutter/material.dart';
import 'common_listview_widget.dart';
import 'custom_dropdown.dart';

class CustomDropdownMultiSelect extends StatefulWidget {
  final List<DropDownDataModel> items;
  final List<DropDownDataModel> selectedItems;
  final ValueChanged<List<DropDownDataModel>> onChanged;
  final String hintText;
  final bool isSearch;
  final Color? borderColor;
  final double? textSize;
  final Color? dropdownIconColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? buttonBackgroundColor;
  final Color? dropdownTextColor;
  final Color? dropdownBackgroundColor;
  final Color? selectedDataColor;
  final Color? selectedDataBgColor;
  final double? radius;
  final double? menuRadius;
  final EdgeInsetsGeometry? buttonPadding;
  final EdgeInsetsGeometry? menuPadding;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Color? searchTextColor;
  final Color? searchBackgroundColor;
  final Color? searchIconColor;
  final EdgeInsetsGeometry? searchTextFieldPadding;
  final double? searchTextFieldRadius;
  final double? selectedFontSize;
  final Color? checkBoxColor;
  final Color? checkColor;
  final double? dropdownIconSize;
  final double? chipCancelIconSize;
  final double? scale;

  const CustomDropdownMultiSelect({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.hintText = "Select options",
    this.isSearch = false,
    this.borderColor,
    this.textSize,
    this.dropdownIconColor,
    this.textColor,
    this.hintTextColor,
    this.buttonBackgroundColor,
    this.dropdownTextColor,
    this.dropdownBackgroundColor,
    this.selectedDataColor,
    this.selectedDataBgColor,
    this.radius,
    this.menuRadius,
    this.buttonPadding,
    this.menuPadding,
    this.separatorBuilder,
    this.searchTextColor,
    this.searchBackgroundColor,
    this.searchIconColor,
    this.searchTextFieldPadding,
    this.searchTextFieldRadius,
    this.selectedFontSize,
    this.checkBoxColor,
    this.checkColor,
    this.dropdownIconSize,
    this.chipCancelIconSize,
    this.scale,
  });

  @override
  State<CustomDropdownMultiSelect> createState() => _CustomDropdownMultiSelectState();
}

class _CustomDropdownMultiSelectState extends State<CustomDropdownMultiSelect> with WidgetsBindingObserver {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  List<DropDownDataModel> _selectedValues = [];
  List<DropDownDataModel> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  bool _showAbove = false;
  bool _showAboveLocal = false;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedItems);
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
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
  void didUpdateWidget(covariant CustomDropdownMultiSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      setState(() {
        _selectedValues = widget.selectedItems;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) => (item.title ?? "").toLowerCase().contains(query)).toList();
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
    _searchController.clear();
    setState(() {});
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    const dropdownHeight = 250.0;
    final spaceBelow = screenHeight - position.dy - size.height;
    final spaceAbove = position.dy;

    _showAboveLocal = spaceBelow < dropdownHeight && spaceAbove > dropdownHeight;
    _showAbove = spaceBelow < dropdownHeight && spaceAbove > dropdownHeight;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
    setState(() {});
  }

  void _toggleSelectItem(DropDownDataModel item) {
    setState(() {
      if (_selectedValues.contains(item)) {
        _selectedValues.remove(item);
      } else {
        _selectedValues.add(item);
      }
      widget.onChanged(_selectedValues.toList());
    });
    _overlayEntry?.markNeedsBuild();
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
            child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
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
                            controller: _searchController,
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
                      if (_filteredItems.isEmpty)
                        const Text("No items found")
                      else
                        Flexible(
                          child: CommonListViewWidget(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: _filteredItems.length,
                            separatorBuilder: widget.separatorBuilder,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              final isSelected = _selectedValues.contains(item);
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _toggleSelectItem(item),
                                child: Container(
                                  padding: widget.menuPadding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: isSelected ? widget.selectedDataBgColor ?? widget.dropdownBackgroundColor : widget.dropdownBackgroundColor,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title ?? '',
                                          style: TextStyle(
                                            fontSize: widget.selectedFontSize ?? 16,
                                            color: isSelected ? widget.selectedDataColor ?? widget.dropdownTextColor : widget.dropdownTextColor,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      CommonCheckBox.checkBox(
                                        isChecked: isSelected,
                                        onChanged: (value) => _toggleSelectItem(item),
                                        activeColor: widget.checkBoxColor,
                                        checkColor: widget.checkColor,
                                        scale: widget.scale,
                                      ),
                                    ],
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
    final selectedText = List.from(_selectedValues).map((e) => e.title).join(', ');

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
              _selectedValues.isEmpty
                  ? Flexible(
                child: Text(
                  _selectedValues.isEmpty ? widget.hintText : selectedText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: widget.textSize ?? 16,
                    color: _selectedValues.isEmpty ? widget.hintTextColor ?? Colors.grey : widget.textColor ?? Colors.black,
                  ),
                ),
              )
                  : Flexible(
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: _selectedValues.map((element) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: widget.checkBoxColor, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              element.title ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: widget.textSize ?? 16, color: widget.checkColor ?? Colors.white),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedValues.removeWhere((data) => data.title == element.title && data.id == element.id);
                                widget.onChanged(_selectedValues.toList());
                              });
                            },
                            child: Icon(Icons.close, color: widget.checkColor, size: widget.chipCancelIconSize),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Icon(
                _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: widget.dropdownIconColor,
                size: widget.dropdownIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonCheckBox {
  static Widget checkBox({
    bool isChecked = false,
    required Function(bool?) onChanged,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
    Color? activeColor = Colors.blue,
    Color? checkColor = Colors.white,
    double borderRadius = 4,
    double? scale,
  }) {
    return Transform.scale(
      scale: scale,
      child: Checkbox(
        value: isChecked,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: checkColor,
        side: BorderSide(color: borderColor, width: borderWidth),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

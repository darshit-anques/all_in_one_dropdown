import 'package:flutter/material.dart';
import 'common_listview_widget.dart';
import 'custom_dropdown.dart';

/// A customizable multi-select dropdown widget with optional search functionality.
///
/// Use this widget to allow users to select multiple items from a dropdown
/// with optional search input and visual chips for selected values.
class CustomDropdownMultiSelect extends StatefulWidget {
  /// The list of all available items.
  final List<DropDownDataModel> items;

  /// The list of currently selected items.
  final List<DropDownDataModel> selectedItems;

  /// Callback when selected items change.
  final ValueChanged<List<DropDownDataModel>> onChanged;

  /// Hint text shown when nothing is selected.
  final String hintText;

  /// Whether to show the search box.
  final bool isSearch;

  /// Border color for the dropdown button.
  final Color? borderColor;

  /// Font size for dropdown text.
  final double? textSize;

  /// Color of the dropdown arrow icon.
  final Color? dropdownIconColor;

  /// Text color of selected items.
  final Color? textColor;

  /// Color of the hint text.
  final Color? hintTextColor;

  /// Background color of the dropdown button.
  final Color? buttonBackgroundColor;

  /// Text color inside dropdown menu.
  final Color? dropdownTextColor;

  /// Background color of the dropdown menu.
  final Color? dropdownBackgroundColor;

  /// Text color of selected options inside dropdown.
  final Color? selectedDataColor;

  /// Background color of selected options inside dropdown.
  final Color? selectedDataBgColor;

  /// Border radius of the dropdown button.
  final double? radius;

  /// Border radius of the dropdown menu.
  final double? menuRadius;

  /// Padding inside the dropdown button.
  final EdgeInsetsGeometry? buttonPadding;

  /// Padding inside the dropdown menu.
  final EdgeInsetsGeometry? menuPadding;

  /// Custom separator builder between dropdown list items.
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// Color of the text inside the search field.
  final Color? searchTextColor;

  /// Background color of the search field.
  final Color? searchBackgroundColor;

  /// Color of the search icon.
  final Color? searchIconColor;

  /// Padding inside the search field.
  final EdgeInsetsGeometry? searchTextFieldPadding;

  /// Border radius of the search field.
  final double? searchTextFieldRadius;

  /// Font size for selected chips.
  final double? selectedFontSize;

  /// Checkbox fill color.
  final Color? checkBoxColor;

  /// Checkbox tick color.
  final Color? checkColor;

  /// Size of the dropdown icon.
  final double? dropdownIconSize;

  /// Size of the close icon in chips.
  final double? chipCancelIconSize;

  /// Scale for checkbox size.
  final double? scale;

  /// Creates a [CustomDropdownMultiSelect] widget.
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

/// A helper class that provides a reusable checkbox widget with styling options.
class CommonCheckBox {
  /// Returns a styled checkbox widget.
  ///
  /// Use this in dropdown lists for multi-selection UI.
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


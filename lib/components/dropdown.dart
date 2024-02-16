import 'package:flutter/material.dart';

class DropdownButtonWidget<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<T> onItemSelected;
  final String hintText;
  final String inputError;

  const DropdownButtonWidget({
    super.key,
    required this.items,
    required this.onItemSelected,
    required this.hintText,
    required this.inputError,
  });

  @override
  _DropdownButtonWidgetState<T> createState() =>
      _DropdownButtonWidgetState<T>();
}

class _DropdownButtonWidgetState<T> extends State<DropdownButtonWidget<T>> {
  T? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<T>(
        value: _selectedItem,
        items: widget.items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
          });
          widget.onItemSelected(value!);
        },
        validator: (value) {
          if (value == null) {
            return widget.inputError;
          }
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 56, 52, 52)),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

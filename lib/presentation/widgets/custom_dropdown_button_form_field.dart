import 'package:flutter/material.dart';
import 'loading_widget.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final T? value;
  final InputDecoration decoration;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool isLoading;
  final String loadingMessage;
  final String emptyMessage;

  const CustomDropdownButtonFormField({
    super.key,
    this.value,
    required this.decoration,
    required this.items,
    this.onChanged,
    this.validator,
    this.isLoading = false,
    this.loadingMessage = 'Loading...',
    this.emptyMessage = 'No items found',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          decoration: decoration.copyWith(
            suffixIcon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: LoadingWidget.small(),
              ),
            ),
          ),
          controller: TextEditingController(text: loadingMessage),
        ),
      );
    }

    if (items.isEmpty) {
      return AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          decoration: decoration,
          controller: TextEditingController(text: emptyMessage),
        ),
      );
    }

    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: decoration,
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

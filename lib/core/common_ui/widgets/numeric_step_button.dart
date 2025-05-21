import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int? initialValue;

  final ValueChanged<int> onChanged;

  const NumericStepButton({
    super.key,
    this.minValue = 0,
    this.maxValue = 200,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  late TextEditingController _controller;
  int counter = 1;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      counter = widget.initialValue!;
    } else {
      counter = widget.minValue;
    }
    _controller = TextEditingController(text: counter.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Opacity(
          opacity: counter == widget.minValue ? 0.5 : 1,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (counter > widget.minValue) {
                  counter--;
                  final updatedValue = counter.toString();
                  _controller.value = _controller.value.copyWith(
                    text: updatedValue,
                    selection: TextSelection.collapsed(
                      offset: updatedValue.length,
                    ),
                  );
                  widget.onChanged(counter);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.grey[100],
            ),
            child: Icon(Icons.remove, color: Colors.grey[700]),
          ),
        ),
        SizedBox(
          width: 60.0,
          height: 48.0,
          child: TextField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (counter.toString() != value) {
                counter = value.isNotEmpty ? int.parse(value) : 0;
                widget.onChanged(counter);
              }
            },
            maxLength: 3,
            maxLines: 1,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              color: Colors.grey.shade900,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              counterText: '',
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (counter < widget.maxValue) {
              setState(() {
                counter++;
                String updatedText = counter.toString();
                _controller.value = _controller.value.copyWith(
                  text: updatedText,
                  selection: TextSelection.collapsed(
                    offset: updatedText.length,
                  ),
                );
                widget.onChanged(counter);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.grey[100],
          ),
          child: Icon(Icons.add, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

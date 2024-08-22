import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final String placeHolder;
  final Icon icon;
  final bool obsecure;
  final bool enableSugguestions;
  final bool autoCorrect;
  final TextEditingController controller;
  final double textSize;
  final TextInputType type;

  const FormInput(
      {required this.label,
      required this.placeHolder,
      required this.icon,
      required this.controller,
      this.textSize = 16,
      this.obsecure = false,
      this.enableSugguestions = true,
      this.autoCorrect = true,
      this.type = TextInputType.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(label),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            keyboardType: type,
            controller: controller,
            enableSuggestions: enableSugguestions,
            autocorrect: autoCorrect,
            obscureText: obsecure,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              label: Text(
                placeHolder,
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            style: TextStyle(letterSpacing: 1.5, fontSize: textSize),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "يرجى تعبئة الحقل المطلوب";
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:status_app/core/configs/text_size.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.nameController,
      required this.type,
      required this.hintText,
      required this.callBack,
      this.isObsecure,
      this.iconButton});

  final TextEditingController nameController;
  final TextInputType type;
  final String hintText;
  final String? Function(String?)? callBack;
  final Widget? iconButton;
  final bool? isObsecure;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextFormField(
      controller: nameController,
      keyboardType: type,
      obscureText: isObsecure ?? false,
      style: TextStyle(
        fontSize: size.height * p1,
      ),
      decoration: InputDecoration(
        suffixIcon: iconButton ?? const SizedBox(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade300,
          fontSize: size.height * p1,
        ),
        filled: false,
        // enabledBorder: OutlineInputBorder(
        // ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: size.width * 0.001,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: callBack,
    );
  }
}

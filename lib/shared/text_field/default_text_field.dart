
import 'package:flutter/material.dart';

Widget defaultTextField({
  TextEditingController? controller,
  bool readOnly = false,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.done,
  bool isSecure = false,
  required String label,
  required IconData preIcon,

  required String?Function(String?) validator,
  VoidCallback? onTap,
})=>TextFormField(
  controller: controller,
  onTap: onTap,
  readOnly: readOnly,
  validator:validator ,
  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w300),
  keyboardType: keyboardType,
  textInputAction: textInputAction,
  maxLines: 1,
  cursorColor: Colors.blue.shade700,
  obscureText: isSecure,
  decoration: InputDecoration(
    labelText:label,
    contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
    filled: true,
    fillColor: Colors.grey.shade300,
    prefixIcon: Icon(preIcon),
    labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 17,color: Colors.black),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300,width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.blue.shade700,width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade600,width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.red.shade600,width: 1),
    ),
  ),
);
import 'package:flutter/material.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({
    super.key,
    required this.xCor,
    required this.yCor,
  });

  final double xCor;
  final double yCor;

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

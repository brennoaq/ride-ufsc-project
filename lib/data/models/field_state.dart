import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FieldState extends Equatable {
  const FieldState({this.controller, this.error});
  final TextEditingController controller;
  final String error;

  @override
  List<Object> get props => [controller.text, error];
}

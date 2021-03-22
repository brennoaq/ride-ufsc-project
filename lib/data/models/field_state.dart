
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FieldState<T> extends Equatable {
  const FieldState({this.controller, this.error, this.type});

  final TextEditingController controller;
  final String error;
  final T type;

  @override
  List<Object> get props => [controller.text, error, type];
}

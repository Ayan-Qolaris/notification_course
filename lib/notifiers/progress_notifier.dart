// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProgressNotifier extends ValueNotifier<ProgressBarState> {
  ProgressNotifier() : super(_initialValue);

  static const _initialValue = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}

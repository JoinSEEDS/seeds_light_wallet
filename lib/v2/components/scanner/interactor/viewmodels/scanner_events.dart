import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ScannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ShowLoading extends ScannerEvent {}

class Scan extends ScannerEvent {}

class Stop extends ScannerEvent {}

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileValues extends ProfileEvent {
  @override
  String toString() => 'LoadProfileValues';
}

class OnUpdateProfileImage extends ProfileEvent {
  final File file;

  const OnUpdateProfileImage(this.file);

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'OnUpdateProfileImage { file: $file }';
}

class OnNameChanged extends ProfileEvent {
  final String name;

  const OnNameChanged(this.name);

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'OnNameChanged { name: $name }';
}

class OnCurrencyChanged extends ProfileEvent {
  const OnCurrencyChanged();

  @override
  String toString() => 'OnCurrencyChanged';
}

class OnProfileLogoutButtonPressed extends ProfileEvent {
  const OnProfileLogoutButtonPressed();

  @override
  String toString() => 'OnProfileLogoutButtonPressed';
}

class OnSavePrivateKeyButtonPressed extends ProfileEvent {
  const OnSavePrivateKeyButtonPressed();

  @override
  String toString() => 'OnSavePrivateKeyButtonPressed';
}

class ClearShowLogoutDialog extends ProfileEvent {
  const ClearShowLogoutDialog();

  @override
  String toString() => 'ClearShowLogoutDialog';
}

class ResetShowLogoutButton extends ProfileEvent {
  const ResetShowLogoutButton();

  @override
  String toString() => 'ResetShowLogoutButton';
}

class ShouldShowNotificationBadge extends ProfileEvent {
  final bool value;

  const ShouldShowNotificationBadge(this.value);

  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class OnActivateResidentButtonTapped extends ProfileEvent {
  const OnActivateResidentButtonTapped();

  @override
  String toString() => 'OnActivateResidentButtonTapped';
}

class OnActivateCitizenButtonTapped extends ProfileEvent {
  const OnActivateCitizenButtonTapped();

  @override
  String toString() => 'OnActivateCitizenButtonTapped';
}


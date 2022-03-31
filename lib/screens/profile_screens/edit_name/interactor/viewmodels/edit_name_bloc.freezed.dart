// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'edit_name_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EditNameEventTearOff {
  const _$EditNameEventTearOff();

  _OnNameChanged onNameChanged(String name) {
    return _OnNameChanged(
      name,
    );
  }

  _SubmitName submitName() {
    return const _SubmitName();
  }

  _ClearPageCommand clearPageCommand() {
    return const _ClearPageCommand();
  }
}

/// @nodoc
const $EditNameEvent = _$EditNameEventTearOff();

/// @nodoc
mixin _$EditNameEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) onNameChanged,
    required TResult Function() submitName,
    required TResult Function() clearPageCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OnNameChanged value) onNameChanged,
    required TResult Function(_SubmitName value) submitName,
    required TResult Function(_ClearPageCommand value) clearPageCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditNameEventCopyWith<$Res> {
  factory $EditNameEventCopyWith(
          EditNameEvent value, $Res Function(EditNameEvent) then) =
      _$EditNameEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$EditNameEventCopyWithImpl<$Res>
    implements $EditNameEventCopyWith<$Res> {
  _$EditNameEventCopyWithImpl(this._value, this._then);

  final EditNameEvent _value;
  // ignore: unused_field
  final $Res Function(EditNameEvent) _then;
}

/// @nodoc
abstract class _$OnNameChangedCopyWith<$Res> {
  factory _$OnNameChangedCopyWith(
          _OnNameChanged value, $Res Function(_OnNameChanged) then) =
      __$OnNameChangedCopyWithImpl<$Res>;
  $Res call({String name});
}

/// @nodoc
class __$OnNameChangedCopyWithImpl<$Res>
    extends _$EditNameEventCopyWithImpl<$Res>
    implements _$OnNameChangedCopyWith<$Res> {
  __$OnNameChangedCopyWithImpl(
      _OnNameChanged _value, $Res Function(_OnNameChanged) _then)
      : super(_value, (v) => _then(v as _OnNameChanged));

  @override
  _OnNameChanged get _value => super._value as _OnNameChanged;

  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(_OnNameChanged(
      name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_OnNameChanged with DiagnosticableTreeMixin implements _OnNameChanged {
  const _$_OnNameChanged(this.name);

  @override
  final String name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EditNameEvent.onNameChanged(name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EditNameEvent.onNameChanged'))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnNameChanged &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  _$OnNameChangedCopyWith<_OnNameChanged> get copyWith =>
      __$OnNameChangedCopyWithImpl<_OnNameChanged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) onNameChanged,
    required TResult Function() submitName,
    required TResult Function() clearPageCommand,
  }) {
    return onNameChanged(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
  }) {
    return onNameChanged?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
    required TResult orElse(),
  }) {
    if (onNameChanged != null) {
      return onNameChanged(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OnNameChanged value) onNameChanged,
    required TResult Function(_SubmitName value) submitName,
    required TResult Function(_ClearPageCommand value) clearPageCommand,
  }) {
    return onNameChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
  }) {
    return onNameChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
    required TResult orElse(),
  }) {
    if (onNameChanged != null) {
      return onNameChanged(this);
    }
    return orElse();
  }
}

abstract class _OnNameChanged implements EditNameEvent {
  const factory _OnNameChanged(String name) = _$_OnNameChanged;

  String get name;
  @JsonKey(ignore: true)
  _$OnNameChangedCopyWith<_OnNameChanged> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$SubmitNameCopyWith<$Res> {
  factory _$SubmitNameCopyWith(
          _SubmitName value, $Res Function(_SubmitName) then) =
      __$SubmitNameCopyWithImpl<$Res>;
}

/// @nodoc
class __$SubmitNameCopyWithImpl<$Res> extends _$EditNameEventCopyWithImpl<$Res>
    implements _$SubmitNameCopyWith<$Res> {
  __$SubmitNameCopyWithImpl(
      _SubmitName _value, $Res Function(_SubmitName) _then)
      : super(_value, (v) => _then(v as _SubmitName));

  @override
  _SubmitName get _value => super._value as _SubmitName;
}

/// @nodoc

class _$_SubmitName with DiagnosticableTreeMixin implements _SubmitName {
  const _$_SubmitName();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EditNameEvent.submitName()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'EditNameEvent.submitName'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SubmitName);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) onNameChanged,
    required TResult Function() submitName,
    required TResult Function() clearPageCommand,
  }) {
    return submitName();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
  }) {
    return submitName?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
    required TResult orElse(),
  }) {
    if (submitName != null) {
      return submitName();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OnNameChanged value) onNameChanged,
    required TResult Function(_SubmitName value) submitName,
    required TResult Function(_ClearPageCommand value) clearPageCommand,
  }) {
    return submitName(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
  }) {
    return submitName?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
    required TResult orElse(),
  }) {
    if (submitName != null) {
      return submitName(this);
    }
    return orElse();
  }
}

abstract class _SubmitName implements EditNameEvent {
  const factory _SubmitName() = _$_SubmitName;
}

/// @nodoc
abstract class _$ClearPageCommandCopyWith<$Res> {
  factory _$ClearPageCommandCopyWith(
          _ClearPageCommand value, $Res Function(_ClearPageCommand) then) =
      __$ClearPageCommandCopyWithImpl<$Res>;
}

/// @nodoc
class __$ClearPageCommandCopyWithImpl<$Res>
    extends _$EditNameEventCopyWithImpl<$Res>
    implements _$ClearPageCommandCopyWith<$Res> {
  __$ClearPageCommandCopyWithImpl(
      _ClearPageCommand _value, $Res Function(_ClearPageCommand) _then)
      : super(_value, (v) => _then(v as _ClearPageCommand));

  @override
  _ClearPageCommand get _value => super._value as _ClearPageCommand;
}

/// @nodoc

class _$_ClearPageCommand
    with DiagnosticableTreeMixin
    implements _ClearPageCommand {
  const _$_ClearPageCommand();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EditNameEvent.clearPageCommand()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EditNameEvent.clearPageCommand'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ClearPageCommand);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) onNameChanged,
    required TResult Function() submitName,
    required TResult Function() clearPageCommand,
  }) {
    return clearPageCommand();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
  }) {
    return clearPageCommand?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? onNameChanged,
    TResult Function()? submitName,
    TResult Function()? clearPageCommand,
    required TResult orElse(),
  }) {
    if (clearPageCommand != null) {
      return clearPageCommand();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OnNameChanged value) onNameChanged,
    required TResult Function(_SubmitName value) submitName,
    required TResult Function(_ClearPageCommand value) clearPageCommand,
  }) {
    return clearPageCommand(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
  }) {
    return clearPageCommand?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OnNameChanged value)? onNameChanged,
    TResult Function(_SubmitName value)? submitName,
    TResult Function(_ClearPageCommand value)? clearPageCommand,
    required TResult orElse(),
  }) {
    if (clearPageCommand != null) {
      return clearPageCommand(this);
    }
    return orElse();
  }
}

abstract class _ClearPageCommand implements EditNameEvent {
  const factory _ClearPageCommand() = _$_ClearPageCommand;
}

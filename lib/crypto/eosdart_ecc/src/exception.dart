// ignore_for_file: annotate_overrides

class InvalidKey implements Exception {
  String cause;

  InvalidKey(this.cause);

  String toString() => cause;
}

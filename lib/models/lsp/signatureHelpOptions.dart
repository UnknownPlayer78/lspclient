import 'package:collection/collection.dart';
import 'dart:convert';

class SignatureHelpOptions {
  ///The characters that trigger signature help
  ///automatically.
  List<String> triggerCharacters;

  ///List of characters that re-trigger signature help.
  ///These trigger characters are only active when signature help is already showing. All trigger characters
  ///are also counted as re-trigger characters.
  ///@since 3.15.0

  List<String> retriggerCharacters;
  SignatureHelpOptions({
    this.triggerCharacters,
    this.retriggerCharacters,
  });

  @override
  String toString() =>
      'SignatureHelpOptions(triggerCharacters: $triggerCharacters, retriggerCharacters: $retriggerCharacters)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is SignatureHelpOptions &&
        listEquals(o.triggerCharacters, triggerCharacters) &&
        listEquals(o.retriggerCharacters, retriggerCharacters);
  }

  @override
  int get hashCode => triggerCharacters.hashCode ^ retriggerCharacters.hashCode;

  SignatureHelpOptions copyWith({
    List<String> triggerCharacters,
    List<String> retriggerCharacters,
  }) {
    return SignatureHelpOptions(
      triggerCharacters: triggerCharacters ?? this.triggerCharacters,
      retriggerCharacters: retriggerCharacters ?? this.retriggerCharacters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'triggerCharacters': triggerCharacters,
      'retriggerCharacters': retriggerCharacters,
    };
  }

  factory SignatureHelpOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SignatureHelpOptions(
      triggerCharacters: List<String>.from(map['triggerCharacters']),
      retriggerCharacters: List<String>.from(map['retriggerCharacters']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SignatureHelpOptions.fromJson(String source) =>
      SignatureHelpOptions.fromMap(json.decode(source));
}

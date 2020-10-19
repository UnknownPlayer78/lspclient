import 'package:collection/collection.dart';
import 'dart:convert';

class DocumentOnTypeFormattingOptions {
  /// A character on which formatting should be triggered, like `}`
  String firstTriggerCharacter;

  /// More trigger characters.
  List<String> moreTriggerCharacter;

  DocumentOnTypeFormattingOptions({
    this.firstTriggerCharacter,
    this.moreTriggerCharacter,
  });

  DocumentOnTypeFormattingOptions copyWith({
    String firstTriggerCharacter,
    List<String> moreTriggerCharacter,
  }) {
    return DocumentOnTypeFormattingOptions(
      firstTriggerCharacter:
          firstTriggerCharacter ?? this.firstTriggerCharacter,
      moreTriggerCharacter: moreTriggerCharacter ?? this.moreTriggerCharacter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstTriggerCharacter': firstTriggerCharacter,
      'moreTriggerCharacter': moreTriggerCharacter,
    };
  }

  factory DocumentOnTypeFormattingOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DocumentOnTypeFormattingOptions(
      firstTriggerCharacter: map['firstTriggerCharacter'],
      moreTriggerCharacter: List<String>.from(map['moreTriggerCharacter']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentOnTypeFormattingOptions.fromJson(String source) =>
      DocumentOnTypeFormattingOptions.fromMap(json.decode(source));

  @override
  String toString() =>
      'DocumentOnTypeFormattingOptions(firstTriggerCharacter: $firstTriggerCharacter, moreTriggerCharacter: $moreTriggerCharacter)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is DocumentOnTypeFormattingOptions &&
        o.firstTriggerCharacter == firstTriggerCharacter &&
        listEquals(o.moreTriggerCharacter, moreTriggerCharacter);
  }

  @override
  int get hashCode =>
      firstTriggerCharacter.hashCode ^ moreTriggerCharacter.hashCode;
}

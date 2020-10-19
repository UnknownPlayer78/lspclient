import 'package:collection/collection.dart';

class CompletionOptions {
  /// Most tools trigger completion request automatically without explicitly requesting
  /// it using a keyboard shortcut (e.g. Ctrl+Space). Typically they do so when the user
  /// starts to type an identifier. For example if the user types `c` in a JavaScript file
  /// code complete will automatically pop up present `console` besides others as a
  /// completion item. Characters that make up identifiers don't need to be listed here.
  /// If code complete should automatically be trigger on characters not being valid inside
  /// an identifier (for example `.` in JavaScript) list them in `triggerCharacters`.
  List<String> triggerCharacters;

  /// The list of all possible characters that commit a completion. This field can be used
  /// if clients don't support individual commit characters per completion item. See
  /// `ClientCapabilities.textDocument.completion.completionItem.commitCharactersSupport`.
  /// If a server provides both `allCommitCharacters` and commit characters on an individual
  /// completion item the ones on the completion item win.
  /// @since 3.2.0
  List<String> allCommitCharacters;

  /// The server provides support to resolve additional
  /// information for a completion item.
  bool resolveProvider;
  factory CompletionOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CompletionOptions(
        resolveProvider: map['resolveProvider'],
        allCommitCharacters: map['allCommitCharacters'],
        triggerCharacters: List<String>.from(map['triggerCharacters']));
  }
  CompletionOptions({
    this.triggerCharacters,
    this.allCommitCharacters,
    this.resolveProvider,
  });

  Map<String, dynamic> toMap() {
    return {
      'triggerCharacters': triggerCharacters,
      'allCommitCharacters': allCommitCharacters,
      'resolveProvider': resolveProvider
    };
  }

  @override
  String toString() =>
      'CompletionOptions(triggerCharacters: $triggerCharacters, allCommitCharacters: $allCommitCharacters, resolveProvider: $resolveProvider)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is CompletionOptions &&
        listEquals(o.triggerCharacters, triggerCharacters) &&
        listEquals(o.allCommitCharacters, allCommitCharacters) &&
        o.resolveProvider == resolveProvider;
  }

  @override
  int get hashCode =>
      triggerCharacters.hashCode ^
      allCommitCharacters.hashCode ^
      resolveProvider.hashCode;
}

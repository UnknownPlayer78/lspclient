import 'dart:convert';

class CodeLensOptions {
  /// Code lens has a resolve provider as well.
  bool ResolveProvider;
  CodeLensOptions({
    this.ResolveProvider,
  });

  CodeLensOptions copyWith({
    bool ResolveProvider,
  }) {
    return CodeLensOptions(
      ResolveProvider: ResolveProvider ?? this.ResolveProvider,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ResolveProvider': ResolveProvider,
    };
  }

  factory CodeLensOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CodeLensOptions(
      ResolveProvider: map['ResolveProvider'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeLensOptions.fromJson(String source) =>
      CodeLensOptions.fromMap(json.decode(source));

  @override
  String toString() => 'CodeLensOptions(ResolveProvider: $ResolveProvider)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CodeLensOptions && o.ResolveProvider == ResolveProvider;
  }

  @override
  int get hashCode => ResolveProvider.hashCode;
}

import 'package:lspclient/models/lsp/workDoneProgressOptions.dart';
import 'dart:convert';

class DocumentLinkOptions extends WorkDoneProgressOptions {
  /// Document links have a resolve provider as well.
  bool ResolveProvider;
  DocumentLinkOptions({
    this.ResolveProvider,
  });

  DocumentLinkOptions copyWith({
    bool ResolveProvider,
  }) {
    return DocumentLinkOptions(
      ResolveProvider: ResolveProvider ?? this.ResolveProvider,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ResolveProvider': ResolveProvider,
    };
  }

  factory DocumentLinkOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DocumentLinkOptions(
      ResolveProvider: map['ResolveProvider'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentLinkOptions.fromJson(String source) =>
      DocumentLinkOptions.fromMap(json.decode(source));

  @override
  String toString() => 'DocumentLinkOptions(ResolveProvider: $ResolveProvider)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DocumentLinkOptions && o.ResolveProvider == ResolveProvider;
  }

  @override
  int get hashCode => ResolveProvider.hashCode;
}

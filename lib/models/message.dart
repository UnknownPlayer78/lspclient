import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:lspclient/utils/headerParser.dart';

class BaseProtocol {
  HeaderPart header;
  dynamic content;

  BaseProtocol({this.header, this.content});

  BaseProtocol.fromLSPMessage(String message) {
    var header_string = message.split('\r\n\r\n')[0];
    header = HeaderPart.fromHeader(header_string);
    var without_header = message.replaceAll(header_string, '').trim();
    content = without_header;
  }

  String toMessage() => '${header.toHeader()}\r\n${content.toString()}';
}

class BaseType {
  static const requestMessage = 'request';
  static const responseMessage = 'response';
}

class HeaderPart {
  HeaderPart({this.contentType, this.contentLength});

  String contentType = 'utf-8';
  int contentLength;

  HeaderPart.fromHeader(String header) {
    var parsed_header = parseHeader(header);
    contentType = parsed_header['Content-Type'];
    contentLength = int.parse(
        parsed_header['Content-Length'] ?? utf8.encode(header).length);
  }
  String toHeader() =>
      'Content-Type: ${contentType ?? 'utf-8'}\r\nContent-Length: $contentLength\r\n';
}

abstract class Message {
  String jsonrpc = '2.0';
}

abstract class RequestMessage extends Message {
  /// The request id
  int id;

  /// The method to be invoked
  String method;

  /// The method's params
  //dynamic params;
}

class InitializeMessage extends RequestMessage {
  @override
  String method = 'initialize';
  InitializeParams params;
  @override
  int id;

  InitializeMessage({params, id})
      : params = params,
        id = id;
  @override
  String toString() {
    return json.encode({
      'jsonrpc': jsonrpc,
      'method': method,
      'id': id,
      'params': params.toMap()
    });
  }
}

class InitializeParams {
  /// The pid of the process that started the request
  int processId;

  /// The rootUri of the workspace. Is null if no
  /// folder is open.
  String rootUri;

  /// User provided initialization options.
  dynamic initializationOptions;

  /// The capabilities provided by the client (editor or tool)
  Map capabilities;

  /// The initial trace setting. If omitted trace is disabled ('off').
  String trace;

  /// The workspace folders configured in the client when the server starts.
  /// This property is only available if the client supports workspace folders.
  /// It can be `null` if the client supports workspace folders but none are
  // configured.
  List<WorkspaceFolder> workspaceFolders;

  InitializeParams(
      {this.processId, this.rootUri, this.capabilities, this.trace});
  Map toMap() {
    return {
      'processId': processId,
      'rootUri': rootUri,
      'trace': trace,
      'capabilities': capabilities
    };
  }
}

class ShutdownMessage extends RequestMessage {
  @override
  String method = 'shutdown';
  @override
  int id;

  ShutdownMessage({id}) : id = id;
  @override
  String toString() {
    return json.encode({
      'jsonrpc': jsonrpc,
      'method': method,
      'id': id,
    });
  }
}

abstract class ClientCapabilities {
  /// Workspace specific client capabilities.
  dynamic workspace;

  /// Text document specific client capabilities.
  Map textDocument;

  /// Window specific client capabilities.
  dynamic window;

  /// Experimental client capabilities.
  dynamic experimental;
  ClientCapabilities(
      {this.workspace, this.textDocument, this.window, this.experimental});
}

abstract class WorkspaceFolder {
  /// The associated URI for this workspace folder.
  String uri;

  /// The name of the workspace folder. Used to refer to this
  /// workspace folder in the user interface.
  String name;
}

abstract class ResponseMessage implements Message {
  /// The request id.
  dynamic /* num | String | null */ id;

  /// The result of a request. This member is REQUIRED on success.
  /// This member MUST NOT exist if there was an error invoking the method.
  dynamic /* String | num | bool | object | null */ result;

  /// The error object in case a request fails.
  ResponseError error;
}

abstract class ResponseError {
  /// A number indicating the error type that occurred.
  num code;

  /// A string providing a short description of the error.
  String message;

  /// A primitive or structured value that contains additional
  /// information about the error. Can be omitted.
  dynamic /* String | num | bool | array | object | null */ data;
}

class ServerCapabilities {
  ///  Defines how text documents are synced. Is either a detailed structure defining each notification or
  ///  for backwards compatibility the TextDocumentSyncKind number. If omitted it defaults to `TextDocumentSyncKind.None`.
  dynamic /*  TextDocumentSyncOptions | num */ textDocumentSync;

  ///  The server provides completion support.
  CompletionOptions completionProvider;

  ///  The server provides hover support.
  dynamic /*  bool | HoverOptions */ hoverProvider;

  ///  The server provides signature help support.
  SignatureHelpOptions signatureHelpProvider;

  ///  The server provides go to declaration support.
  ///  @since 3.14.0
  dynamic /*  bool | DeclarationOptions | DeclarationRegistrationOptions */ declarationProvider;

  ///  The server provides goto definition support.
  dynamic /*  bool | DefinitionOptions */ definitionProvider;

  ///  The server provides goto type definition support.
  ///  @since 3.6.0
  dynamic /*  bool | TypeDefinitionOptions | TypeDefinitionRegistrationOptions */ typeDefinitionProvider;

  ///  The server provides goto implementation support.
  ///  @since 3.6.0
  dynamic /*  bool | ImplementationOptions | ImplementationRegistrationOptions */ implementationProvider;

  ///  The server provides find references support.
  dynamic /*  bool | ReferenceOptions */ referencesProvider;

  ///  The server provides document highlight support.
  dynamic /*  bool | DocumentHighlightOptions */ documentHighlightProvider;

  ///  The server provides document symbol support.
  dynamic /*  bool | DocumentSymbolOptions */ documentSymbolProvider;

  ///  The server provides code actions. The `CodeActionOptions` return type is only
  ///  valid if the client signals code action literal support via the property
  ///  `textDocument.codeAction.codeActionLiteralSupport`.
  dynamic /*  bool | CodeActionOptions */ codeActionProvider;

  ///  The server provides code lens.
  CodeLensOptions codeLensProvider;

  ///  The server provides document link support.
  DocumentLinkOptions documentLinkProvider;

  ///  The server provides color provider support.
  ///  @since 3.6.0
  dynamic /*  bool | DocumentColorOptions | DocumentColorRegistrationOptions */ colorProvider;

  ///  The server provides document formatting.
  dynamic /*  bool | DocumentFormattingOptions */ documentFormattingProvider;

  ///  The server provides document range formatting.
  dynamic /*  bool | DocumentRangeFormattingOptions */ documentRangeFormattingProvider;

  ///  The server provides document formatting on typing.
  DocumentOnTypeFormattingOptions documentOnTypeFormattingProvider;

  ///  The server provides rename support. RenameOptions may only be
  ///  specified if the client states that it supports
  ///  `prepareSupport` in its initial `initialize` request.
  dynamic /*  bool | RenameOptions */ renameProvider;

  ///  The server provides folding provider support.
  ///  @since 3.10.0
  dynamic /*  bool | FoldingRangeOptions | FoldingRangeRegistrationOptions */ foldingRangeProvider;

  ///  The server provides execute command support.
  ExecuteCommandOptions executeCommandProvider;

  ///  The server provides selection range support.
  ///  @since 3.15.0
  dynamic /*  bool | SelectionRangeOptions | SelectionRangeRegistrationOptions */ selectionRangeProvider;

  ///  The server provides workspace symbol support.
  bool workspaceSymbolProvider;

  ///  Workspace specific server capabilities
  dynamic workspace;

  ///  Experimental server capabilities.
  dynamic experimental;
  ServerCapabilities({
    this.textDocumentSync,
    this.completionProvider,
    this.hoverProvider,
    this.signatureHelpProvider,
    this.declarationProvider,
    this.definitionProvider,
    this.typeDefinitionProvider,
    this.implementationProvider,
    this.referencesProvider,
    this.documentHighlightProvider,
    this.documentSymbolProvider,
    this.codeActionProvider,
    this.codeLensProvider,
    this.documentLinkProvider,
    this.colorProvider,
    this.documentFormattingProvider,
    this.documentRangeFormattingProvider,
    this.documentOnTypeFormattingProvider,
    this.renameProvider,
    this.foldingRangeProvider,
    this.executeCommandProvider,
    this.selectionRangeProvider,
    this.workspaceSymbolProvider,
    this.workspace,
    this.experimental,
  });

  Map<String, dynamic> toMap() {
    return {
      'textDocumentSync': textDocumentSync?.toMap(),
      'completionProvider': completionProvider?.toMap(),
      'hoverProvider': hoverProvider?.toMap(),
      'signatureHelpProvider': signatureHelpProvider?.toMap(),
      'declarationProvider': declarationProvider?.toMap(),
      'definitionProvider': definitionProvider?.toMap(),
      'typeDefinitionProvider': typeDefinitionProvider?.toMap(),
      'implementationProvider': implementationProvider?.toMap(),
      'referencesProvider': referencesProvider?.toMap(),
      'documentHighlightProvider': documentHighlightProvider?.toMap(),
      'documentSymbolProvider': documentSymbolProvider?.toMap(),
      'codeActionProvider': codeActionProvider?.toMap(),
      'codeLensProvider': codeLensProvider?.toMap(),
      'documentLinkProvider': documentLinkProvider?.toMap(),
      'colorProvider': colorProvider?.toMap(),
      'documentFormattingProvider': documentFormattingProvider?.toMap(),
      'documentRangeFormattingProvider':
          documentRangeFormattingProvider?.toMap(),
      'documentOnTypeFormattingProvider':
          documentOnTypeFormattingProvider?.toMap(),
      'renameProvider': renameProvider?.toMap(),
      'foldingRangeProvider': foldingRangeProvider?.toMap(),
      'executeCommandProvider': executeCommandProvider?.toMap(),
      'selectionRangeProvider': selectionRangeProvider?.toMap(),
      'workspaceSymbolProvider': workspaceSymbolProvider,
      'workspace': workspace,
      'experimental': experimental,
    };
  }

  factory ServerCapabilities.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ServerCapabilities(
      textDocumentSync: map['textDocumentSync'],
      completionProvider: CompletionOptions.fromMap(map['completionProvider']),
      hoverProvider: map['hoverProvider'],
      signatureHelpProvider:
          SignatureHelpOptions.fromMap(map['signatureHelpProvider']),
      declarationProvider: map['declarationProvider'],
      definitionProvider: map['definitionProvider'],
      typeDefinitionProvider: map['typeDefinitionProvider'],
      implementationProvider: map['implementationProvider'],
      referencesProvider: map['referencesProvider'],
      documentHighlightProvider: map['documentHighlightProvider'],
      documentSymbolProvider: map['documentSymbolProvider'],
      codeActionProvider: map['codeActionProvider'],
      codeLensProvider: CodeLensOptions.fromMap(map['codeLensProvider']),
      documentLinkProvider:
          DocumentLinkOptions.fromMap(map['documentLinkProvider']),
      colorProvider: map['colorProvider'],
      documentFormattingProvider: map['documentFormattingProvider'],
      documentRangeFormattingProvider: map['documentRangeFormattingProvider'],
      documentOnTypeFormattingProvider: DocumentOnTypeFormattingOptions.fromMap(
          map['documentOnTypeFormattingProvider']),
      renameProvider: map['renameProvider'],
      foldingRangeProvider: map['foldingRangeProvider'],
      executeCommandProvider:
          ExecuteCommandOptions.fromMap(map['executeCommandProvider']),
      selectionRangeProvider: map['selectionRangeProvider'],
      workspaceSymbolProvider: map['workspaceSymbolProvider'],
      workspace: map['workspace'],
      experimental: map['experimental'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServerCapabilities.fromJson(String source) =>
      ServerCapabilities.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServerCapabilities(textDocumentSync: $textDocumentSync, completionProvider: $completionProvider, hoverProvider: $hoverProvider, signatureHelpProvider: $signatureHelpProvider, declarationProvider: $declarationProvider, definitionProvider: $definitionProvider, typeDefinitionProvider: $typeDefinitionProvider, implementationProvider: $implementationProvider, referencesProvider: $referencesProvider, documentHighlightProvider: $documentHighlightProvider, documentSymbolProvider: $documentSymbolProvider, codeActionProvider: $codeActionProvider, codeLensProvider: $codeLensProvider, documentLinkProvider: $documentLinkProvider, colorProvider: $colorProvider, documentFormattingProvider: $documentFormattingProvider, documentRangeFormattingProvider: $documentRangeFormattingProvider, documentOnTypeFormattingProvider: $documentOnTypeFormattingProvider, renameProvider: $renameProvider, foldingRangeProvider: $foldingRangeProvider, executeCommandProvider: $executeCommandProvider, selectionRangeProvider: $selectionRangeProvider, workspaceSymbolProvider: $workspaceSymbolProvider, workspace: $workspace, experimental: $experimental)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ServerCapabilities &&
        o.textDocumentSync == textDocumentSync &&
        o.completionProvider == completionProvider &&
        o.hoverProvider == hoverProvider &&
        o.signatureHelpProvider == signatureHelpProvider &&
        o.declarationProvider == declarationProvider &&
        o.definitionProvider == definitionProvider &&
        o.typeDefinitionProvider == typeDefinitionProvider &&
        o.implementationProvider == implementationProvider &&
        o.referencesProvider == referencesProvider &&
        o.documentHighlightProvider == documentHighlightProvider &&
        o.documentSymbolProvider == documentSymbolProvider &&
        o.codeActionProvider == codeActionProvider &&
        o.codeLensProvider == codeLensProvider &&
        o.documentLinkProvider == documentLinkProvider &&
        o.colorProvider == colorProvider &&
        o.documentFormattingProvider == documentFormattingProvider &&
        o.documentRangeFormattingProvider == documentRangeFormattingProvider &&
        o.documentOnTypeFormattingProvider ==
            documentOnTypeFormattingProvider &&
        o.renameProvider == renameProvider &&
        o.foldingRangeProvider == foldingRangeProvider &&
        o.executeCommandProvider == executeCommandProvider &&
        o.selectionRangeProvider == selectionRangeProvider &&
        o.workspaceSymbolProvider == workspaceSymbolProvider &&
        o.workspace == workspace &&
        o.experimental == experimental;
  }

  @override
  int get hashCode {
    return textDocumentSync.hashCode ^
        completionProvider.hashCode ^
        hoverProvider.hashCode ^
        signatureHelpProvider.hashCode ^
        declarationProvider.hashCode ^
        definitionProvider.hashCode ^
        typeDefinitionProvider.hashCode ^
        implementationProvider.hashCode ^
        referencesProvider.hashCode ^
        documentHighlightProvider.hashCode ^
        documentSymbolProvider.hashCode ^
        codeActionProvider.hashCode ^
        codeLensProvider.hashCode ^
        documentLinkProvider.hashCode ^
        colorProvider.hashCode ^
        documentFormattingProvider.hashCode ^
        documentRangeFormattingProvider.hashCode ^
        documentOnTypeFormattingProvider.hashCode ^
        renameProvider.hashCode ^
        foldingRangeProvider.hashCode ^
        executeCommandProvider.hashCode ^
        selectionRangeProvider.hashCode ^
        workspaceSymbolProvider.hashCode ^
        workspace.hashCode ^
        experimental.hashCode;
  }
}

///Completion options.
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
        triggerCharacters: map['triggerCharacters']);
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

abstract class WorkDoneProgressOptions {
  bool workDoneProgress;
}

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

class ExecuteCommandOptions extends WorkDoneProgressOptions {
  /// The commands to be executed on the server
  List<String> commands;
  ExecuteCommandOptions({
    this.commands,
  });

  ExecuteCommandOptions copyWith({
    List<String> commands,
  }) {
    return ExecuteCommandOptions(
      commands: commands ?? this.commands,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commands': commands,
    };
  }

  factory ExecuteCommandOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ExecuteCommandOptions(
      commands: List<String>.from(map['commands']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExecuteCommandOptions.fromJson(String source) =>
      ExecuteCommandOptions.fromMap(json.decode(source));

  @override
  String toString() => 'ExecuteCommandOptions(commands: $commands)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is ExecuteCommandOptions && listEquals(o.commands, commands);
  }

  @override
  int get hashCode => commands.hashCode;
}

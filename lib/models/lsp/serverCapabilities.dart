import 'package:lspclient/models/lsp/completionOptions.dart';
import 'package:lspclient/models/lsp/signatureHelpOptions.dart';
import 'package:lspclient/models/lsp/codeLensOptions.dart';
import 'package:lspclient/models/lsp/documentOnTypeFormattingOptions.dart';
import 'package:lspclient/models/lsp/documentLinkOptions.dart';
import 'package:lspclient/models/lsp/executeCommandOptions.dart';
import 'dart:convert';

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

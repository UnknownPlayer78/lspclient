import 'dart:convert';
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

abstract class ServerCapabilities {
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
}

///Completion options.
abstract class CompletionOptions implements WorkDoneProgressOptions {
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
}

abstract class WorkDoneProgressOptions {
  bool workDoneProgress;
}

abstract class SignatureHelpOptions implements WorkDoneProgressOptions {
  ///The characters that trigger signature help
  ///automatically.
  List<String> triggerCharacters;

  ///List of characters that re-trigger signature help.
  ///These trigger characters are only active when signature help is already showing. All trigger characters
  ///are also counted as re-trigger characters.
  ///@since 3.15.0

  List<String> retriggerCharacters;
}

class CodeLensOptions {
  /// Code lens has a resolve provider as well.
  bool ResolveProvider;
}

class DocumentLinkOptions extends WorkDoneProgressOptions {
  /// Document links have a resolve provider as well.
  bool ResolveProvider;
}

class DocumentOnTypeFormattingOptions {
  /// A character on which formatting should be triggered, like `}`.
  String firstTriggerCharacter;

  /// More trigger characters.
  List<String> moreTriggerCharacter;
}

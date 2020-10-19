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
    content = without_header.isNotEmpty && without_header != ' '
        ? without_header
        : '{}';
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
    contentLength = int.parse(parsed_header['Content-Length'] ??
        utf8.encode(header).length.toString());
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

class ExitMessage extends RequestMessage {
  @override
  String method = 'exit';
  @override
  int id;
  ExitMessage({id}) : id = id;
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

///Completion options.

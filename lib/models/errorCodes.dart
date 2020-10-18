library error_codes;

class ErrorCodes {
  // Defined by JSON RPC
  static const ParseError = -32700;
  static const InvalidRequest = -32600;
  static const MethodNotFound = -32601;
  static const InvalidParams = -32602;
  static const InternalError = -32603;
  static const serverErrorStart = -32099;
  static const serverErrorEnd = -32000;
  static const ServerNotInitialized = -32002;
  static const UnknownErrorCode = -32001;

  // Defined by the protocol.
  static const RequestCancelled = -32800;
  static const ContentModified = -32801;
}

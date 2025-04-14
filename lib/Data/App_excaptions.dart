class AppExcaption implements Exception {

  final _message;
  final _prefix;
AppExcaption([this._message , this._prefix]);

  String toString() {
    return '$_message$_prefix';


}}
class FetchDataException extends AppExcaption {

  FetchDataException([String? message]) : super (message , '      \nPlease  On  Your InterNet ');

}

class BadRequestException extends AppExcaption {

  BadRequestException([String? message]) : super (message , 'Invalid Request');

}

class UnauthoriesdException extends AppExcaption {

  UnauthoriesdException([String? message]) : super (message , 'Unauthoriesd Request');

}

class InvalidInputException extends AppExcaption {

  InvalidInputException([String? message]) : super (message , 'Invalid Input');

}
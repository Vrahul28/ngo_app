class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions(this._message, this._prefix);

  @override
  String toString() {
    return 'AppExceptions{_message: $_message, _prefix: $_prefix}';
  }
}

class InternetException extends AppExceptions {
  InternetException(message) : super(message, 'No internet');
}

class RequestTimeOut extends AppExceptions {
  RequestTimeOut(message) : super(message, 'Request Time Out');
}

class FetchDataException extends AppExceptions {
  FetchDataException(message) : super(message, '');
}

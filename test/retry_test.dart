import 'package:flutter_test/flutter_test.dart';
import 'package:venera/network/app_dio.dart';

DioException err(
  DioExceptionType type, {
  int? statusCode,
  String message = "",
}) {
  var options = RequestOptions(path: "/");
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<void>(requestOptions: options, statusCode: statusCode),
    message: message.isEmpty ? null : message,
  );
}

void main() {
  test("timeouts and connection errors are transient", () {
    for (var t in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      expect(AppDio.isTransientError(err(t)), isTrue, reason: t.name);
    }
  });

  test("5xx is transient, 4xx is not", () {
    expect(
      AppDio.isTransientError(
        err(DioExceptionType.badResponse, statusCode: 502),
      ),
      isTrue,
    );
    expect(
      AppDio.isTransientError(
        err(DioExceptionType.badResponse, statusCode: 404),
      ),
      isFalse,
    );
    expect(
      AppDio.isTransientError(
        err(DioExceptionType.badResponse, statusCode: null),
      ),
      isFalse,
    );
  });

  test("connection reset in unknown is transient", () {
    expect(
      AppDio.isTransientError(
        err(DioExceptionType.unknown, message: "SocketException: failed"),
      ),
      isTrue,
    );
    expect(
      AppDio.isTransientError(
        err(
          DioExceptionType.unknown,
          message: "Connection reset by peer",
        ),
      ),
      isTrue,
    );
    expect(
      AppDio.isTransientError(
        err(DioExceptionType.unknown, message: "some other error"),
      ),
      isFalse,
    );
  });

  test("cancel and badCertificate are not transient", () {
    expect(AppDio.isTransientError(err(DioExceptionType.cancel)), isFalse);
    expect(
      AppDio.isTransientError(err(DioExceptionType.badCertificate)),
      isFalse,
    );
  });
}

import 'dart:convert';

class BaseController {
  String jsonResponseEncode(Object? data) =>
      const JsonEncoder.withIndent(' ').convert(data);
}

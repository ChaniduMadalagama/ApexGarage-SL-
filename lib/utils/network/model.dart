abstract class ApiResponse {
  ApiResponse._fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = json['message'] as String;
    } else {
      message = 'Unknown error';
    }
  }

  String message = '';
  dynamic data;

  static ApiResponse fromJson(Map<String, dynamic> json) {
    if (json['result'] == null) {
      return ApiFailureResponse._fromJson({
        'result': false,
        'message': 'Unknown error',
      });
    }
    if (json['result'] == true) {
      return ApiSuccessResponse._fromJson(json);
    } else {
      return ApiFailureResponse._fromJson(json);
    }
  }
}

class ApiSuccessResponse extends ApiResponse {
  ApiSuccessResponse._fromJson(Map<String, dynamic> json) : super._fromJson(json) {
    if (json['payload'] != null) {
      data = json['payload'];
    }
  }
}

class ApiFailureResponse extends ApiResponse {
  ApiFailureResponse._fromJson(super.json) : super._fromJson();
}

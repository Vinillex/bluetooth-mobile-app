class ApiFailure {
  String message;
  int statusCode;
  ApiFailure(
      [this.message = 'Oops', this.statusCode = 200]);
}
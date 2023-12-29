
// check the data that is inserting / fetch the database or not
class Response {
  int statusCode;
  dynamic data;

  Response({
    this.statusCode = 200,
    this.data,
  });
}

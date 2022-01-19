class Http implements Exception {
  String Message;

  Http(this.Message);

  @override
  String toString() {
    return Message;
  }
}

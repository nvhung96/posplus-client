class RestResponse {
  int _status;
  String _message;
  dynamic _data;

  RestResponse(this._status, this._message, this._data);

  get status => _status;

  get message => _message;

  get data => _data;
}

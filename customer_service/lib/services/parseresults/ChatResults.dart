import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:customer_service/services/parseresults/ResultStatus.dart';

class ChatResults {

  List<ParseObject> list = <ParseObject>[];
  // 1 -> loading, 2 -> success, 3 -> failed
  ResultStatus status = ResultStatus.loading;

  //ChatResults(this._results, this._state);

  load(List<ParseObject> list) {
    this.list = list;
    if (this.list.isNotEmpty) {
      this.status = ResultStatus.loaded;
    }
    else {
      this.status = ResultStatus.failed;
    }
  }

  fail() {
    this.list = <ParseObject>[];
    this.status = ResultStatus.failed;
  }
}
import 'dart:async';

import 'package:intl/intl.dart';

class TimeEverySecond {
  dynamic _timer;
  dynamic callback;
  TimeEverySecond([this._timer, this.callback]);

  void startTimer(Function callback) {
    this.callback = callback;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (callback != null) {
        callback([
          DateFormat('H').format(DateTime.now()).toString(),
          DateFormat('m').format(DateTime.now()).toString(),
        ]);
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }
}

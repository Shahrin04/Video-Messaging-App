import 'package:flutter/widgets.dart';
import 'package:skype_clone/enum/view_state.dart';

class ImageUploadProvider with ChangeNotifier {
  ViewState _viewState = ViewState.IDLE; //initially set as idle
  ViewState get getViewState =>
      _viewState; //getting _viewstate value for other class

  setToLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  } //setting as loading

  setToIdle() {
    _viewState = ViewState.IDLE;
    notifyListeners();
  } //setting as idle

}

import 'package:postplus_client/ui/base/base_view.dart';

abstract class BasePresenter {
  BaseView view;

  BasePresenter(this.view);

  void notifyDataChanged() {
    view.update();
  }
}

import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/authen_repo.dart';
import 'package:postplus_client/repo/impl/authen_rest_repo.dart';
import 'package:postplus_client/repo/impl/user_prefs_repo.dart';
import 'package:postplus_client/repo/impl/user_sqlite_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

/// TODO:  A naive implementation of Observer/Subscriber Pattern. Will do for now.
/// TODO: manage these kind of global states in your app
class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  factory AuthStateProvider() => _instance;

  List<AuthStateListener> _subscribers;
  UserRepo _userRepo = UserPrefsRepo();
  AuthenRepo _authenRepo = AuthenRestRepo();

  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    var isLoggedIn = await _userRepo.isLoggedIn();

    if (isLoggedIn) {
      String currentToken = await _userRepo.getToken();
      User me = await _authenRepo.me(currentToken);
      if (me == null)
        notify(AuthState.LOGGED_OUT);
      else
        notify(AuthState.LOGGED_IN);
    } else {
      notify(AuthState.LOGGED_OUT);
    }
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for (var l in _subscribers) {
      if (l == listener) _subscribers.remove(l);
    }
  }

  void notify(AuthState state) {
    print("=====> NOTIFY: " + state.toString());
    print("=====> NOTIFY _subscribers SIZE: " + _subscribers.toString());
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}

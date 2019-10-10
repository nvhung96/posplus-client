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
  UserRepo _userRepo = UserSqliteRepo();

  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    var isLoggedIn = await _userRepo.isLoggedIn();

    if (isLoggedIn)
      notify(AuthState.LOGGED_IN);
    else
      notify(AuthState.LOGGED_OUT);
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
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}

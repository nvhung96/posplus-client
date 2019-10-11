import 'dart:async';
import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/impl/user_prefs_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';
import 'package:postplus_client/service/auth.dart';
import 'package:postplus_client/ui/inc/password_form_field.dart';
import 'package:postplus_client/ui/login/login_screen_presenter.dart';
import 'package:postplus_client/util/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _context;
  bool _isLoading = false;
  String _username, _password;
  LoginScreenPresenter _presenter;
  Timer _timer;

  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  UserRepo _userRepo = UserPrefsRepo();

  @override
  void initState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
    super.initState();
  }

  void _submit() {
    FocusScope.of(context).requestFocus(new FocusNode());

    final form = formKey.currentState;

    _timer = Timer(Duration(seconds: 10), () {
      print("=====> Login Timeout after 10 seconds");
      _showSnackBar("Có lỗi xảy ra. Vui lòng thử lại sau (Err: 0)", true);
      form.reset();
      setState(() {
        _isLoading = false;
        _usernameTextController.text = "";
        _passwordTextController.text = "";
      });
    });

    if (_usernameTextController.text.isEmpty) {
      _timer.cancel();
      _showSnackBar("Vui lòng điền đầy đủ thông tin đăng nhập!", true);
      return;
    }

    if (_passwordTextController.text.isEmpty) {
      _timer.cancel();
      _showSnackBar("Vui lòng điền đầy đủ thông tin đăng nhập!", true);
      return;
    }

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text, bool isError) {
    Color color = isError ? Colors.red : Colors.green;

    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      backgroundColor: color,
    ));
  }

  @override
  void onLoginError(String errorTxt) {
    _timer.cancel();
    _showSnackBar(errorTxt, true);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _timer.cancel();
    _showSnackBar("Đăng nhập thành công", false);
    setState(() => _isLoading = false);
    await _userRepo.saveUser(user);

    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  @override
  void onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      print("LoginScreen_context: " + _context.toString());
      Navigator.of(_context).pushNamed("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text(
        "ĐĂNG NHẬP",
        style: TextStyle(color: COLOR_CARD),
      ),
      color: COLOR_MAIN,
    );

    var loginForm = new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: new Image.asset(
            "assets/logo.jpg",
            width: 100.0,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: new BorderedText(
              strokeWidth: 1.8,
              strokeColor: COLOR_CARD,
              child: new Text(
                APP_NAME,
                textScaleFactor: 1.6,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: COLOR_MAIN,
                ),
              )),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: new BorderedText(
              strokeWidth: 1.2,
              strokeColor: COLOR_CARD,
              child: new Text(
                COMPANY_NAME,
                textScaleFactor: 1.1,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: COLOR_MAIN,
                    fontStyle: FontStyle.italic),
              )),
        ),
        new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new TextFormField(
                    onSaved: (val) => _username = val,
                    /*validator: (val) {
                      return val.isEmpty
                          ? "Tên đăng nhập không được để trống"
                          : null;
                    },*/
                    decoration: new InputDecoration(
                        labelText: "TÊN ĐĂNG NHẬP",
                        labelStyle: TextStyle(
                            fontSize: 12.0, fontStyle: FontStyle.italic)),
                    controller: _usernameTextController,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: PasswordFormField(
                    labelText: "MẬT KHẨU",
                    onSaved: (val) => _password = val,
                    passwordTextController: _passwordTextController,
                  ),
                ),
              ],
            )),
        new Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: _isLoading ? new CircularProgressIndicator() : loginBtn,
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: null,
          key: scaffoldKey,
          body: new Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/login_background.jpg"),
                    fit: BoxFit.cover)),
            child: new Center(
              child: new ClipRect(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: new Container(
                    child: loginForm,
                    height: 360.0,
                    width: 300.0,
                    decoration: new BoxDecoration(
                        color: Colors.grey.shade50.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

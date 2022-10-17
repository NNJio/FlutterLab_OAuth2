import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;
  FlutterAppAuth appAuth = const FlutterAppAuth();
  String? idToken;

  Future<void> _incrementCounter() async {
    try {
      final AuthorizationTokenResponse? r = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'psu_supper_app',
          'ssoKeycloak://oauth2redirect/auth',
          clientSecret: 'Ink21bQa7gQ2hdIsCtxUcBPPh4RjROX5',
          discoveryUrl: 'ssoKeycloak',
          // preferEphemeralSession: true,
          scopes: ['openid'],
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: 'https://sso.fintechinno.com/realms/Development/protocol/openid-connect/auth',
            tokenEndpoint: 'https://sso.fintechinno.com/realms/Development/protocol/openid-connect/token',
            endSessionEndpoint: 'https://sso.fintechinno.com/realms/Development/protocol/openid-connect/logout',
          ),
        ),
      );
      // print(r?.authorizationAdditionalParameters);
      idToken = r?.idToken;
      // print(r?.authorizationAdditionalParameters);
      print(r?.idToken);
      // print(r?.accessTokenExpirationDateTime);
      // print(r?.tokenType);
      // print(r?.refreshToken);
      // print(r?.scopes);
      var token = r?.accessToken;
      print(r?.tokenAdditionalParameters);
      var snackBar = SnackBar(
        content: Text('Token  : ${token != null ? "YES" : "NO"}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e, s) {
      print(e);
      print(s);
      var snackBar = SnackBar(
        content: Text('Error  : ${e}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () async {
                print(idToken);
                EndSessionResponse? e = await appAuth.endSession(EndSessionRequest(
                  idTokenHint: idToken,
                  // discoveryUrl: 'ssoKeycloak',
                  // postLogoutRedirectUrl: 'ssoKeycloak',
                  postLogoutRedirectUrl: 'ssoKeycloak://oauth2redirect/auth',
                  // additionalParameters: {"session_state": "ebe04bd9-ab67-4301-b546-b86f942abde1"},
                  serviceConfiguration: const AuthorizationServiceConfiguration(
                    authorizationEndpoint: 'https://sso.fintechinno.com/realms/Development/protocol/openid-connect/auth',
                    tokenEndpoint: 'https://sso.fintechinno.com/realms/Development/protocol/openid-connect/token',
                    endSessionEndpoint: 'https://sso.fintechinno.com/realms/Development/protocol/openid-connect/logout',
                  ),
                ));
                print(e?.state);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}


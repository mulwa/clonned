//Root of the app
import 'package:cloneapp/models/userLocation.dart';
import 'package:cloneapp/screens/sharedLogin/sharedLogin.dart';
import 'package:cloneapp/screens/uniqueuserpage/uniqueuserpage.dart';
import 'package:cloneapp/states/UserRepository.dart';
import 'package:cloneapp/states/data_bloc.dart';
import 'package:cloneapp/webservice/locationProvider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/mainlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:cloneapp/states/distanceProvider.dart';

SharedPreferences accountTypeAccount;

distanceProvider provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  accountTypeAccount = await SharedPreferences.getInstance();

  provider = distanceProvider();
  await provider.getPosition();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: MultiProvider(
        providers: [
          Provider(
            create: (context) => provider,
          ),
          Provider(
            create: (context) => DataBloc(context),
          ),
          StreamProvider<UserLocation>(
              create: (_) => LocationProvider().locationStream,
              initialData: null)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Consumer(
            builder: (context, UserRepository user, child) {
              print("DEBUG main(): user.status result: " +
                  user.status.toString());
              user.accountType = accountTypeAccount.get('type');
              print("DEBUG main(): user.accounttype result: " +
                  user.accountType.toString());
              switch (user.status) {
                case Status.Authenticated:
                case Status.Anonymous:
                  if (user.accountType == null) return sharedLogin();
                  switch (user.accountType) {
                    case "u2":
                      return uniqueUserPage();
                    default:
                      final bloc = Provider.of<DataBloc>(context);
                      if (bloc.documents.isEmpty) {
                        Position pos = Provider.of<distanceProvider>(context,
                                listen: false)
                            .userPosition;

                        Provider.of<DataBloc>(context).getData(pos);
                        //TODO: Need u1gF, unlock in data_bloc u1gF
                        //Provider.of<DataBloc>(context).u1gF();
                      }
                      return mainlist();
                  }
                  return sharedLogin();
                case Status.Unauthenticated:
                case Status.Uninitialized:
                case Status.Authenticating:
                default:
                  return sharedLogin();
              }
            },
          ),
        ),
      ),
    );
  }
}

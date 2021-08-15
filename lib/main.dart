import 'package:big_finance/add_page_transcision.dart';
import 'package:big_finance/graph_widget.dart';
import 'package:big_finance/login_state.dart';
import 'package:big_finance/pages/add_page.dart';
import 'package:big_finance/pages/details_page.dart';
import 'package:big_finance/pages/home_page.dart';
import 'package:big_finance/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'month_widget.dart';
import 'package:big_finance/login_state.dart';

// void main() => runApp(MyApp());

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
// void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
       child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),

         onGenerateRoute: (settings) {
           if (settings.name == '/details') {
             DetailsParams params = settings.arguments;
             return MaterialPageRoute(
                 builder: (BuildContext context) {
                   return DetailsPage(
                     params: params ,
                   );
                 }
             );
           }
           else if(settings.name == '/add'){
             Rect bottomRect= settings.arguments;

             return AddPageTransition(
               page: addPages(
                   buttomRect: bottomRect,
               )
             );
           }
         },

        routes: {
          '/':(BuildContext context) {
            var state= Provider.of<LoginState>(context);
            if(state.isLoggedIn()){
              return HomePage();
            }
            else{
              return  LoginPage();

            }

          },

        },
      ),
    );
  }

}



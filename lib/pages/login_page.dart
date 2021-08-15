import 'package:big_finance/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 TapGestureRecognizer _recognizer1;
 TapGestureRecognizer _recognizer2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(
         child: Column(
           children: [
             Flex(direction: Axis.vertical),
             Expanded(
               flex: 1,
               child: Container(),
             ),
             Text("Big Finance", style: Theme.of(context).textTheme.display1),
             Padding(
               padding: const EdgeInsets.all(32.0),
               child: Image.asset('assets/LoginImage.png') ,
             ),
             Text("Aplicacion para control de gastos",style: Theme.of(context).textTheme.caption),
             Expanded(
               flex: 1,
               child: Container(),
             ),
             Consumer<LoginState>(
               builder: (BuildContext context, LoginState value, Widget child){
                  if(value.isLoading()){
                    return CircularProgressIndicator();
                  }
                  else{
                    return child;
                  }
               },
               child: RaisedButton(
                child: Text("Iniciar sesion con Google"),
                 onPressed: (){
                   Provider.of<LoginState>(context,listen: false).login();
                 },
               ),

             ),
             Expanded(
                child: Container(),
             ),
           ],
         ),
       ),
    );
  }
}




  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Consumer<LoginState>(
  //         builder: (BuildContext context, LoginState value, Widget child){
  //            if(value.isLoading()){
  //              return CircularProgressIndicator();
  //            }
  //            else{
  //              return child;
  //            }
  //         },
  //         child:  RaisedButton(
  //           child: Text("Iniciar sesion"),
  //           onPressed: (){
  //             Provider.of<LoginState>(context,listen: false).login();
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }



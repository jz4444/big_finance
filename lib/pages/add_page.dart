import 'dart:ffi';

import 'package:big_finance/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../category_selection_widget.dart';

class addPages extends StatefulWidget {
  final Rect buttomRect;

  const addPages({Key key, this.buttomRect}) : super(key: key);
  @override
  _addPagesState createState() => _addPagesState();
}

class _addPagesState extends State<addPages> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation buttomAnimation;
  Animation pageAnimation;


  String category="";
  int value=0;
 String dateStr="hoy";
 DateTime date= DateTime.now();

  @override
  void initState(){
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    buttomAnimation = Tween<double>(begin: 0.4 , end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );

    pageAnimation = Tween<double>(begin: -1 , end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );


    _animationController.addListener(() {
          setState(() {});
    });

    _animationController.addStatusListener((status) {
         if(status == AnimationStatus.dismissed){
           Navigator.of(context).pop();
         }
    });
    _animationController.forward();
  }


  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    return Stack(
      children:[
        Transform.translate(
          offset: Offset(0,h*(1 - pageAnimation.value)),
          child:  Scaffold(
            appBar: AppBar(
               automaticallyImplyLeading: false,
               backgroundColor: Colors.transparent,
               elevation: 0.0,
               title: GestureDetector(
                 onTap: (){
                   showDatePicker(
                       context: context,
                       initialDate: DateTime.now(),
                       firstDate: DateTime.now().subtract(Duration(hours: 24 * 30)),
                       lastDate: DateTime.now(),
                   ).then((newDate) {
                     if(newDate != null)
                       {
                         setState(() {
                           date= newDate;
                           dateStr= "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
                         });
                       }
                       print(newDate);
                   });
                 },
                 child: Text('Categorias ($dateStr)',
                    style: TextStyle(color: Colors.grey),
                             ),
               ),
                centerTitle: false,
                actions: [
                     IconButton(
                     icon:Icon(Icons.close, color: Colors.grey,),
                      onPressed: (){
                       _animationController.reverse();
          },
        ),
      ],
    ),
    body: _body(),
    ),
        ),
        _submit(),
      ],
    );
  }

 Widget _body() {
    var h = MediaQuery.of(context).size.height;
    return Column(
       children: [
         _categorySelector(),
         _currentValue(),
         _numpad(),
         SizedBox(
           height: h - widget.buttomRect.top,
         )
       ],
    );
 }

  Widget  _categorySelector() {

    return Container(
      height: 80.0,
      child: categorySelectionWidget(
        categories: {
          "Compras": Icons.shopping_cart,
          "Bebidas":FontAwesomeIcons.beer,
          "Comidas rapidas": FontAwesomeIcons.hamburger,
          "Facturas": FontAwesomeIcons.wallet,
          "Transporte": FontAwesomeIcons.car,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }


  Widget _currentValue() {
    var realvalue = value;
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 32.0),
       child: Text("\$${realvalue.toStringAsFixed(2)}",
         style: TextStyle(
           fontSize: 50.0,
           color: Colors.blueAccent,
           fontWeight: FontWeight.w500,
         ),
       ),
     );
  }

  Widget _num(String text, double height){
   return GestureDetector(
     behavior: HitTestBehavior.opaque,
     onTap: (){
      setState(() {
        if(text==","){
            value=value*100;
        }
        else{
          value= value*10 + int.parse(text);
        }

      });
     },
     child: Container(
         height: height,
         child: Center(
           child: Text(text,
             style: TextStyle(fontSize: 40.0, color: Colors.grey),),
         )),
   );

  }

  Widget  _numpad() {
  return Expanded(
    child: LayoutBuilder(
      builder:(BuildContext context, BoxConstraints Constraints ){
        var height= Constraints.biggest.height / 4;
        return  Table(
          border: TableBorder.all(
              color: Colors.grey,
              width: 1.0
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(children: [
              _num("4", height),
              _num("5", height),
              _num("6", height),
            ]),
            TableRow(children: [
              _num("7", height),
              _num("8", height),
              _num("9", height),
            ]),
            TableRow(children: [
              _num(",", height),
              _num("0", height),
               GestureDetector(
                 onTap: (){
                   setState(() {
                     value= value ~/ 10;
                   });
                 },
                 child: Container(
                     height: height,
                     child: Center(
                       child: Icon(Icons.backspace,
                         color: Colors.grey,
                         size: 40.0,
                       ),
                     )),
               )

              // Icon(Icons.backspace),
            ]),
          ],
        );
      }
    )

  );

  }
  Widget  _submit() {
    if(_animationController.value <1){
      var buttomWidth = widget.buttomRect.right - widget.buttomRect.left;
      var w = MediaQuery.of(context).size.width;
   return Positioned(
     // top: widget.buttomRect.top,
     // left: widget.buttomRect.left *(1 - buttomAnimation.value) ,
     // right: widget.buttomRect.right *(1 - buttomAnimation.value),
     // bottom: widget.buttomRect.bottom *(1 - buttomAnimation.value),
     left: widget.buttomRect.left * (1 - buttomAnimation.value),
     //<-- Margin from left
     right: (w - widget.buttomRect.right) * (1 - buttomAnimation.value),
     //<-- Margin from right
     top: widget.buttomRect.top,
     //<-- Margin from top
     bottom: (MediaQuery.of(context).size.height - widget.buttomRect.bottom) * (1 - buttomAnimation.value),
     //<-- Margin from bottom
     child: Container(
       width: double.infinity,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(buttomWidth *(1 - buttomAnimation.value)),
           color: Colors.red,
       ),

     ),
   );
    }
    else
        {
          return  Positioned(
              top:  widget.buttomRect.top,
              bottom: 0,
              left: 0,
              right: 0,
              child: Builder(builder: (BuildContext context){
                return  Container(
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  child: MaterialButton(
                    child: Text("Agregar Gasto", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    onPressed:(){
                      var user= Provider.of<LoginState>(context, listen: false).currentUser();
                      var today = date;
                      if(value > 0 && category !="" && today != null){

                        //guardar valor
                        Firestore.instance
                            .collection('Users')
                            .document(user.uid)
                            .collection('Gastos')
                            .add({
                          "category": category,
                          "value": value,
                          "month": today.month,
                          "day": today.day,
                          "Year": today.year,
                        });

                        Navigator.of(context).pop();


                      }
                      else{

                         showDialog(
                             context: context,
                             builder: (context)=> AlertDialog(
                               content: Text("Debe colocar un monto y seleccionar la categoria"),
                               actions: <Widget>[
                                 FlatButton(
                                   child: Text("Ok"),
                                   onPressed: (){
                                     Navigator.of(context).pop();
                                   },
                                 ),
                               ],
                             ),
                         );


                        //forma antigua
                        // Scaffold.of(context).showSnackBar(
                        //     SnackBar(content: Text("Seleccione un valor y la categoria"))
                        // );

                      }

                    } ,
                  ),
                );
              },
              )
          );
        }


      

  }
}

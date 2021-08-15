import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class categorySelectionWidget extends StatefulWidget {
  final Map<String,IconData> categories;
  final Function(String) onValueChanged;

  const categorySelectionWidget({Key key, this.categories, this.onValueChanged}) : super(key: key);


  @override
  _categorySelectionWidgetState createState() => _categorySelectionWidgetState();
}

class categorywidget extends StatelessWidget{
  final String name;
  final IconData icon;
  final bool selected;

  const categorywidget({Key key, this.name, this.icon, this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: selected ? Colors.blueAccent : Colors.grey,
              width: selected ? 3.0 : 1.0,

            )
          ),
          child: Icon(icon),
        ),
        Text(name),
      ],
      )
    );
  }
}

class _categorySelectionWidgetState extends State<categorySelectionWidget> {
  String currentItem="";
  @override
  Widget build(BuildContext context) {
    var widgets=<Widget>[];
    widget.categories.forEach((name, icon) {
       widgets.add( GestureDetector(
         onTap:(){
          setState(() {
            currentItem=name;
          });
          widget.onValueChanged(name);
         },
        child: categorywidget(
           name: name,
           icon: icon,
           selected: name == currentItem,
       ),
       ));
    });
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}

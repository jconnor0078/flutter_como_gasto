import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategorySelectionWidget extends StatefulWidget{
  final Map<String, IconData> categories;
  final Function(String) onValueChanched;

  const CategorySelectionWidget({Key key, this.categories, this.onValueChanched}) : super(key: key);

  @override
  _CategorySelectionWidgetState createState() => _CategorySelectionWidgetState();
}

class CategoryWidget extends StatelessWidget{
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget({Key key, this.name, this.icon, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0 ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: selected ? Colors.blueAccent: Colors.grey,
                width: selected ? 3.0 : 1.0
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


class _CategorySelectionWidgetState extends State<CategorySelectionWidget>{
  String currentItem=""; //elemento seleccionado 
  @override
  Widget build(BuildContext context){
    var widgets= <Widget>[];

    widget.categories.forEach((name, icon){

      widgets.add(
        GestureDetector(//para seleccionar un item
          onTap: (){
            setState(() {
             currentItem=name; 
            });
            widget.onValueChanched(name);
          },
          child: CategoryWidget(
            name:name,
            icon: icon,
            selected: name == currentItem,
          ) ,
        )
      );
    });


    return  ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../category_selection_widget.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category;
  double value=0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,//quita el boton de ir atras
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title:Text("Category",
          style: TextStyle(
            color: Colors.grey
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.grey,
            onPressed: (){
              Navigator.of(context).pop(); //vuelve a la pantalla anterior
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numPad(),
        _submit()
      ],
    );
  }
 

  Widget _categorySelector(){

      return  Container(
        height: 80.0,
        child: CategorySelectionWidget(
          categories: {
            "Shopping":Icons.shopping_cart,
            "Alcohol" : FontAwesomeIcons.wineGlass,
            "Fast food":FontAwesomeIcons.hamburger,
            "Bills": FontAwesomeIcons.wallet
          },
          onValueChanched: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
     return Padding(
       padding:  const EdgeInsets.symmetric(vertical: 32.0),
       child: Text("\$${value.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500
        ),
       ),

     );
  }

  Widget _num(String text, double height)
  {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,//esto es para que de click en todos los espacios del cuadro
      onTap: (){
        setState(() {
         value=value*10 + int.parse(text);
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey
            ),
          ),
        )
      ),
    );
   
  }

  Widget _numPad(){
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints){
          var height = contraints.biggest.height/4;

          return Table(
            border: TableBorder.all(
              color: Colors.grey,
              width: 3.0
            ),
            children: [
              TableRow(
                children: [
                  _num("1", height),
                  _num("2", height),
                  _num("3", height)
                ]
              ),
              TableRow(
                children: [
                  _num("4", height),
                  _num("5", height),
                  _num("6", height)
                ]
              ),
              TableRow(
                children: [
                  _num("7", height),
                  _num("8", height),
                  _num("9", height)
                ]
              ),
              TableRow(
                children: [
                  _num(",", height),
                  _num("0", height),
                  GestureDetector (
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      setState(() {
                        //value / 10).toInt()== (value ~/ 10 )
                        value= (value ~/ 10) + (value - value.toInt());
                      });
                    },
                    child: Container(
                      height: height,
                      child: Center(
                        child: Icon(
                          Icons.backspace,
                          color: Colors.grey,
                          size: 40,
                          ),
                      ) ,
                    ),
                  ) 
                ]
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _submit(){
    return Builder (builder: (BuildContext context){
      return Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueAccent
        ),
        child: MaterialButton(
            child: Text("Add expense",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
              )
            ),
            onPressed: (){
              if(value>0 && category != "")
              {

              }
              else
              {
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Seleccione un valor y una categoria"),)
                );
              }
            },
        ),
      );
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'graph_widget.dart';

class MonthWidget extends StatefulWidget{
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  MonthWidget({Key key, this.documents}) 
              : 
                //esto es lo mismo que variable.Select(s=>s.Numero).Sum();
                //documents.map coloca todos los valores dentro de (doc) y luego puedo seleccionar una lista de uno de los campos en especifico
                //la funcion fold nos permite a partir de un numero inicial 0.0, especificando que variables van a trabajar a,b donde a es el valor inicial y b es el valor del indice en la lista
                //     seguido de la funcion que hará con las dos variable, luego pasa al segundo indice de la lista (hace un bucle) en donde el segundo indice a= al resultado del indice anterior y b = al valor del siguiente indice
                total= documents.map((doc)=>doc['value'])
                            .fold(0.0, (a,b) => a+b),
                
                //buscar la sumatoria de los valores por dia, para hacerlo haremos un generador de lista de 30 index
                perDay= List.generate(30, (int index){
                   return documents.where((doc)=> doc['day']==(index + 1))
                            .map((doc) => doc['value'])
                            .fold(0.0, (a,b)  =>a + b);
                }),

                categories= documents.fold({}, (Map<String, double> map, documents){
                  if(! map.containsKey(documents['category'])){
                    map[documents['category']]=0.0;
                  }
                  
                  map[documents['category']] += documents['value'];
                  return map;
                }),
                
                super(key: key);
  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget>{
  @override
  Widget build (BuildContext context){
    return 
    Expanded(
      child: Column(
      children: <Widget>[
            _expenses(),
            _graph(),
            Container(
              color: Colors.blueAccent.withOpacity(0.15),
              height: 24.0,
            ),
            _list()
        ],
      ),
    );
    
  }
  
  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text("RD\$${widget.total.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0
          ),
        ),
        Text("Total de gastos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          )
      ],
    );
  }

  Widget _graph() {
    return 
    Container(
      height: 250.0,
      child: GraphWidget(
        data: widget.perDay
        )
      );
  }


/* Lista con ViewList
  Widget _list(){
    return Expanded(
      child: ListView(
        children: <Widget>[
          _item(FontAwesomeIcons.shoppingCart, "Shopping",14,145.12),
          _item(FontAwesomeIcons.wineGlass, "Alcohol",5,73.57),
        ],
      ),
    );
  }*/

  //LIsta con separadores
  Widget _list(){
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        //itemBuilder: (BuildContext context, int index) => _item(FontAwesomeIcons.shoppingCart, "Shopping",14,145.12), //fabricacion manual
        itemBuilder: (BuildContext context, int index){
          var key = widget.categories.keys.elementAt(index);//obtenemos el key del elemento en el momento (esto es un bucle)
          var data = widget.categories[key];
          return _item(FontAwesomeIcons.shoppingCart, key, (100*data ~/ widget.total),data);
        },
        separatorBuilder: (BuildContext context, int index){
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }

  
  Widget _item(IconData icon, String name, int percent, double value){
    return ListTile(
      leading: Icon(icon, size: 32.0),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
      ),
      subtitle: Text("$percent% of expenses",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey
        )
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("RD\$$value",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            )
          ),
        ),
      ),
    );
  }



}
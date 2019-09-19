import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:como_gasto/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'cl';
 


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _controller;
  int currentPage= DateTime.now().month-1;
  Stream<QuerySnapshot> _query;

  @override
  void initState()
  {
    super.initState();
    //inicializando el query sin el listen para que no escuche todo el tiempo
    _query= Firestore.instance
              .collection('expenses')
              .where('month', isEqualTo: currentPage+1)
              .snapshots();
    // Firestore.instance
    // .collection('expenses')
    // .where('month', isEqualTo: currentPage+1)
    // .snapshots()
    // .listen((data) =>
    // data.documents.forEach((doc) => print(doc['category']))
    // );

    _controller= PageController(
      initialPage: currentPage,
      viewportFraction: 0.4, //indica cual es la fraccion que quiere que ocupe cada pagina
    );
  }

  Widget _bottonAction(IconData icon)
  {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon)
      ),
      onTap: (){}
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,//para hacer la mueca en el boto add
        shape: CircularNotchedRectangle(),//para hacer la mueca en el boton add
        child: Row(
          mainAxisSize: MainAxisSize.max,//se expanda completamente el boton dentro del bottomNavigationBar
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,//se separen los elementos de igual tamano
          children: <Widget>[
            _bottonAction(FontAwesomeIcons.history),
            _bottonAction(FontAwesomeIcons.chartPie),
            SizedBox(width:48.0),
            _bottonAction(FontAwesomeIcons.wallet),
            _bottonAction(Icons.settings)
          ],
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed('/add');
        },
      ),
      body: _body(),
    );
  }

  Widget _body()
  {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if(data.hasData){
                return MonthWidget( documents: data.data.documents);
              }
              else{
                return Center(
                  child: CircularProgressIndicator()
                );
              }
               
            },
          )         
        ],
      ),  
    );
  }

  //codigo para crear la lista horizontal de la parte superior y el Widget PageView Usa un controller para poder controlarlo
  Widget _selector(){
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage){
          setState(() {
           currentPage=newPage; 
           //cuando cambie el mes cambiamos la query
          _query= Firestore.instance
            .collection('expenses')
            .where('month', isEqualTo: currentPage+1)
            .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem ("Enero",0),
          _pageItem ("Febrero",1),
          _pageItem ("Marzo",2),
          _pageItem ("Abril",3),
          _pageItem ("Mayo",4),
          _pageItem ("Junio",5),
          _pageItem ("Julio",6),
          _pageItem ("Agosto",7),
          _pageItem ("Septiembre",8),
          _pageItem ("Octubre",9),
          _pageItem ("Noviembre",10),
          _pageItem ("Diciembre",11),
        ],
      ),
    );
  }


  Widget _pageItem(String name, int position)
  {
    var _alignment;

    final selected= TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey
    );
    final unselected= TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.blueGrey.withOpacity(0.4)
    );

    if (position == currentPage)
    {
      _alignment= Alignment.center;
    }
    else if (position>currentPage)
    {
      _alignment= Alignment.centerRight;
    }
    else
    {
      _alignment= Alignment.centerLeft;
    }
    return Align(
      alignment: _alignment,
      child: Text(name,
        style: position==currentPage?selected:unselected,
      ),
    );
  }

}
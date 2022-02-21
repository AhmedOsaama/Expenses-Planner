import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  String cardText = "";
  MyCard(this.cardText);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text("???"),
            ),
          ),
        ),
        title: Text(
          cardText,
          style: TextStyle(
              fontFamily: "QuickSand",
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        onTap: cardText == "HERE"
            ? () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                          appBar: AppBar(
                            title: Text("?????????????????????"),
                          ),
                          body: SingleChildScrollView(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.network("https://static0.srcdn.com/wordpress/wp-content/uploads/2020/06/Spongebob-Dark-Theories.jpg",width: double.infinity,height: 300,fit: BoxFit.cover,),
                                  Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.network("https://i.kym-cdn.com/photos/images/facebook/002/243/540/778.png",width: double.infinity,height: 300,fit: BoxFit.cover,),
                                  Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.network("https://static2.srcdn.com/wordpress/wp-content/uploads/2019/05/Jeff-the-Killer-creepypasta.jpg",width: double.infinity,height: 400,fit: BoxFit.cover,),
                                ],
                              ),
                            ),
                          ),
                        )))
            : null,
      ),
    );
  }
}

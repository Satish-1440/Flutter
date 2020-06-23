import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ChatWindow extends StatefulWidget {
  final String username;
  ChatWindow({Key key, this.username}) : super(key: key);

  @override
  _ChatWindow createState() => _ChatWindow(username);
}

class _ChatWindow extends State<ChatWindow> {
  String username;
  _ChatWindow(String username) {
    this.username = username;
  }
  TextEditingController txtMessage = TextEditingController();
  TextEditingController activeUsers = TextEditingController();
  TextEditingController messages = TextEditingController();
  bool stopTimer = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      var activeUsersRes = await http.read("http://165.22.14.77:8080/Satish/WebChat/activeUsers.jsp?username=" + username);
      var messagesRes = await http.read("http://165.22.14.77:8080/Satish/WebChat/showMessages.jsp?username=" + username);
      setState(() {
        activeUsers.text = activeUsersRes.replaceAll("<br>", "").replaceAll("&#8226;", "●").trim();
        messages.text = messagesRes.trim();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _sendMessage() async {
    var sendStatus = await http.read("http://165.22.14.77:8080/Satish/WebChat/sendMessage.jsp?username=" + username + "&message=" + txtMessage.text);
    txtMessage.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        reverse: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Chat Room',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Active Users',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: 270,
                          height: 140,
                          child: SingleChildScrollView(
                              child: Text(
                                activeUsers.text,
                                style: TextStyle(color: Colors.green),
                              )
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                          width: 330,
                          height: 350,
                          child: SingleChildScrollView(
                              reverse: true,
                              child: Text(
                                messages.text,
                                style: TextStyle(color: Colors.brown),
                              )
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(40, 20, 5, 0),
                          decoration: BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 5.0),
                            ],
                          ),
                          child: SizedBox(
                              width: 270,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 10, 0),
                                  child: TextField(
                                    controller: txtMessage,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a message"),
                                  )
                              )
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
                          decoration: BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 10),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  onPressed: () {
                                    if (txtMessage.text.isNotEmpty) {
                                      _sendMessage();
                                    }
                                    else {
                                      displayToast("Type your message to send!");

                                    }
                                  },
                                  icon: Icon(Icons.send, color: Colors.blue, size: 35.0,),
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 10),
                    ],
                  ),
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: FlatButton(
                        textTheme: ButtonTextTheme.accent,
                        onPressed: () {
                          _signOut(username);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)
                        ),
                        color: Colors.white,
                        child: Align(
                          child: Text(
                            "Sign Out",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                fontSize: 16.0
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signOut(String username) async {
    await http.read("http://165.22.14.77:8080/Satish/WebChat/signOut.jsp?username=" + username);
    displayToast("Good bye!");
    setState(() {
      Navigator.pop(context);
    });
  }
  void displayToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white
    );
  }
}

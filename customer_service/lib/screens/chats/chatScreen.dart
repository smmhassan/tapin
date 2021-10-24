import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/tabbedwindow/TabbedWindow.dart';
import '../../widgets/tabbedwindow/TabbedWindowList.dart';
import '../../widgets/tabbedwindow/TabbedWindowListOrganization.dart';
import '../../widgets/tabbedwindow/TabbedWindowListCorrespondence.dart';
import '../../widgets/DashHeader.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';
import 'package:customer_service/widgets/chat/ChatAppBar.dart';
import 'package:customer_service/widgets/chat/Message.dart';

import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  QueryMutation addMutation = QueryMutation();
  final double desktopHeaderHeight = 0.15;
  final double desktopListHeight = 0.6;
  final double desktopTitleHeight = 22;
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  final Image headerLogo = new Image(
      image: new ExactAssetImage('assets/logo_text.png'),
      height: AppBar().preferredSize.height - 30,
      //width: 20.0,
      alignment: FractionalOffset.center);

  final double maxContentWidth = 800;
  final double mobileHeaderHeight = .12;
  final double mobileListHeight = .36;
  final double mobileTitleHeight = 18;
  ParseUser user = ParseUser('', '', '');

  final scrollController = ScrollController();

  @override
  void initState() {
    initData().then((bool success) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      ParseUser.currentUser().then((currentUser) {
        setState(() {
          user = currentUser;
        });
      });
    }).catchError((dynamic _) {});
    super.initState();
  }

  Future<bool> initData() async {
    return (await Parse().healthCheck()).success;
  }

  @override
  Widget build(BuildContext context) {
    bool narrow = MediaQuery.of(context).size.width < 600;
    bool wide = MediaQuery.of(context).size.width > 1000;

    List<String> messages = [
      'hello',
      'how are you',
      'I am doing fine',
      'this is a very long message, blalblablab lal b al blablabl alb alb labl ablal bla bla blablblab lal  balbla blablalbla',
      'no',
      'ok',
      'yes',
      'ok',
      'testing',
      '123',
      'owl',
      'a',
      'b',
      'c',
      'd',
      'f',
      'g',
    ];
    List<bool> messageSide = [
      true,
      true,
      false,
      false,
      true,
      false,
      true,
      false,
      true,
      true,
      false,
      true,
      true,
      true,
      true,
      true,
      true,
    ];

    return Scaffold(
      appBar: ChatAppBar(
        context,
        user,
        NetworkImage('https://parsefiles.back4app.com/P8CudbQwTfa32Tc0rxXw3AXHmVPV9EPzIBh3alUB/69044f2e59e31dd8a3bb84adbf8570e6_fox%20placeholder.png'),
        'A test Correspondence'
      ),
      //appBar: AppBar(),

      endDrawer: wide
          ? null
          : NavigationDrawer(
              user: user,
            ),

      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Column(
            children: [
              // messages
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: maxContentWidth,
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Message(
                        author: 'test',
                        text: messages[index],
                        customer: messageSide[index],
                      );
                    }
                  ),
                ),
              ),
              // text entry field
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        onTap: () {
                          Timer(
                            Duration(milliseconds: 400),
                              () => scrollController.jumpTo(scrollController.position.maxScrollExtent)
                          );
                          //scrollController.animateTo(
                          //  scrollController.position.maxScrollExtent,
                          //  duration: Duration(milliseconds: 150),
                          //  curve: Curves.fastOutSlowIn,
                          //);
                        },
                        textInputAction: TextInputAction.send,
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Theme.of(context).selectedRowColor,
                          ),
                          hintText: "Write message...",
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: (){},
                      child: Icon(Icons.send,color: Theme.of(context).canvasColor,size: 18,),
                      backgroundColor: Theme.of(context).buttonColor,
                      elevation: 0,
                    ),
                  ],

                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class OrganizationResult {
  static int getCount(QueryResult result) {
    return result.data?["organizations"]['count'];
  }

  static String getId(QueryResult result, int i) {
    return result.data?["organizations"]["edges"][i]["node"]["objectId"];
  }

  static String getName(QueryResult result, int i) {
    return result.data?["organizations"]["edges"][i]["node"]["name"];
  }

  static String getImageURL(QueryResult result, int i) {
    return result.data?["organizations"]["edges"][i]["node"]["logo"]["url"];
  }

  static ImageProvider getImage(QueryResult result, int i) {
    return NetworkImage(
        result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]);
  }
}

class CorrespondenceResult {
  static int getCount(QueryResult result) {
    return result.data?["chats"]['count'];
  }

  static String getSummary(QueryResult result, int i) {
    return result.data?["chats"]["edges"][i]["node"]["correspondence"]
        ["summary"];
  }

  static String getId(QueryResult result, int i) {
    return result.data?["chats"]["edges"][i]["node"]["correspondence"]
        ["objectId"];
  }

  static String getName(QueryResult result, int i) {
    return result.data?["chats"]["edges"][i]["node"]["members"]["edges"][0]
        ["node"]["user"]["employee"]["organization"]["name"];
  }

  static String getImageURL(QueryResult result, int i) {
    return result.data?["chats"]["edges"][i]["node"]["members"]["edges"][0]
        ["node"]["user"]["employee"]["organization"]["logo"]["url"];
  }

  static ImageProvider getImage(QueryResult result, int i) {
    return NetworkImage(result.data?["chats"]["edges"][i]["node"]["members"]
            ["edges"][0]["node"]["user"]["employee"]["organization"]["logo"]
        ["url"]);
  }
}

class ChatBuilder extends StatelessWidget {
  final QueryResult result;
  final bool narrow;

  const ChatBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isLoading) {
      return ChatLoading();
    }
//------------------------------------------------------------------------------------------------------------------------------------------------------------/
    else if (result.data != null && OrganizationResult.getCount(result) > 0) {
      //int count = result.data?["organizations"]['count'];
      int count = OrganizationResult.getCount(result);
      return TabbedWindowList(listItems: [
        for (var i = 0; i < count; i++)
          TabbedWindowListOrganization(
            //name: result.data?["organizations"]["edges"][i]["node"]["name"],
            name: OrganizationResult.getName(result, i),
            //image: NetworkImage(result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]),
            image: OrganizationResult.getImage(result, i),
            dense: narrow ? true : false,
          ),
      ]);
    } else {
      return TabbedWindowEmpty();
    }
  }
}

class CorrespondenceTabbedWindowListBuilder extends StatelessWidget {
  final QueryResult result;
  final bool narrow;

  const CorrespondenceTabbedWindowListBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isLoading) {
      return ChatLoading();
    } else if (result.data != null &&
        CorrespondenceResult.getCount(result) > 0) {
      //print(result.data);
      int count = CorrespondenceResult.getCount(result);
      return TabbedWindowList(listItems: [
        for (var i = 0; i < count; i++)
          TabbedWindowListCorrespondence(
            name: CorrespondenceResult.getName(result, i),
            description: CorrespondenceResult.getSummary(result, i),
            image: CorrespondenceResult.getImage(result, i),
            dense: narrow ? true : false,
          ),
      ]);
    } else {
      return TabbedWindowEmpty();
    }
  }
}

class ChatLoading extends StatelessWidget {
  const ChatLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'loading...',
      style: TextStyle(color: Theme.of(context).accentColor),
    ));
  }
}

class TabbedWindowEmpty extends StatelessWidget {
  const TabbedWindowEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'could not find anything',
      style: TextStyle(color: Theme.of(context).accentColor),
    ));
  }
}
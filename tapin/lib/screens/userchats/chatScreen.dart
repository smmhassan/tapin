import 'dart:async';
import 'dart:convert';
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
import 'localwidgets/ChatAppBar.dart';
import 'localwidgets/Message.dart';
import 'localwidgets/MessageBubble.dart';

import 'package:tapin/services/graphQLConf.dart';
import "package:tapin/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart' as ParseServer;
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
      image: new ExactAssetImage('assets/logo3.png'),
      height: AppBar().preferredSize.height - 30,
      //width: 20.0,
      alignment: FractionalOffset.center);

  // messages
  late String message;
  late List<Message> messages;

  // controllers
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // sizing parameters
  final double maxContentWidth = 800;
  final double mobileHeaderHeight = .12;
  final double mobileListHeight = .36;
  final double mobileTitleHeight = 18;
  ParseServer.ParseUser user = ParseServer.ParseUser('', '', '');
  String idFrom = "";

  @override
  void initState() {
    initData().then((bool success) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      ParseServer.ParseUser.currentUser().then((currentUser) {
        setState(() {
          user = currentUser;
          idFrom = user.objectId.toString();
        });
      });
    }).catchError((dynamic _) {});
    messages = <Message>[];
    message = "";
    _handleLiveQuery();
    super.initState();
  }

  Future<bool> initData() async {
    return (await ParseServer.Parse().healthCheck()).success;
  }

  void _handleLiveQuery() async {
    final ParseServer.LiveQuery liveQuery = ParseServer.LiveQuery(debug: true);
    ParseServer.QueryBuilder<ParseServer.ParseObject> query =
        ParseServer.QueryBuilder<ParseServer.ParseObject>(
            ParseServer.ParseObject('Message'));

    print('LiveQueryURL ${ParseServer.ParseCoreData().liveQueryURL}');

    ParseServer.Subscription subscription =
        await liveQuery.client.subscribe(query);
    subscription.on(ParseServer.LiveQueryEvent.create, (value) {
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      Message m = Message.clone().fromJson(jsonDecode(value.toString()));
      //print(m);
      setState(() {
        messages.add(m);
      });
      //print(messages);
    });

    subscription.on(ParseServer.LiveQueryEvent.update, (value) {
      print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
    });

    subscription.on(ParseServer.LiveQueryEvent.delete, (value) {
      print('*** DELETE ***: ${DateTime.now().toString()}\n $value ');
    });

    print('Subscribe done');
  }

  void _sendMessage() {
    sendMessagePressed(message: message);
  }

  Future<bool> sendMessage({required String message}) async {
    var m = Message()
      ..set('message', message)
      ..set('idFrom', idFrom)
      ..set('user', await ParseServer.ParseUser.currentUser());
    var apiResponse = await m.save();
    return apiResponse.success;
  }

  Future<void> sendMessagePressed({required String message}) async {
    await this.sendMessage(
      message: message,
    );
  }

  Future<List<Message>> loadAllMessages() async {
    var apiResponse = await Message().getAll();
    List<Message> messages = [];
    if (apiResponse.success && apiResponse.result != null) {
      for (Message m in apiResponse.result) {
        messages.add(m);
      }
    }

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    bool narrow = MediaQuery.of(context).size.width < 600;
    bool wide = MediaQuery.of(context).size.width > 1000;
    bool showDrawer = MediaQuery.of(context).size.width < 1250;

    List<Message> messagesBuild = messages;
    idFrom = idFrom;

    return Scaffold(
      appBar: ChatAppBar(
          context,
          user,
          NetworkImage(
              'https://parsefiles.back4app.com/P8CudbQwTfa32Tc0rxXw3AXHmVPV9EPzIBh3alUB/69044f2e59e31dd8a3bb84adbf8570e6_fox%20placeholder.png'),
          'A test Correspondence with a longer name'),
      //appBar: AppBar(),

      endDrawer: !showDrawer
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
                        return MessageBubble(
                          message: messagesBuild[index].message!,
                          idFrom: messagesBuild[index].toAndFromCheck(idFrom),
                        );
                      }),
                ),
              ),
              // text entry field
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        //focusNode: textFocusNode,
                        key: Key('Message'),
                        onTap: () {
                          Timer(
                              Duration(milliseconds: 400),
                              () => scrollController.jumpTo(
                                  scrollController.position.maxScrollExtent));
                        },
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          if (textController.text.length > 0) {
                            message = textController.text;
                            _sendMessage();
                            textController.clear();
                          }
                        },
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                        ),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Theme.of(context).selectedRowColor,
                            ),
                            hintText: "Write message...",
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: () {
                        if (textController.text.length > 0) {
                          message = textController.text;
                          _sendMessage();
                          textController.clear();
                          FocusScope.of(context).unfocus();
                        }
                        FocusScope.of(context).unfocus();
                      },
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).canvasColor,
                        size: 18,
                      ),
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
    return result.data?["userchats"]['count'];
  }

  static String getSummary(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["correspondence"]
        ["summary"];
  }

  static String getId(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["correspondence"]
        ["objectId"];
  }

  static String getName(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["members"]["edges"][0]
        ["node"]["user"]["employee"]["organization"]["name"];
  }

  static String getImageURL(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["members"]["edges"][0]
        ["node"]["user"]["employee"]["organization"]["logo"]["url"];
  }

  static ImageProvider getImage(QueryResult result, int i) {
    return NetworkImage(result.data?["userchats"]["edges"][i]["node"]["members"]
            ["edges"][0]["node"]["user"]["employee"]["organization"]["logo"]
        ["url"]);
  }
}

class ChatBuilder extends StatelessWidget {
  const ChatBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  final bool narrow;
  final QueryResult result;

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
  const CorrespondenceTabbedWindowListBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  final bool narrow;
  final QueryResult result;

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

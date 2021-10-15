/* import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../../widgets/tabbedwindow/TabbedWindow.dart';
import '../../widgets/tabbedwindow/TabbedWindowList.dart';
import '../../widgets/tabbedwindow/TabbedWindowListOrganization.dart';
import '../../widgets/tabbedwindow/TabbedWindowListCorrespondence.dart';
import '../../widgets/DashHeader.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:google_sign_in/google_sign_in.dart';
class ChatUI extends StatefulWidget{
  @override
  _Chat
}
Widget _buildChat(HomeState state) {
    if (state is HomeLoaded) {
      lst = state.lstMessages;
    }
    return Stack(
      children: <Widget>[
        ListView.separated(
          itemCount: lst.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                color: (index % 2 == 0) ? Colors.grey.shade100 : Colors.grey.shade200,
                height: 55,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: (index % 2 == 0) ? Alignment.bottomLeft : Alignment.bottomRight,
                      child: Text(
                        lst[index].user.objectId,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    Align(
                      alignment: (index % 2 == 0) ? Alignment.bottomLeft : Alignment.bottomRight,
                      child: Text(
                        lst[index].message,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
            color: Colors.white12,
          ),
        ),
        _buildMessageBox(),
      ],
    );
  }

  Widget _buildMessageBox() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Form(
            key: _formKey,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    key: Key('Message'),
                    validator: NameFieldValidator.validate,
                    onSaved: (value) => _message = value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: _sendMessage,
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'MESSAGES',
                style: Theme.of(context).textTheme.headline5,
              ),
              elevation: 0.5,
            ),
            body: _buildListOfMessages(state));
      },
    );
  }

  void _handleLiveQuery() async {
    final LiveQuery liveQuery = LiveQuery(debug: true);
    QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Messages'));

    print('LiveQueryURL ${ParseCoreData().liveQueryURL}');

    Subscription subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      Message m = Message.clone().fromJson(jsonDecode(value.toString()));
      lst.add(m);
      setState(() {});
    });

    subscription.on(LiveQueryEvent.update, (value) {
      print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
    });

    subscription.on(LiveQueryEvent.delete, (value) {
      print('*** DELETE ***: ${DateTime.now().toString()}\n $value ');
    });

    print('Subscribe done');
  } */
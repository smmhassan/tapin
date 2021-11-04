import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/home/home_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/home/home_states.dart';
import 'package:customer_service/screens/userchats/lib/data/models/message.dart';
import 'package:customer_service/screens/userchats/lib/data/validators/name_validator.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _message;
  late HomeCubit _homeCubit;
  late List<Message> lst;

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    // ignore: deprecated_member_use
    lst = <Message>[];
    _handleLiveQuery();
    super.initState();
  }

  Widget _buildListOfMessages(HomeState state) {
    if (state is HomeLoaded) {
      lst = state.lstMessages;
    }
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: lst.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          physics: ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: (index % 2 == 0)
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: Text(
                      lst[index].user!.objectId!,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Align(
                    alignment: (index % 2 == 0)
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (index % 2 == 0)
                            ? Colors.grey.shade200
                            : Colors.blue[200],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        lst[index].message!,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        _buildMessageBox(),
      ],
    );
  }

  Widget _buildMessageBox() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextFormField(
                  key: Key('Message'),
                  validator: NameFieldValidator.validate,
                  onSaved: (value) => _message = value!,
                  decoration: InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: _sendMessage,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
                backgroundColor: Colors.blue,
                elevation: 0,
              ),
            ],
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
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Message'));

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
  }

  bool _validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _sendMessage() {
    if (_validateAndSave()) {
      _homeCubit.sendMessagePressed(message: _message);
    }
  }
}

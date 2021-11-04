///import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:customer_service/screens/userchats/lib/blocs/home/home_states.dart';
import 'package:customer_service/screens/userchats/lib/data/models/message.dart';
import 'package:customer_service/screens/userchats/lib/repositories/message_repos.dart';

class HomeCubit extends Cubit<HomeState> {
  final MessageRepository messageRepository;

  HomeCubit({required this.messageRepository})
      : assert(messageRepository != null),
        super(HomeLoading());

  Future<void> sendMessagePressed({required String message}) async {
    //emit(HomeLoading());
    try {
      bool result = await messageRepository.sendMessage(
        message: message,
      );

      if (result) {
        emit(SendMessageSuccess());
      } else {
        emit(Failure(error: 'Send message Failed'));
      }
    } catch (error) {
      emit(Failure(error: error.toString()));
    }
  }

  Future<void> homeStarted() async {
    emit(HomeLoading());
    try {
      List result = await messageRepository.loadAllMessages();
      emit(HomeLoaded(lstMessages: result));
    } catch (error) {
      emit(Failure(error: error.toString()));
    }
  }
}

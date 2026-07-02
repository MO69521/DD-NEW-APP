import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalizedAdsCubit extends Cubit<bool> {
  PersonalizedAdsCubit() : super(true);

  void setEnabled(bool value) {
    emit(value);
  }
}

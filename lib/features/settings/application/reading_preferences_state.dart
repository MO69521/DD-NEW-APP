import 'package:equatable/equatable.dart';

enum ReadingPreferenceGender {
  female('女生'),
  male('男生');

  const ReadingPreferenceGender(this.label);

  final String label;
}

enum ReadingPreferenceAge {
  under17('17岁以下'),
  age18To25('18-25岁'),
  age26To40('26-40岁'),
  over41('41岁以上');

  const ReadingPreferenceAge(this.label);

  final String label;
}

class ReadingPreferencesState extends Equatable {
  const ReadingPreferencesState({
    this.gender = ReadingPreferenceGender.female,
    this.age = ReadingPreferenceAge.under17,
  });

  final ReadingPreferenceGender gender;
  final ReadingPreferenceAge age;

  ReadingPreferencesState copyWith({
    ReadingPreferenceGender? gender,
    ReadingPreferenceAge? age,
  }) {
    return ReadingPreferencesState(
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

  @override
  List<Object?> get props => [gender, age];
}

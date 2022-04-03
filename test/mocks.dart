import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:timer_tracker_flutter_course/services/auth.dart';
import 'package:timer_tracker_flutter_course/services/database.dart';

class MockAuth extends Mock implements AuthBase {}

class MockDatabase extends Mock implements Database {}

class MockUser extends Mock implements User {
  MockUser();

  factory MockUser.uid(String uid) {
    final user = MockUser();

    when(user.uid).thenReturn(uid);
    return user;
  }
}

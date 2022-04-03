import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timer_tracker_flutter_course/app/sign_in/sing_in_manager.dart';

import 'mocks.dart';

class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = [];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuth mockAuth;
  MockValueNotifier<bool> isLoading;
  SignInManager manager;

  setUp(() {
    mockAuth = MockAuth();
    isLoading = MockValueNotifier(false);
    manager = SignInManager(auth: mockAuth, isLoading: isLoading);
  });

  test('sing-in - success', () async {
    when(mockAuth.signInAnonymously()).thenAnswer((_) => Future.value(
          MockUser.uid('123'),
        ));
    await manager.signInAnonymously();
    expect(isLoading.values, [true]);
  });

  test('sing-in - failure', () async {
    when(mockAuth.signInAnonymously())
        .thenThrow(PlatformException(code: 'ERROR', message: 'sign-in failed'));
    try {
      await manager.signInAnonymously();
    } catch (e) {
      expect(isLoading.values, [true, false]);
    }
  });
}

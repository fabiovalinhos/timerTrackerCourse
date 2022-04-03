import 'package:flutter_test/flutter_test.dart';
import 'package:timer_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  EmailSignInChangeModel model;

  setUp(() {
    mockAuth = MockAuth();
    model = EmailSignInChangeModel(auth: mockAuth);
  });

  test('updateEmail', () {
    var didNotifyListener = false;
    model.addListener(() => didNotifyListener = true);
    const sampleEmail = 'email@email';
    model.updateEmail(sampleEmail);

    expect(model.email, sampleEmail);
    expect(didNotifyListener, true);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:timer_tracker_flutter_course/app/home/job_entries/format.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-5), '0h');
    });

    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('date - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale, '');
    });

    test('2022-01-31', () {
      expect(Format.date(DateTime(2022, 01, 31)), '31 Jan 2022');
    });
  });

  group('dayOfWeek - GB locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale, '');
    });

    test('Monday', () {
      expect(Format.dayOfWeek(DateTime(2022, 01, 31)), 'Mon');
    });
  });

  group('dayOfWeek - IT locale', () {
    setUp(() async {
      Intl.defaultLocale = 'it_IT';
      await initializeDateFormatting(Intl.defaultLocale, '');
    });

    test('Ludeni', () {
      expect(Format.dayOfWeek(DateTime(2022, 01, 31)), 'lun');
    });
  });

  group('currency - US locale', () {
    setUp(() {
      Intl.defaultLocale = 'en_US';
    });

    test('positive', () {
      expect(Format.currency(10), '\$10');
    });
    test('zero', () {
      expect(Format.currency(0), '');
    });
    test('negative', () {
      expect(Format.currency(-5), '-\$5');
    });
  });
}

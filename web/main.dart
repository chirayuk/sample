import 'dart:collection';
import 'dart:html';

import 'package:di/di.dart';
import 'package:logging/logging.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';


class A {
  String _value = "";
  void set value(int n) {
    _value = n.toString();
  }

  String get prop => _value;
  String func() => _value;
}


@Controller(selector: '[root-controller]',
            publishAs: 'G')
class RootController {
  Scope scope;
  int skip_frames = 50;
  int skipped_frame = 0;
  int value = 100;

  RootController(this.scope) {
    scope.context['a'] = new A();
    _update(0);
  }

  _update(num num) {
    if (skipped_frame < skip_frames) {
      skipped_frame++;
    } else {
      skipped_frame=0;
      scope.context['a'].value = value++;
    }
    window.requestAnimationFrame(_update);
  }
}

@Controller(selector: '[ck-foo]',
            map: const {'.': '=>value'})
class Foo {
  String _value;
  set value(String v) {
    _value = v;
  }
}


void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}


Injector runApp() {
  setupLogger();
  var module = new Module()..bind(RootController);
  Injector injector = applicationFactory().addModule(module).run();
  assert(injector != null);
  return injector;
}

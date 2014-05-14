import 'dart:async' as async;
import 'dart:collection';
import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:route_hierarchical/client.dart';

import 'package:angular/angular.dart';
import 'package:angular/core_dom/module_internal.dart';
import 'package:angular/application_factory.dart';


class AppRoutes implements Function {
  void call(Router router, RouteViewFactory views) {
    views.configure({
      'admin': ngRoute(
          path: '/admin',
          view: '/admin.html',
          mount: {
              'admin_all': ngRoute(path: 'all',
                             view: '/admin_all.html',
                             defaultRoute: true),
          }),
      'foo': ngRoute(
          path: '/foo',
          view: '/foo.html',
          mount: {
              'foo_all': ngRoute(path: '/foo_all',
                             view: '/foo_all.html',
                             defaultRoute: true),
          }),
    });
  }
}



@Controller(selector: '[root-controller]',
            publishAs: 'G')
class RootController {
  Scope scope;
  String text = "chirayu@chirayuk.com";
  String transformed_text = "";

  RootController(Scope this.scope) {
    text = "chirayu@chirayuk.com";
    transformed_text = "";
  }

  OPERATION(String text) {
    transformed_text = "<<$text>>";
    print("OPERATION('$text') -> '${transformed_text}'");
  }
}


class AppModule extends Module {
  AppRoutes appRoutes = new AppRoutes();
  AppModule() {
    bind(RouteInitializerFn, toValue: appRoutes);
    bind(AppRoutes, toValue: appRoutes);
    bind(RootController);
  }
}


main() {
  applicationFactory().addModule(new AppModule()).run();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

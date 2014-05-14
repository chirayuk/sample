import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

@Controller(selector: '[root-controller]', publishAs: 'G')
class RootController {
  var items = ["new item"];

  addItem() => items.add("new item");
  removeItem() {
    if (items.length > 0) {
      items.removeLast();
    }
  }
}

main() {
  var module = new Module()..bind(RootController);
  applicationFactory().addModule(module).run();
}

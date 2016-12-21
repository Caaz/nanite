# Nanite

Nanite is a simple dart server package so that you can quickly and easily build and publish websites without hassle.

## Features
- Compiles views only when they're needed, Re-uses files previously compiled in the temporary folder.
- Probably fast.

## Example

### main.dart
```dart
import 'packages:nanite/nanite.dart';

main() {
  Nanite nanite = new Nanite('./tmp/');
  nanite
  ..addRoute(new Route('/',
  (Nani nani) {
    print('Got match on ${nani.request.uri}!');
    nani.render.pug('test.pug',{'name': 'Caaz'});
  }))
  ..listen('0.0.0.0',3000);
}
```
### test.pug
```pug
doctype html
html
  head
    title Hello World
  body
    p Hello, #{name}! You're using Nanite!

```

## To-do
- [ ] Make sure jaded is doing everything pug does
- [ ] Implement SSL listener
- [ ] Implement a CSS Preprocessor
- [ ] Write some documentation

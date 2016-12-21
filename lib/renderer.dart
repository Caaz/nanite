part of nanite;

class Renderer {
  HttpRequest req;
  String tmp;
  Renderer(this.req, this.tmp);
  _hash(String str) {
    var hval = 0x811c9dc5;
    for (int i = 0, l = str.length; i < l; i++) {
      hval ^= str.codeUnitAt(i);
      hval += (hval << 1) + (hval << 4) + (hval << 7) + (hval << 8) + (hval << 24);
    }
    String hashed = ('0000000' + (hval >> 0).toString());
    return hashed.substring(hashed.length-8);
  }
  pug(String file, [Object data]) {
    String hash = _hash(file+data.toString());
    File source = new File(file);
    File precompiled = new File(tmp+hash);
    if(precompiled.existsSync() && (precompiled.lastModifiedSync().isAfter(source.lastModifiedSync()))) {
      print('Rendering precompiled copy.');
      String html = precompiled.readAsStringSync();
      write(ContentType.HTML, html);
    } else {
      print('Compiling file to $hash');
      String src = source.readAsStringSync();
      var renderAsync = jade.compile(src);
      renderAsync(data).then((html) {
        write(ContentType.HTML, html);
        precompiled.writeAsStringSync(html);
      });
    }
  }
  write(ContentType type, Object data) {
    req.response.statusCode = 200;
    req.response.headers.contentType = type;
    req.response.write(data);
    req.response.close();
  }
}

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/routing.coffee                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var fs;
fs = Npm.require('fs');
Router.map(function () {
  return this.route('dump', {
    path: '/dump/:token',
    where: 'server',
    action: function () {
      var basename, content, e, filename, stats;
      basename = this.params.token + ".rwf";
      filename = "/tmp" + "/" + basename;

      try {
        stats = fs.statSync(filename);

        if (stats.isFile()) {
          this.response.writeHead(200, {
            "Content-Type": "application/octet-stream",
            "Content-Length": stats.size,
            "Pragma": "public",
            "Expires": "0",
            "Cache-Control": "must-revalidate, post-check=0, pre-check=0",
            "Content-Disposition": "attachment; filename=\"" + basename + "\"",
            "Content-Transfer-Encoding": "binary"
          });
          content = fs.readFileSync(filename);
          this.response.write(content);
          this.response.end();
          return;
        }
      } catch (error) {
        e = error;
      }

      this.response.writeHead(404);
      return this.response.end();
    }
  });
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/routing.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3JvdXRpbmcuY29mZmVlIl0sIm5hbWVzIjpbImZzIiwiTnBtIiwicmVxdWlyZSIsIlJvdXRlciIsIm1hcCIsInJvdXRlIiwicGF0aCIsIndoZXJlIiwiYWN0aW9uIiwiYmFzZW5hbWUiLCJjb250ZW50IiwiZSIsImZpbGVuYW1lIiwic3RhdHMiLCJwYXJhbXMiLCJ0b2tlbiIsInN0YXRTeW5jIiwiaXNGaWxlIiwicmVzcG9uc2UiLCJ3cml0ZUhlYWQiLCJzaXplIiwicmVhZEZpbGVTeW5jIiwid3JpdGUiLCJlbmQiLCJlcnJvciJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUEsSUFBQUEsRUFBQTtBQUFBQSxFQUFBLEdBQUtDLEdBQUcsQ0FBQ0MsT0FBSixDQUFZLElBQVosQ0FBTDtBQUVBQyxNQUFNLENBQUNDLEdBQVAsQ0FBVztBQUdULFNBRkEsS0FBQ0MsS0FBRCxDQUFPLE1BQVAsRUFBZTtBQUNiQyxRQUFBLEVBQU0sY0FETztBQUViQyxTQUFBLEVBQU8sUUFGTTtBQUdiQyxVQUFBLEVBQVE7QUFDTixVQUFBQyxRQUFBLEVBQUFDLE9BQUEsRUFBQUMsQ0FBQSxFQUFBQyxRQUFBLEVBQUFDLEtBQUE7QUFBQUosY0FBQSxHQUFXLEtBQUNLLE1BQUQsQ0FBUUMsS0FBUixHQUFnQixNQUEzQjtBQUNBSCxjQUFBLEdBQVcsU0FBUyxHQUFULEdBQWVILFFBQTFCOztBQUNBO0FBQ0VJLGFBQUEsR0FBUWIsRUFBRSxDQUFDZ0IsUUFBSCxDQUFZSixRQUFaLENBQVI7O0FBQ0EsWUFBR0MsS0FBSyxDQUFDSSxNQUFOLEVBQUg7QUFDRSxlQUFDQyxRQUFELENBQVVDLFNBQVYsQ0FBb0IsR0FBcEIsRUFDRTtBQUFBLDRCQUFnQiwwQkFBaEI7QUFDQSw4QkFBa0JOLEtBQUssQ0FBQ08sSUFEeEI7QUFFQSxzQkFBVSxRQUZWO0FBR0EsdUJBQVcsR0FIWDtBQUlBLDZCQUFpQiw0Q0FKakI7QUFLQSxtQ0FBdUIsNEJBQTRCWCxRQUE1QixHQUF1QyxJQUw5RDtBQU1BLHlDQUE2QjtBQU43QixXQURGO0FBUUFDLGlCQUFBLEdBQVVWLEVBQUUsQ0FBQ3FCLFlBQUgsQ0FBZ0JULFFBQWhCLENBQVY7QUFDQSxlQUFDTSxRQUFELENBQVVJLEtBQVYsQ0FBZ0JaLE9BQWhCO0FBQ0EsZUFBQ1EsUUFBRCxDQUFVSyxHQUFWO0FBQ0E7QUFkSjtBQUFBLGVBQUFDLEtBQUE7QUFlTWIsU0FBQSxHQUFBYSxLQUFBO0FBT0w7O0FBTkQsV0FBQ04sUUFBRCxDQUFVQyxTQUFWLENBQW9CLEdBQXBCO0FBUUEsYUFQQSxLQUFDRCxRQUFELENBQVVLLEdBQVYsRUFPQTtBQTNCTTtBQUhLLEdBQWYsQ0FFQTtBQUhGLEciLCJmaWxlIjoiL3NlcnZlci9yb3V0aW5nLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbImZzID0gTnBtLnJlcXVpcmUoJ2ZzJylcblxuUm91dGVyLm1hcCAtPlxuICBAcm91dGUoJ2R1bXAnLCB7XG4gICAgcGF0aDogJy9kdW1wLzp0b2tlbicsXG4gICAgd2hlcmU6ICdzZXJ2ZXInLFxuICAgIGFjdGlvbjogLT5cbiAgICAgIGJhc2VuYW1lID0gQHBhcmFtcy50b2tlbiArIFwiLnJ3ZlwiXG4gICAgICBmaWxlbmFtZSA9IFwiL3RtcFwiICsgXCIvXCIgKyBiYXNlbmFtZVxuICAgICAgdHJ5XG4gICAgICAgIHN0YXRzID0gZnMuc3RhdFN5bmMoZmlsZW5hbWUpXG4gICAgICAgIGlmIHN0YXRzLmlzRmlsZSgpXG4gICAgICAgICAgQHJlc3BvbnNlLndyaXRlSGVhZCAyMDAsXG4gICAgICAgICAgICBcIkNvbnRlbnQtVHlwZVwiOiBcImFwcGxpY2F0aW9uL29jdGV0LXN0cmVhbVwiXG4gICAgICAgICAgICBcIkNvbnRlbnQtTGVuZ3RoXCI6IHN0YXRzLnNpemVcbiAgICAgICAgICAgIFwiUHJhZ21hXCI6IFwicHVibGljXCJcbiAgICAgICAgICAgIFwiRXhwaXJlc1wiOiBcIjBcIlxuICAgICAgICAgICAgXCJDYWNoZS1Db250cm9sXCI6IFwibXVzdC1yZXZhbGlkYXRlLCBwb3N0LWNoZWNrPTAsIHByZS1jaGVjaz0wXCJcbiAgICAgICAgICAgIFwiQ29udGVudC1EaXNwb3NpdGlvblwiOiBcImF0dGFjaG1lbnQ7IGZpbGVuYW1lPVxcXCJcIiArIGJhc2VuYW1lICsgXCJcXFwiXCJcbiAgICAgICAgICAgIFwiQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZ1wiOiBcImJpbmFyeVwiXG4gICAgICAgICAgY29udGVudCA9IGZzLnJlYWRGaWxlU3luYyhmaWxlbmFtZSlcbiAgICAgICAgICBAcmVzcG9uc2Uud3JpdGUoY29udGVudClcbiAgICAgICAgICBAcmVzcG9uc2UuZW5kKClcbiAgICAgICAgICByZXR1cm5cbiAgICAgIGNhdGNoIGVcbiAgICAgIEByZXNwb25zZS53cml0ZUhlYWQoNDA0KVxuICAgICAgQHJlc3BvbnNlLmVuZCgpXG4gIH0pXG4iXX0=

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/helpers.coffee                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
OriginalHandlebars.registerHelper("t", function (key, hash) {
  var params, result;
  params = {}; //default

  if (hash) {
    params = hash.hash;
  }

  result = root.i18n.t(key, params);
  return new OriginalHandlebars.SafeString(result);
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/helpers.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2hlbHBlcnMuY29mZmVlIl0sIm5hbWVzIjpbIk9yaWdpbmFsSGFuZGxlYmFycyIsInJlZ2lzdGVySGVscGVyIiwia2V5IiwiaGFzaCIsInBhcmFtcyIsInJlc3VsdCIsInJvb3QiLCJpMThuIiwidCIsIlNhZmVTdHJpbmciXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBQSxrQkFBa0IsQ0FBQ0MsY0FBbkIsQ0FBa0MsR0FBbEMsRUFBdUMsVUFBQ0MsR0FBRCxFQUFNQyxJQUFOO0FBQ3JDLE1BQUFDLE1BQUEsRUFBQUMsTUFBQTtBQUFBRCxRQUFBLEdBQVMsRUFBVCxDQURxQyxDQUNyQzs7QUFDQSxNQUF1QkQsSUFBdkI7QUFBQUMsVUFBQSxHQUFTRCxJQUFJLENBQUNBLElBQWQ7QUFHQzs7QUFGREUsUUFBQSxHQUFTQyxJQUFJLENBQUNDLElBQUwsQ0FBVUMsQ0FBVixDQUFZTixHQUFaLEVBQWlCRSxNQUFqQixDQUFUO0FBSUEsU0FIQSxJQUFJSixrQkFBa0IsQ0FBQ1MsVUFBdkIsQ0FBa0NKLE1BQWxDLENBR0E7QUFQRixHIiwiZmlsZSI6Ii9zZXJ2ZXIvaGVscGVycy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJPcmlnaW5hbEhhbmRsZWJhcnMucmVnaXN0ZXJIZWxwZXIgXCJ0XCIsIChrZXksIGhhc2gpIC0+XG4gIHBhcmFtcyA9IHt9ICNkZWZhdWx0XG4gIHBhcmFtcyA9IGhhc2guaGFzaCAgaWYgaGFzaFxuICByZXN1bHQgPSByb290LmkxOG4udChrZXksIHBhcmFtcylcbiAgbmV3IE9yaWdpbmFsSGFuZGxlYmFycy5TYWZlU3RyaW5nKHJlc3VsdClcbiJdfQ==

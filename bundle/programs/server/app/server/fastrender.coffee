(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/fastrender.coffee                                            //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
FastRender.onAllRoutes(function (params) {
  this.subscribe("currentUser");
  this.subscribe("users");
  this.subscribe("configs");
  this.subscribe("queries");
  this.subscribe("ipsets");
  return this.subscribe("tuples");
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/fastrender.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2Zhc3RyZW5kZXIuY29mZmVlIl0sIm5hbWVzIjpbIkZhc3RSZW5kZXIiLCJvbkFsbFJvdXRlcyIsInBhcmFtcyIsInN1YnNjcmliZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUFBLFVBQVUsQ0FBQ0MsV0FBWCxDQUF1QixVQUFDQyxNQUFEO0FBQ3JCLE9BQUNDLFNBQUQsQ0FBVyxhQUFYO0FBQ0EsT0FBQ0EsU0FBRCxDQUFXLE9BQVg7QUFDQSxPQUFDQSxTQUFELENBQVcsU0FBWDtBQUNBLE9BQUNBLFNBQUQsQ0FBVyxTQUFYO0FBQ0EsT0FBQ0EsU0FBRCxDQUFXLFFBQVg7QUFDQSxjQUFDQSxTQUFELENBQVcsUUFBWDtBQU5GLEciLCJmaWxlIjoiL3NlcnZlci9mYXN0cmVuZGVyLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbIkZhc3RSZW5kZXIub25BbGxSb3V0ZXMgKHBhcmFtcykgLT5cbiAgQHN1YnNjcmliZShcImN1cnJlbnRVc2VyXCIpXG4gIEBzdWJzY3JpYmUoXCJ1c2Vyc1wiKVxuICBAc3Vic2NyaWJlKFwiY29uZmlnc1wiKVxuICBAc3Vic2NyaWJlKFwicXVlcmllc1wiKVxuICBAc3Vic2NyaWJlKFwiaXBzZXRzXCIpXG4gIEBzdWJzY3JpYmUoXCJ0dXBsZXNcIilcbiJdfQ==

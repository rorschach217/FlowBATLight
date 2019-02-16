(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// common/ipsets.hooks.coffee                                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.IPSets.before.update(function (userId, ipset, fieldNames, modifier, options) {
  if (_.intersection(fieldNames, ["contents"]).length) {
    modifier.$set = modifier.$set || {};
    return modifier.$set.isOutputStale = true;
  }
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/common/ipsets.hooks.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvY29tbW9uL2lwc2V0cy5ob29rcy5jb2ZmZWUiXSwibmFtZXMiOlsic2hhcmUiLCJJUFNldHMiLCJiZWZvcmUiLCJ1cGRhdGUiLCJ1c2VySWQiLCJpcHNldCIsImZpZWxkTmFtZXMiLCJtb2RpZmllciIsIm9wdGlvbnMiLCJfIiwiaW50ZXJzZWN0aW9uIiwibGVuZ3RoIiwiJHNldCIsImlzT3V0cHV0U3RhbGUiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBQSxLQUFLLENBQUNDLE1BQU4sQ0FBYUMsTUFBYixDQUFvQkMsTUFBcEIsQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFULEVBQWdCQyxVQUFoQixFQUE0QkMsUUFBNUIsRUFBc0NDLE9BQXRDO0FBQ3pCLE1BQUdDLENBQUMsQ0FBQ0MsWUFBRixDQUFlSixVQUFmLEVBQTJCLENBQUMsVUFBRCxDQUEzQixFQUF5Q0ssTUFBNUM7QUFDRUosWUFBUSxDQUFDSyxJQUFULEdBQWdCTCxRQUFRLENBQUNLLElBQVQsSUFBaUIsRUFBakM7QUFDQSxXQUFBTCxRQUFRLENBQUNLLElBQVQsQ0FBY0MsYUFBZCxHQUE4QixJQUE5QjtBQUNEO0FBSkgsRyIsImZpbGUiOiIvY29tbW9uL2lwc2V0cy5ob29rcy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJzaGFyZS5JUFNldHMuYmVmb3JlLnVwZGF0ZSAodXNlcklkLCBpcHNldCwgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIGlmIF8uaW50ZXJzZWN0aW9uKGZpZWxkTmFtZXMsIFtcImNvbnRlbnRzXCJdKS5sZW5ndGhcbiAgICBtb2RpZmllci4kc2V0ID0gbW9kaWZpZXIuJHNldCBvciB7fVxuICAgIG1vZGlmaWVyLiRzZXQuaXNPdXRwdXRTdGFsZSA9IHRydWVcbiJdfQ==

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/configs.hooks.coffee                                         //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.Configs.after.update(function (userId, config) {
  share.IPSets.update({}, {
    $set: {
      isOutputStale: true
    }
  }, {
    multi: true
  });
  return share.Tuples.update({}, {
    $set: {
      isOutputStale: true
    }
  }, {
    multi: true
  });
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/configs.hooks.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2NvbmZpZ3MuaG9va3MuY29mZmVlIl0sIm5hbWVzIjpbInNoYXJlIiwiQ29uZmlncyIsImFmdGVyIiwidXBkYXRlIiwidXNlcklkIiwiY29uZmlnIiwiSVBTZXRzIiwiJHNldCIsImlzT3V0cHV0U3RhbGUiLCJtdWx0aSIsIlR1cGxlcyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUFBLEtBQUssQ0FBQ0MsT0FBTixDQUFjQyxLQUFkLENBQW9CQyxNQUFwQixDQUEyQixVQUFDQyxNQUFELEVBQVNDLE1BQVQ7QUFDekJMLE9BQUssQ0FBQ00sTUFBTixDQUFhSCxNQUFiLENBQW9CLEVBQXBCLEVBQXdCO0FBQUNJLFFBQUEsRUFBTTtBQUFDQyxtQkFBQSxFQUFlO0FBQWhCO0FBQVAsR0FBeEIsRUFBdUQ7QUFBQ0MsU0FBQSxFQUFPO0FBQVIsR0FBdkQ7QUFPQSxTQU5BVCxLQUFLLENBQUNVLE1BQU4sQ0FBYVAsTUFBYixDQUFvQixFQUFwQixFQUF3QjtBQUFDSSxRQUFBLEVBQU07QUFBQ0MsbUJBQUEsRUFBZTtBQUFoQjtBQUFQLEdBQXhCLEVBQXVEO0FBQUNDLFNBQUEsRUFBTztBQUFSLEdBQXZELENBTUE7QUFSRixHIiwiZmlsZSI6Ii9zZXJ2ZXIvY29uZmlncy5ob29rcy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJzaGFyZS5Db25maWdzLmFmdGVyLnVwZGF0ZSAodXNlcklkLCBjb25maWcpIC0+XG4gIHNoYXJlLklQU2V0cy51cGRhdGUoe30sIHskc2V0OiB7aXNPdXRwdXRTdGFsZTogdHJ1ZX19LCB7bXVsdGk6IHRydWV9KVxuICBzaGFyZS5UdXBsZXMudXBkYXRlKHt9LCB7JHNldDoge2lzT3V0cHV0U3RhbGU6IHRydWV9fSwge211bHRpOiB0cnVlfSlcbiJdfQ==

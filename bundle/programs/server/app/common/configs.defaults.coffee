(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// common/configs.defaults.coffee                                      //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var configPreSave;

configPreSave = function (userId, changes) {};

share.Configs.before.update(function (userId, config, fieldNames, modifier, options) {
  var now;
  now = new Date();
  modifier.$set = modifier.$set || {};
  modifier.$set.updatedAt = modifier.$set.updatedAt || now;
  return configPreSave.call(this, userId, modifier.$set);
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/common/configs.defaults.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvY29tbW9uL2NvbmZpZ3MuZGVmYXVsdHMuY29mZmVlIl0sIm5hbWVzIjpbImNvbmZpZ1ByZVNhdmUiLCJ1c2VySWQiLCJjaGFuZ2VzIiwic2hhcmUiLCJDb25maWdzIiwiYmVmb3JlIiwidXBkYXRlIiwiY29uZmlnIiwiZmllbGROYW1lcyIsIm1vZGlmaWVyIiwib3B0aW9ucyIsIm5vdyIsIkRhdGUiLCIkc2V0IiwidXBkYXRlZEF0IiwiY2FsbCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUEsSUFBQUEsYUFBQTs7QUFBQUEsYUFBQSxHQUFnQixVQUFDQyxNQUFELEVBQVNDLE9BQVQsSUFBaEI7O0FBRUFDLEtBQUssQ0FBQ0MsT0FBTixDQUFjQyxNQUFkLENBQXFCQyxNQUFyQixDQUE0QixVQUFDTCxNQUFELEVBQVNNLE1BQVQsRUFBaUJDLFVBQWpCLEVBQTZCQyxRQUE3QixFQUF1Q0MsT0FBdkM7QUFDMUIsTUFBQUMsR0FBQTtBQUFBQSxLQUFBLEdBQU0sSUFBSUMsSUFBSixFQUFOO0FBQ0FILFVBQVEsQ0FBQ0ksSUFBVCxHQUFnQkosUUFBUSxDQUFDSSxJQUFULElBQWlCLEVBQWpDO0FBQ0FKLFVBQVEsQ0FBQ0ksSUFBVCxDQUFjQyxTQUFkLEdBQTBCTCxRQUFRLENBQUNJLElBQVQsQ0FBY0MsU0FBZCxJQUEyQkgsR0FBckQ7QUFJQSxTQUhBWCxhQUFhLENBQUNlLElBQWQsQ0FBbUIsSUFBbkIsRUFBc0JkLE1BQXRCLEVBQThCUSxRQUFRLENBQUNJLElBQXZDLENBR0E7QUFQRixHIiwiZmlsZSI6Ii9jb21tb24vY29uZmlncy5kZWZhdWx0cy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJjb25maWdQcmVTYXZlID0gKHVzZXJJZCwgY2hhbmdlcykgLT5cblxuc2hhcmUuQ29uZmlncy5iZWZvcmUudXBkYXRlICh1c2VySWQsIGNvbmZpZywgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIG5vdyA9IG5ldyBEYXRlKClcbiAgbW9kaWZpZXIuJHNldCA9IG1vZGlmaWVyLiRzZXQgb3Ige31cbiAgbW9kaWZpZXIuJHNldC51cGRhdGVkQXQgPSBtb2RpZmllci4kc2V0LnVwZGF0ZWRBdCBvciBub3dcbiAgY29uZmlnUHJlU2F2ZS5jYWxsKEAsIHVzZXJJZCwgbW9kaWZpZXIuJHNldClcbiJdfQ==

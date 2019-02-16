(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/model/collections.coffee                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
// Don't use transforms, they break validation ("Expected plain object", but transforms give an extended object)
share.Emails = new Meteor.Collection("emails");
share.Queries = new Meteor.Collection("queries");
share.IPSets = new Meteor.Collection("ipsets");
share.Tuples = new Meteor.Collection("tuples");
share.Configs = new Meteor.Collection("configs");
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/model/collections.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL21vZGVsL2NvbGxlY3Rpb25zLmNvZmZlZSJdLCJuYW1lcyI6WyJzaGFyZSIsIkVtYWlscyIsIk1ldGVvciIsIkNvbGxlY3Rpb24iLCJRdWVyaWVzIiwiSVBTZXRzIiwiVHVwbGVzIiwiQ29uZmlncyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUE7QUFFQUEsS0FBSyxDQUFDQyxNQUFOLEdBQWUsSUFBSUMsTUFBTSxDQUFDQyxVQUFYLENBQXNCLFFBQXRCLENBQWY7QUFDQUgsS0FBSyxDQUFDSSxPQUFOLEdBQWdCLElBQUlGLE1BQU0sQ0FBQ0MsVUFBWCxDQUFzQixTQUF0QixDQUFoQjtBQUNBSCxLQUFLLENBQUNLLE1BQU4sR0FBZSxJQUFJSCxNQUFNLENBQUNDLFVBQVgsQ0FBc0IsUUFBdEIsQ0FBZjtBQUNBSCxLQUFLLENBQUNNLE1BQU4sR0FBZSxJQUFJSixNQUFNLENBQUNDLFVBQVgsQ0FBc0IsUUFBdEIsQ0FBZjtBQUNBSCxLQUFLLENBQUNPLE9BQU4sR0FBZ0IsSUFBSUwsTUFBTSxDQUFDQyxVQUFYLENBQXNCLFNBQXRCLENBQWhCLEMiLCJmaWxlIjoiL3NlcnZlci9tb2RlbC9jb2xsZWN0aW9ucy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyIjIERvbid0IHVzZSB0cmFuc2Zvcm1zLCB0aGV5IGJyZWFrIHZhbGlkYXRpb24gKFwiRXhwZWN0ZWQgcGxhaW4gb2JqZWN0XCIsIGJ1dCB0cmFuc2Zvcm1zIGdpdmUgYW4gZXh0ZW5kZWQgb2JqZWN0KVxuXG5zaGFyZS5FbWFpbHMgPSBuZXcgTWV0ZW9yLkNvbGxlY3Rpb24oXCJlbWFpbHNcIilcbnNoYXJlLlF1ZXJpZXMgPSBuZXcgTWV0ZW9yLkNvbGxlY3Rpb24oXCJxdWVyaWVzXCIpXG5zaGFyZS5JUFNldHMgPSBuZXcgTWV0ZW9yLkNvbGxlY3Rpb24oXCJpcHNldHNcIilcbnNoYXJlLlR1cGxlcyA9IG5ldyBNZXRlb3IuQ29sbGVjdGlvbihcInR1cGxlc1wiKVxuc2hhcmUuQ29uZmlncyA9IG5ldyBNZXRlb3IuQ29sbGVjdGlvbihcImNvbmZpZ3NcIilcbiJdfQ==

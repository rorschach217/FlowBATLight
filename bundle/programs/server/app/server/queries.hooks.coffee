(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/queries.hooks.coffee                                         //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.Queries.after.remove(function (userId, query) {
  return Meteor.users.update({
    "profile.dashboardQueryIds": query._id
  }, {
    $pull: {
      "profile.dashboardQueryIds": query._id
    }
  }, {
    multi: true
  });
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/queries.hooks.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3F1ZXJpZXMuaG9va3MuY29mZmVlIl0sIm5hbWVzIjpbInNoYXJlIiwiUXVlcmllcyIsImFmdGVyIiwicmVtb3ZlIiwidXNlcklkIiwicXVlcnkiLCJNZXRlb3IiLCJ1c2VycyIsInVwZGF0ZSIsIl9pZCIsIiRwdWxsIiwibXVsdGkiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBQSxLQUFLLENBQUNDLE9BQU4sQ0FBY0MsS0FBZCxDQUFvQkMsTUFBcEIsQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFUO0FBQ3pCLFNBQUFDLE1BQU0sQ0FBQ0MsS0FBUCxDQUFhQyxNQUFiLENBQW9CO0FBQUMsaUNBQTZCSCxLQUFLLENBQUNJO0FBQXBDLEdBQXBCLEVBQThEO0FBQUNDLFNBQUEsRUFBTztBQUFDLG1DQUE2QkwsS0FBSyxDQUFDSTtBQUFwQztBQUFSLEdBQTlELEVBQWlIO0FBQUNFLFNBQUEsRUFBTztBQUFSLEdBQWpIO0FBREYsRyIsImZpbGUiOiIvc2VydmVyL3F1ZXJpZXMuaG9va3MuY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsic2hhcmUuUXVlcmllcy5hZnRlci5yZW1vdmUgKHVzZXJJZCwgcXVlcnkpIC0+XG4gIE1ldGVvci51c2Vycy51cGRhdGUoe1wicHJvZmlsZS5kYXNoYm9hcmRRdWVyeUlkc1wiOiBxdWVyeS5faWR9LCB7JHB1bGw6IHtcInByb2ZpbGUuZGFzaGJvYXJkUXVlcnlJZHNcIjogcXVlcnkuX2lkfX0sIHttdWx0aTogdHJ1ZX0pXG4iXX0=

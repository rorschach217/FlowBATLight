(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/security/configs.coffee                                      //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.Configs.allow({
  insert: share.securityRulesWrapper(function (userId, config) {
    return false; // There can be only one!
  }),
  update: share.securityRulesWrapper(function (userId, config, fieldNames, modifier, options) {
    var $set;

    if (!share.Security.hasRole(userId, "admin")) {
      throw new Match.Error("Operation not allowed for non admins");
    }

    $set = {
      isSSH: Match.Optional(Boolean),
      host: Match.Optional(String),
      port: Match.Optional(String),
      user: Match.Optional(String),
      identityFile: Match.Optional(String),
      siteConfigFile: Match.Optional(String),
      dataRootdir: Match.Optional(String),
      dataTempdir: Match.Optional(String),
      isNew: Match.Optional(Match.App.isNewUpdate(config.isNew)),
      updatedAt: Date
    };

    if (!config.isSetupComplete) {
      _.extend($set, {
        isSetupComplete: Match.Optional(Boolean)
      });
    }

    check(modifier, {
      $set: $set
    });

    if (modifier.$set && _.has(modifier.$set, "siteConfigFile") && !modifier.$set.siteConfigFile) {
      throw new Match.Error("siteConfigFile required");
    }

    if (modifier.$set && _.has(modifier.$set, "dataRootdir") && !modifier.$set.dataRootdir) {
      throw new Match.Error("dataRootdir required");
    }

    if (modifier.$set && _.has(modifier.$set, "dataTempdir") && !modifier.$set.dataTempdir) {
      throw new Match.Error("dataTempdir required");
    }

    return true;
  }),
  remove: share.securityRulesWrapper(function (userId, config) {
    return false; // Who wants to live forever?
  })
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/security/configs.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3NlY3VyaXR5L2NvbmZpZ3MuY29mZmVlIl0sIm5hbWVzIjpbInNoYXJlIiwiQ29uZmlncyIsImFsbG93IiwiaW5zZXJ0Iiwic2VjdXJpdHlSdWxlc1dyYXBwZXIiLCJ1c2VySWQiLCJjb25maWciLCJ1cGRhdGUiLCJmaWVsZE5hbWVzIiwibW9kaWZpZXIiLCJvcHRpb25zIiwiJHNldCIsIlNlY3VyaXR5IiwiaGFzUm9sZSIsIk1hdGNoIiwiRXJyb3IiLCJpc1NTSCIsIk9wdGlvbmFsIiwiQm9vbGVhbiIsImhvc3QiLCJTdHJpbmciLCJwb3J0IiwidXNlciIsImlkZW50aXR5RmlsZSIsInNpdGVDb25maWdGaWxlIiwiZGF0YVJvb3RkaXIiLCJkYXRhVGVtcGRpciIsImlzTmV3IiwiQXBwIiwiaXNOZXdVcGRhdGUiLCJ1cGRhdGVkQXQiLCJEYXRlIiwiaXNTZXR1cENvbXBsZXRlIiwiXyIsImV4dGVuZCIsImNoZWNrIiwiaGFzIiwicmVtb3ZlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQUEsS0FBSyxDQUFDQyxPQUFOLENBQWNDLEtBQWQsQ0FDRTtBQUFBQyxRQUFBLEVBQVFILEtBQUssQ0FBQ0ksb0JBQU4sQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxNQUFUO0FBQ2pDLGlCQURpQztBQUEzQixJQUFSO0FBRUFDLFFBQUEsRUFBUVAsS0FBSyxDQUFDSSxvQkFBTixDQUEyQixVQUFDQyxNQUFELEVBQVNDLE1BQVQsRUFBaUJFLFVBQWpCLEVBQTZCQyxRQUE3QixFQUF1Q0MsT0FBdkM7QUFDakMsUUFBQUMsSUFBQTs7QUFBQSxTQUFPWCxLQUFLLENBQUNZLFFBQU4sQ0FBZUMsT0FBZixDQUF1QlIsTUFBdkIsRUFBK0IsT0FBL0IsQ0FBUDtBQUNFLFlBQU0sSUFBSVMsS0FBSyxDQUFDQyxLQUFWLENBQWdCLHNDQUFoQixDQUFOO0FBR0Q7O0FBRkRKLFFBQUEsR0FDRTtBQUFBSyxXQUFBLEVBQU9GLEtBQUssQ0FBQ0csUUFBTixDQUFlQyxPQUFmLENBQVA7QUFDQUMsVUFBQSxFQUFNTCxLQUFLLENBQUNHLFFBQU4sQ0FBZUcsTUFBZixDQUROO0FBRUFDLFVBQUEsRUFBTVAsS0FBSyxDQUFDRyxRQUFOLENBQWVHLE1BQWYsQ0FGTjtBQUdBRSxVQUFBLEVBQU1SLEtBQUssQ0FBQ0csUUFBTixDQUFlRyxNQUFmLENBSE47QUFJQUcsa0JBQUEsRUFBY1QsS0FBSyxDQUFDRyxRQUFOLENBQWVHLE1BQWYsQ0FKZDtBQUtBSSxvQkFBQSxFQUFnQlYsS0FBSyxDQUFDRyxRQUFOLENBQWVHLE1BQWYsQ0FMaEI7QUFNQUssaUJBQUEsRUFBYVgsS0FBSyxDQUFDRyxRQUFOLENBQWVHLE1BQWYsQ0FOYjtBQU9BTSxpQkFBQSxFQUFhWixLQUFLLENBQUNHLFFBQU4sQ0FBZUcsTUFBZixDQVBiO0FBUUFPLFdBQUEsRUFBT2IsS0FBSyxDQUFDRyxRQUFOLENBQWVILEtBQUssQ0FBQ2MsR0FBTixDQUFVQyxXQUFWLENBQXNCdkIsTUFBTSxDQUFDcUIsS0FBN0IsQ0FBZixDQVJQO0FBU0FHLGVBQUEsRUFBV0M7QUFUWCxLQURGOztBQVdBLFFBQUcsQ0FBSXpCLE1BQU0sQ0FBQzBCLGVBQWQ7QUFDRUMsT0FBQyxDQUFDQyxNQUFGLENBQVN2QixJQUFULEVBQ0U7QUFBQXFCLHVCQUFBLEVBQWlCbEIsS0FBSyxDQUFDRyxRQUFOLENBQWVDLE9BQWY7QUFBakIsT0FERjtBQU9EOztBQUpEaUIsU0FBQSxDQUFNMUIsUUFBTixFQUNFO0FBQUFFLFVBQUEsRUFBTUE7QUFBTixLQURGOztBQUdBLFFBQUdGLFFBQVEsQ0FBQ0UsSUFBVCxJQUFrQnNCLENBQUMsQ0FBQ0csR0FBRixDQUFNM0IsUUFBUSxDQUFDRSxJQUFmLEVBQXFCLGdCQUFyQixDQUFsQixJQUE2RCxDQUFJRixRQUFRLENBQUNFLElBQVQsQ0FBY2EsY0FBbEY7QUFDRSxZQUFNLElBQUlWLEtBQUssQ0FBQ0MsS0FBVixDQUFnQix5QkFBaEIsQ0FBTjtBQU1EOztBQUxELFFBQUdOLFFBQVEsQ0FBQ0UsSUFBVCxJQUFrQnNCLENBQUMsQ0FBQ0csR0FBRixDQUFNM0IsUUFBUSxDQUFDRSxJQUFmLEVBQXFCLGFBQXJCLENBQWxCLElBQTBELENBQUlGLFFBQVEsQ0FBQ0UsSUFBVCxDQUFjYyxXQUEvRTtBQUNFLFlBQU0sSUFBSVgsS0FBSyxDQUFDQyxLQUFWLENBQWdCLHNCQUFoQixDQUFOO0FBT0Q7O0FBTkQsUUFBR04sUUFBUSxDQUFDRSxJQUFULElBQWtCc0IsQ0FBQyxDQUFDRyxHQUFGLENBQU0zQixRQUFRLENBQUNFLElBQWYsRUFBcUIsYUFBckIsQ0FBbEIsSUFBMEQsQ0FBSUYsUUFBUSxDQUFDRSxJQUFULENBQWNlLFdBQS9FO0FBQ0UsWUFBTSxJQUFJWixLQUFLLENBQUNDLEtBQVYsQ0FBZ0Isc0JBQWhCLENBQU47QUFRRDs7QUFDRCxXQVJBLElBUUE7QUFuQ00sSUFGUjtBQThCQXNCLFFBQUEsRUFBUXJDLEtBQUssQ0FBQ0ksb0JBQU4sQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxNQUFUO0FBVWpDLFdBVEEsS0FTQSxDQVZpQztBQUEzQjtBQTlCUixDQURGLEUiLCJmaWxlIjoiL3NlcnZlci9zZWN1cml0eS9jb25maWdzLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlLkNvbmZpZ3MuYWxsb3dcbiAgaW5zZXJ0OiBzaGFyZS5zZWN1cml0eVJ1bGVzV3JhcHBlciAodXNlcklkLCBjb25maWcpIC0+XG4gICAgZmFsc2UgIyBUaGVyZSBjYW4gYmUgb25seSBvbmUhXG4gIHVwZGF0ZTogc2hhcmUuc2VjdXJpdHlSdWxlc1dyYXBwZXIgKHVzZXJJZCwgY29uZmlnLCBmaWVsZE5hbWVzLCBtb2RpZmllciwgb3B0aW9ucykgLT5cbiAgICB1bmxlc3Mgc2hhcmUuU2VjdXJpdHkuaGFzUm9sZSh1c2VySWQsIFwiYWRtaW5cIilcbiAgICAgIHRocm93IG5ldyBNYXRjaC5FcnJvcihcIk9wZXJhdGlvbiBub3QgYWxsb3dlZCBmb3Igbm9uIGFkbWluc1wiKVxuICAgICRzZXQgPVxuICAgICAgaXNTU0g6IE1hdGNoLk9wdGlvbmFsKEJvb2xlYW4pXG4gICAgICBob3N0OiBNYXRjaC5PcHRpb25hbChTdHJpbmcpXG4gICAgICBwb3J0OiBNYXRjaC5PcHRpb25hbChTdHJpbmcpXG4gICAgICB1c2VyOiBNYXRjaC5PcHRpb25hbChTdHJpbmcpXG4gICAgICBpZGVudGl0eUZpbGU6IE1hdGNoLk9wdGlvbmFsKFN0cmluZylcbiAgICAgIHNpdGVDb25maWdGaWxlOiBNYXRjaC5PcHRpb25hbChTdHJpbmcpXG4gICAgICBkYXRhUm9vdGRpcjogTWF0Y2guT3B0aW9uYWwoU3RyaW5nKVxuICAgICAgZGF0YVRlbXBkaXI6IE1hdGNoLk9wdGlvbmFsKFN0cmluZylcbiAgICAgIGlzTmV3OiBNYXRjaC5PcHRpb25hbChNYXRjaC5BcHAuaXNOZXdVcGRhdGUoY29uZmlnLmlzTmV3KSlcbiAgICAgIHVwZGF0ZWRBdDogRGF0ZVxuICAgIGlmIG5vdCBjb25maWcuaXNTZXR1cENvbXBsZXRlXG4gICAgICBfLmV4dGVuZCgkc2V0LFxuICAgICAgICBpc1NldHVwQ29tcGxldGU6IE1hdGNoLk9wdGlvbmFsKEJvb2xlYW4pXG4gICAgICApXG4gICAgY2hlY2sobW9kaWZpZXIsXG4gICAgICAkc2V0OiAkc2V0XG4gICAgKVxuICAgIGlmIG1vZGlmaWVyLiRzZXQgYW5kIF8uaGFzKG1vZGlmaWVyLiRzZXQsIFwic2l0ZUNvbmZpZ0ZpbGVcIikgYW5kIG5vdCBtb2RpZmllci4kc2V0LnNpdGVDb25maWdGaWxlXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJzaXRlQ29uZmlnRmlsZSByZXF1aXJlZFwiKVxuICAgIGlmIG1vZGlmaWVyLiRzZXQgYW5kIF8uaGFzKG1vZGlmaWVyLiRzZXQsIFwiZGF0YVJvb3RkaXJcIikgYW5kIG5vdCBtb2RpZmllci4kc2V0LmRhdGFSb290ZGlyXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJkYXRhUm9vdGRpciByZXF1aXJlZFwiKVxuICAgIGlmIG1vZGlmaWVyLiRzZXQgYW5kIF8uaGFzKG1vZGlmaWVyLiRzZXQsIFwiZGF0YVRlbXBkaXJcIikgYW5kIG5vdCBtb2RpZmllci4kc2V0LmRhdGFUZW1wZGlyXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJkYXRhVGVtcGRpciByZXF1aXJlZFwiKVxuICAgIHRydWVcbiAgcmVtb3ZlOiBzaGFyZS5zZWN1cml0eVJ1bGVzV3JhcHBlciAodXNlcklkLCBjb25maWcpIC0+XG4gICAgZmFsc2UgIyBXaG8gd2FudHMgdG8gbGl2ZSBmb3JldmVyP1xuIl19

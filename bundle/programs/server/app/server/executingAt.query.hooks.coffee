(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/executingAt.query.hooks.coffee                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var indexOf = [].indexOf;
share.Queries.before.update(function (userId, query, fieldNames, modifier, options) {
  if (modifier.$set) {
    if (_.has(modifier.$set, "executingInterval")) {
      if (modifier.$set.executingInterval) {
        return modifier.$set.executingAt = new Date(new Date().getTime() + modifier.$set.executingInterval);
      } else {
        return modifier.$set.executingAt = null;
      }
    }
  }
});
share.Queries.after.update(function (userId, query, fieldNames, modifier, options) {
  if (options.skipResetTimeout) {
    return;
  }

  if (indexOf.call(fieldNames, "executingAt") >= 0 && query.executingAt) {
    return share.periodicExecution.resetTimeout();
  }
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/executingAt.query.hooks.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2V4ZWN1dGluZ0F0LnF1ZXJ5Lmhvb2tzLmNvZmZlZSJdLCJuYW1lcyI6WyJpbmRleE9mIiwic2hhcmUiLCJRdWVyaWVzIiwiYmVmb3JlIiwidXBkYXRlIiwidXNlcklkIiwicXVlcnkiLCJmaWVsZE5hbWVzIiwibW9kaWZpZXIiLCJvcHRpb25zIiwiJHNldCIsIl8iLCJoYXMiLCJleGVjdXRpbmdJbnRlcnZhbCIsImV4ZWN1dGluZ0F0IiwiRGF0ZSIsImdldFRpbWUiLCJhZnRlciIsInNraXBSZXNldFRpbWVvdXQiLCJjYWxsIiwicGVyaW9kaWNFeGVjdXRpb24iLCJyZXNldFRpbWVvdXQiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBLElBQUFBLE9BQUEsTUFBQUEsT0FBQTtBQUFBQyxLQUFLLENBQUNDLE9BQU4sQ0FBY0MsTUFBZCxDQUFxQkMsTUFBckIsQ0FBNEIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFULEVBQWdCQyxVQUFoQixFQUE0QkMsUUFBNUIsRUFBc0NDLE9BQXRDO0FBQzFCLE1BQUdELFFBQVEsQ0FBQ0UsSUFBWjtBQUNFLFFBQUdDLENBQUMsQ0FBQ0MsR0FBRixDQUFNSixRQUFRLENBQUNFLElBQWYsRUFBcUIsbUJBQXJCLENBQUg7QUFDRSxVQUFHRixRQUFRLENBQUNFLElBQVQsQ0FBY0csaUJBQWpCO0FBR0UsZUFGQUwsUUFBUSxDQUFDRSxJQUFULENBQWNJLFdBQWQsR0FBNEIsSUFBSUMsSUFBSixDQUFTLElBQUlBLElBQUosR0FBV0MsT0FBWCxLQUF1QlIsUUFBUSxDQUFDRSxJQUFULENBQWNHLGlCQUE5QyxDQUU1QjtBQUhGO0FBS0UsZUFGQUwsUUFBUSxDQUFDRSxJQUFULENBQWNJLFdBQWQsR0FBNEIsSUFFNUI7QUFOSjtBQURGO0FBVUM7QUFYSDtBQVFBYixLQUFLLENBQUNDLE9BQU4sQ0FBY2UsS0FBZCxDQUFvQmIsTUFBcEIsQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFULEVBQWdCQyxVQUFoQixFQUE0QkMsUUFBNUIsRUFBc0NDLE9BQXRDO0FBQ3pCLE1BQUdBLE9BQU8sQ0FBQ1MsZ0JBQVg7QUFDRTtBQU9EOztBQU5ELE1BQUdsQixPQUFBLENBQUFtQixJQUFBLENBQWlCWixVQUFqQix5QkFBZ0NELEtBQUssQ0FBQ1EsV0FBekM7QUFRRSxXQVBBYixLQUFLLENBQUNtQixpQkFBTixDQUF3QkMsWUFBeEIsRUFPQTtBQUNEO0FBWkgsRyIsImZpbGUiOiIvc2VydmVyL2V4ZWN1dGluZ0F0LnF1ZXJ5Lmhvb2tzLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlLlF1ZXJpZXMuYmVmb3JlLnVwZGF0ZSAodXNlcklkLCBxdWVyeSwgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIGlmIG1vZGlmaWVyLiRzZXRcbiAgICBpZiBfLmhhcyhtb2RpZmllci4kc2V0LCBcImV4ZWN1dGluZ0ludGVydmFsXCIpXG4gICAgICBpZiBtb2RpZmllci4kc2V0LmV4ZWN1dGluZ0ludGVydmFsXG4gICAgICAgIG1vZGlmaWVyLiRzZXQuZXhlY3V0aW5nQXQgPSBuZXcgRGF0ZShuZXcgRGF0ZSgpLmdldFRpbWUoKSArIG1vZGlmaWVyLiRzZXQuZXhlY3V0aW5nSW50ZXJ2YWwpXG4gICAgICBlbHNlXG4gICAgICAgIG1vZGlmaWVyLiRzZXQuZXhlY3V0aW5nQXQgPSBudWxsXG5cbnNoYXJlLlF1ZXJpZXMuYWZ0ZXIudXBkYXRlICh1c2VySWQsIHF1ZXJ5LCBmaWVsZE5hbWVzLCBtb2RpZmllciwgb3B0aW9ucykgLT5cbiAgaWYgb3B0aW9ucy5za2lwUmVzZXRUaW1lb3V0XG4gICAgcmV0dXJuXG4gIGlmIFwiZXhlY3V0aW5nQXRcIiBpbiBmaWVsZE5hbWVzIGFuZCBxdWVyeS5leGVjdXRpbmdBdFxuICAgIHNoYXJlLnBlcmlvZGljRXhlY3V0aW9uLnJlc2V0VGltZW91dCgpIl19

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/security/users.coffee                                        //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
Meteor.users.allow({
  insert: share.securityRulesWrapper(function (userId, user) {
    return false;
  }),
  update: share.securityRulesWrapper(function (userId, user, fieldNames, modifier) {
    if (!share.Security.hasRole(userId, "admin")) {
      throw new Match.Error("Operation not allowed for non admins");
    }

    return true;
  }),
  remove: share.securityRulesWrapper(function (userId, user) {
    if (!userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    if (userId === user._id) {
      throw new Match.Error("User can't remove himself");
    }

    if (!share.Security.hasRole(userId, "admin")) {
      throw new Match.Error("Operation not allowed for non admins");
    }

    return true;
  })
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/security/users.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3NlY3VyaXR5L3VzZXJzLmNvZmZlZSJdLCJuYW1lcyI6WyJNZXRlb3IiLCJ1c2VycyIsImFsbG93IiwiaW5zZXJ0Iiwic2hhcmUiLCJzZWN1cml0eVJ1bGVzV3JhcHBlciIsInVzZXJJZCIsInVzZXIiLCJ1cGRhdGUiLCJmaWVsZE5hbWVzIiwibW9kaWZpZXIiLCJTZWN1cml0eSIsImhhc1JvbGUiLCJNYXRjaCIsIkVycm9yIiwicmVtb3ZlIiwiX2lkIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQUEsTUFBTSxDQUFDQyxLQUFQLENBQWFDLEtBQWIsQ0FDRTtBQUFBQyxRQUFBLEVBQVFDLEtBQUssQ0FBQ0Msb0JBQU4sQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxJQUFUO0FBQ2pDO0FBRE0sSUFBUjtBQUVBQyxRQUFBLEVBQVFKLEtBQUssQ0FBQ0Msb0JBQU4sQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxJQUFULEVBQWVFLFVBQWYsRUFBMkJDLFFBQTNCO0FBQ2pDLFNBQU9OLEtBQUssQ0FBQ08sUUFBTixDQUFlQyxPQUFmLENBQXVCTixNQUF2QixFQUErQixPQUEvQixDQUFQO0FBQ0UsWUFBTSxJQUFJTyxLQUFLLENBQUNDLEtBQVYsQ0FBZ0Isc0NBQWhCLENBQU47QUFFRDs7QUFDRCxXQUZBLElBRUE7QUFMTSxJQUZSO0FBTUFDLFFBQUEsRUFBUVgsS0FBSyxDQUFDQyxvQkFBTixDQUEyQixVQUFDQyxNQUFELEVBQVNDLElBQVQ7QUFDakMsU0FBT0QsTUFBUDtBQUNFLFlBQU0sSUFBSU8sS0FBSyxDQUFDQyxLQUFWLENBQWdCLDhDQUFoQixDQUFOO0FBSUQ7O0FBSEQsUUFBR1IsTUFBQSxLQUFVQyxJQUFJLENBQUNTLEdBQWxCO0FBQ0UsWUFBTSxJQUFJSCxLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsMkJBQWhCLENBQU47QUFLRDs7QUFKRCxTQUFPVixLQUFLLENBQUNPLFFBQU4sQ0FBZUMsT0FBZixDQUF1Qk4sTUFBdkIsRUFBK0IsT0FBL0IsQ0FBUDtBQUNFLFlBQU0sSUFBSU8sS0FBSyxDQUFDQyxLQUFWLENBQWdCLHNDQUFoQixDQUFOO0FBTUQ7O0FBQ0QsV0FOQSxJQU1BO0FBYk07QUFOUixDQURGLEUiLCJmaWxlIjoiL3NlcnZlci9zZWN1cml0eS91c2Vycy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJNZXRlb3IudXNlcnMuYWxsb3dcbiAgaW5zZXJ0OiBzaGFyZS5zZWN1cml0eVJ1bGVzV3JhcHBlciAodXNlcklkLCB1c2VyKSAtPlxuICAgIGZhbHNlXG4gIHVwZGF0ZTogc2hhcmUuc2VjdXJpdHlSdWxlc1dyYXBwZXIgKHVzZXJJZCwgdXNlciwgZmllbGROYW1lcywgbW9kaWZpZXIpIC0+XG4gICAgdW5sZXNzIHNoYXJlLlNlY3VyaXR5Lmhhc1JvbGUodXNlcklkLCBcImFkbWluXCIpXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIG5vbiBhZG1pbnNcIilcbiAgICB0cnVlXG4gIHJlbW92ZTogc2hhcmUuc2VjdXJpdHlSdWxlc1dyYXBwZXIgKHVzZXJJZCwgdXNlcikgLT5cbiAgICB1bmxlc3MgdXNlcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIHVuYXV0aG9yaXplZCB1c2Vyc1wiKVxuICAgIGlmIHVzZXJJZCBpcyB1c2VyLl9pZFxuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiVXNlciBjYW4ndCByZW1vdmUgaGltc2VsZlwiKVxuICAgIHVubGVzcyBzaGFyZS5TZWN1cml0eS5oYXNSb2xlKHVzZXJJZCwgXCJhZG1pblwiKVxuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiT3BlcmF0aW9uIG5vdCBhbGxvd2VkIGZvciBub24gYWRtaW5zXCIpXG4gICAgdHJ1ZVxuIl19

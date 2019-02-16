(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// lib/security.coffee                                                 //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var indexOf = [].indexOf;
share.Security = {
  effectiveRoles: {
    admin: ["admin", "analyst"],
    analyst: ["admin", "analyst"]
  },
  groups: function () {
    return Object.keys(this.effectiveRoles);
  },
  currentUserHasRole: function (role) {
    return share.Security.hasRole(Meteor.userId(), role);
  },
  userIdCanChangeUserGroupOrRemove: function (userId, user) {
    return userId !== user._id && this.hasRole(userId, "admin");
  },
  hasRole: function (userId, role) {
    var user;
    user = Meteor.users.findOne(userId);

    if (user) {
      if (indexOf.call(share.Security.effectiveRoles[user.group], role) >= 0) {
        return true;
      }
    }

    return false;
  }
};
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/lib/security.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvbGliL3NlY3VyaXR5LmNvZmZlZSJdLCJuYW1lcyI6WyJpbmRleE9mIiwic2hhcmUiLCJTZWN1cml0eSIsImVmZmVjdGl2ZVJvbGVzIiwiYWRtaW4iLCJhbmFseXN0IiwiZ3JvdXBzIiwiT2JqZWN0Iiwia2V5cyIsImN1cnJlbnRVc2VySGFzUm9sZSIsInJvbGUiLCJoYXNSb2xlIiwiTWV0ZW9yIiwidXNlcklkIiwidXNlcklkQ2FuQ2hhbmdlVXNlckdyb3VwT3JSZW1vdmUiLCJ1c2VyIiwiX2lkIiwidXNlcnMiLCJmaW5kT25lIiwiY2FsbCIsImdyb3VwIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxPQUFBLE1BQUFBLE9BQUE7QUFBQUMsS0FBSyxDQUFDQyxRQUFOLEdBQ0U7QUFBQUMsZ0JBQUEsRUFDRTtBQUFBQyxTQUFBLEVBQU8sQ0FBQyxPQUFELEVBQVUsU0FBVixDQUFQO0FBQ0FDLFdBQUEsRUFBUyxDQUFDLE9BQUQsRUFBVSxTQUFWO0FBRFQsR0FERjtBQUdBQyxRQUFBLEVBQVE7QUFJTixXQUhBQyxNQUFNLENBQUNDLElBQVAsQ0FBWSxLQUFDTCxjQUFiLENBR0E7QUFQRjtBQUtBTSxvQkFBQSxFQUFvQixVQUFDQyxJQUFEO0FBS2xCLFdBSkFULEtBQUssQ0FBQ0MsUUFBTixDQUFlUyxPQUFmLENBQXVCQyxNQUFNLENBQUNDLE1BQVAsRUFBdkIsRUFBd0NILElBQXhDLENBSUE7QUFWRjtBQU9BSSxrQ0FBQSxFQUFrQyxVQUFDRCxNQUFELEVBQVNFLElBQVQ7QUFNaEMsV0FMQUYsTUFBQSxLQUFZRSxJQUFJLENBQUNDLEdBQWpCLElBQXlCLEtBQUNMLE9BQUQsQ0FBU0UsTUFBVCxFQUFpQixPQUFqQixDQUt6QjtBQWJGO0FBU0FGLFNBQUEsRUFBUyxVQUFDRSxNQUFELEVBQVNILElBQVQ7QUFDUCxRQUFBSyxJQUFBO0FBQUFBLFFBQUEsR0FBT0gsTUFBTSxDQUFDSyxLQUFQLENBQWFDLE9BQWIsQ0FBcUJMLE1BQXJCLENBQVA7O0FBQ0EsUUFBR0UsSUFBSDtBQUNFLFVBQUdmLE9BQUEsQ0FBQW1CLElBQUEsQ0FBUWxCLEtBQUssQ0FBQ0MsUUFBTixDQUFlQyxjQUFmLENBQThCWSxJQUFJLENBQUNLLEtBQW5DLENBQVIsRUFBQVYsSUFBQSxNQUFIO0FBQ0UsZUFBTyxJQUFQO0FBRko7QUFXQzs7QUFSRCxXQUFPLEtBQVA7QUFMTztBQVRULENBREYsQyIsImZpbGUiOiIvbGliL3NlY3VyaXR5LmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlLlNlY3VyaXR5ID1cbiAgZWZmZWN0aXZlUm9sZXM6XG4gICAgYWRtaW46IFtcImFkbWluXCIsIFwiYW5hbHlzdFwiXVxuICAgIGFuYWx5c3Q6IFtcImFkbWluXCIsIFwiYW5hbHlzdFwiXVxuICBncm91cHM6IC0+XG4gICAgT2JqZWN0LmtleXMoQGVmZmVjdGl2ZVJvbGVzKVxuICBjdXJyZW50VXNlckhhc1JvbGU6IChyb2xlKSAtPlxuICAgIHNoYXJlLlNlY3VyaXR5Lmhhc1JvbGUoTWV0ZW9yLnVzZXJJZCgpLCByb2xlKVxuICB1c2VySWRDYW5DaGFuZ2VVc2VyR3JvdXBPclJlbW92ZTogKHVzZXJJZCwgdXNlcikgLT5cbiAgICB1c2VySWQgaXNudCB1c2VyLl9pZCBhbmQgQGhhc1JvbGUodXNlcklkLCBcImFkbWluXCIpXG4gIGhhc1JvbGU6ICh1c2VySWQsIHJvbGUpIC0+XG4gICAgdXNlciA9IE1ldGVvci51c2Vycy5maW5kT25lKHVzZXJJZClcbiAgICBpZiB1c2VyXG4gICAgICBpZiByb2xlIGluIHNoYXJlLlNlY3VyaXR5LmVmZmVjdGl2ZVJvbGVzW3VzZXIuZ3JvdXBdXG4gICAgICAgIHJldHVybiB0cnVlXG4gICAgcmV0dXJuIGZhbHNlXG4iXX0=

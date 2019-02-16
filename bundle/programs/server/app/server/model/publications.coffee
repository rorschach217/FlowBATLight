(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/model/publications.coffee                                    //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
//Meteor.publish "loginServiceConfigurationData", () ->
//  Accounts.loginServiceConfiguration.find({})
Meteor.publish("currentUser", function () {
  if (!this.userId) {
    return [];
  }

  return Meteor.users.find({
    _id: this.userId
  }, {
    fields: {
      "group": 1,
      "emails": 1,
      "profile": 1,
      "status": 1,
      "createdAt": 1
    }
  });
});
Meteor.publish("users", function () {
  if (!this.userId) {
    return [];
  }

  if (share.Security.hasRole(this.userId, "admin")) {
    return Meteor.users.find({}, {
      fields: {
        "group": 1,
        "emails": 1,
        "profile": 1,
        "status": 1,
        "createdAt": 1
      }
    });
  } else {
    return [];
  }
});
Meteor.publish("configs", function () {
  var config;

  if (!this.userId) {
    config = share.Configs.findOne();

    if (config && !config.isSetupComplete) {
      return share.Configs.find();
    }

    return [];
  }

  if (share.Security.hasRole(this.userId, "admin")) {
    return share.Configs.find();
  } else {
    return [];
  }
});
Meteor.publish("queries", function () {
  if (!this.userId) {
    return [];
  }

  return share.Queries.find({
    ownerId: this.userId
  });
});
Meteor.publish("ipsets", function () {
  if (!this.userId) {
    return [];
  }

  return share.IPSets.find({
    ownerId: this.userId
  });
});
Meteor.publish("tuples", function () {
  if (!this.userId) {
    return [];
  }

  return share.Tuples.find({
    ownerId: this.userId
  });
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/model/publications.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL21vZGVsL3B1YmxpY2F0aW9ucy5jb2ZmZWUiXSwibmFtZXMiOlsiTWV0ZW9yIiwicHVibGlzaCIsInVzZXJJZCIsInVzZXJzIiwiZmluZCIsIl9pZCIsImZpZWxkcyIsInNoYXJlIiwiU2VjdXJpdHkiLCJoYXNSb2xlIiwiY29uZmlnIiwiQ29uZmlncyIsImZpbmRPbmUiLCJpc1NldHVwQ29tcGxldGUiLCJRdWVyaWVzIiwib3duZXJJZCIsIklQU2V0cyIsIlR1cGxlcyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUE7QUFDQTtBQUVBQSxNQUFNLENBQUNDLE9BQVAsQ0FBZSxhQUFmLEVBQThCO0FBQzVCLE1BQUcsQ0FBSSxLQUFDQyxNQUFSO0FBQW9CLFdBQU8sRUFBUDtBQUNuQjs7QUFDRCxTQURBRixNQUFNLENBQUNHLEtBQVAsQ0FBYUMsSUFBYixDQUFrQjtBQUFDQyxPQUFBLEVBQUssS0FBQ0g7QUFBUCxHQUFsQixFQUNFO0FBQUFJLFVBQUEsRUFDRTtBQUFBLGVBQVMsQ0FBVDtBQUNBLGdCQUFVLENBRFY7QUFFQSxpQkFBVyxDQUZYO0FBR0EsZ0JBQVUsQ0FIVjtBQUlBLG1CQUFhO0FBSmI7QUFERixHQURGLENBQ0E7QUFIRjtBQVdBTixNQUFNLENBQUNDLE9BQVAsQ0FBZSxPQUFmLEVBQXdCO0FBQ3RCLE1BQUcsQ0FBSSxLQUFDQyxNQUFSO0FBQW9CLFdBQU8sRUFBUDtBQU9uQjs7QUFORCxNQUFHSyxLQUFLLENBQUNDLFFBQU4sQ0FBZUMsT0FBZixDQUF1QixLQUFDUCxNQUF4QixFQUFnQyxPQUFoQyxDQUFIO0FBUUUsV0FQQUYsTUFBTSxDQUFDRyxLQUFQLENBQWFDLElBQWIsQ0FBa0IsRUFBbEIsRUFDRTtBQUFBRSxZQUFBLEVBQ0U7QUFBQSxpQkFBUyxDQUFUO0FBQ0Esa0JBQVUsQ0FEVjtBQUVBLG1CQUFXLENBRlg7QUFHQSxrQkFBVSxDQUhWO0FBSUEscUJBQWE7QUFKYjtBQURGLEtBREYsQ0FPQTtBQVJGO0FBa0JFLFdBUkEsRUFRQTtBQUNEO0FBckJIO0FBY0FOLE1BQU0sQ0FBQ0MsT0FBUCxDQUFlLFNBQWYsRUFBMEI7QUFDeEIsTUFBQVMsTUFBQTs7QUFBQSxNQUFHLENBQUksS0FBQ1IsTUFBUjtBQUNFUSxVQUFBLEdBQVNILEtBQUssQ0FBQ0ksT0FBTixDQUFjQyxPQUFkLEVBQVQ7O0FBQ0EsUUFBR0YsTUFBQSxJQUFXLENBQUlBLE1BQU0sQ0FBQ0csZUFBekI7QUFDRSxhQUFPTixLQUFLLENBQUNJLE9BQU4sQ0FBY1AsSUFBZCxFQUFQO0FBWUQ7O0FBWEQsV0FBTyxFQUFQO0FBYUQ7O0FBWkQsTUFBR0csS0FBSyxDQUFDQyxRQUFOLENBQWVDLE9BQWYsQ0FBdUIsS0FBQ1AsTUFBeEIsRUFBZ0MsT0FBaEMsQ0FBSDtBQUNFLFdBQU9LLEtBQUssQ0FBQ0ksT0FBTixDQUFjUCxJQUFkLEVBQVA7QUFERjtBQUdFLFdBQU8sRUFBUDtBQWNEO0FBdkJIO0FBV0FKLE1BQU0sQ0FBQ0MsT0FBUCxDQUFlLFNBQWYsRUFBMEI7QUFDeEIsTUFBRyxDQUFJLEtBQUNDLE1BQVI7QUFBb0IsV0FBTyxFQUFQO0FBaUJuQjs7QUFDRCxTQWpCQUssS0FBSyxDQUFDTyxPQUFOLENBQWNWLElBQWQsQ0FBbUI7QUFBQ1csV0FBQSxFQUFTLEtBQUNiO0FBQVgsR0FBbkIsQ0FpQkE7QUFuQkY7QUFJQUYsTUFBTSxDQUFDQyxPQUFQLENBQWUsUUFBZixFQUF5QjtBQUN2QixNQUFHLENBQUksS0FBQ0MsTUFBUjtBQUFvQixXQUFPLEVBQVA7QUFzQm5COztBQUNELFNBdEJBSyxLQUFLLENBQUNTLE1BQU4sQ0FBYVosSUFBYixDQUFrQjtBQUFDVyxXQUFBLEVBQVMsS0FBQ2I7QUFBWCxHQUFsQixDQXNCQTtBQXhCRjtBQUlBRixNQUFNLENBQUNDLE9BQVAsQ0FBZSxRQUFmLEVBQXlCO0FBQ3ZCLE1BQUcsQ0FBSSxLQUFDQyxNQUFSO0FBQW9CLFdBQU8sRUFBUDtBQTJCbkI7O0FBQ0QsU0EzQkFLLEtBQUssQ0FBQ1UsTUFBTixDQUFhYixJQUFiLENBQWtCO0FBQUNXLFdBQUEsRUFBUyxLQUFDYjtBQUFYLEdBQWxCLENBMkJBO0FBN0JGLEciLCJmaWxlIjoiL3NlcnZlci9tb2RlbC9wdWJsaWNhdGlvbnMuY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsiI01ldGVvci5wdWJsaXNoIFwibG9naW5TZXJ2aWNlQ29uZmlndXJhdGlvbkRhdGFcIiwgKCkgLT5cbiMgIEFjY291bnRzLmxvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24uZmluZCh7fSlcblxuTWV0ZW9yLnB1Ymxpc2ggXCJjdXJyZW50VXNlclwiLCAoKSAtPlxuICBpZiBub3QgQHVzZXJJZCB0aGVuIHJldHVybiBbXVxuICBNZXRlb3IudXNlcnMuZmluZCh7X2lkOiBAdXNlcklkfSxcbiAgICBmaWVsZHM6XG4gICAgICBcImdyb3VwXCI6IDFcbiAgICAgIFwiZW1haWxzXCI6IDFcbiAgICAgIFwicHJvZmlsZVwiOiAxXG4gICAgICBcInN0YXR1c1wiOiAxXG4gICAgICBcImNyZWF0ZWRBdFwiOiAxXG4gIClcblxuTWV0ZW9yLnB1Ymxpc2ggXCJ1c2Vyc1wiLCAtPlxuICBpZiBub3QgQHVzZXJJZCB0aGVuIHJldHVybiBbXVxuICBpZiBzaGFyZS5TZWN1cml0eS5oYXNSb2xlKEB1c2VySWQsIFwiYWRtaW5cIilcbiAgICBNZXRlb3IudXNlcnMuZmluZCh7fSxcbiAgICAgIGZpZWxkczpcbiAgICAgICAgXCJncm91cFwiOiAxXG4gICAgICAgIFwiZW1haWxzXCI6IDFcbiAgICAgICAgXCJwcm9maWxlXCI6IDFcbiAgICAgICAgXCJzdGF0dXNcIjogMVxuICAgICAgICBcImNyZWF0ZWRBdFwiOiAxXG4gICAgKVxuICBlbHNlXG4gICAgW11cblxuTWV0ZW9yLnB1Ymxpc2ggXCJjb25maWdzXCIsIC0+XG4gIGlmIG5vdCBAdXNlcklkXG4gICAgY29uZmlnID0gc2hhcmUuQ29uZmlncy5maW5kT25lKClcbiAgICBpZiBjb25maWcgYW5kIG5vdCBjb25maWcuaXNTZXR1cENvbXBsZXRlXG4gICAgICByZXR1cm4gc2hhcmUuQ29uZmlncy5maW5kKClcbiAgICByZXR1cm4gW11cbiAgaWYgc2hhcmUuU2VjdXJpdHkuaGFzUm9sZShAdXNlcklkLCBcImFkbWluXCIpXG4gICAgcmV0dXJuIHNoYXJlLkNvbmZpZ3MuZmluZCgpXG4gIGVsc2VcbiAgICByZXR1cm4gW11cblxuTWV0ZW9yLnB1Ymxpc2ggXCJxdWVyaWVzXCIsIC0+XG4gIGlmIG5vdCBAdXNlcklkIHRoZW4gcmV0dXJuIFtdXG4gIHNoYXJlLlF1ZXJpZXMuZmluZCh7b3duZXJJZDogQHVzZXJJZH0pXG5cbk1ldGVvci5wdWJsaXNoIFwiaXBzZXRzXCIsIC0+XG4gIGlmIG5vdCBAdXNlcklkIHRoZW4gcmV0dXJuIFtdXG4gIHNoYXJlLklQU2V0cy5maW5kKHtvd25lcklkOiBAdXNlcklkfSlcblxuTWV0ZW9yLnB1Ymxpc2ggXCJ0dXBsZXNcIiwgLT5cbiAgaWYgbm90IEB1c2VySWQgdGhlbiByZXR1cm4gW11cbiAgc2hhcmUuVHVwbGVzLmZpbmQoe293bmVySWQ6IEB1c2VySWR9KVxuIl19

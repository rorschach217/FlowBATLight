(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/methods.coffee                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.getMailDomail = function () {
  var matches;

  if (process.env.MAIL_URL) {
    matches = process.env.MAIL_URL.match(/\/\/(.+)%40(.+):(.+)@(.+):(\d+)/);
    return matches[2];
  }

  return "";
};

Meteor.methods({
  setPassword: function (userId, password) {
    check(userId, String);
    check(password, String);

    if (!(userId === this.userId || share.Security.hasRole(this.userId, "admin"))) {
      Meteor._debug("Setting password is not allowed for non admins");

      return;
    }

    return Accounts.setPassword(userId, password);
  },
  addNewUser: function (newUser) {
    var config, user, userId;
    check(newUser, {
      email: Match.App.Email,
      name: String,
      password: String,
      group: Match.App.InArray(share.Security.groups())
    });
    newUser.email = newUser.email.toLowerCase();

    if (this.userId) {
      if (!share.Security.hasRole(this.userId, "admin")) {
        Meteor._debug("Creating users is not allowed for non admins");

        return;
      }
    } else {
      config = share.Configs.findOne();

      if (config.isSetupComplete) {
        Meteor._debug("Creating users is not allowed for non admins");

        return;
      } else {
        newUser.group = "admin";
      }
    }

    userId = Accounts.createUser({
      email: newUser.email,
      password: newUser.password,
      profile: {
        name: newUser.name
      }
    });
    Meteor.users.update(userId, {
      $set: {
        group: newUser.group
      }
    });
    user = Meteor.users.findOne(userId);
    Email.send({
      from: '"' + root.i18n.t("messages.postman") + ' (FlowBAT)" <herald@' + share.getMailDomail() + '>',
      to: newUser.email,
      subject: Handlebars.templates["newUserSubject"]({
        user: user,
        settings: Meteor.settings
      }).trim(),
      html: Handlebars.templates["newUserHtml"]({
        user: user,
        email: newUser.email,
        password: newUser.password,
        settings: Meteor.settings
      }).trim()
    });
    return userId;
  }
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/methods.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL21ldGhvZHMuY29mZmVlIl0sIm5hbWVzIjpbInNoYXJlIiwiZ2V0TWFpbERvbWFpbCIsIm1hdGNoZXMiLCJwcm9jZXNzIiwiZW52IiwiTUFJTF9VUkwiLCJtYXRjaCIsIk1ldGVvciIsIm1ldGhvZHMiLCJzZXRQYXNzd29yZCIsInVzZXJJZCIsInBhc3N3b3JkIiwiY2hlY2siLCJTdHJpbmciLCJTZWN1cml0eSIsImhhc1JvbGUiLCJfZGVidWciLCJBY2NvdW50cyIsImFkZE5ld1VzZXIiLCJuZXdVc2VyIiwiY29uZmlnIiwidXNlciIsImVtYWlsIiwiTWF0Y2giLCJBcHAiLCJFbWFpbCIsIm5hbWUiLCJncm91cCIsIkluQXJyYXkiLCJncm91cHMiLCJ0b0xvd2VyQ2FzZSIsIkNvbmZpZ3MiLCJmaW5kT25lIiwiaXNTZXR1cENvbXBsZXRlIiwiY3JlYXRlVXNlciIsInByb2ZpbGUiLCJ1c2VycyIsInVwZGF0ZSIsIiRzZXQiLCJzZW5kIiwiZnJvbSIsInJvb3QiLCJpMThuIiwidCIsInRvIiwic3ViamVjdCIsIkhhbmRsZWJhcnMiLCJ0ZW1wbGF0ZXMiLCJzZXR0aW5ncyIsInRyaW0iLCJodG1sIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQUEsS0FBSyxDQUFDQyxhQUFOLEdBQXNCO0FBQ3BCLE1BQUFDLE9BQUE7O0FBQUEsTUFBR0MsT0FBTyxDQUFDQyxHQUFSLENBQVlDLFFBQWY7QUFDRUgsV0FBQSxHQUFVQyxPQUFPLENBQUNDLEdBQVIsQ0FBWUMsUUFBWixDQUFxQkMsS0FBckIsQ0FBMkIsaUNBQTNCLENBQVY7QUFDQSxXQUFPSixPQUFRLEdBQWY7QUFFRDs7QUFERCxTQUFPLEVBQVA7QUFKb0IsQ0FBdEI7O0FBTUFLLE1BQU0sQ0FBQ0MsT0FBUCxDQUNFO0FBQUFDLGFBQUEsRUFBYSxVQUFDQyxNQUFELEVBQVNDLFFBQVQ7QUFDWEMsU0FBQSxDQUFNRixNQUFOLEVBQWNHLE1BQWQ7QUFDQUQsU0FBQSxD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RFU7QUFQWixDQURGLEUiLCJmaWxlIjoiL3NlcnZlci9tZXRob2RzLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlLmdldE1haWxEb21haWwgPSAtPlxuICBpZiBwcm9jZXNzLmVudi5NQUlMX1VSTFxuICAgIG1hdGNoZXMgPSBwcm9jZXNzLmVudi5NQUlMX1VSTC5tYXRjaCgvXFwvXFwvKC4rKSU0MCguKyk6KC4rKUAoLispOihcXGQrKS8pXG4gICAgcmV0dXJuIG1hdGNoZXNbMl1cbiAgcmV0dXJuIFwiXCJcblxuTWV0ZW9yLm1ldGhvZHNcbiAgc2V0UGFzc3dvcmQ6ICh1c2VySWQsIHBhc3N3b3JkKSAtPlxuICAgIGNoZWNrKHVzZXJJZCwgU3RyaW5nKVxuICAgIGNoZWNrKHBhc3N3b3JkLCBTdHJpbmcpXG4gICAgdW5sZXNzIHVzZXJJZCBpcyBAdXNlcklkIG9yIHNoYXJlLlNlY3VyaXR5Lmhhc1JvbGUoQHVzZXJJZCwgXCJhZG1pblwiKVxuICAgICAgTWV0ZW9yLl9kZWJ1ZyhcIlNldHRpbmcgcGFzc3dvcmQgaXMgbm90IGFsbG93ZWQgZm9yIG5vbiBhZG1pbnNcIilcbiAgICAgIHJldHVyblxuICAgIEFjY291bnRzLnNldFBhc3N3b3JkKHVzZXJJZCwgcGFzc3dvcmQpXG4gIGFkZE5ld1VzZXI6IChuZXdVc2VyKSAtPlxuICAgIGNoZWNrIG5ld1VzZXIsXG4gICAgICBlbWFpbDogTWF0Y2guQXBwLkVtYWlsXG4gICAgICBuYW1lOiBTdHJpbmdcbiAgICAgIHBhc3N3b3JkOiBTdHJpbmdcbiAgICAgIGdyb3VwOiBNYXRjaC5BcHAuSW5BcnJheShzaGFyZS5TZWN1cml0eS5ncm91cHMoKSlcbiAgICBuZXdVc2VyLmVtYWlsID0gbmV3VXNlci5lbWFpbC50b0xvd2VyQ2FzZSgpXG4gICAgaWYgQHVzZXJJZFxuICAgICAgaWYgbm90IHNoYXJlLlNlY3VyaXR5Lmhhc1JvbGUoQHVzZXJJZCwgXCJhZG1pblwiKVxuICAgICAgICBNZXRlb3IuX2RlYnVnKFwiQ3JlYXRpbmcgdXNlcnMgaXMgbm90IGFsbG93ZWQgZm9yIG5vbiBhZG1pbnNcIilcbiAgICAgICAgcmV0dXJuXG4gICAgZWxzZVxuICAgICAgY29uZmlnID0gc2hhcmUuQ29uZmlncy5maW5kT25lKClcbiAgICAgIGlmIGNvbmZpZy5pc1NldHVwQ29tcGxldGVcbiAgICAgICAgTWV0ZW9yLl9kZWJ1ZyhcIkNyZWF0aW5nIHVzZXJzIGlzIG5vdCBhbGxvd2VkIGZvciBub24gYWRtaW5zXCIpXG4gICAgICAgIHJldHVyblxuICAgICAgZWxzZVxuICAgICAgICBuZXdVc2VyLmdyb3VwID0gXCJhZG1pblwiXG4gICAgdXNlcklkID0gQWNjb3VudHMuY3JlYXRlVXNlclxuICAgICAgZW1haWw6IG5ld1VzZXIuZW1haWxcbiAgICAgIHBhc3N3b3JkOiBuZXdVc2VyLnBhc3N3b3JkXG4gICAgICBwcm9maWxlOlxuICAgICAgICBuYW1lOiBuZXdVc2VyLm5hbWVcbiAgICBNZXRlb3IudXNlcnMudXBkYXRlKHVzZXJJZCwgeyRzZXQ6IHtncm91cDogbmV3VXNlci5ncm91cH19KVxuICAgIHVzZXIgPSBNZXRlb3IudXNlcnMuZmluZE9uZSh1c2VySWQpXG4gICAgRW1haWwuc2VuZFxuICAgICAgZnJvbTogJ1wiJyArIHJvb3QuaTE4bi50KFwibWVzc2FnZXMucG9zdG1hblwiKSArICcgKEZsb3dCQVQpXCIgPGhlcmFsZEAnICsgc2hhcmUuZ2V0TWFpbERvbWFpbCgpICsgJz4nXG4gICAgICB0bzogbmV3VXNlci5lbWFpbFxuICAgICAgc3ViamVjdDogSGFuZGxlYmFycy50ZW1wbGF0ZXNbXCJuZXdVc2VyU3ViamVjdFwiXSh1c2VyOiB1c2VyLCBzZXR0aW5nczogTWV0ZW9yLnNldHRpbmdzKS50cmltKClcbiAgICAgIGh0bWw6IEhhbmRsZWJhcnMudGVtcGxhdGVzW1wibmV3VXNlckh0bWxcIl0odXNlcjogdXNlciwgZW1haWw6IG5ld1VzZXIuZW1haWwsIHBhc3N3b3JkOiBuZXdVc2VyLnBhc3N3b3JkLCBzZXR0aW5nczogTWV0ZW9yLnNldHRpbmdzKS50cmltKClcbiAgICB1c2VySWRcbiJdfQ==

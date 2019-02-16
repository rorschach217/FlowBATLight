(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// common/users.defaults.coffee                                        //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var getInitials, userPreSave;

getInitials = function (name) {
  var firstLetters, firstWords;
  firstWords = _.first(name.replace(/\s+/g, " ").trim().split(" "), 2);

  if (firstWords.length < 2) {
    firstLetters = firstWords[0].substring(0, 2);
  } else {
    firstLetters = _.map(firstWords || [], function (word) {
      return word.charAt(0);
    }).join("");
  }

  return firstLetters.toUpperCase();
};

userPreSave = function (userId, changes) {
  var ref;

  if ((ref = changes.profile) != null ? ref.name : void 0) {
    changes.profile.initials = getInitials(changes.profile.name);
  }

  if (changes["profile.name"]) {
    return changes["profile.initials"] = getInitials(changes["profile.name"]);
  }
};

Meteor.users.before.insert(function (userId, user) {
  _.defaults(user, {
    isNew: true,
    isInvitation: false,
    invitations: []
  });

  _.defaults(user.profile, {
    numRecs: 10,
    dashboardQueryIds: [],
    isRealName: false
  });

  return userPreSave.call(this, userId, user);
});
Meteor.users.before.update(function (userId, user, fieldNames, modifier, options) {
  return userPreSave.call(this, userId, modifier.$set || {});
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/common/users.defaults.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvY29tbW9uL3VzZXJzLmRlZmF1bHRzLmNvZmZlZSJdLCJuYW1lcyI6WyJnZXRJbml0aWFscyIsInVzZXJQcmVTYXZlIiwibmFtZSIsImZpcnN0TGV0dGVycyIsImZpcnN0V29yZHMiLCJfIiwiZmlyc3QiLCJyZXBsYWNlIiwidHJpbSIsInNwbGl0IiwibGVuZ3RoIiwic3Vic3RyaW5nIiwibWFwIiwid29yZCIsImNoYXJBdCIsImpvaW4iLCJ0b1VwcGVyQ2FzZSIsInVzZXJJZCIsImNoYW5nZXMiLCJyZWYiLCJwcm9maWxlIiwiaW5pdGlhbHMiLCJNZXRlb3IiLCJ1c2VycyIsImJlZm9yZSIsImluc2VydCIsInVzZXIiLCJkZWZhdWx0cyIsImlzTmV3IiwiaXNJbnZpdGF0aW9uIiwiaW52aXRhdGlvbnMiLCJudW1SZWNzIiwiZGFzaGJvYXJkUXVlcnlJZHMiLCJpc1JlYWxOYW1lIiwiY2FsbCIsInVwZGF0ZSIsImZpZWxkTmFtZXMiLCJtb2RpZmllciIsIm9wdGlvbnMiLCIkc2V0Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxXQUFBLEVBQUFDLFdBQUE7O0FBQUFELFdBQUEsR0FBYyxVQUFDRSxJQUFEO0FBQ1osTUFBQUMsWUFBQSxFQUFBQyxVQUFBO0FBQUFBLFlBQUEsR0FBYUMsQ0FBQyxDQUFDQyxLQUFGLENBQVFKLElBQUksQ0FBQ0ssT0FBTCxDQUFhLE1BQWIsRUFBcUIsR0FBckIsRUFBMEJDLElBQTFCLEdBQWlDQyxLQUFqQyxDQUF1QyxHQUF2QyxDQUFSLEVBQXFELENBQXJELENBQWI7O0FBQ0EsTUFBR0wsVUFBVSxDQUFDTSxNQUFYLEdBQW9CLENBQXZCO0FBQ0VQLGdCQUFBLEdBQWVDLFVBQVcsR0FBWCxDQUFjTyxTQUFkLENBQXdCLENBQXhCLEVBQTJCLENBQTNCLENBQWY7QUFERjtBQUdFUixnQkFBQSxHQUFlRSxDQUFDLENBQUNPLEdBQUYsQ0FBTVIsVUFBQSxJQUFjLEVBQXBCLEVBQXdCLFVBQUNTLElBQUQ7QUFJckMsYUFIQUEsSUFBSSxDQUFDQyxNQUFMLENBQVksQ0FBWixDQUdBO0FBSmEsT0FDR0MsSUFESCxDQUNRLEVBRFIsQ0FBZjtBQU1EOztBQUNELFNBTEFaLFlBQVksQ0FBQ2EsV0FBYixFQUtBO0FBWlksQ0FBZDs7QUFTQWYsV0FBQSxHQUFjLFVBQUNnQixNQUFELEVBQVNDLE9BQVQ7QUFDWixNQUFBQyxHQUFBOztBQUFBLE9BQUFBLEdBQUEsR0FBQUQsT0FBQSxDQUFBRSxPQUFBLFlBQUFELEdBQWtCLENBQUVqQixJQUFwQixHQUFvQixNQUFwQjtBQUNFZ0IsV0FBTyxDQUFDRSxPQUFSLENBQWdCQyxRQUFoQixHQUEyQnJCLFdBQUEsQ0FBWWtCLE9BQU8sQ0FBQ0UsT0FBUixDQUFnQmxCLElBQTVCLENBQTNCO0FBUUQ7O0FBUEQsTUFBR2dCLE9BQVEsZ0JBQVg7QUFTRSxXQVJBQSxPQUFRLG9CQUFSLEdBQThCbEIsV0FBQSxDQUFZa0IsT0FBUSxnQkFBcEIsQ0FROUI7QUFDRDtBQWJXLENBQWQ7O0FBTUFJLE1BQU0sQ0FBQ0MsS0FBUCxDQUFhQyxNQUFiLENBQW9CQyxNQUFwQixDQUEyQixVQUFDUixNQUFELEVBQVNTLElBQVQ7QUFDekJyQixHQUFDLENBQUNzQixRQUFGLENBQVdELElBQVgsRUFDRTtBQUFBRSxTQUFBLEVBQU8sSUFBUDtBQUNBQyxnQkFBQSxFQUFjLEtBRGQ7QUFFQUMsZUFBQSxFQUFhO0FBRmIsR0FERjs7QUFLQXpCLEdBQUMsQ0FBQ3NCLFFBQUYsQ0FBV0QsSUFBSSxDQUFDTixPQUFoQixFQUNFO0FBQUFXLFdBQUEsRUFBUyxFQUFUO0FBQ0FDLHFCQUFBLEVBQW1CLEVBRG5CO0FBRUFDLGNBQUEsRUFBWTtBQUZaLEdBREY7O0FBZUEsU0FWQWhDLFdBQVcsQ0FBQ2lDLElBQVosQ0FBaUIsSUFBakIsRUFBb0JqQixNQUFwQixFQUE0QlMsSUFBNUIsQ0FVQTtBQXJCRjtBQWFBSixNQUFNLENBQUNDLEtBQVAsQ0FBYUMsTUFBYixDQUFvQlcsTUFBcEIsQ0FBMkIsVUFBQ2xCLE1BQUQsRUFBU1MsSUFBVCxFQUFlVSxVQUFmLEVBQTJCQyxRQUEzQixFQUFxQ0MsT0FBckM7QUFZekIsU0FYQXJDLFdBQVcsQ0FBQ2lDLElBQVosQ0FBaUIsSUFBakIsRUFBb0JqQixNQUFwQixFQUE0Qm9CLFFBQVEsQ0FBQ0UsSUFBVCxJQUFpQixFQUE3QyxDQVdBO0FBWkYsRyIsImZpbGUiOiIvY29tbW9uL3VzZXJzLmRlZmF1bHRzLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbImdldEluaXRpYWxzID0gKG5hbWUpIC0+XG4gIGZpcnN0V29yZHMgPSBfLmZpcnN0KG5hbWUucmVwbGFjZSgvXFxzKy9nLCBcIiBcIikudHJpbSgpLnNwbGl0KFwiIFwiKSwgMilcbiAgaWYgZmlyc3RXb3Jkcy5sZW5ndGggPCAyXG4gICAgZmlyc3RMZXR0ZXJzID0gZmlyc3RXb3Jkc1swXS5zdWJzdHJpbmcoMCwgMilcbiAgZWxzZVxuICAgIGZpcnN0TGV0dGVycyA9IF8ubWFwKGZpcnN0V29yZHMgfHwgW10sICh3b3JkKSAtPlxuICAgICAgd29yZC5jaGFyQXQoMCkpLmpvaW4oXCJcIilcbiAgZmlyc3RMZXR0ZXJzLnRvVXBwZXJDYXNlKClcblxudXNlclByZVNhdmUgPSAodXNlcklkLCBjaGFuZ2VzKSAtPlxuICBpZiBjaGFuZ2VzLnByb2ZpbGU/Lm5hbWVcbiAgICBjaGFuZ2VzLnByb2ZpbGUuaW5pdGlhbHMgPSBnZXRJbml0aWFscyhjaGFuZ2VzLnByb2ZpbGUubmFtZSlcbiAgaWYgY2hhbmdlc1tcInByb2ZpbGUubmFtZVwiXVxuICAgIGNoYW5nZXNbXCJwcm9maWxlLmluaXRpYWxzXCJdID0gZ2V0SW5pdGlhbHMoY2hhbmdlc1tcInByb2ZpbGUubmFtZVwiXSlcblxuTWV0ZW9yLnVzZXJzLmJlZm9yZS5pbnNlcnQgKHVzZXJJZCwgdXNlcikgLT5cbiAgXy5kZWZhdWx0cyh1c2VyLFxuICAgIGlzTmV3OiB0cnVlXG4gICAgaXNJbnZpdGF0aW9uOiBmYWxzZVxuICAgIGludml0YXRpb25zOiBbXVxuICApXG4gIF8uZGVmYXVsdHModXNlci5wcm9maWxlLFxuICAgIG51bVJlY3M6IDEwXG4gICAgZGFzaGJvYXJkUXVlcnlJZHM6IFtdXG4gICAgaXNSZWFsTmFtZTogZmFsc2VcbiAgKVxuICB1c2VyUHJlU2F2ZS5jYWxsKEAsIHVzZXJJZCwgdXNlcilcblxuTWV0ZW9yLnVzZXJzLmJlZm9yZS51cGRhdGUgKHVzZXJJZCwgdXNlciwgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIHVzZXJQcmVTYXZlLmNhbGwoQCwgdXNlcklkLCBtb2RpZmllci4kc2V0IHx8IHt9KVxuIl19

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/security/tuples.coffee                                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.Tuples.allow({
  insert: share.securityRulesWrapper(function (userId, tuple) {
    if (!userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    tuple._id = tuple._id || Random.id();
    tuple.ownerId = userId;
    check(tuple, {
      _id: Match.App.Id,
      name: String,
      note: String,
      contents: String,
      isOutputStale: Boolean,
      isNew: Boolean,
      ownerId: Match.App.UserId,
      updatedAt: Date,
      createdAt: Date
    });

    if (!tuple.name) {
      throw new Match.Error("Name required");
    }

    if (!tuple.contents) {
      throw new Match.Error("Contents required");
    }

    return true;
  }),
  update: share.securityRulesWrapper(function (userId, tuple, fieldNames, modifier, options) {
    var $set;

    if (!userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    if (userId !== tuple.ownerId) {
      throw new Match.Error("Operation not allowed for non-owners");
    }

    $set = {
      name: Match.Optional(String),
      note: Match.Optional(String),
      contents: Match.Optional(String),
      isOutputStale: Match.Optional(Boolean),
      isNew: Match.Optional(Match.App.isNewUpdate(tuple.isNew)),
      updatedAt: Date
    };
    check(modifier, {
      $set: $set
    });

    if (modifier.$set && _.has(modifier.$set, "name") && !modifier.$set.name) {
      throw new Match.Error("Name required");
    }

    if (modifier.$set && _.has(modifier.$set, "contents") && !modifier.$set.contents) {
      throw new Match.Error("Contents required");
    }

    return true;
  }),
  remove: share.securityRulesWrapper(function (userId, tuple) {
    if (!userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    if (userId !== tuple.ownerId) {
      throw new Match.Error("Operation not allowed for non-owners");
    }

    return true;
  })
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/security/tuples.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3NlY3VyaXR5L3R1cGxlcy5jb2ZmZWUiXSwibmFtZXMiOlsic2hhcmUiLCJUdXBsZXMiLCJhbGxvdyIsImluc2VydCIsInNlY3VyaXR5UnVsZXNXcmFwcGVyIiwidXNlcklkIiwidHVwbGUiLCJNYXRjaCIsIkVycm9yIiwiX2lkIiwiUmFuZG9tIiwiaWQiLCJvd25lcklkIiwiY2hlY2siLCJBcHAiLCJJZCIsIm5hbWUiLCJTdHJpbmciLCJub3RlIiwiY29udGVudHMiLCJpc091dHB1dFN0YWxlIiwiQm9vbGVhbiIsImlzTmV3IiwiVXNlcklkIiwidXBkYXRlZEF0IiwiRGF0ZSIsImNyZWF0ZWRBdCIsInVwZGF0ZSIsImZpZWxkTmFtZXMiLCJtb2RpZmllciIsIm9wdGlvbnMiLCIkc2V0IiwiT3B0aW9uYWwiLCJpc05ld1VwZGF0ZSIsIl8iLCJoYXMiLCJyZW1vdmUiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBQSxLQUFLLENBQUNDLE1BQU4sQ0FBYUMsS0FBYixDQUNFO0FBQUFDLFFBQUEsRUFBUUgsS0FBSyxDQUFDSSxvQkFBTixDQUEyQixVQUFDQyxNQUFELEVBQVNDLEtBQVQ7QUFDakMsU0FBT0QsTUFBUDtBQUNFLFlBQU0sSUFBSUUsS0FBSyxDQUFDQyxLQUFWLENBQWdCLDhDQUFoQixDQUFOO0FBQ0Q7O0FBQURGLFNBQUssQ0FBQ0csR0FBTixHQUFZSCxLQUFLLENBQUNHLEdBQU4sSUFBYUMsTUFBTSxDQUFDQyxFQUFQLEVBQXpCO0FBQ0FMLFNBQUssQ0FBQ00sT0FBTixHQUFnQlAsTUFBaEI7QUFDQVEsU0FBQSxDQUFNUCxLQUFOLEVBQ0U7QUFBQUcsU0FBQSxFQUFLRixLQUFLLENBQUNPLEdBQU4sQ0FBVUMsRUFBZjtBQUNBQyxVQUFBLEVBQU1DLE1BRE47QUFFQUMsVUFBQSxFQUFNRCxNQUZOO0FBR0FFLGNBQUEsRUFBVUYsTUFIVjtBQUlBRyxtQkFBQSxFQUFlQyxPQUpmO0FBS0FDLFdBQUEsRUFBT0QsT0FMUDtBQU1BVCxhQUFBLEVBQVNMLEtBQUssQ0FBQ08sR0FBTixDQUFVUyxNQU5uQjtBQU9BQyxlQUFBLEVBQVdDLElBUFg7QUFRQUMsZUFBQSxFQUFXRDtBQVJYLEtBREY7O0FBV0EsUUFBRyxDQUFJbkIsS0FBSyxDQUFDVSxJQUFiO0FBQ0UsWUFBTSxJQUFJVCxLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsZUFBaEIsQ0FBTjtBQUVEOztBQURELFFBQUcsQ0FBSUYsS0FBSyxDQUFDYSxRQUFiO0FBQ0UsWUFBTSxJQUFJWixLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsbUJBQWhCLENBQU47QUFHRDs7QUFDRCxXQUhBLElBR0E7QUF2Qk0sSUFBUjtBQXFCQW1CLFFBQUEsRUFBUTNCLEtBQUssQ0FBQ0ksb0JBQU4sQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFULEVBQWdCc0IsVUFBaEIsRUFBNEJDLFFBQTVCLEVBQXNDQyxPQUF0QztBQUNqQyxRQUFBQyxJQUFBOztBQUFBLFNBQU8xQixNQUFQO0FBQ0UsWUFBTSxJQUFJRSxLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsOENBQWhCLENBQU47QUFNRDs7QUFMRCxRQUFPSCxNQUFBLEtBQVVDLEtBQUssQ0FBQ00sT0FBdkI7QUFDRSxZQUFNLElBQUlMLEtBQUssQ0FBQ0MsS0FBVixDQUFnQixzQ0FBaEIsQ0FBTjtBQU9EOztBQU5EdUIsUUFBQSxHQUNFO0FBQUFmLFVBQUEsRUFBTVQsS0FBSyxDQUFDeUIsUUFBTixDQUFlZixNQUFmLENBQU47QUFDQUMsVUFBQSxFQUFNWCxLQUFLLENBQUN5QixRQUFOLENBQWVmLE1BQWYsQ0FETjtBQUVBRSxjQUFBLEVBQVVaLEtBQUssQ0FBQ3lCLFFBQU4sQ0FBZWYsTUFBZixDQUZWO0FBR0FHLG1CQUFBLEVBQWViLEtBQUssQ0FBQ3lCLFFBQU4sQ0FBZVgsT0FBZixDQUhmO0FBSUFDLFdBQUEsRUFBT2YsS0FBSyxDQUFDeUIsUUFBTixDQUFlekIsS0FBSyxDQUFDTyxHQUFOLENBQVVtQixXQUFWLENBQXNCM0IsS0FBSyxDQUFDZ0IsS0FBNUIsQ0FBZixDQUpQO0FBS0FFLGVBQUEsRUFBV0M7QUFMWCxLQURGO0FBT0FaLFNBQUEsQ0FBTWdCLFFBQU4sRUFDRTtBQUFBRSxVQUFBLEVBQU1BO0FBQU4sS0FERjs7QUFHQSxRQUFHRixRQUFRLENBQUNFLElBQVQsSUFBa0JHLENBQUMsQ0FBQ0MsR0FBRixDQUFNTixRQUFRLENBQUNFLElBQWYsRUFBcUIsTUFBckIsQ0FBbEIsSUFBbUQsQ0FBSUYsUUFBUSxDQUFDRSxJQUFULENBQWNmLElBQXhFO0FBQ0UsWUFBTSxJQUFJVCxLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsZUFBaEIsQ0FBTjtBQVNEOztBQVJELFFBQUdxQixRQUFRLENBQUNFLElBQVQsSUFBa0JHLENBQUMsQ0FBQ0MsR0FBRixDQUFNTixRQUFRLENBQUNFLElBQWYsRUFBcUIsVUFBckIsQ0FBbEIsSUFBdUQsQ0FBSUYsUUFBUSxDQUFDRSxJQUFULENBQWNaLFFBQTVFO0FBQ0UsWUFBTSxJQUFJWixLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsbUJBQWhCLENBQU47QUFVRDs7QUFDRCxXQVZBLElBVUE7QUE3Qk0sSUFyQlI7QUF5Q0E0QixRQUFBLEVBQVFwQyxLQUFLLENBQUNJLG9CQUFOLENBQTJCLFVBQUNDLE1BQUQsRUFBU0MsS0FBVDtBQUNqQyxTQUFPRCxNQUFQO0FBQ0UsWUFBTSxJQUFJRSxLQUFLLENBQUNDLEtBQVYsQ0FBZ0IsOENBQWhCLENBQU47QUFZRDs7QUFYRCxRQUFPSCxNQUFBLEtBQVVDLEtBQUssQ0FBQ00sT0FBdkI7QUFDRSxZQUFNLElBQUlMLEtBQUssQ0FBQ0MsS0FBVixDQUFnQixzQ0FBaEIsQ0FBTjtBQWFEOztBQUNELFdBYkEsSUFhQTtBQWxCTTtBQXpDUixDQURGLEUiLCJmaWxlIjoiL3NlcnZlci9zZWN1cml0eS90dXBsZXMuY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsic2hhcmUuVHVwbGVzLmFsbG93XG4gIGluc2VydDogc2hhcmUuc2VjdXJpdHlSdWxlc1dyYXBwZXIgKHVzZXJJZCwgdHVwbGUpIC0+XG4gICAgdW5sZXNzIHVzZXJJZFxuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiT3BlcmF0aW9uIG5vdCBhbGxvd2VkIGZvciB1bmF1dGhvcml6ZWQgdXNlcnNcIilcbiAgICB0dXBsZS5faWQgPSB0dXBsZS5faWQgb3IgUmFuZG9tLmlkKClcbiAgICB0dXBsZS5vd25lcklkID0gdXNlcklkXG4gICAgY2hlY2sodHVwbGUsXG4gICAgICBfaWQ6IE1hdGNoLkFwcC5JZFxuICAgICAgbmFtZTogU3RyaW5nXG4gICAgICBub3RlOiBTdHJpbmdcbiAgICAgIGNvbnRlbnRzOiBTdHJpbmdcbiAgICAgIGlzT3V0cHV0U3RhbGU6IEJvb2xlYW5cbiAgICAgIGlzTmV3OiBCb29sZWFuXG4gICAgICBvd25lcklkOiBNYXRjaC5BcHAuVXNlcklkXG4gICAgICB1cGRhdGVkQXQ6IERhdGVcbiAgICAgIGNyZWF0ZWRBdDogRGF0ZVxuICAgIClcbiAgICBpZiBub3QgdHVwbGUubmFtZVxuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiTmFtZSByZXF1aXJlZFwiKVxuICAgIGlmIG5vdCB0dXBsZS5jb250ZW50c1xuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiQ29udGVudHMgcmVxdWlyZWRcIilcbiAgICB0cnVlXG4gIHVwZGF0ZTogc2hhcmUuc2VjdXJpdHlSdWxlc1dyYXBwZXIgKHVzZXJJZCwgdHVwbGUsIGZpZWxkTmFtZXMsIG1vZGlmaWVyLCBvcHRpb25zKSAtPlxuICAgIHVubGVzcyB1c2VySWRcbiAgICAgIHRocm93IG5ldyBNYXRjaC5FcnJvcihcIk9wZXJhdGlvbiBub3QgYWxsb3dlZCBmb3IgdW5hdXRob3JpemVkIHVzZXJzXCIpXG4gICAgdW5sZXNzIHVzZXJJZCBpcyB0dXBsZS5vd25lcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIG5vbi1vd25lcnNcIilcbiAgICAkc2V0ID1cbiAgICAgIG5hbWU6IE1hdGNoLk9wdGlvbmFsKFN0cmluZylcbiAgICAgIG5vdGU6IE1hdGNoLk9wdGlvbmFsKFN0cmluZylcbiAgICAgIGNvbnRlbnRzOiBNYXRjaC5PcHRpb25hbChTdHJpbmcpXG4gICAgICBpc091dHB1dFN0YWxlOiBNYXRjaC5PcHRpb25hbChCb29sZWFuKVxuICAgICAgaXNOZXc6IE1hdGNoLk9wdGlvbmFsKE1hdGNoLkFwcC5pc05ld1VwZGF0ZSh0dXBsZS5pc05ldykpXG4gICAgICB1cGRhdGVkQXQ6IERhdGVcbiAgICBjaGVjayhtb2RpZmllcixcbiAgICAgICRzZXQ6ICRzZXRcbiAgICApXG4gICAgaWYgbW9kaWZpZXIuJHNldCBhbmQgXy5oYXMobW9kaWZpZXIuJHNldCwgXCJuYW1lXCIpIGFuZCBub3QgbW9kaWZpZXIuJHNldC5uYW1lXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJOYW1lIHJlcXVpcmVkXCIpXG4gICAgaWYgbW9kaWZpZXIuJHNldCBhbmQgXy5oYXMobW9kaWZpZXIuJHNldCwgXCJjb250ZW50c1wiKSBhbmQgbm90IG1vZGlmaWVyLiRzZXQuY29udGVudHNcbiAgICAgIHRocm93IG5ldyBNYXRjaC5FcnJvcihcIkNvbnRlbnRzIHJlcXVpcmVkXCIpXG4gICAgdHJ1ZVxuICByZW1vdmU6IHNoYXJlLnNlY3VyaXR5UnVsZXNXcmFwcGVyICh1c2VySWQsIHR1cGxlKSAtPlxuICAgIHVubGVzcyB1c2VySWRcbiAgICAgIHRocm93IG5ldyBNYXRjaC5FcnJvcihcIk9wZXJhdGlvbiBub3QgYWxsb3dlZCBmb3IgdW5hdXRob3JpemVkIHVzZXJzXCIpXG4gICAgdW5sZXNzIHVzZXJJZCBpcyB0dXBsZS5vd25lcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIG5vbi1vd25lcnNcIilcbiAgICB0cnVlXG4iXX0=

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// common/tuples.defaults.coffee                                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var tuplePreSave;

tuplePreSave = function (userId, changes) {};

share.Tuples.before.insert(function (userId, tuple) {
  var count, now, prefix;
  tuple._id = tuple._id || Random.id();
  now = new Date();

  _.defaults(tuple, {
    name: "",
    note: "",
    contents: "",
    isOutputStale: true,
    isNew: true,
    ownerId: userId,
    updatedAt: now,
    createdAt: now
  });

  if (!tuple.name) {
    prefix = "New Tuple File";
    count = share.Tuples.find({
      name: {
        $regex: "^" + prefix,
        $options: "i"
      }
    }).count();
    tuple.name = prefix;

    if (count) {
      tuple.name += " (" + count + ")";
    }
  }

  return tuplePreSave.call(this, userId, tuple);
});
share.Tuples.before.update(function (userId, tuple, fieldNames, modifier, options) {
  var now;
  now = new Date();
  modifier.$set = modifier.$set || {};
  modifier.$set.updatedAt = modifier.$set.updatedAt || now;
  return tuplePreSave.call(this, userId, modifier.$set);
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/common/tuples.defaults.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvY29tbW9uL3R1cGxlcy5kZWZhdWx0cy5jb2ZmZWUiXSwibmFtZXMiOlsidHVwbGVQcmVTYXZlIiwidXNlcklkIiwiY2hhbmdlcyIsInNoYXJlIiwiVHVwbGVzIiwiYmVmb3JlIiwiaW5zZXJ0IiwidHVwbGUiLCJjb3VudCIsIm5vdyIsInByZWZpeCIsIl9pZCIsIlJhbmRvbSIsImlkIiwiRGF0ZSIsIl8iLCJkZWZhdWx0cyIsIm5hbWUiLCJub3RlIiwiY29udGVudHMiLCJpc091dHB1dFN0YWxlIiwiaXNOZXciLCJvd25lcklkIiwidXBkYXRlZEF0IiwiY3JlYXRlZEF0IiwiZmluZCIsIiRyZWdleCIsIiRvcHRpb25zIiwiY2FsbCIsInVwZGF0ZSIsImZpZWxkTmFtZXMiLCJtb2RpZmllciIsIm9wdGlvbnMiLCIkc2V0Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxZQUFBOztBQUFBQSxZQUFBLEdBQWUsVUFBQ0MsTUFBRCxFQUFTQyxPQUFULElBQWY7O0FBRUFDLEtBQUssQ0FBQ0MsTUFBTixDQUFhQyxNQUFiLENBQW9CQyxNQUFwQixDQUEyQixVQUFDTCxNQUFELEVBQVNNLEtBQVQ7QUFDekIsTUFBQUMsS0FBQSxFQUFBQyxHQUFBLEVBQUFDLE1BQUE7QUFBQUgsT0FBSyxDQUFDSSxHQUFOLEdBQVlKLEtBQUssQ0FBQ0ksR0FBTixJQUFhQyxNQUFNLENBQUNDLEVBQVAsRUFBekI7QUFDQUosS0FBQSxHQUFNLElBQUlLLElBQUosRUFBTjs7QUFDQUMsR0FBQyxDQUFDQyxRQUFGLENBQVdULEtBQVgsRUFDRTtBQUFBVSxRQUFBLEVBQU0sRUFBTjtBQUNBQyxRQUFBLEVBQU0sRUFETjtBQUVBQyxZQUFBLEVBQVUsRUFGVjtBQUdBQyxpQkFBQSxFQUFlLElBSGY7QUFJQUMsU0FBQSxFQUFPLElBSlA7QUFLQUMsV0FBQSxFQUFTckIsTUFMVDtBQU1Bc0IsYUFBQSxFQUFXZCxHQU5YO0FBT0FlLGFBQUEsRUFBV2Y7QUFQWCxHQURGOztBQVVBLE1BQUcsQ0FBSUYsS0FBSyxDQUFDVSxJQUFiO0FBQ0VQLFVBQUEsR0FBUyxnQkFBVDtBQUNBRixTQUFBLEdBQVFMLEtBQUssQ0FBQ0MsTUFBTixDQUFhcUIsSUFBYixDQUFrQjtBQUFFUixVQUFBLEVBQU07QUFBRVMsY0FBQSxFQUFRLE1BQU1oQixNQUFoQjtBQUF3QmlCLGdCQUFBLEVBQVU7QUFBbEM7QUFBUixLQUFsQixFQUFxRW5CLEtBQXJFLEVBQVI7QUFDQUQsU0FBSyxDQUFDVSxJQUFOLEdBQWFQLE1BQWI7O0FBQ0EsUUFBR0YsS0FBSDtBQUNFRCxXQUFLLENBQUNVLElBQU4sSUFBYyxPQUFPVCxLQUFQLEdBQWUsR0FBN0I7QUFMSjtBQWVDOztBQUNELFNBVkFSLFlBQVksQ0FBQzRCLElBQWIsQ0FBa0IsSUFBbEIsRUFBcUIzQixNQUFyQixFQUE2Qk0sS0FBN0IsQ0FVQTtBQTdCRjtBQXFCQUosS0FBSyxDQUFDQyxNQUFOLENBQWFDLE1BQWIsQ0FBb0J3QixNQUFwQixDQUEyQixVQUFDNUIsTUFBRCxFQUFTTSxLQUFULEVBQWdCdUIsVUFBaEIsRUFBNEJDLFFBQTVCLEVBQXNDQyxPQUF0QztBQUN6QixNQUFBdkIsR0FBQTtBQUFBQSxLQUFBLEdBQU0sSUFBSUssSUFBSixFQUFOO0FBQ0FpQixVQUFRLENBQUNFLElBQVQsR0FBZ0JGLFFBQVEsQ0FBQ0UsSUFBVCxJQUFpQixFQUFqQztBQUNBRixVQUFRLENBQUNFLElBQVQsQ0FBY1YsU0FBZCxHQUEwQlEsUUFBUSxDQUFDRSxJQUFULENBQWNWLFNBQWQsSUFBMkJkLEdBQXJEO0FBYUEsU0FaQVQsWUFBWSxDQUFDNEIsSUFBYixDQUFrQixJQUFsQixFQUFxQjNCLE1BQXJCLEVBQTZCOEIsUUFBUSxDQUFDRSxJQUF0QyxDQVlBO0FBaEJGLEciLCJmaWxlIjoiL2NvbW1vbi90dXBsZXMuZGVmYXVsdHMuY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsidHVwbGVQcmVTYXZlID0gKHVzZXJJZCwgY2hhbmdlcykgLT5cblxuc2hhcmUuVHVwbGVzLmJlZm9yZS5pbnNlcnQgKHVzZXJJZCwgdHVwbGUpIC0+XG4gIHR1cGxlLl9pZCA9IHR1cGxlLl9pZCB8fCBSYW5kb20uaWQoKVxuICBub3cgPSBuZXcgRGF0ZSgpXG4gIF8uZGVmYXVsdHModHVwbGUsXG4gICAgbmFtZTogXCJcIlxuICAgIG5vdGU6IFwiXCJcbiAgICBjb250ZW50czogXCJcIlxuICAgIGlzT3V0cHV0U3RhbGU6IHRydWVcbiAgICBpc05ldzogdHJ1ZVxuICAgIG93bmVySWQ6IHVzZXJJZFxuICAgIHVwZGF0ZWRBdDogbm93XG4gICAgY3JlYXRlZEF0OiBub3dcbiAgKVxuICBpZiBub3QgdHVwbGUubmFtZVxuICAgIHByZWZpeCA9IFwiTmV3IFR1cGxlIEZpbGVcIlxuICAgIGNvdW50ID0gc2hhcmUuVHVwbGVzLmZpbmQoeyBuYW1lOiB7ICRyZWdleDogXCJeXCIgKyBwcmVmaXgsICRvcHRpb25zOiBcImlcIiB9IH0pLmNvdW50KClcbiAgICB0dXBsZS5uYW1lID0gcHJlZml4XG4gICAgaWYgY291bnRcbiAgICAgIHR1cGxlLm5hbWUgKz0gXCIgKFwiICsgY291bnQgKyBcIilcIlxuICB0dXBsZVByZVNhdmUuY2FsbChALCB1c2VySWQsIHR1cGxlKVxuXG5zaGFyZS5UdXBsZXMuYmVmb3JlLnVwZGF0ZSAodXNlcklkLCB0dXBsZSwgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIG5vdyA9IG5ldyBEYXRlKClcbiAgbW9kaWZpZXIuJHNldCA9IG1vZGlmaWVyLiRzZXQgb3Ige31cbiAgbW9kaWZpZXIuJHNldC51cGRhdGVkQXQgPSBtb2RpZmllci4kc2V0LnVwZGF0ZWRBdCBvciBub3dcbiAgdHVwbGVQcmVTYXZlLmNhbGwoQCwgdXNlcklkLCBtb2RpZmllci4kc2V0KVxuIl19

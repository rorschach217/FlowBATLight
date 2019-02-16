(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// common/ipsets.defaults.coffee                                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var ipsetPreSave;

ipsetPreSave = function (userId, changes) {};

share.IPSets.before.insert(function (userId, ipset) {
  var count, now, prefix;
  ipset._id = ipset._id || Random.id();
  now = new Date();

  _.defaults(ipset, {
    name: "",
    note: "",
    contents: "",
    isOutputStale: true,
    isNew: true,
    ownerId: userId,
    updatedAt: now,
    createdAt: now
  });

  if (!ipset.name) {
    prefix = "New IP Set";
    count = share.IPSets.find({
      name: {
        $regex: "^" + prefix,
        $options: "i"
      }
    }).count();
    ipset.name = prefix;

    if (count) {
      ipset.name += " (" + count + ")";
    }
  }

  return ipsetPreSave.call(this, userId, ipset);
});
share.IPSets.before.update(function (userId, ipset, fieldNames, modifier, options) {
  var now;
  now = new Date();
  modifier.$set = modifier.$set || {};
  modifier.$set.updatedAt = modifier.$set.updatedAt || now;
  return ipsetPreSave.call(this, userId, modifier.$set);
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/common/ipsets.defaults.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvY29tbW9uL2lwc2V0cy5kZWZhdWx0cy5jb2ZmZWUiXSwibmFtZXMiOlsiaXBzZXRQcmVTYXZlIiwidXNlcklkIiwiY2hhbmdlcyIsInNoYXJlIiwiSVBTZXRzIiwiYmVmb3JlIiwiaW5zZXJ0IiwiaXBzZXQiLCJjb3VudCIsIm5vdyIsInByZWZpeCIsIl9pZCIsIlJhbmRvbSIsImlkIiwiRGF0ZSIsIl8iLCJkZWZhdWx0cyIsIm5hbWUiLCJub3RlIiwiY29udGVudHMiLCJpc091dHB1dFN0YWxlIiwiaXNOZXciLCJvd25lcklkIiwidXBkYXRlZEF0IiwiY3JlYXRlZEF0IiwiZmluZCIsIiRyZWdleCIsIiRvcHRpb25zIiwiY2FsbCIsInVwZGF0ZSIsImZpZWxkTmFtZXMiLCJtb2RpZmllciIsIm9wdGlvbnMiLCIkc2V0Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxZQUFBOztBQUFBQSxZQUFBLEdBQWUsVUFBQ0MsTUFBRCxFQUFTQyxPQUFULElBQWY7O0FBRUFDLEtBQUssQ0FBQ0MsTUFBTixDQUFhQyxNQUFiLENBQW9CQyxNQUFwQixDQUEyQixVQUFDTCxNQUFELEVBQVNNLEtBQVQ7QUFDekIsTUFBQUMsS0FBQSxFQUFBQyxHQUFBLEVBQUFDLE1BQUE7QUFBQUgsT0FBSyxDQUFDSSxHQUFOLEdBQVlKLEtBQUssQ0FBQ0ksR0FBTixJQUFhQyxNQUFNLENBQUNDLEVBQVAsRUFBekI7QUFDQUosS0FBQSxHQUFNLElBQUlLLElBQUosRUFBTjs7QUFDQUMsR0FBQyxDQUFDQyxRQUFGLENBQVdULEtBQVgsRUFDRTtBQUFBVSxRQUFBLEVBQU0sRUFBTjtBQUNBQyxRQUFBLEVBQU0sRUFETjtBQUVBQyxZQUFBLEVBQVUsRUFGVjtBQUdBQyxpQkFBQSxFQUFlLElBSGY7QUFJQUMsU0FBQSxFQUFPLElBSlA7QUFLQUMsV0FBQSxFQUFTckIsTUFMVDtBQU1Bc0IsYUFBQSxFQUFXZCxHQU5YO0FBT0FlLGFBQUEsRUFBV2Y7QUFQWCxHQURGOztBQVVBLE1BQUcsQ0FBSUYsS0FBSyxDQUFDVSxJQUFiO0FBQ0VQLFVBQUEsR0FBUyxZQUFUO0FBQ0FGLFNBQUEsR0FBUUwsS0FBSyxDQUFDQyxNQUFOLENBQWFxQixJQUFiLENBQWtCO0FBQUVSLFVBQUEsRUFBTTtBQUFFUyxjQUFBLEVBQVEsTUFBTWhCLE1BQWhCO0FBQXdCaUIsZ0JBQUEsRUFBVTtBQUFsQztBQUFSLEtBQWxCLEVBQXFFbkIsS0FBckUsRUFBUjtBQUNBRCxTQUFLLENBQUNVLElBQU4sR0FBYVAsTUFBYjs7QUFDQSxRQUFHRixLQUFIO0FBQ0VELFdBQUssQ0FBQ1UsSUFBTixJQUFjLE9BQU9ULEtBQVAsR0FBZSxHQUE3QjtBQUxKO0FBZUM7O0FBQ0QsU0FWQVIsWUFBWSxDQUFDNEIsSUFBYixDQUFrQixJQUFsQixFQUFxQjNCLE1BQXJCLEVBQTZCTSxLQUE3QixDQVVBO0FBN0JGO0FBcUJBSixLQUFLLENBQUNDLE1BQU4sQ0FBYUMsTUFBYixDQUFvQndCLE1BQXBCLENBQTJCLFVBQUM1QixNQUFELEVBQVNNLEtBQVQsRUFBZ0J1QixVQUFoQixFQUE0QkMsUUFBNUIsRUFBc0NDLE9BQXRDO0FBQ3pCLE1BQUF2QixHQUFBO0FBQUFBLEtBQUEsR0FBTSxJQUFJSyxJQUFKLEVBQU47QUFDQWlCLFVBQVEsQ0FBQ0UsSUFBVCxHQUFnQkYsUUFBUSxDQUFDRSxJQUFULElBQWlCLEVBQWpDO0FBQ0FGLFVBQVEsQ0FBQ0UsSUFBVCxDQUFjVixTQUFkLEdBQTBCUSxRQUFRLENBQUNFLElBQVQsQ0FBY1YsU0FBZCxJQUEyQmQsR0FBckQ7QUFhQSxTQVpBVCxZQUFZLENBQUM0QixJQUFiLENBQWtCLElBQWxCLEVBQXFCM0IsTUFBckIsRUFBNkI4QixRQUFRLENBQUNFLElBQXRDLENBWUE7QUFoQkYsRyIsImZpbGUiOiIvY29tbW9uL2lwc2V0cy5kZWZhdWx0cy5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJpcHNldFByZVNhdmUgPSAodXNlcklkLCBjaGFuZ2VzKSAtPlxuXG5zaGFyZS5JUFNldHMuYmVmb3JlLmluc2VydCAodXNlcklkLCBpcHNldCkgLT5cbiAgaXBzZXQuX2lkID0gaXBzZXQuX2lkIHx8IFJhbmRvbS5pZCgpXG4gIG5vdyA9IG5ldyBEYXRlKClcbiAgXy5kZWZhdWx0cyhpcHNldCxcbiAgICBuYW1lOiBcIlwiXG4gICAgbm90ZTogXCJcIlxuICAgIGNvbnRlbnRzOiBcIlwiXG4gICAgaXNPdXRwdXRTdGFsZTogdHJ1ZVxuICAgIGlzTmV3OiB0cnVlXG4gICAgb3duZXJJZDogdXNlcklkXG4gICAgdXBkYXRlZEF0OiBub3dcbiAgICBjcmVhdGVkQXQ6IG5vd1xuICApXG4gIGlmIG5vdCBpcHNldC5uYW1lXG4gICAgcHJlZml4ID0gXCJOZXcgSVAgU2V0XCJcbiAgICBjb3VudCA9IHNoYXJlLklQU2V0cy5maW5kKHsgbmFtZTogeyAkcmVnZXg6IFwiXlwiICsgcHJlZml4LCAkb3B0aW9uczogXCJpXCIgfSB9KS5jb3VudCgpXG4gICAgaXBzZXQubmFtZSA9IHByZWZpeFxuICAgIGlmIGNvdW50XG4gICAgICBpcHNldC5uYW1lICs9IFwiIChcIiArIGNvdW50ICsgXCIpXCJcbiAgaXBzZXRQcmVTYXZlLmNhbGwoQCwgdXNlcklkLCBpcHNldClcblxuc2hhcmUuSVBTZXRzLmJlZm9yZS51cGRhdGUgKHVzZXJJZCwgaXBzZXQsIGZpZWxkTmFtZXMsIG1vZGlmaWVyLCBvcHRpb25zKSAtPlxuICBub3cgPSBuZXcgRGF0ZSgpXG4gIG1vZGlmaWVyLiRzZXQgPSBtb2RpZmllci4kc2V0IG9yIHt9XG4gIG1vZGlmaWVyLiRzZXQudXBkYXRlZEF0ID0gbW9kaWZpZXIuJHNldC51cGRhdGVkQXQgb3Igbm93XG4gIGlwc2V0UHJlU2F2ZS5jYWxsKEAsIHVzZXJJZCwgbW9kaWZpZXIuJHNldClcbiJdfQ==

(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// common/queries.hooks.coffee                                         //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var indexOf = [].indexOf;
share.Queries.before.update(function (userId, query, fieldNames, modifier, options) {
  if (_.intersection(fieldNames, ["output", "presentation", "startRecNum", "sortField", "sortReverse", "fields", "fieldsOrder"]).length) {
    modifier.$set = modifier.$set || {};
    modifier.$set.isOutputStale = true;
  }

  if (_.intersection(fieldNames, ["interface", "output", "presentation"]).length) {
    modifier.$set = modifier.$set || {};
    return _.extend(modifier.$set, share.queryBlankValues);
  }
});
share.Queries.after.update(function (userId, query, fieldNames, modifier, options) {
  var availableChartTypes, ref, transformedQuery;

  if (_.intersection(fieldNames, ["output"]).length) {
    transformedQuery = share.Transformations.query(query);
    availableChartTypes = transformedQuery.availableChartTypes();

    if (ref = query.chartType, indexOf.call(availableChartTypes, ref) < 0) {
      return share.Queries.update(query._id, {
        $set: {
          chartType: availableChartTypes[0] || ""
        }
      });
    }
  }
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/common/queries.hooks.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvY29tbW9uL3F1ZXJpZXMuaG9va3MuY29mZmVlIl0sIm5hbWVzIjpbImluZGV4T2YiLCJzaGFyZSIsIlF1ZXJpZXMiLCJiZWZvcmUiLCJ1cGRhdGUiLCJ1c2VySWQiLCJxdWVyeSIsImZpZWxkTmFtZXMiLCJtb2RpZmllciIsIm9wdGlvbnMiLCJfIiwiaW50ZXJzZWN0aW9uIiwibGVuZ3RoIiwiJHNldCIsImlzT3V0cHV0U3RhbGUiLCJleHRlbmQiLCJxdWVyeUJsYW5rVmFsdWVzIiwiYWZ0ZXIiLCJhdmFpbGFibGVDaGFydFR5cGVzIiwicmVmIiwidHJhbnNmb3JtZWRRdWVyeSIsIlRyYW5zZm9ybWF0aW9ucyIsImNoYXJ0VHlwZSIsImNhbGwiLCJfaWQiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBLElBQUFBLE9BQUEsTUFBQUEsT0FBQTtBQUFBQyxLQUFLLENBQUNDLE9BQU4sQ0FBY0MsTUFBZCxDQUFxQkMsTUFBckIsQ0FBNEIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFULEVBQWdCQyxVQUFoQixFQUE0QkMsUUFBNUIsRUFBc0NDLE9BQXRDO0FBQzFCLE1BQUdDLENBQUMsQ0FBQ0MsWUFBRixDQUFlSixVQUFmLEVBQTJCLENBQUMsUUFBRCxFQUFXLGNBQVgsRUFBMkIsYUFBM0IsRUFBMEMsV0FBMUMsRUFBdUQsYUFBdkQsRUFBc0UsUUFBdEUsRUFBZ0YsYUFBaEYsQ0FBM0IsRUFBMkhLLE1BQTlIO0FBQ0VKLFlBQVEsQ0FBQ0ssSUFBVCxHQUFnQkwsUUFBUSxDQUFDSyxJQUFULElBQWlCLEVBQWpDO0FBQ0FMLFlBQVEsQ0FBQ0ssSUFBVCxDQUFjQyxhQUFkLEdBQThCLElBQTlCO0FBR0Q7O0FBRkQsTUFBR0osQ0FBQyxDQUFDQyxZQUFGLENBQWVKLFVBQWYsRUFBMkIsQ0FBQyxXQUFELEVBQWMsUUFBZCxFQUF3QixjQUF4QixDQUEzQixFQUFvRUssTUFBdkU7QUFDRUosWUFBUSxDQUFDSyxJQUFULEdBQWdCTCxRQUFRLENBQUNLLElBQVQsSUFBaUIsRUFBakM7QUFJQSxXQUhBSCxDQUFDLENBQUNLLE1BQUYsQ0FBU1AsUUFBUSxDQUFDSyxJQUFsQixFQUF3QlosS0FBSyxDQUFDZSxnQkFBOUIsQ0FHQTtBQUNEO0FBVkg7QUFRQWYsS0FBSyxDQUFDQyxPQUFOLENBQWNlLEtBQWQsQ0FBb0JiLE1BQXBCLENBQTJCLFVBQUNDLE1BQUQsRUFBU0MsS0FBVCxFQUFnQkMsVUFBaEIsRUFBNEJDLFFBQTVCLEVBQXNDQyxPQUF0QztBQUN6QixNQUFBUyxtQkFBQSxFQUFBQyxHQUFBLEVBQUFDLGdCQUFBOztBQUFBLE1BQUdWLENBQUMsQ0FBQ0MsWUFBRixDQUFlSixVQUFmLEVBQTJCLENBQUMsUUFBRCxDQUEzQixFQUF1Q0ssTUFBMUM7QUFDRVEsb0JBQUEsR0FBbUJuQixLQUFLLENBQUNvQixlQUFOLENBQXNCZixLQUF0QixDQUE0QkEsS0FBNUIsQ0FBbkI7QUFDQVksdUJBQUEsR0FBc0JFLGdCQUFnQixDQUFDRixtQkFBakIsRUFBdEI7O0FBQ0EsUUFBQUMsR0FBQSxHQUFHYixLQUFLLENBQUNnQixTQUFULEVBQUd0QixPQUFBLENBQUF1QixJQUFBLENBQXVCTCxtQkFBdkIsRUFBQUMsR0FBQSxLQUFIO0FBT0UsYUFOQWxCLEtBQUssQ0FBQ0MsT0FBTixDQUFjRSxNQUFkLENBQXFCRSxLQUFLLENBQUNrQixHQUEzQixFQUFnQztBQUFDWCxZQUFBLEVBQU07QUFBQ1MsbUJBQUEsRUFBV0osbUJBQW9CLEdBQXBCLElBQTBCO0FBQXRDO0FBQVAsT0FBaEMsQ0FNQTtBQVZKO0FBZ0JDO0FBakJILEciLCJmaWxlIjoiL2NvbW1vbi9xdWVyaWVzLmhvb2tzLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlLlF1ZXJpZXMuYmVmb3JlLnVwZGF0ZSAodXNlcklkLCBxdWVyeSwgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIGlmIF8uaW50ZXJzZWN0aW9uKGZpZWxkTmFtZXMsIFtcIm91dHB1dFwiLCBcInByZXNlbnRhdGlvblwiLCBcInN0YXJ0UmVjTnVtXCIsIFwic29ydEZpZWxkXCIsIFwic29ydFJldmVyc2VcIiwgXCJmaWVsZHNcIiwgXCJmaWVsZHNPcmRlclwiXSkubGVuZ3RoXG4gICAgbW9kaWZpZXIuJHNldCA9IG1vZGlmaWVyLiRzZXQgb3Ige31cbiAgICBtb2RpZmllci4kc2V0LmlzT3V0cHV0U3RhbGUgPSB0cnVlXG4gIGlmIF8uaW50ZXJzZWN0aW9uKGZpZWxkTmFtZXMsIFtcImludGVyZmFjZVwiLCBcIm91dHB1dFwiLCBcInByZXNlbnRhdGlvblwiXSkubGVuZ3RoXG4gICAgbW9kaWZpZXIuJHNldCA9IG1vZGlmaWVyLiRzZXQgb3Ige31cbiAgICBfLmV4dGVuZChtb2RpZmllci4kc2V0LCBzaGFyZS5xdWVyeUJsYW5rVmFsdWVzKVxuXG5zaGFyZS5RdWVyaWVzLmFmdGVyLnVwZGF0ZSAodXNlcklkLCBxdWVyeSwgZmllbGROYW1lcywgbW9kaWZpZXIsIG9wdGlvbnMpIC0+XG4gIGlmIF8uaW50ZXJzZWN0aW9uKGZpZWxkTmFtZXMsIFtcIm91dHB1dFwiXSkubGVuZ3RoXG4gICAgdHJhbnNmb3JtZWRRdWVyeSA9IHNoYXJlLlRyYW5zZm9ybWF0aW9ucy5xdWVyeShxdWVyeSlcbiAgICBhdmFpbGFibGVDaGFydFR5cGVzID0gdHJhbnNmb3JtZWRRdWVyeS5hdmFpbGFibGVDaGFydFR5cGVzKClcbiAgICBpZiBxdWVyeS5jaGFydFR5cGUgbm90IGluIGF2YWlsYWJsZUNoYXJ0VHlwZXNcbiAgICAgIHNoYXJlLlF1ZXJpZXMudXBkYXRlKHF1ZXJ5Ll9pZCwgeyRzZXQ6IHtjaGFydFR5cGU6IGF2YWlsYWJsZUNoYXJ0VHlwZXNbMF0gb3IgXCJcIn19KVxuIl19

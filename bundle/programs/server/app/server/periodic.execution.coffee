(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/periodic.execution.coffee                                    //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.periodicExecution = {
  timeout: null,
  nearestExecutingAt: null,
  execute: function () {
    share.Queries.find({
      executingAt: {
        $lte: new Date()
      }
    }).forEach(function (query) {
      var executingAt; //      cl "executing" + query.name + " at " + new Date() + " requested at " + query.executingAt

      executingAt = new Date(new Date().getTime() + query.executingInterval);
      return share.Queries.update(query._id, {
        $set: {
          isInputStale: true,
          isOutputStale: true,
          executingAt: executingAt
        }
      }, {
        skipResetTimeout: true
      });
    });
    return this.resetTimeout();
  },
  resetTimeout: function () {
    var nearestQuery, timeout;
    nearestQuery = share.Queries.findOne({
      executingAt: {
        $ne: null
      }
    }, {
      sort: {
        executingAt: 1
      }
    });
    timeout = 30 * 1000;

    if (nearestQuery) {
      timeout = nearestQuery.executingAt.getTime() - new Date().getTime();
    }

    if (this.timeout) {
      Meteor.clearTimeout(this.timeout);
    }

    timeout = Math.max(1000, timeout); // at least a second in future; protection from state with executingAt in the past
    //    cl "resetTimeout to " + timeout

    return this.timeout = Meteor.setTimeout(this.execute, timeout);
  }
};

_.bindAll(share.periodicExecution, "execute", "resetTimeout");
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/periodic.execution.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3BlcmlvZGljLmV4ZWN1dGlvbi5jb2ZmZWUiXSwibmFtZXMiOlsic2hhcmUiLCJwZXJpb2RpY0V4ZWN1dGlvbiIsInRpbWVvdXQiLCJuZWFyZXN0RXhlY3V0aW5nQXQiLCJleGVjdXRlIiwiUXVlcmllcyIsImZpbmQiLCJleGVjdXRpbmdBdCIsIiRsdGUiLCJEYXRlIiwiZm9yRWFjaCIsInF1ZXJ5IiwiZ2V0VGltZSIsImV4ZWN1dGluZ0ludGVydmFsIiwidXBkYXRlIiwiX2lkIiwiJHNldCIsImlzSW5wdXRTdGFsZSIsImlzT3V0cHV0U3RhbGUiLCJza2lwUmVzZXRUaW1lb3V0IiwicmVzZXRUaW1lb3V0IiwibmVhcmVzdFF1ZXJ5IiwiZmluZE9uZSIsIiRuZSIsInNvcnQiLCJNZXRlb3IiLCJjbGVhclRpbWVvdXQiLCJNYXRoIiwibWF4Iiwic2V0VGltZW91dCIsIl8iLCJiaW5kQWxsIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQUEsS0FBSyxDQUFDQyxpQkFBTixHQUNFO0FBQUFDLFNBQUEsRUFBUyxJQUFUO0FBQ0FDLG9CQUFBLEVBQW9CLElBRHBCO0FBRUFDLFNBQUEsRUFBUztBQUNQSixTQUFLLENBQUNLLE9BQU4sQ0FBY0MsSUFBZCxDQUFtQjtBQUFDQyxpQkFBQSxFQUFhO0FBQUNDLFlBQUEsRUFBTSxJQUFJQyxJQUFKO0FBQVA7QUFBZCxLQUFuQixFQUFzREMsT0FBdEQsQ0FBOEQsVUFBQ0MsS0FBRDtBQUU1RCxVQUFBSixXQUFBLENBRjRELENBTTVEOztBQUpBQSxpQkFBQSxHQUFjLElBQUlFLElBQUosQ0FBUyxJQUFJQSxJQUFKLEdBQVdHLE9BQVgsS0FBdUJELEtBQUssQ0FBQ0UsaUJBQXRDLENBQWQ7QUFNQSxhQUxBYixLQUFLLENBQUNLLE9BQU4sQ0FBY1MsTUFBZCxDQUFxQkgsS0FBSyxDQUFDSSxHQUEzQixFQUFnQztBQUFDQyxZQUFBLEVBQU07QUFBQ0Msc0JBQUEsRUFBYyxJQUFmO0FBQXFCQyx1QkFBQSxFQUFlLElBQXBDO0FBQTBDWCxxQkFBQSxFQUFhQTtBQUF2RDtBQUFQLE9BQWhDLEVBQTZHO0FBQUNZLHdCQUFBLEVBQWtCO0FBQW5CLE9BQTdHLENBS0E7QUFSRjtBQWtCQSxXQWRBLEtBQUNDLFlBQUQsRUFjQTtBQXJCRjtBQVFBQSxjQUFBLEVBQWM7QUFDWixRQUFBQyxZQUFBLEVBQUFuQixPQUFBO0FBQUFtQixnQkFBQSxHQUFlckIsS0FBSyxDQUFDSyxPQUFOLENBQWNpQixPQUFkLENBQXNCO0FBQUNmLGlCQUFBLEVBQWE7QUFBQ2dCLFdBQUEsRUFBSztBQUFOO0FBQWQsS0FBdEIsRUFBa0Q7QUFBQ0MsVUFBQSxFQUFNO0FBQUNqQixtQkFBQSxFQUFhO0FBQWQ7QUFBUCxLQUFsRCxDQUFmO0FBQ0FMLFdBQUEsR0FBVSxLQUFLLElBQWY7O0FBQ0EsUUFBR21CLFlBQUg7QUFDRW5CLGFBQUEsR0FBVW1CLFlBQVksQ0FBQ2QsV0FBYixDQUF5QkssT0FBekIsS0FBcUMsSUFBSUgsSUFBSixHQUFXRyxPQUFYLEVBQS9DO0FBeUJEOztBQXhCRCxRQUFHLEtBQUNWLE9BQUo7QUFDRXVCLFlBQU0sQ0FBQ0MsWUFBUCxDQUFvQixLQUFDeEIsT0FBckI7QUEwQkQ7O0FBekJEQSxXQUFBLEdBQVV5QixJQUFJLENBQUNDLEdBQUwsQ0FBUyxJQUFULEVBQWUxQixPQUFmLENBQVYsQ0FQWSxDQUNaO0FBaUNBOztBQUNBLFdBMUJBLEtBQUNBLE9BQUQsR0FBV3VCLE1BQU0sQ0FBQ0ksVUFBUCxDQUFrQixLQUFDekIsT0FBbkIsRUFBNEJGLE9BQTVCLENBMEJYO0FBbkNZO0FBUmQsQ0FERjs7QUFvQkE0QixDQUFDLENBQUNDLE9BQUYsQ0FBVS9CLEtBQUssQ0FBQ0MsaUJBQWhCLEVBQW1DLFNBQW5DLEVBQThDLGNBQTlDLEUiLCJmaWxlIjoiL3NlcnZlci9wZXJpb2RpYy5leGVjdXRpb24uY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsic2hhcmUucGVyaW9kaWNFeGVjdXRpb24gPVxuICB0aW1lb3V0OiBudWxsXG4gIG5lYXJlc3RFeGVjdXRpbmdBdDogbnVsbFxuICBleGVjdXRlOiAtPlxuICAgIHNoYXJlLlF1ZXJpZXMuZmluZCh7ZXhlY3V0aW5nQXQ6IHskbHRlOiBuZXcgRGF0ZSgpfX0pLmZvckVhY2ggKHF1ZXJ5KSAtPlxuIyAgICAgIGNsIFwiZXhlY3V0aW5nXCIgKyBxdWVyeS5uYW1lICsgXCIgYXQgXCIgKyBuZXcgRGF0ZSgpICsgXCIgcmVxdWVzdGVkIGF0IFwiICsgcXVlcnkuZXhlY3V0aW5nQXRcbiAgICAgIGV4ZWN1dGluZ0F0ID0gbmV3IERhdGUobmV3IERhdGUoKS5nZXRUaW1lKCkgKyBxdWVyeS5leGVjdXRpbmdJbnRlcnZhbClcbiAgICAgIHNoYXJlLlF1ZXJpZXMudXBkYXRlKHF1ZXJ5Ll9pZCwgeyRzZXQ6IHtpc0lucHV0U3RhbGU6IHRydWUsIGlzT3V0cHV0U3RhbGU6IHRydWUsIGV4ZWN1dGluZ0F0OiBleGVjdXRpbmdBdH19LCB7c2tpcFJlc2V0VGltZW91dDogdHJ1ZX0pXG4gICAgQHJlc2V0VGltZW91dCgpXG4gIHJlc2V0VGltZW91dDogLT5cbiAgICBuZWFyZXN0UXVlcnkgPSBzaGFyZS5RdWVyaWVzLmZpbmRPbmUoe2V4ZWN1dGluZ0F0OiB7JG5lOiBudWxsfX0sIHtzb3J0OiB7ZXhlY3V0aW5nQXQ6IDF9fSlcbiAgICB0aW1lb3V0ID0gMzAgKiAxMDAwXG4gICAgaWYgbmVhcmVzdFF1ZXJ5XG4gICAgICB0aW1lb3V0ID0gbmVhcmVzdFF1ZXJ5LmV4ZWN1dGluZ0F0LmdldFRpbWUoKSAtIG5ldyBEYXRlKCkuZ2V0VGltZSgpXG4gICAgaWYgQHRpbWVvdXRcbiAgICAgIE1ldGVvci5jbGVhclRpbWVvdXQoQHRpbWVvdXQpXG4gICAgdGltZW91dCA9IE1hdGgubWF4KDEwMDAsIHRpbWVvdXQpICMgYXQgbGVhc3QgYSBzZWNvbmQgaW4gZnV0dXJlOyBwcm90ZWN0aW9uIGZyb20gc3RhdGUgd2l0aCBleGVjdXRpbmdBdCBpbiB0aGUgcGFzdFxuIyAgICBjbCBcInJlc2V0VGltZW91dCB0byBcIiArIHRpbWVvdXRcbiAgICBAdGltZW91dCA9IE1ldGVvci5zZXRUaW1lb3V0KEBleGVjdXRlLCB0aW1lb3V0KVxuXG5fLmJpbmRBbGwoc2hhcmUucGVyaW9kaWNFeGVjdXRpb24sIFwiZXhlY3V0ZVwiLCBcInJlc2V0VGltZW91dFwiKVxuIl19

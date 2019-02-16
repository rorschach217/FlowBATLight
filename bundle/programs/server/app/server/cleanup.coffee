(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/cleanup.coffee                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var Process;
Process = Npm.require("child_process");

share.cleanupQuickQueries = function () {
  var borderline;
  borderline = new Date(new Date().getTime() - 7 * share.day); //  borderline = new Date(new Date().getTime() - 1000)

  return share.Queries.find({
    isQuick: true,
    executingInterval: {
      $lte: 0
    },
    updatedAt: {
      $lt: borderline
    }
  }).forEach(function (query) {
    return share.Queries.remove(query._id);
  });
};

share.cleanupCachedQueryResults = function () {
  var borderline, config;
  borderline = new Date(new Date().getTime() - 2 * share.day); //  borderline = new Date(new Date().getTime() - 1000)

  config = share.Configs.findOne({}, {
    transform: share.Transformations.config
  });
  return share.Queries.find({
    executingInterval: {
      $lte: 0
    },
    updatedAt: {
      $lt: borderline
    }
  }).forEach(function (query) {
    var rmCommand;
    rmCommand = "rm -f " + config.dataTempdir + "/" + query._id + ".rwf";

    if (config.isSSH) {
      rmCommand = config.wrapCommand(rmCommand);
    }

    return Process.exec(rmCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
      var code, error, result;
      result = stdout.trim();
      error = stderr.trim();
      code = err ? err.code : 0;

      if (error) {
        throw new Error(error);
      }
    }));
  });
};

share.Queries.after.remove(function (userId, query) {
  var config, rmCommand;
  config = share.Configs.findOne({}, {
    transform: share.Transformations.config
  });
  rmCommand = "rm -f " + config.dataTempdir + "/" + query._id + ".rwf";

  if (config.isSSH) {
    rmCommand = config.wrapCommand(rmCommand);
  }

  return Process.exec(rmCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
    var code, error, result;
    result = stdout.trim();
    error = stderr.trim();
    code = err ? err.code : 0;

    if (error) {
      throw new Error(error);
    }
  }));
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/cleanup.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2NsZWFudXAuY29mZmVlIl0sIm5hbWVzIjpbIlByb2Nlc3MiLCJOcG0iLCJyZXF1aXJlIiwic2hhcmUiLCJjbGVhbnVwUXVpY2tRdWVyaWVzIiwiYm9yZGVybGluZSIsIkRhdGUiLCJnZXRUaW1lIiwiZGF5IiwiUXVlcmllcyIsImZpbmQiLCJpc1F1aWNrIiwiZXhlY3V0aW5nSW50ZXJ2YWwiLCIkbHRlIiwidXBkYXRlZEF0IiwiJGx0IiwiZm9yRWFjaCIsInF1ZXJ5IiwicmVtb3ZlIiwiX2lkIiwiY2xlYW51cENhY2hlZFF1ZXJ5UmVzdWx0cyIsImNvbmZpZyIsIkNvbmZpZ3MiLCJmaW5kT25lIiwidHJhbnNmb3JtIiwiVHJhbnNmb3JtYXRpb25zIiwicm1Db21tYW5kIiwiZGF0YVRlbXBkaXIiLCJpc1NTSCIsIndyYXBDb21tYW5kIiwiZXhlYyIsIk1ldGVvciIsImJpbmRFbnZpcm9ubWVudCIsImVyciIsInN0ZG91dCIsInN0ZGVyciIsImNvZGUiLCJlcnJvciIsInJlc3VsdCIsInRyaW0iLCJFcnJvciIsImFmdGVyIiwidXNlcklkIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxPQUFBO0FBQUFBLE9BQUEsR0FBVUMsR0FBRyxDQUFDQyxPQUFKLENBQVksZUFBWixDQUFWOztBQUVBQyxLQUFLLENBQUNDLG1CQUFOLEdBQTRCO0FBQzFCLE1BQUFDLFVBQUE7QUFBQUEsWUFBQSxHQUFhLElBQUlDLElBQUosQ0FBUyxJQUFJQSxJQUFKLEdBQVdDLE9BQVgsS0FBdUIsSUFBSUosS0FBSyxDQUFDSyxHQUExQyxDQUFiLENBRDBCLENBSzFCOztBQUNBLFNBSEFMLEtBQUssQ0FBQ00sT0FBTixDQUFjQyxJQUFkLENBQW1CO0FBQUNDLFdBQUEsRUFBUyxJQUFWO0FBQWdCQyxxQkFBQSxFQUFtQjtBQUFDQyxVQUFBLEVBQU07QUFBUCxLQUFuQztBQUE4Q0MsYUFBQSxFQUFXO0FBQUNDLFNBQUEsRUFBS1Y7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R0FBVUgsR0FBSCxHQUFZQSxHQUFHLENBQUNHLElBQWhCLEdBQTBCLENBQWpDOztBQUNBLFFBQUdDLEtBQUg7QUFDRSxZQUFNLElBQUlHLEtBQUosQ0FBVUgsS0FBVixDQUFOO0FBbUNEO0FBeENxQixJQUF4QixDQWlDQTtBQXRDRixHIiwiZmlsZSI6Ii9zZXJ2ZXIvY2xlYW51cC5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJQcm9jZXNzID0gTnBtLnJlcXVpcmUoXCJjaGlsZF9wcm9jZXNzXCIpXG5cbnNoYXJlLmNsZWFudXBRdWlja1F1ZXJpZXMgPSAtPlxuICBib3JkZXJsaW5lID0gbmV3IERhdGUobmV3IERhdGUoKS5nZXRUaW1lKCkgLSA3ICogc2hhcmUuZGF5KVxuIyAgYm9yZGVybGluZSA9IG5ldyBEYXRlKG5ldyBEYXRlKCkuZ2V0VGltZSgpIC0gMTAwMClcbiAgc2hhcmUuUXVlcmllcy5maW5kKHtpc1F1aWNrOiB0cnVlLCBleGVjdXRpbmdJbnRlcnZhbDogeyRsdGU6IDB9LCB1cGRhdGVkQXQ6IHskbHQ6IGJvcmRlcmxpbmV9fSkuZm9yRWFjaCAocXVlcnkpIC0+XG4gICAgc2hhcmUuUXVlcmllcy5yZW1vdmUocXVlcnkuX2lkKVxuXG5zaGFyZS5jbGVhbnVwQ2FjaGVkUXVlcnlSZXN1bHRzID0gLT5cbiAgYm9yZGVybGluZSA9IG5ldyBEYXRlKG5ldyBEYXRlKCkuZ2V0VGltZSgpIC0gMiAqIHNoYXJlLmRheSlcbiMgIGJvcmRlcmxpbmUgPSBuZXcgRGF0ZShuZXcgRGF0ZSgpLmdldFRpbWUoKSAtIDEwMDApXG4gIGNvbmZpZyA9IHNoYXJlLkNvbmZpZ3MuZmluZE9uZSh7fSwge3RyYW5zZm9ybTogc2hhcmUuVHJhbnNmb3JtYXRpb25zLmNvbmZpZ30pXG4gIHNoYXJlLlF1ZXJpZXMuZmluZCh7ZXhlY3V0aW5nSW50ZXJ2YWw6IHskbHRlOiAwfSwgdXBkYXRlZEF0OiB7JGx0OiBib3JkZXJsaW5lfX0pLmZvckVhY2ggKHF1ZXJ5KSAtPlxuICAgIHJtQ29tbWFuZCA9IFwicm0gLWYgXCIgKyBjb25maWcuZGF0YVRlbXBkaXIgKyBcIi9cIiArIHF1ZXJ5Ll9pZCArIFwiLnJ3ZlwiXG4gICAgaWYgY29uZmlnLmlzU1NIXG4gICAgICBybUNvbW1hbmQgPSBjb25maWcud3JhcENvbW1hbmQocm1Db21tYW5kKVxuICAgIFByb2Nlc3MuZXhlYyhybUNvbW1hbmQsIE1ldGVvci5iaW5kRW52aXJvbm1lbnQoKGVyciwgc3Rkb3V0LCBzdGRlcnIpIC0+XG4gICAgICByZXN1bHQgPSBzdGRvdXQudHJpbSgpXG4gICAgICBlcnJvciA9IHN0ZGVyci50cmltKClcbiAgICAgIGNvZGUgPSBpZiBlcnIgdGhlbiBlcnIuY29kZSBlbHNlIDBcbiAgICAgIGlmIGVycm9yXG4gICAgICAgIHRocm93IG5ldyBFcnJvcihlcnJvcilcbiAgICApKVxuXG5zaGFyZS5RdWVyaWVzLmFmdGVyLnJlbW92ZSAodXNlcklkLCBxdWVyeSkgLT5cbiAgY29uZmlnID0gc2hhcmUuQ29uZmlncy5maW5kT25lKHt9LCB7dHJhbnNmb3JtOiBzaGFyZS5UcmFuc2Zvcm1hdGlvbnMuY29uZmlnfSlcbiAgcm1Db21tYW5kID0gXCJybSAtZiBcIiArIGNvbmZpZy5kYXRhVGVtcGRpciArIFwiL1wiICsgcXVlcnkuX2lkICsgXCIucndmXCJcbiAgaWYgY29uZmlnLmlzU1NIXG4gICAgcm1Db21tYW5kID0gY29uZmlnLndyYXBDb21tYW5kKHJtQ29tbWFuZClcbiAgUHJvY2Vzcy5leGVjKHJtQ29tbWFuZCwgTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCBzdGRvdXQsIHN0ZGVycikgLT5cbiAgICByZXN1bHQgPSBzdGRvdXQudHJpbSgpXG4gICAgZXJyb3IgPSBzdGRlcnIudHJpbSgpXG4gICAgY29kZSA9IGlmIGVyciB0aGVuIGVyci5jb2RlIGVsc2UgMFxuICAgIGlmIGVycm9yXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoZXJyb3IpXG4gICkpXG4iXX0=

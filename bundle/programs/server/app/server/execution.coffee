(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/execution.coffee                                             //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var Future, Process, executeQuery, fs, loadQueryResult, writeFile;
fs = Npm.require("fs");
Process = Npm.require("child_process");
Future = Npm.require('fibers/future');
writeFile = Future.wrap(fs.writeFile);
share.Queries.after.update(function (userId, query, fieldNames, modifier, options) {
  if (_.intersection(fieldNames, share.inputFields).length) {
    return share.Queries.update(query._id, {
      $set: {
        isInputStale: true
      }
    });
  }
});
share.Queries.after.update(function (userId, query, fieldNames, modifier, options) {
  var callback, config, profile;

  if (!query.isOutputStale) {
    return;
  }

  config = share.Configs.findOne({}, {
    transform: share.Transformations.config
  });
  query = share.Transformations.query(query);

  if (!query.inputOptions(config)) {
    share.Queries.update(query._id, {
      $set: {
        isInputStale: false,
        isOutputStale: false
      }
    });
    return;
  }

  profile = Meteor.users.findOne(query.ownerId).profile;

  callback = function (result, error, code) {
    return share.Queries.update(query._id, {
      $set: {
        result: result,
        error: error,
        code: code,
        isInputStale: false,
        isOutputStale: false
      }
    });
  };

  return loadQueryResult(query, config, profile, callback);
});
Meteor.methods({
  checkConnection: function () {
    var callback, config, fut, profile, query, queryId;

    if (!this.userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    queryId = share.Queries.insert({
      interface: "cmd",
      cmd: "--protocol=0-255",
      isQuick: true
    });
    config = share.Configs.findOne({}, {
      transform: share.Transformations.config
    });
    profile = Meteor.users.findOne(this.userId).profile;
    query = share.Queries.findOne(queryId, {
      transform: share.Transformations.query
    });
    this.unblock();
    fut = new Future();

    callback = function (result, error, code) {
      if (error) {
        return fut.throw(new Meteor.Error(500, error));
      } else {
        return fut.return(result);
      }
    };

    executeQuery(query, config, profile, callback);
    return fut.wait();
  },
  // quick queries are cleaned up automatically
  loadDataForCSV: function (queryId) {
    var callback, config, fut, query;
    check(queryId, Match.App.QueryId);

    if (!this.userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    config = share.Configs.findOne({}, {
      transform: share.Transformations.config
    });
    query = share.Queries.findOne(queryId, {
      transform: share.Transformations.query
    });

    if (this.userId !== query.ownerId) {
      throw new Match.Error("Operation not allowed for non-owners");
    }

    this.unblock();
    fut = new Future();

    callback = function (result, error, code) {
      if (error) {
        return fut.throw(new Error(error));
      } else {
        return fut.return(result);
      }
    };

    query.startRecNum = 1;
    loadQueryResult(query, config, {
      numRecs: 0
    }, callback);
    return fut.wait();
  },
  getRwfToken: function (queryId) {
    var callback, config, fut, profile, query, token;
    check(queryId, Match.App.QueryId);

    if (!this.userId) {
      throw new Match.Error("Operation not allowed for unauthorized users");
    }

    config = share.Configs.findOne({}, {
      transform: share.Transformations.config
    });
    profile = Meteor.users.findOne(this.userId).profile;
    query = share.Queries.findOne(queryId, {
      transform: share.Transformations.query
    });

    if (this.userId !== query.ownerId) {
      throw new Match.Error("Operation not allowed for non-owners");
    }

    this.unblock();
    token = Random.id();
    fut = new Future();

    callback = function (result, error, code) {
      var copyCommand;

      if (error) {
        return fut.throw(new Error(error));
      } else {
        if (config.isSSH) {
          copyCommand = "scp " + config.getSSHOptions() + " -P " + config.port + " " + config.user + "@" + config.host + ":" + config.dataTempdir + "/" + query._id + ".rwf " + "/tmp" + "/" + token + ".rwf";
        } else {
          copyCommand = "cp " + config.dataTempdir + "/" + query._id + ".rwf " + "/tmp" + "/" + token + ".rwf";
        }

        return Process.exec(copyCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
          result = stdout.trim();
          error = stderr.trim();
          code = err ? err.code : 0;

          if (error) {
            return fut.throw(new Error(error));
          } else {
            return fut.return(token);
          }
        }));
      }
    };

    executeQuery(query, config, profile, callback);
    return fut.wait();
  }
});

executeQuery = function (query, config, profile, callback) {
  var command, isIpsetStale, isTupleStale, rwsetbuildErrors, rwsetbuildFutures, tuplebuildErrors, tuplebuildFutures;
  rwsetbuildErrors = [];
  rwsetbuildFutures = [];
  isIpsetStale = false;

  _.each(["dipSet", "sipSet", "anySet"], function (field) {
    var rmCommand, rmFuture, rwsFilename, rwsetbuildFuture, scpCommand, scpFuture, set, txtFilename, writeFileFuture;

    if (query[field + "Enabled"] && query[field]) {
      set = share.IPSets.findOne(query[field]);

      if (set.isOutputStale) {
        isIpsetStale = true;
        rwsetbuildFuture = new Future();
        txtFilename = "/tmp" + "/" + set._id + ".txt";
        rwsFilename = config.dataTempdir + "/" + set._id + ".rws";
        writeFileFuture = writeFile(txtFilename, set.contents);

        if (config.isSSH) {
          scpCommand = "scp " + config.getSSHOptions() + " -P " + config.port + " " + txtFilename + " " + config.user + "@" + config.host + ":" + txtFilename;
          scpFuture = new Future();
          Process.exec(scpCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
            var code, error, result;
            result = stdout.trim();
            error = stderr.trim();
            code = err ? err.code : 0;

            if (error) {
              rwsetbuildErrors.push(error);
            }

            if (code === 0) {} else {
              if (!error) {
                throw "scp: code is \"" + code + "\" while stderr is \"" + error + "\"";
              }
            }

            return scpFuture.return(result);
          }));
          scpFuture.wait();
        }

        rmCommand = "rm -f " + rwsFilename;

        if (config.isSSH) {
          rmCommand = config.wrapCommand(rmCommand);
        }

        rmFuture = new Future();
        Process.exec(rmCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
          var code, error, result;
          result = stdout.trim();
          error = stderr.trim();
          code = err ? err.code : 0;

          if (error) {
            rwsetbuildErrors.push(error);
          }

          if (code === 0) {} else {
            if (!error) {
              throw "rm: code is \"" + code + "\" while stderr is \"" + error + "\"";
            }
          }

          return rmFuture.return(result);
        }));
        rmFuture.wait();
        writeFileFuture.resolve(Meteor.bindEnvironment(function (err, result) {
          var rwsetbuildCommand;

          if (err) {
            rwsetbuildErrors.push(err);
            return rwsetbuildFuture.return(result);
          } else {
            rwsetbuildCommand = "rwsetbuild " + txtFilename + " " + rwsFilename;

            if (config.isSSH) {
              rwsetbuildCommand = config.wrapCommand(rwsetbuildCommand);
            }

            return Process.exec(rwsetbuildCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
              var code, error;
              result = stdout.trim();
              error = stderr.trim();
              code = err ? err.code : 0;

              if (error) {
                rwsetbuildErrors.push(error);
              }

              if (code === 0) {
                share.IPSets.update(set._id, {
                  $set: {
                    isOutputStale: false
                  }
                });
              } else {
                if (!error) {
                  throw "rwsetbuild: code is \"" + code + "\" while stderr is \"" + error + "\"";
                }
              }

              return rwsetbuildFuture.return(result);
            }));
          }
        }));
        return rwsetbuildFutures.push(rwsetbuildFuture);
      }
    }
  });

  Future.wait(rwsetbuildFutures);

  if (rwsetbuildErrors.length) {
    callback("", rwsetbuildErrors.join("\n"), 255);
    return;
  }

  if (!query.isInputStale && !isIpsetStale) {
    callback("", "", 0);
    return;
  }

  tuplebuildErrors = [];
  tuplebuildFutures = [];
  isTupleStale = false;

  _.each(["tupleFile"], function (field) {
    var rmCommand, rmFuture, scpCommand, scpFuture, set, tupleFilename, tuplebuildFuture, txtFilename, writeFileFuture;

    if (query[field + "Enabled"] && query[field]) {
      set = share.Tuples.findOne(query[field]);

      if (set.isOutputStale) {
        isTupleStale = true;
        tuplebuildFuture = new Future();
        txtFilename = "/tmp" + "/" + set._id + ".txt";
        tupleFilename = config.dataTempdir + "/" + set._id + ".tuple";
        writeFileFuture = writeFile(txtFilename, set.contents);

        if (config.isSSH) {
          scpCommand = "scp " + config.getSSHOptions() + " -P " + config.port + " " + txtFilename + " " + config.user + "@" + config.host + ":" + txtFilename;
          scpFuture = new Future();
          Process.exec(scpCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
            var code, error, result;
            result = stdout.trim();
            error = stderr.trim();
            code = err ? err.code : 0;

            if (error) {
              tuplebuildErrors.push(error);
            }

            if (code === 0) {} else {
              if (!error) {
                throw "scp: code is \"" + code + "\" while stderr is \"" + error + "\"";
              }
            }

            return scpFuture.return(result);
          }));
          scpFuture.wait();
        }

        rmCommand = "rm -f " + tupleFilename;

        if (config.isSSH) {
          rmCommand = config.wrapCommand(rmCommand);
        }

        rmFuture = new Future();
        Process.exec(rmCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
          var code, error, result;
          result = stdout.trim();
          error = stderr.trim();
          code = err ? err.code : 0;

          if (error) {
            tuplebuildErrors.push(error);
          }

          if (code === 0) {} else {
            if (!error) {
              throw "rm: code is \"" + code + "\" while stderr is \"" + error + "\"";
            }
          }

          return rmFuture.return(result);
        }));
        rmFuture.wait();
        writeFileFuture.resolve(Meteor.bindEnvironment(function (err, result) {
          var tuplebuildCommand;

          if (err) {
            tuplebuildErrors.push(err);
            return tuplebuildFuture.return(result);
          } else {
            tuplebuildCommand = "cat " + txtFilename + " > " + tupleFilename;

            if (config.isSSH) {
              tuplebuildCommand = config.wrapCommand(tuplebuildCommand);
            }

            return Process.exec(tuplebuildCommand, Meteor.bindEnvironment(function (err, stdout, stderr) {
              var code, error;
              result = stdout.trim();
              error = stderr.trim();
              code = err ? err.code : 0;

              if (error) {
                tuplebuildErrors.push(error);
              }

              if (code === 0) {
                share.Tuples.update(set._id, {
                  $set: {
                    isOutputStale: false
                  }
                });
              } else {
                if (!error) {
                  throw "tuplebuild: code is \"" + code + "\" while stderr is \"" + error + "\"";
                }
              }

              return tuplebuildFuture.return(result);
            }));
          }
        }));
        return tuplebuildFutures.push(tuplebuildFuture);
      }
    }
  });

  Future.wait(tuplebuildFutures);

  if (tuplebuildErrors.length) {
    callback("", tuplebuildErrors.join("\n"), 255);
    return;
  }

  if (!query.isInputStale && !isTupleStale) {
    callback("", "", 0);
    return;
  }

  command = query.inputCommand(config, profile);
  return Process.exec(command, Meteor.bindEnvironment(function (err, stdout, stderr) {
    var code, error, result;
    result = stdout.trim();
    error = stderr.trim();
    code = err ? err.code : 0;

    if (error.indexOf("Rejected") !== -1) {
      error = null;
    }

    return callback(result, error, code);
  }));
};

loadQueryResult = function (query, config, profile, callback) {
  return executeQuery(query, config, profile, Meteor.bindEnvironment(function (result, error, code) {
    var command;

    if (error) {
      return callback(result, error, code);
    }

    command = query.outputCommand(config, profile);
    return Process.exec(command, Meteor.bindEnvironment(function (err, stdout, stderr) {
      result = stdout.trim();
      error = stderr.trim();
      code = err ? err.code : 0;

      if (error.indexOf("Error opening file") !== -1) {
        query.isInputStale = true;
        return loadQueryResult(query, config, profile, callback);
      } else {
        return callback(result, error, code);
      }
    }));
  }));
};
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/execution.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2V4ZWN1dGlvbi5jb2ZmZWUiXSwibmFtZXMiOlsiRnV0dXJlIiwiUHJvY2VzcyIsImV4ZWN1dGVRdWVyeSIsImZzIiwibG9hZFF1ZXJ5UmVzdWx0Iiwid3JpdGVGaWxlIiwiTnBtIiwicmVxdWlyZSIsIndyYXAiLCJzaGFyZSIsIlF1ZXJpZXMiLCJhZnRlciIsInVwZGF0ZSIsInVzZXJJZCIsInF1ZXJ5IiwiZmllbGROYW1lcyIsIm1vZGlmaWVyIiwib3B0aW9ucyIsIl8iLCJpbnRlcnNlY3Rpb24iLCJpbnB1dEZpZWxkcyIsImxlbmd0aCIsIl9pZCIsIiRzZXQiLCJpc0lucHV0U3RhbGUiLCJjYWxsYmFjayIsImNvbmZpZyIsInByb2ZpbGUiLCJpc091dHB1dFN0YWxlIiwiQ29uZmlncyIsImZpbmRPbmUiLCJ0cmFuc2Zvcm0iLCJUcmFuc2Zvcm1hdGlvbnMiLCJpbnB1dE9wdGlvbnMiLCJNZXRlb3IiLCJ1c2VycyIsIm93bmVySWQiLCJyZXN1bHQiLCJlcnJvciIsImNvZGUiLCJtZXRob2RzIiwiY2hlY2tDb25uZWN0aW9uIiwiZnV0IiwicXVlcnlJZCIsIk1hdGNoIiwiRXJyb3IiLCJpbnNlcnQiLCJpbnRlcmZhY2UiLCJjbWQiLCJpc1F1aWNrIiwidW5ibG9jayIsInRocm93IiwicmV0dXJuIiwid2FpdCIsImxvYWREYXRhRm9yQ1NWIiwiY2hlY2siLCJBcHAiLCJRdWVyeUlkIiwic3RhcnRSZWNOdW0iLCJudW1SZWNzIiwiZ2V0UndmVG9rZW4iLCJ0b2tlbiIsIlJhbmRvbSIsImlkIiwiY29weUNvbW1hbmQiLCJpc1NTSCIsImdldFNTSE9wdGlvbnMiLCJwb3J0IiwidXNlciIsImhvc3QiLCJkYXRhVGVtcGRpciIsImV4ZWMiLCJiaW5kRW52aXJvbm1lbnQiLCJlcnIiLCJzdGRvdXQiLCJzdGRlcnIiLCJ0cmltIiwiY29tbWFuZCIsImlzSXBzZXRTdGFsZSIsImlzVHVwbGVTdGFsZSIsInJ3c2V0YnVpbGRFcnJvcnMiLCJyd3NldGJ1aWxkRnV0dXJlcyIsInR1cGxlYnVpbGRFcnJvcnMiLCJ0dXBsZWJ1aWxkRnV0dXJlcyIsImVhY2giLCJmaWVsZCIsInJtQ29tbWFuZCIsInJtRnV0dXJlIiwicndzRmlsZW5hbWUiLCJyd3NldGJ1aWxkRnV0dXJlIiwic2NwQ29tbWFuZCIsInNjcEZ1dHVyZSIsInNldCIsInR4dEZpbGVuYW1lIiwid3JpdGVGaWxlRnV0dXJlIiwiSVBTZXRzIiwiY29udGVudHMiLCJwdXNoIiwid3JhcENvbW1hbmQiLCJyZXNvbHZlIiwicndzZXRidWlsZENvbW1hbmQiLCJqb2luIiwidHVwbGVGaWxlbmFtZSIsInR1cGxlYnVpbGRGdXR1cmUiLCJUdXBsZXMiLCJ0dXBsZWJ1aWxkQ29tbWFuZCIsImlucHV0Q29tbWFuZCIsImluZGV4T2YiLCJvdXRwdXRDb21tYW5kIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxNQUFBLEVBQUFDLE9BQUEsRUFBQUMsWUFBQSxFQUFBQyxFQUFBLEVBQUFDLGVBQUEsRUFBQUMsU0FBQTtBQUFBRixFQUFBLEdBQUtHLEdBQUcsQ0FBQ0MsT0FBSixDQUFZLElBQVosQ0FBTDtBQUNBTixPQUFBLEdBQVVLLEdBQUcsQ0FBQ0MsT0FBSixDQUFZLGVBQVosQ0FBVjtBQUNBUCxNQUFBLEdBQVNNLEdBQUcsQ0FBQ0MsT0FBSixDQUFZLGVBQVosQ0FBVDtBQUNBRixTQUFBLEdBQVlMLE1BQU0sQ0FBQ1EsSUFBUCxDQUFZTCxFQUFFLENBQUNFLFNBQWYsQ0FBWjtBQUVBSSxLQUFLLENBQUNDLE9BQU4sQ0FBY0MsS0FBZCxDQUFvQkMsTUFBcEIsQ0FBMkIsVUFBQ0MsTUFBRCxFQUFTQyxLQUFULEVBQWdCQyxVQUFoQixFQUE0QkMsUUFBNUIsRUFBc0NDLE9BQXRDO0FBQ3pCLE1BQUdDLENBQUMsQ0FBQ0MsWUFBRixDQUFlSixVQUFmLEVBQTJCTixLQUFLLENBQUNXLFdBQWpDLEVBQThDQyxNQUFqRDtBQU1FLFdBTEFaLEtBQUssQ0FBQ0MsT0FBTixDQUFj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Q0FBVjtBQTJIQSxXQTFIQTFCLE9BQU8sQ0FBQ3NFLElBQVIsQ0FBYU0sT0FBYixFQUFzQjNDLE1BQU0sQ0FBQ3NDLGVBQVAsQ0FBdUIsVUFBQ0MsR0FBRCxFQUFNQyxNQUFOLEVBQWNDLE1BQWQ7QUFDM0N0QyxZQUFBLEdBQVNxQyxNQUFNLENBQUNFLElBQVAsRUFBVDtBQUNBdEMsV0FBQSxHQUFRcUMsTUFBTSxDQUFDQyxJQUFQLEVBQVI7QUFDQXJDLFVBQUEsR0FBVWtDLEdBQUgsR0FBWUEsR0FBRyxDQUFDbEMsSUFBaEIsR0FBMEIsQ0FBakM7O0FBQ0EsVUFBR0QsS0FBSyxDQUFDcUUsT0FBTixDQUFjLG9CQUFkLE1BQXlDLENBQUMsQ0FBN0M7QUFDRTdGLGFBQUssQ0FBQ1UsWUFBTixHQUFxQixJQUFyQjtBQTJIQSxlQTFIQXBCLGVBQUEsQ0FBZ0JVLEtBQWhCLEVBQXVCWSxNQUF2QixFQUErQkMsT0FBL0IsRUFBd0NGLFFBQXhDLENBMEhBO0FBNUhGO0FBOEhFLGVBMUhBQSxRQUFBLENBQVNZLE1BQVQsRUFBaUJDLEtBQWpCLEVBQXdCQyxJQUF4QixDQTBIQTtBQUNEO0FBbkltQixNQUF0QixDQTBIQTtBQTlIbUMsSUFBckMsQ0F3SEE7QUF6SGdCLENBQWxCLEMiLCJmaWxlIjoiL3NlcnZlci9leGVjdXRpb24uY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsiZnMgPSBOcG0ucmVxdWlyZShcImZzXCIpXG5Qcm9jZXNzID0gTnBtLnJlcXVpcmUoXCJjaGlsZF9wcm9jZXNzXCIpXG5GdXR1cmUgPSBOcG0ucmVxdWlyZSgnZmliZXJzL2Z1dHVyZScpXG53cml0ZUZpbGUgPSBGdXR1cmUud3JhcChmcy53cml0ZUZpbGUpXG5cbnNoYXJlLlF1ZXJpZXMuYWZ0ZXIudXBkYXRlICh1c2VySWQsIHF1ZXJ5LCBmaWVsZE5hbWVzLCBtb2RpZmllciwgb3B0aW9ucykgLT5cbiAgaWYgXy5pbnRlcnNlY3Rpb24oZmllbGROYW1lcywgc2hhcmUuaW5wdXRGaWVsZHMpLmxlbmd0aFxuICAgIHNoYXJlLlF1ZXJpZXMudXBkYXRlKHF1ZXJ5Ll9pZCwgeyRzZXQ6IHtpc0lucHV0U3RhbGU6IHRydWV9fSlcblxuc2hhcmUuUXVlcmllcy5hZnRlci51cGRhdGUgKHVzZXJJZCwgcXVlcnksIGZpZWxkTmFtZXMsIG1vZGlmaWVyLCBvcHRpb25zKSAtPlxuICBpZiBub3QgcXVlcnkuaXNPdXRwdXRTdGFsZVxuICAgIHJldHVyblxuICBjb25maWcgPSBzaGFyZS5Db25maWdzLmZpbmRPbmUoe30sIHt0cmFuc2Zvcm06IHNoYXJlLlRyYW5zZm9ybWF0aW9ucy5jb25maWd9KVxuICBxdWVyeSA9IHNoYXJlLlRyYW5zZm9ybWF0aW9ucy5xdWVyeShxdWVyeSlcbiAgaWYgbm90IHF1ZXJ5LmlucHV0T3B0aW9ucyhjb25maWcpXG4gICAgc2hhcmUuUXVlcmllcy51cGRhdGUocXVlcnkuX2lkLCB7JHNldDoge2lzSW5wdXRTdGFsZTogZmFsc2UsIGlzT3V0cHV0U3RhbGU6IGZhbHNlfX0pXG4gICAgcmV0dXJuXG4gIHByb2ZpbGUgPSBNZXRlb3IudXNlcnMuZmluZE9uZShxdWVyeS5vd25lcklkKS5wcm9maWxlXG4gIGNhbGxiYWNrID0gKHJlc3VsdCwgZXJyb3IsIGNvZGUpIC0+XG4gICAgc2hhcmUuUXVlcmllcy51cGRhdGUocXVlcnkuX2lkLCB7JHNldDoge3Jlc3VsdDogcmVzdWx0LCBlcnJvcjogZXJyb3IsIGNvZGU6IGNvZGUsIGlzSW5wdXRTdGFsZTogZmFsc2UsIGlzT3V0cHV0U3RhbGU6IGZhbHNlfX0pXG4gIGxvYWRRdWVyeVJlc3VsdChxdWVyeSwgY29uZmlnLCBwcm9maWxlLCBjYWxsYmFjaylcblxuTWV0ZW9yLm1ldGhvZHNcbiAgY2hlY2tDb25uZWN0aW9uOiAtPlxuICAgIHVubGVzcyBAdXNlcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIHVuYXV0aG9yaXplZCB1c2Vyc1wiKVxuICAgIHF1ZXJ5SWQgPSBzaGFyZS5RdWVyaWVzLmluc2VydCh7XG4gICAgICBpbnRlcmZhY2U6IFwiY21kXCJcbiAgICAgIGNtZDogXCItLXByb3RvY29sPTAtMjU1XCJcbiAgICAgIGlzUXVpY2s6IHRydWVcbiAgICB9KVxuICAgIGNvbmZpZyA9IHNoYXJlLkNvbmZpZ3MuZmluZE9uZSh7fSwge3RyYW5zZm9ybTogc2hhcmUuVHJhbnNmb3JtYXRpb25zLmNvbmZpZ30pXG4gICAgcHJvZmlsZSA9IE1ldGVvci51c2Vycy5maW5kT25lKEB1c2VySWQpLnByb2ZpbGVcbiAgICBxdWVyeSA9IHNoYXJlLlF1ZXJpZXMuZmluZE9uZShxdWVyeUlkLCB7dHJhbnNmb3JtOiBzaGFyZS5UcmFuc2Zvcm1hdGlvbnMucXVlcnl9KVxuICAgIEB1bmJsb2NrKClcbiAgICBmdXQgPSBuZXcgRnV0dXJlKClcbiAgICBjYWxsYmFjayA9IChyZXN1bHQsIGVycm9yLCBjb2RlKSAtPlxuICAgICAgaWYgZXJyb3JcbiAgICAgICAgZnV0LnRocm93KG5ldyBNZXRlb3IuRXJyb3IoNTAwLCBlcnJvcikpXG4gICAgICBlbHNlXG4gICAgICAgIGZ1dC5yZXR1cm4ocmVzdWx0KVxuICAgIGV4ZWN1dGVRdWVyeShxdWVyeSwgY29uZmlnLCBwcm9maWxlLCBjYWxsYmFjaylcbiAgICBmdXQud2FpdCgpXG4gICAgIyBxdWljayBxdWVyaWVzIGFyZSBjbGVhbmVkIHVwIGF1dG9tYXRpY2FsbHlcbiAgbG9hZERhdGFGb3JDU1Y6IChxdWVyeUlkKSAtPlxuICAgIGNoZWNrKHF1ZXJ5SWQsIE1hdGNoLkFwcC5RdWVyeUlkKVxuICAgIHVubGVzcyBAdXNlcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIHVuYXV0aG9yaXplZCB1c2Vyc1wiKVxuICAgIGNvbmZpZyA9IHNoYXJlLkNvbmZpZ3MuZmluZE9uZSh7fSwge3RyYW5zZm9ybTogc2hhcmUuVHJhbnNmb3JtYXRpb25zLmNvbmZpZ30pXG4gICAgcXVlcnkgPSBzaGFyZS5RdWVyaWVzLmZpbmRPbmUocXVlcnlJZCwge3RyYW5zZm9ybTogc2hhcmUuVHJhbnNmb3JtYXRpb25zLnF1ZXJ5fSlcbiAgICB1bmxlc3MgQHVzZXJJZCBpcyBxdWVyeS5vd25lcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIG5vbi1vd25lcnNcIilcbiAgICBAdW5ibG9jaygpXG4gICAgZnV0ID0gbmV3IEZ1dHVyZSgpXG4gICAgY2FsbGJhY2sgPSAocmVzdWx0LCBlcnJvciwgY29kZSkgLT5cbiAgICAgIGlmIGVycm9yXG4gICAgICAgIGZ1dC50aHJvdyhuZXcgRXJyb3IoZXJyb3IpKVxuICAgICAgZWxzZVxuICAgICAgICBmdXQucmV0dXJuKHJlc3VsdClcbiAgICBxdWVyeS5zdGFydFJlY051bSA9IDFcbiAgICBsb2FkUXVlcnlSZXN1bHQocXVlcnksIGNvbmZpZywge251bVJlY3M6IDB9LCBjYWxsYmFjaylcbiAgICBmdXQud2FpdCgpXG4gIGdldFJ3ZlRva2VuOiAocXVlcnlJZCkgLT5cbiAgICBjaGVjayhxdWVyeUlkLCBNYXRjaC5BcHAuUXVlcnlJZClcbiAgICB1bmxlc3MgQHVzZXJJZFxuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiT3BlcmF0aW9uIG5vdCBhbGxvd2VkIGZvciB1bmF1dGhvcml6ZWQgdXNlcnNcIilcbiAgICBjb25maWcgPSBzaGFyZS5Db25maWdzLmZpbmRPbmUoe30sIHt0cmFuc2Zvcm06IHNoYXJlLlRyYW5zZm9ybWF0aW9ucy5jb25maWd9KVxuICAgIHByb2ZpbGUgPSBNZXRlb3IudXNlcnMuZmluZE9uZShAdXNlcklkKS5wcm9maWxlXG4gICAgcXVlcnkgPSBzaGFyZS5RdWVyaWVzLmZpbmRPbmUocXVlcnlJZCwge3RyYW5zZm9ybTogc2hhcmUuVHJhbnNmb3JtYXRpb25zLnF1ZXJ5fSlcbiAgICB1bmxlc3MgQHVzZXJJZCBpcyBxdWVyeS5vd25lcklkXG4gICAgICB0aHJvdyBuZXcgTWF0Y2guRXJyb3IoXCJPcGVyYXRpb24gbm90IGFsbG93ZWQgZm9yIG5vbi1vd25lcnNcIilcbiAgICBAdW5ibG9jaygpXG4gICAgdG9rZW4gPSBSYW5kb20uaWQoKVxuICAgIGZ1dCA9IG5ldyBGdXR1cmUoKVxuICAgIGNhbGxiYWNrID0gKHJlc3VsdCwgZXJyb3IsIGNvZGUpIC0+XG4gICAgICBpZiBlcnJvclxuICAgICAgICBmdXQudGhyb3cobmV3IEVycm9yKGVycm9yKSlcbiAgICAgIGVsc2VcbiAgICAgICAgaWYgY29uZmlnLmlzU1NIXG4gICAgICAgICAgY29weUNvbW1hbmQgPSBcInNjcCBcIiArIGNvbmZpZy5nZXRTU0hPcHRpb25zKCkgKyBcIiAtUCBcIiArIGNvbmZpZy5wb3J0ICsgXCIgXCIgKyBjb25maWcudXNlciArIFwiQFwiICsgY29uZmlnLmhvc3QgKyBcIjpcIiArIGNvbmZpZy5kYXRhVGVtcGRpciArIFwiL1wiICsgcXVlcnkuX2lkICsgXCIucndmIFwiICsgXCIvdG1wXCIgKyBcIi9cIiArIHRva2VuICsgXCIucndmXCJcbiAgICAgICAgZWxzZVxuICAgICAgICAgIGNvcHlDb21tYW5kID0gXCJjcCBcIiArIGNvbmZpZy5kYXRhVGVtcGRpciArIFwiL1wiICsgcXVlcnkuX2lkICsgXCIucndmIFwiICsgXCIvdG1wXCIgKyBcIi9cIiArIHRva2VuICsgXCIucndmXCJcbiAgICAgICAgUHJvY2Vzcy5leGVjKGNvcHlDb21tYW5kLCBNZXRlb3IuYmluZEVudmlyb25tZW50KChlcnIsIHN0ZG91dCwgc3RkZXJyKSAtPlxuICAgICAgICAgIHJlc3VsdCA9IHN0ZG91dC50cmltKClcbiAgICAgICAgICBlcnJvciA9IHN0ZGVyci50cmltKClcbiAgICAgICAgICBjb2RlID0gaWYgZXJyIHRoZW4gZXJyLmNvZGUgZWxzZSAwXG4gICAgICAgICAgaWYgZXJyb3JcbiAgICAgICAgICAgIGZ1dC50aHJvdyhuZXcgRXJyb3IoZXJyb3IpKVxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIGZ1dC5yZXR1cm4odG9rZW4pXG4gICAgICAgICkpXG4gICAgZXhlY3V0ZVF1ZXJ5KHF1ZXJ5LCBjb25maWcsIHByb2ZpbGUsIGNhbGxiYWNrKVxuICAgIGZ1dC53YWl0KClcblxuZXhlY3V0ZVF1ZXJ5ID0gKHF1ZXJ5LCBjb25maWcsIHByb2ZpbGUsIGNhbGxiYWNrKSAtPlxuICByd3NldGJ1aWxkRXJyb3JzID0gW11cbiAgcndzZXRidWlsZEZ1dHVyZXMgPSBbXVxuICBpc0lwc2V0U3RhbGUgPSBmYWxzZVxuICBfLmVhY2goW1wiZGlwU2V0XCIsIFwic2lwU2V0XCIsIFwiYW55U2V0XCJdLCAoZmllbGQpIC0+XG4gICAgaWYgcXVlcnlbZmllbGQgKyBcIkVuYWJsZWRcIl0gYW5kIHF1ZXJ5W2ZpZWxkXVxuICAgICAgc2V0ID0gc2hhcmUuSVBTZXRzLmZpbmRPbmUocXVlcnlbZmllbGRdKVxuICAgICAgaWYgc2V0LmlzT3V0cHV0U3RhbGVcbiAgICAgICAgaXNJcHNldFN0YWxlID0gdHJ1ZVxuICAgICAgICByd3NldGJ1aWxkRnV0dXJlID0gbmV3IEZ1dHVyZSgpXG4gICAgICAgIHR4dEZpbGVuYW1lID0gXCIvdG1wXCIgKyBcIi9cIiArIHNldC5faWQgKyBcIi50eHRcIlxuICAgICAgICByd3NGaWxlbmFtZSA9IGNvbmZpZy5kYXRhVGVtcGRpciArIFwiL1wiICsgc2V0Ll9pZCArIFwiLnJ3c1wiXG4gICAgICAgIHdyaXRlRmlsZUZ1dHVyZSA9IHdyaXRlRmlsZSh0eHRGaWxlbmFtZSwgc2V0LmNvbnRlbnRzKVxuICAgICAgICBpZiBjb25maWcuaXNTU0hcbiAgICAgICAgICBzY3BDb21tYW5kID0gXCJzY3AgXCIgKyBjb25maWcuZ2V0U1NIT3B0aW9ucygpICsgXCIgLVAgXCIgKyBjb25maWcucG9ydCArIFwiIFwiICsgdHh0RmlsZW5hbWUgKyBcIiBcIiArIGNvbmZpZy51c2VyICsgXCJAXCIgKyBjb25maWcuaG9zdCArIFwiOlwiICsgdHh0RmlsZW5hbWVcbiAgICAgICAgICBzY3BGdXR1cmUgPSBuZXcgRnV0dXJlKClcbiAgICAgICAgICBQcm9jZXNzLmV4ZWMoc2NwQ29tbWFuZCwgTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCBzdGRvdXQsIHN0ZGVycikgLT5cbiAgICAgICAgICAgIHJlc3VsdCA9IHN0ZG91dC50cmltKClcbiAgICAgICAgICAgIGVycm9yID0gc3RkZXJyLnRyaW0oKVxuICAgICAgICAgICAgY29kZSA9IGlmIGVyciB0aGVuIGVyci5jb2RlIGVsc2UgMFxuICAgICAgICAgICAgaWYgZXJyb3JcbiAgICAgICAgICAgICAgcndzZXRidWlsZEVycm9ycy5wdXNoKGVycm9yKVxuICAgICAgICAgICAgaWYgY29kZSBpcyAwXG4gICAgICAgICAgICBlbHNlXG4gICAgICAgICAgICAgIGlmIG5vdCBlcnJvclxuICAgICAgICAgICAgICAgIHRocm93IFwic2NwOiBjb2RlIGlzIFxcXCJcIiArIGNvZGUgKyBcIlxcXCIgd2hpbGUgc3RkZXJyIGlzIFxcXCJcIiArIGVycm9yICsgXCJcXFwiXCJcbiAgICAgICAgICAgIHNjcEZ1dHVyZS5yZXR1cm4ocmVzdWx0KVxuICAgICAgICAgICkpXG4gICAgICAgICAgc2NwRnV0dXJlLndhaXQoKVxuICAgICAgICBybUNvbW1hbmQgPSBcInJtIC1mIFwiICsgcndzRmlsZW5hbWVcbiAgICAgICAgaWYgY29uZmlnLmlzU1NIXG4gICAgICAgICAgcm1Db21tYW5kID0gY29uZmlnLndyYXBDb21tYW5kKHJtQ29tbWFuZClcbiAgICAgICAgcm1GdXR1cmUgPSBuZXcgRnV0dXJlKClcbiAgICAgICAgUHJvY2Vzcy5leGVjKHJtQ29tbWFuZCwgTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCBzdGRvdXQsIHN0ZGVycikgLT5cbiAgICAgICAgICByZXN1bHQgPSBzdGRvdXQudHJpbSgpXG4gICAgICAgICAgZXJyb3IgPSBzdGRlcnIudHJpbSgpXG4gICAgICAgICAgY29kZSA9IGlmIGVyciB0aGVuIGVyci5jb2RlIGVsc2UgMFxuICAgICAgICAgIGlmIGVycm9yXG4gICAgICAgICAgICByd3NldGJ1aWxkRXJyb3JzLnB1c2goZXJyb3IpXG4gICAgICAgICAgaWYgY29kZSBpcyAwXG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgaWYgbm90IGVycm9yXG4gICAgICAgICAgICAgIHRocm93IFwicm06IGNvZGUgaXMgXFxcIlwiICsgY29kZSArIFwiXFxcIiB3aGlsZSBzdGRlcnIgaXMgXFxcIlwiICsgZXJyb3IgKyBcIlxcXCJcIlxuICAgICAgICAgIHJtRnV0dXJlLnJldHVybihyZXN1bHQpXG4gICAgICAgICkpXG4gICAgICAgIHJtRnV0dXJlLndhaXQoKVxuICAgICAgICB3cml0ZUZpbGVGdXR1cmUucmVzb2x2ZSBNZXRlb3IuYmluZEVudmlyb25tZW50KChlcnIsIHJlc3VsdCkgLT5cbiAgICAgICAgICBpZiBlcnJcbiAgICAgICAgICAgIHJ3c2V0YnVpbGRFcnJvcnMucHVzaChlcnIpXG4gICAgICAgICAgICByd3NldGJ1aWxkRnV0dXJlLnJldHVybihyZXN1bHQpXG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgcndzZXRidWlsZENvbW1hbmQgPSBcInJ3c2V0YnVpbGQgXCIgKyB0eHRGaWxlbmFtZSArIFwiIFwiICsgcndzRmlsZW5hbWVcbiAgICAgICAgICAgIGlmIGNvbmZpZy5pc1NTSFxuICAgICAgICAgICAgICByd3NldGJ1aWxkQ29tbWFuZCA9IGNvbmZpZy53cmFwQ29tbWFuZChyd3NldGJ1aWxkQ29tbWFuZClcbiAgICAgICAgICAgIFByb2Nlc3MuZXhlYyhyd3NldGJ1aWxkQ29tbWFuZCwgTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCBzdGRvdXQsIHN0ZGVycikgLT5cbiAgICAgICAgICAgICAgcmVzdWx0ID0gc3Rkb3V0LnRyaW0oKVxuICAgICAgICAgICAgICBlcnJvciA9IHN0ZGVyci50cmltKClcbiAgICAgICAgICAgICAgY29kZSA9IGlmIGVyciB0aGVuIGVyci5jb2RlIGVsc2UgMFxuICAgICAgICAgICAgICBpZiBlcnJvclxuICAgICAgICAgICAgICAgIHJ3c2V0YnVpbGRFcnJvcnMucHVzaChlcnJvcilcbiAgICAgICAgICAgICAgaWYgY29kZSBpcyAwXG4gICAgICAgICAgICAgICAgc2hhcmUuSVBTZXRzLnVwZGF0ZShzZXQuX2lkLCB7JHNldDoge2lzT3V0cHV0U3RhbGU6IGZhbHNlfX0pXG4gICAgICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgICAgICBpZiBub3QgZXJyb3JcbiAgICAgICAgICAgICAgICAgIHRocm93IFwicndzZXRidWlsZDogY29kZSBpcyBcXFwiXCIgKyBjb2RlICsgXCJcXFwiIHdoaWxlIHN0ZGVyciBpcyBcXFwiXCIgKyBlcnJvciArIFwiXFxcIlwiXG4gICAgICAgICAgICAgIHJ3c2V0YnVpbGRGdXR1cmUucmV0dXJuKHJlc3VsdClcbiAgICAgICAgICAgICkpXG4gICAgICAgIClcbiAgICAgICAgcndzZXRidWlsZEZ1dHVyZXMucHVzaChyd3NldGJ1aWxkRnV0dXJlKVxuICApXG4gIEZ1dHVyZS53YWl0KHJ3c2V0YnVpbGRGdXR1cmVzKVxuXG4gIGlmIHJ3c2V0YnVpbGRFcnJvcnMubGVuZ3RoXG4gICAgY2FsbGJhY2soXCJcIiwgcndzZXRidWlsZEVycm9ycy5qb2luKFwiXFxuXCIpLCAyNTUpXG4gICAgcmV0dXJuXG5cbiAgaWYgbm90IHF1ZXJ5LmlzSW5wdXRTdGFsZSBhbmQgbm90IGlzSXBzZXRTdGFsZVxuICAgIGNhbGxiYWNrKFwiXCIsIFwiXCIsIDApXG4gICAgcmV0dXJuXG5cbiAgdHVwbGVidWlsZEVycm9ycyA9IFtdXG4gIHR1cGxlYnVpbGRGdXR1cmVzID0gW11cbiAgaXNUdXBsZVN0YWxlID0gZmFsc2VcbiAgXy5lYWNoKFtcInR1cGxlRmlsZVwiXSwgKGZpZWxkKSAtPlxuICAgIGlmIHF1ZXJ5W2ZpZWxkICsgXCJFbmFibGVkXCJdIGFuZCBxdWVyeVtmaWVsZF1cbiAgICAgIHNldCA9IHNoYXJlLlR1cGxlcy5maW5kT25lKHF1ZXJ5W2ZpZWxkXSlcbiAgICAgIGlmIHNldC5pc091dHB1dFN0YWxlXG4gICAgICAgIGlzVHVwbGVTdGFsZSA9IHRydWVcbiAgICAgICAgdHVwbGVidWlsZEZ1dHVyZSA9IG5ldyBGdXR1cmUoKVxuICAgICAgICB0eHRGaWxlbmFtZSA9IFwiL3RtcFwiICsgXCIvXCIgKyBzZXQuX2lkICsgXCIudHh0XCJcbiAgICAgICAgdHVwbGVGaWxlbmFtZSA9IGNvbmZpZy5kYXRhVGVtcGRpciArIFwiL1wiICsgc2V0Ll9pZCArIFwiLnR1cGxlXCJcbiAgICAgICAgd3JpdGVGaWxlRnV0dXJlID0gd3JpdGVGaWxlKHR4dEZpbGVuYW1lLCBzZXQuY29udGVudHMpXG4gICAgICAgIGlmIGNvbmZpZy5pc1NTSFxuICAgICAgICAgIHNjcENvbW1hbmQgPSBcInNjcCBcIiArIGNvbmZpZy5nZXRTU0hPcHRpb25zKCkgKyBcIiAtUCBcIiArIGNvbmZpZy5wb3J0ICsgXCIgXCIgKyB0eHRGaWxlbmFtZSArIFwiIFwiICsgY29uZmlnLnVzZXIgKyBcIkBcIiArIGNvbmZpZy5ob3N0ICsgXCI6XCIgKyB0eHRGaWxlbmFtZVxuICAgICAgICAgIHNjcEZ1dHVyZSA9IG5ldyBGdXR1cmUoKVxuICAgICAgICAgIFByb2Nlc3MuZXhlYyhzY3BDb21tYW5kLCBNZXRlb3IuYmluZEVudmlyb25tZW50KChlcnIsIHN0ZG91dCwgc3RkZXJyKSAtPlxuICAgICAgICAgICAgcmVzdWx0ID0gc3Rkb3V0LnRyaW0oKVxuICAgICAgICAgICAgZXJyb3IgPSBzdGRlcnIudHJpbSgpXG4gICAgICAgICAgICBjb2RlID0gaWYgZXJyIHRoZW4gZXJyLmNvZGUgZWxzZSAwXG4gICAgICAgICAgICBpZiBlcnJvclxuICAgICAgICAgICAgICB0dXBsZWJ1aWxkRXJyb3JzLnB1c2goZXJyb3IpXG4gICAgICAgICAgICBpZiBjb2RlIGlzIDBcbiAgICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgICAgaWYgbm90IGVycm9yXG4gICAgICAgICAgICAgICAgdGhyb3cgXCJzY3A6IGNvZGUgaXMgXFxcIlwiICsgY29kZSArIFwiXFxcIiB3aGlsZSBzdGRlcnIgaXMgXFxcIlwiICsgZXJyb3IgKyBcIlxcXCJcIlxuICAgICAgICAgICAgc2NwRnV0dXJlLnJldHVybihyZXN1bHQpXG4gICAgICAgICAgKSlcbiAgICAgICAgICBzY3BGdXR1cmUud2FpdCgpXG4gICAgICAgIHJtQ29tbWFuZCA9IFwicm0gLWYgXCIgKyB0dXBsZUZpbGVuYW1lXG4gICAgICAgIGlmIGNvbmZpZy5pc1NTSFxuICAgICAgICAgIHJtQ29tbWFuZCA9IGNvbmZpZy53cmFwQ29tbWFuZChybUNvbW1hbmQpXG4gICAgICAgIHJtRnV0dXJlID0gbmV3IEZ1dHVyZSgpXG4gICAgICAgIFByb2Nlc3MuZXhlYyhybUNvbW1hbmQsIE1ldGVvci5iaW5kRW52aXJvbm1lbnQoKGVyciwgc3Rkb3V0LCBzdGRlcnIpIC0+XG4gICAgICAgICAgcmVzdWx0ID0gc3Rkb3V0LnRyaW0oKVxuICAgICAgICAgIGVycm9yID0gc3RkZXJyLnRyaW0oKVxuICAgICAgICAgIGNvZGUgPSBpZiBlcnIgdGhlbiBlcnIuY29kZSBlbHNlIDBcbiAgICAgICAgICBpZiBlcnJvclxuICAgICAgICAgICAgdHVwbGVidWlsZEVycm9ycy5wdXNoKGVycm9yKVxuICAgICAgICAgIGlmIGNvZGUgaXMgMFxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIGlmIG5vdCBlcnJvclxuICAgICAgICAgICAgICB0aHJvdyBcInJtOiBjb2RlIGlzIFxcXCJcIiArIGNvZGUgKyBcIlxcXCIgd2hpbGUgc3RkZXJyIGlzIFxcXCJcIiArIGVycm9yICsgXCJcXFwiXCJcbiAgICAgICAgICBybUZ1dHVyZS5yZXR1cm4ocmVzdWx0KVxuICAgICAgICApKVxuICAgICAgICBybUZ1dHVyZS53YWl0KClcbiAgICAgICAgd3JpdGVGaWxlRnV0dXJlLnJlc29sdmUgTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCByZXN1bHQpIC0+XG4gICAgICAgICAgaWYgZXJyXG4gICAgICAgICAgICB0dXBsZWJ1aWxkRXJyb3JzLnB1c2goZXJyKVxuICAgICAgICAgICAgdHVwbGVidWlsZEZ1dHVyZS5yZXR1cm4ocmVzdWx0KVxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIHR1cGxlYnVpbGRDb21tYW5kID0gXCJjYXQgXCIgKyB0eHRGaWxlbmFtZSArIFwiID4gXCIgKyB0dXBsZUZpbGVuYW1lXG4gICAgICAgICAgICBpZiBjb25maWcuaXNTU0hcbiAgICAgICAgICAgICAgdHVwbGVidWlsZENvbW1hbmQgPSBjb25maWcud3JhcENvbW1hbmQodHVwbGVidWlsZENvbW1hbmQpXG4gICAgICAgICAgICBQcm9jZXNzLmV4ZWModHVwbGVidWlsZENvbW1hbmQsIE1ldGVvci5iaW5kRW52aXJvbm1lbnQoKGVyciwgc3Rkb3V0LCBzdGRlcnIpIC0+XG4gICAgICAgICAgICAgIHJlc3VsdCA9IHN0ZG91dC50cmltKClcbiAgICAgICAgICAgICAgZXJyb3IgPSBzdGRlcnIudHJpbSgpXG4gICAgICAgICAgICAgIGNvZGUgPSBpZiBlcnIgdGhlbiBlcnIuY29kZSBlbHNlIDBcbiAgICAgICAgICAgICAgaWYgZXJyb3JcbiAgICAgICAgICAgICAgICB0dXBsZWJ1aWxkRXJyb3JzLnB1c2goZXJyb3IpXG4gICAgICAgICAgICAgIGlmIGNvZGUgaXMgMFxuICAgICAgICAgICAgICAgIHNoYXJlLlR1cGxlcy51cGRhdGUoc2V0Ll9pZCwgeyRzZXQ6IHtpc091dHB1dFN0YWxlOiBmYWxzZX19KVxuICAgICAgICAgICAgICBlbHNlXG4gICAgICAgICAgICAgICAgaWYgbm90IGVycm9yXG4gICAgICAgICAgICAgICAgICB0aHJvdyBcInR1cGxlYnVpbGQ6IGNvZGUgaXMgXFxcIlwiICsgY29kZSArIFwiXFxcIiB3aGlsZSBzdGRlcnIgaXMgXFxcIlwiICsgZXJyb3IgKyBcIlxcXCJcIlxuICAgICAgICAgICAgICB0dXBsZWJ1aWxkRnV0dXJlLnJldHVybihyZXN1bHQpXG4gICAgICAgICAgICApKVxuICAgICAgICApXG4gICAgICAgIHR1cGxlYnVpbGRGdXR1cmVzLnB1c2godHVwbGVidWlsZEZ1dHVyZSlcbiAgKVxuICBGdXR1cmUud2FpdCh0dXBsZWJ1aWxkRnV0dXJlcylcblxuICBpZiB0dXBsZWJ1aWxkRXJyb3JzLmxlbmd0aFxuICAgIGNhbGxiYWNrKFwiXCIsIHR1cGxlYnVpbGRFcnJvcnMuam9pbihcIlxcblwiKSwgMjU1KVxuICAgIHJldHVyblxuXG4gIGlmIG5vdCBxdWVyeS5pc0lucHV0U3RhbGUgYW5kIG5vdCBpc1R1cGxlU3RhbGVcbiAgICBjYWxsYmFjayhcIlwiLCBcIlwiLCAwKVxuICAgIHJldHVyblxuXG4gIGNvbW1hbmQgPSBxdWVyeS5pbnB1dENvbW1hbmQoY29uZmlnLCBwcm9maWxlKVxuICBQcm9jZXNzLmV4ZWMoY29tbWFuZCwgTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCBzdGRvdXQsIHN0ZGVycikgLT5cbiAgICByZXN1bHQgPSBzdGRvdXQudHJpbSgpXG4gICAgZXJyb3IgPSBzdGRlcnIudHJpbSgpXG4gICAgY29kZSA9IGlmIGVyciB0aGVuIGVyci5jb2RlIGVsc2UgMFxuICAgIGlmIGVycm9yLmluZGV4T2YoXCJSZWplY3RlZFwiKSBpc250IC0xXG4gICAgICBlcnJvciA9IG51bGxcbiAgICBjYWxsYmFjayhyZXN1bHQsIGVycm9yLCBjb2RlKVxuICApKVxuXG5sb2FkUXVlcnlSZXN1bHQgPSAocXVlcnksIGNvbmZpZywgcHJvZmlsZSwgY2FsbGJhY2spIC0+XG4gIGV4ZWN1dGVRdWVyeShxdWVyeSwgY29uZmlnLCBwcm9maWxlLCBNZXRlb3IuYmluZEVudmlyb25tZW50KChyZXN1bHQsIGVycm9yLCBjb2RlKSAtPlxuICAgIGlmIGVycm9yXG4gICAgICByZXR1cm4gY2FsbGJhY2socmVzdWx0LCBlcnJvciwgY29kZSlcbiAgICBjb21tYW5kID0gcXVlcnkub3V0cHV0Q29tbWFuZChjb25maWcsIHByb2ZpbGUpXG4gICAgUHJvY2Vzcy5leGVjKGNvbW1hbmQsIE1ldGVvci5iaW5kRW52aXJvbm1lbnQoKGVyciwgc3Rkb3V0LCBzdGRlcnIpIC0+XG4gICAgICByZXN1bHQgPSBzdGRvdXQudHJpbSgpXG4gICAgICBlcnJvciA9IHN0ZGVyci50cmltKClcbiAgICAgIGNvZGUgPSBpZiBlcnIgdGhlbiBlcnIuY29kZSBlbHNlIDBcbiAgICAgIGlmIGVycm9yLmluZGV4T2YoXCJFcnJvciBvcGVuaW5nIGZpbGVcIikgaXNudCAtMVxuICAgICAgICBxdWVyeS5pc0lucHV0U3RhbGUgPSB0cnVlXG4gICAgICAgIGxvYWRRdWVyeVJlc3VsdChxdWVyeSwgY29uZmlnLCBwcm9maWxlLCBjYWxsYmFjaylcbiAgICAgIGVsc2VcbiAgICAgICAgY2FsbGJhY2socmVzdWx0LCBlcnJvciwgY29kZSlcbiAgICApKVxuICApKVxuIl19

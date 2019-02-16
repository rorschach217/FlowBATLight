(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// lib/transformations.coffee                                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
// not used by default
var indexOf = [].indexOf;
share.User = class User {
  constructor(doc) {
    var ref, ref1;

    _.extend(this, doc);

    this.email = (ref = this.emails) != null ? (ref1 = ref[0]) != null ? ref1.address : void 0 : void 0;
    this.name = this.profile.name;
    this.firstName = this.name.split(' ').slice(0, 1).join(' ');
    this.lastName = this.name.split(' ').slice(1).join(' ');
  }

};
share.Config = class Config {
  constructor(doc) {
    _.extend(this, doc);
  }

  wrapCommand(command) {
    return "ssh " + this.getSSHOptions() + " -p " + this.port + " " + this.user + "@" + this.host + " \"" + command + "\"";
  }

  getSSHOptions() {
    return "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=error -i " + this.getIdentityFile();
  }

  getIdentityFile() {
    if (this.identityFile) {
      return this.identityFile;
    } else {
      return process.env.PWD + "/settings/identity";
    }
  }

};
share.Query = class Query {
  constructor(doc) {
    var distinctRegex, filteredHeader, i, index, j, k, l, len, len1, len2, len3, len4, len5, m, n, name, o, parsedResult, parsedRow, parsedValue, rawHeader, ref, ref1, row, spec;

    _.extend(this, doc);

    this.header = [];
    this.rows = [];

    if (this.result) {
      parsedResult = share.parseResult(this.result);

      if (this.output === "rwstats") {
        parsedResult.shift();
        parsedResult.shift();
      } // shift-shift outta here, you redundant rows


      if (this.output === "rwcount") {
        parsedResult.unshift(share.rwcountFields);
      }

      rawHeader = parsedResult.shift();

      for (i = 0, len = rawHeader.length; i < len; i++) {
        name = rawHeader[i];
        spec = {
          _id: name,
          name: name.trim(),
          isDistinct: false,
          isPercentage: false
        };

        if (spec.name.indexOf("%") === 0) {
          spec.isPercentage = true;
          spec.name = spec.name.substr(1);
        }

        distinctRegex = /-D.*$/i;

        if (spec.name.match(distinctRegex)) {
          spec.isDistinct = true;
          spec.name = spec.name.replace(distinctRegex, "");
        }

        if (spec.isDistinct) {
          spec.chartType = "number";
        } else {
          spec.chartType = share.chartFieldTypes[spec.name] || "string";
        }

        this.header.push(spec);
      }

      if (this.presentation === "chart") {
        for (j = 0, len1 = parsedResult.length; j < len1; j++) {
          parsedRow = parsedResult[j];
          row = [];

          for (index = k = 0, len2 = parsedRow.length; k < len2; index = ++k) {
            parsedValue = parsedRow[index];
            spec = this.header[index];

            if (this.output === "rwcount" && (ref = spec.name, indexOf.call(this.rwcountFields, ref) < 0)) {
              continue;
            }

            switch (spec.chartType) {
              case "number":
                parsedValue = parseFloat(parsedValue);
                break;

              case "date":
              case "datetime":
                m = moment.utc(parsedValue, "YYYY/MM/DDTHH:mm:ss.SSS");
                parsedValue = m.toDate();
            }

            row.push(parsedValue);
          }

          this.rows.push(row);
        }
      } else {
        for (l = 0, len3 = parsedResult.length; l < len3; l++) {
          parsedRow = parsedResult[l];
          row = [];

          for (index = n = 0, len4 = parsedRow.length; n < len4; index = ++n) {
            parsedValue = parsedRow[index];
            spec = this.header[index];
            row.push({
              _id: spec._id,
              value: parsedValue,
              queryId: this._id
            });
          }

          this.rows.push(row);
        }
      }

      filteredHeader = [];
      ref1 = this.header;

      for (o = 0, len5 = ref1.length; o < len5; o++) {
        spec = ref1[o];
        filteredHeader.push(spec);
      }

      this.header = filteredHeader;
    }
  }

  displayName() {
    if (this.isQuick) {
      return "Quick query #" + this._id;
    } else {
      return this.name || "#" + this._id;
    }
  }

  inputCommand(config, profile, isPresentation = false) {
    var command, exclusion, i, len, pcapFile, pcapFileValidate, ref, rwFileValidate, typeValidate;
    command = "rwfilter";
    command += " " + this.inputOptions(config); // defaults to having --type=all as the standard instead of the SiLK default.

    if (this.interface === "cmd") {
      typeValidate = command.search(RegExp('--type', 'i'));

      if (typeValidate < 0) {
        command += " --type=all ";
      }
    }

    if (config.siteConfigFile) {
      command += " --site-config-file=" + config.siteConfigFile;
    } // rwf and pcap integration


    rwFileValidate = command.search(RegExp(' (\\/|\\w)+(\\/|\\w|\\-)*\\.(rwf|rw)', 'i'));

    if (rwFileValidate < 0) {
      pcapFileValidate = command.search(RegExp(' (\\/|\\w)+(\\/|\\w|\\-)*\\.(pcap)', 'i'));

      if (pcapFileValidate >= 0) {
        pcapFile = command.match(RegExp('(\\/|\\w)+(\\/|\\w|\\-)*\\.(pcap)', 'i'));
        command += " --input-pipe=stdin";
        command = command.replace(pcapFile[0], "");
        command = "rwp2yaf2silk --in=" + pcapFile[0] + " --out=- |" + command;
      } else {
        if (config.dataRootdir) {
          command += " --data-rootdir=" + config.dataRootdir;
        }
      }
    }

    command += " --pass=stdout";
    ref = this.inputExclusions();

    for (i = 0, len = ref.length; i < len; i++) {
      exclusion = ref[i];
      command += " | rwfilter --input-pipe=stdin";
      command += " " + exclusion;

      if (config.siteConfigFile) {
        command += " --site-config-file=" + config.siteConfigFile;
      } // config.dataRootdir shouldn't be used with exclusions


      command += " --fail=stdout";
    }

    command += " > " + (config.dataTempdir || "/tmp") + "/" + this._id + ".rwf";

    if (config.isSSH && !isPresentation) {
      command = config.wrapCommand(command);
    }

    return command;
  }

  inputOptions(config) {
    var eTimeMoment, parameters, sTimeMoment, startDateOffsetNumber, string, value;

    if (this.interface === "builder") {
      parameters = [];

      if (this.typesEnabled && this.types.length && _.difference(share.queryTypes, this.types).length) {
        value = this.types.join(",");
      } else {
        value = "all";
      }

      parameters.push("--type=" + value);

      if (this.startDateType === "interval") {
        if (this.startDateEnabled && this.startDate) {
          parameters.push("--start-date=" + this.startDate);
        }

        if (this.endDateEnabled && this.endDate) {
          parameters.push("--end-date=" + this.endDate);
        }

        if (this.activeTimeEnabled && this.activeTime) {
          parameters.push("--active-time=" + this.activeTime);
        }
      } else {
        if (this.startDateOffsetEnabled && this.startDateOffset) {
          startDateOffsetNumber = share.intval(this.startDateOffset);
          eTimeMoment = moment.utc();
          sTimeMoment = eTimeMoment.clone().subtract(startDateOffsetNumber, 'minutes');
          parameters.push("--start-date=" + sTimeMoment.format("YYYY/MM/DD:HH"));
          parameters.push("--end-date=" + eTimeMoment.format("YYYY/MM/DD:HH"));
          parameters.push("--active-time=" + sTimeMoment.format("YYYY/MM/DDTHH:mm:ss.SSS") + "-" + eTimeMoment.format("YYYY/MM/DDTHH:mm:ss.SSS"));
        }
      }

      if (this.sensorEnabled && this.sensor) {
        parameters.push("--sensor=" + this.sensor);
      }

      if (this.daddressEnabled && this.daddress) {
        parameters.push("--daddress=" + this.daddress);
      }

      if (this.saddressEnabled && this.saddress) {
        parameters.push("--saddress=" + this.saddress);
      }

      if (this.anyAddressEnabled && this.anyAddress) {
        parameters.push("--any-address=" + this.anyAddress);
      }

      if (this.dipSetEnabled && this.dipSet) {
        parameters.push("--dipset=" + (config.dataTempdir || "/tmp") + "/" + this.dipSet + ".rws");
      }

      if (this.sipSetEnabled && this.sipSet) {
        parameters.push("--sipset=" + (config.dataTempdir || "/tmp") + "/" + this.sipSet + ".rws");
      }

      if (this.anySetEnabled && this.anySet) {
        parameters.push("--anyset=" + (config.dataTempdir || "/tmp") + "/" + this.anySet + ".rws");
      }

      if (this.tupleFileEnabled && this.tupleFile) {
        parameters.push("--tuple-file=" + (config.dataTempdir || "/tmp") + "/" + this.tupleFile + ".tuple");
      }

      if (this.tupleDirectionEnabled && this.tupleDirection) {
        parameters.push("--tuple-direction=" + this.tupleDirection);
      }

      if (this.tupleDelimiterEnabled && this.tupleDelimiter) {
        parameters.push("--tuple-delimiter=" + this.tupleDelimiter);
      }

      if (this.tupleFieldsEnabled && this.tupleFields) {
        parameters.push("--tuple-fields=" + this.tupleFields);
      }

      if (this.dportEnabled && this.dport) {
        parameters.push("--dport=" + this.dport);
      }

      if (this.sportEnabled && this.sport) {
        parameters.push("--sport=" + this.sport);
      }

      if (this.aportEnabled && this.aport) {
        parameters.push("--aport=" + this.aport);
      }

      if (this.dccEnabled && this.dcc.length) {
        parameters.push("--dcc=" + this.dcc.join(","));
      }

      if (this.sccEnabled && this.scc.length) {
        parameters.push("--scc=" + this.scc.join(","));
      }

      if (this.protocolEnabled && this.protocol) {
        parameters.push("--protocol=" + this.protocol);
      }

      if (this.flagsAllEnabled && this.flagsAll) {
        parameters.push("--flags-all=" + this.flagsAll);
      }

      if (this.additionalParametersEnabled && this.additionalParameters) {
        parameters.push(this.additionalParameters);
      }

      string = parameters.join(" ");
    } else {
      string = this.cmd;
    }

    return share.filterOptions(string);
  }

  inputExclusions() {
    var exclusionsCmd;
    exclusionsCmd = "";

    if (this.interface === "builder") {
      if (this.additionalExclusionsCmdEnabled) {
        exclusionsCmd = this.additionalExclusionsCmd;
      }
    } else {
      exclusionsCmd = this.exclusionsCmd;
    }

    exclusionsCmd = share.filterOptions(exclusionsCmd);
    return _.compact(exclusionsCmd.split(/\s+(?:OR|\|\|)\s+/i));
  }

  outputCommand(config, profile, isPresentation = false) {
    switch (this.output) {
      case "rwcut":
        return this.outputRwcutCommand(config, profile, isPresentation);

      case "rwstats":
        return this.outputRwstatsCommand(config, profile, isPresentation);

      case "rwcount":
        return this.outputRwcountCommand(config, profile, isPresentation);
    }
  }

  outputRwcutCommand(config, profile, isPresentation = false) {
    var command, commands, rwcutOptions, rwcutOptionsString, rwsortOptions, rwsortOptionsString;
    commands = [];

    if (this.sortField) {
      rwsortOptions = ["--fields=" + this.sortField];

      if (this.sortReverse) {
        rwsortOptions.push("--reverse");
      }

      if (config.siteConfigFile) {
        rwsortOptions.push("--site-config-file=" + config.siteConfigFile);
      }

      rwsortOptionsString = rwsortOptions.join(" ");
      rwsortOptionsString = share.filterOptions(rwsortOptionsString);
      commands.push("rwsort " + rwsortOptionsString);
    }

    rwcutOptions = ["--num-recs=" + profile.numRecs, "--start-rec-num=" + this.startRecNum, "--delimited"];

    if (this.fields.length) {
      rwcutOptions.push("--fields=" + _.intersection(this.fieldsOrder, this.fields).join(","));
    }

    if (config.siteConfigFile) {
      rwcutOptions.push("--site-config-file=" + config.siteConfigFile);
    }

    rwcutOptionsString = rwcutOptions.join(" ");
    rwcutOptionsString = share.filterOptions(rwcutOptionsString);
    commands.push("rwcut " + rwcutOptionsString);
    commands[0] += " " + (config.dataTempdir || "/tmp") + "/" + this._id + ".rwf";
    command = commands.join(" | ");

    if (config.isSSH && !isPresentation) {
      command = config.wrapCommand(command);
    }

    return command;
  }

  outputRwstatsCommand(config, profile, isPresentation = false) {
    var command, defaultRwstatsOptions, i, index, len, ref, rwstatsOptions, rwstatsOptionsString, rwstatsValues, rwstatsValuesOrder, value, values;
    defaultRwstatsOptions = ["--delimited"];

    if (this.interface === "builder") {
      rwstatsOptions = defaultRwstatsOptions;

      if (this.rwstatsFields.length) {
        rwstatsOptions.push("--fields=" + _.intersection(this.rwstatsFieldsOrder, this.rwstatsFields).join(","));
      }

      rwstatsValues = this.rwstatsValues.slice(0);
      rwstatsValuesOrder = this.rwstatsValuesOrder.slice(0);

      if (this.rwstatsPrimaryValue) {
        rwstatsValues.unshift(this.rwstatsPrimaryValue);
        rwstatsValuesOrder.unshift(this.rwstatsPrimaryValue);
      }

      if (rwstatsValues.length) {
        values = _.intersection(rwstatsValuesOrder, rwstatsValues);

        for (index = i = 0, len = values.length; i < len; index = ++i) {
          value = values[index];

          if (indexOf.call(share.rwstatsValues, value) < 0) {
            values[index] = "distinct:" + value;
          }
        }

        rwstatsOptions.push("--values=" + values.join(","));

        if (ref = values[0], indexOf.call(share.rwstatsValues, ref) < 0) {
          rwstatsOptions.push("--no-percents");
        }
      }

      rwstatsOptions.push("--" + this.rwstatsDirection);

      switch (this.rwstatsMode) {
        case "count":
          rwstatsOptions.push("--count=" + this.rwstatsCountModeValue);
          break;

        case "threshold":
          rwstatsOptions.push("--threshold=" + this.rwstatsThresholdModeValue);
          break;

        case "percentage":
          rwstatsOptions.push("--percentage=" + this.rwstatsPercentageModeValue);
      }

      if (this.rwstatsBinTimeEnabled) {
        if (this.rwstatsBinTime) {
          rwstatsOptions.push("--bin-time=" + this.rwstatsBinTime);
        } else {
          rwstatsOptions.push("--bin-time");
        }
      }

      if (config.siteConfigFile) {
        rwstatsOptions.push("--site-config-file=" + config.siteConfigFile);
      }

      rwstatsOptionsString = rwstatsOptions.join(" ");
    } else {
      rwstatsOptionsString = this.rwstatsCmd + " " + defaultRwstatsOptions.join(" ");
      rwstatsOptionsString = share.filterOptions(rwstatsOptionsString);
    }

    command = "rwstats " + rwstatsOptionsString;
    command += " " + (config.dataTempdir || "/tmp") + "/" + this._id + ".rwf";

    if (config.isSSH && !isPresentation) {
      command = config.wrapCommand(command);
    }

    return command;
  }

  outputRwcountCommand(config, profile, isPresentation = false) {
    var command, defaultRwcountOptions, fieldIndex, headCommand, headOptions, rwcountOptions, rwcountOptionsString, sortCommand, sortOptions, tailCommand, tailOptions;
    defaultRwcountOptions = ["--delimited", "--no-titles" // --no-titles is necessary, because header is added later
    ];

    if (this.interface === "builder") {
      rwcountOptions = defaultRwcountOptions;

      if (this.rwcountBinSizeEnabled) {
        rwcountOptions.push("--bin-size=" + this.rwcountBinSize);
      }

      if (this.rwcountLoadSchemeEnabled) {
        rwcountOptions.push("--load-scheme=" + this.rwcountLoadScheme);
      }

      if (this.rwcountSkipZeroes) {
        rwcountOptions.push("--skip-zeroes");
      }

      if (config.siteConfigFile) {
        rwcountOptions.push("--site-config-file=" + config.siteConfigFile);
      }

      rwcountOptionsString = rwcountOptions.join(" ");
    } else {
      rwcountOptionsString = this.rwcountCmd + " " + defaultRwcountOptions.join(" ");
    }

    rwcountOptionsString = share.filterOptions(rwcountOptionsString);
    command = "rwcount " + rwcountOptionsString;
    command += " " + (config.dataTempdir || "/tmp") + "/" + this._id + ".rwf";

    if (this.presentation === "table") {
      if (this.sortField) {
        fieldIndex = share.rwcountFields.indexOf(this.sortField);
        sortOptions = "--field-separator=\\\| --key=+" + (fieldIndex + 1) + "n" + (this.sortReverse ? "r" : "");
        sortOptions = share.filterOptions(sortOptions, "\\\\\\|\\+");
        sortCommand = "sort " + sortOptions;
        command += " | " + sortCommand;
      }

      if (profile.numRecs) {
        headOptions = "--lines=" + (this.startRecNum + profile.numRecs - 1);
        headOptions = share.filterOptions(headOptions);
        headCommand = "head " + headOptions;
        tailOptions = "--lines=" + profile.numRecs;
        tailOptions = share.filterOptions(tailOptions);
        tailCommand = "tail " + tailOptions;
        command += " | " + headCommand + " | " + tailCommand;
      }
    }

    if (config.isSSH && !isPresentation) {
      command = config.wrapCommand(command);
    }

    return command;
  }

  rwstatsCountModeValueIsEnabled() {
    return this.rwstatsMode === "count";
  }

  rwstatsThresholdModeValueIsEnabled() {
    return this.rwstatsMode === "threshold";
  }

  rwstatsPercentageModeValueIsEnabled() {
    return this.rwstatsMode === "percentage";
  }

  availableChartTypes() {
    return share.availableChartTypes[this.output];
  }

  path() {
    return "/query/" + this._id;
  }

};
share.IPSet = class IPSet {
  constructor(doc) {
    _.extend(this, doc);
  }

  displayName() {
    return this.name || "#" + this._id;
  }

  objectSelectName() {
    return this.displayName();
  }

  objectSelectValue() {
    return this._id;
  }

  path() {
    return "/ipset/" + this._id;
  }

};
share.Tuple = class Tuple {
  constructor(doc) {
    _.extend(this, doc);
  }

  displayName() {
    return this.name || "#" + this._id;
  }

  objectSelectName() {
    return this.displayName();
  }

  objectSelectValue() {
    return this._id;
  }

  path() {
    return "/tuple/" + this._id;
  }

};
share.Transformations = {
  user: function (user) {
    if (user instanceof share.User || !user) {
      return user;
    } else {
      return new share.User(user);
    }
  },
  config: function (config) {
    if (config instanceof share.Config || !config) {
      return config;
    } else {
      return new share.Config(config);
    }
  },
  query: function (query) {
    if (query instanceof share.Query || !query) {
      return query;
    } else {
      return new share.Query(query);
    }
  },
  ipset: function (ipset) {
    if (ipset instanceof share.IPSet || !ipset) {
      return ipset;
    } else {
      return new share.IPSet(ipset);
    }
  },
  tuple: function (tuple) {
    if (tuple instanceof share.Tuple || !tuple) {
      return tuple;
    } else {
      return new share.Tuple(tuple);
    }
  }
};
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/lib/transformations.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvbGliL3RyYW5zZm9ybWF0aW9ucy5jb2ZmZWUiXSwibmFtZXMiOlsiaW5kZXhPZiIsInNoYXJlIiwiVXNlciIsImNvbnN0cnVjdG9yIiwiZG9jIiwicmVmIiwicmVmMSIsIl8iLCJleHRlbmQiLCJlbWFpbCIsImVtYWlscyIsImFkZHJlc3MiLCJuYW1lIiwicHJvZmlsZSIsImZpcnN0TmFtZSIsInNwbGl0Iiwic2xpY2UiLCJqb2luIiwibGFzdE5hbWUiLCJDb25maWciLCJ3cmFwQ29tbWFuZCIsImNvbW1hbmQiLCJnZXRTU0hPcHRpb25zIiwicG9ydCIsInVzZXIiLCJob3N0IiwiZ2V0SWRlbnRpdHlGaWxlIiwiaWRlbnRpdHlGaWxlIiwicHJvY2VzcyIsImVudiIsIlBXRCIsIlF1ZXJ5IiwiZGlzdGluY3RSZWdleCIsImZpbHRlcmVkSGVhZGVyIiwiaSIsImluZGV4IiwiaiIsImsiLCJsIiwibGVuIiwibGVuMSIsImxlbjIiLCJsZW4zIiwibGVuNCIsImxlbjUiLCJtIiwibiIsIm8iLCJwYXJzZWRSZXN1bHQiLCJwYXJzZWRSb3ciLCJwYXJzZWRWYWx1ZSIsInJhd0hlYWRlciIsInJvdyIsInNwZWMiLCJoZWFkZXIiLCJyb3dzIiwicmVzdWx0IiwicGFyc2VSZXN1bHQiLCJvdXRwdXQiLCJzaGlmdCIsInVuc2hpZnQiLCJyd2NvdW50RmllbGRzIiwibGVuZ3RoIiwiX2lkIiwidHJpbSIsImlzRGlzdGluY3QiLCJpc1BlcmNlbnRhZ2UiLCJzdWJzdHIiLCJtYXRjaCIsInJlcGxhY2UiLCJjaGFydFR5cGUiLCJjaGFydEZpZWxkVHlwZXMiLCJwdXNoIiwicHJlc2VudGF0aW9uIiwiY2FsbCIsInBhcnNlRmxvYXQiLCJtb21lbnQiLCJ1dGMiLCJ0b0RhdGUiLCJ2YWx1ZSIsInF1ZXJ5SWQiLCJkaXNwbGF5TmFtZSIsImlzUXVpY2siLCJpbnB1dENvbW1hbmQiLCJjb25maWciLCJpc1ByZXNlbnRhdGlvbiIsImV4Y2x1c2lvbiIsInBjYXBGaWxlIiwicGNhcEZpbGVWYWxpZGF0ZSIsInJ3RmlsZVZhbGlkYXRlIiwidHlwZVZhbGlkYXRlIiwiaW5wdXRPcHRpb25zIiwiaW50ZXJmYWNlIiwic2VhcmNoIiwiUmVnRXhwIiwic2l0ZUNvbmZpZ0ZpbGUiLCJkYXRhUm9vdGRpciIsImlucHV0RXhjbHVzaW9ucyIsImRhdGFUZW1wZGlyIiwiaXNTU0giLCJlVGltZU1vbWVudCIsInBhcmFtZXRlcnMiLCJzVGltZU1vbWVudCIsInN0YXJ0RGF0ZU9mZnNldE51bWJlciIsInN0cmluZyIsInR5cGVzRW5hYmxlZCIsInR5cGVzIiwiZGlmZmVyZW5jZSIsInF1ZXJ5VHlwZXMiLCJzdGFydERhdGVUeXBlIiwic3RhcnREYXRlRW5hYmxlZCIsInN0YXJ0RGF0ZSIsImVuZERhdGVFbmFibGVkIiwiZW5kRGF0ZSIsImFjdGl2ZVRpbWVFbmFibGVkIiwiYWN0aXZlVGltZSIsInN0YXJ0RGF0ZU9mZnNldEVuYWJsZWQiLCJzdGFydERhdGVPZmZzZXQiLCJpbnR2YWwiLCJjbG9uZSIsInN1YnRyYWN0IiwiZm9ybWF0Iiwic2Vuc29yRW5hYmxlZCIsInNlbnNvciIsImRhZGRyZXNzRW5hYmxlZCIsImRhZGRyZXNzIiwic2FkZHJlc3NFbmFibGVkIiwic2FkZHJlc3MiLCJhbnlBZGRyZXNzRW5hYmxlZCIsImFueUFkZHJlc3MiLCJkaXBTZXRFbmFibGVkIiwiZGlwU2V0Iiwic2lwU2V0RW5hYmxlZCIsInNpcFNldCIsImFueVNldEVuYWJsZWQiLCJhbnlTZXQiLCJ0dXBsZUZpbGVFbmFibGVkIiwidHVwbGVGaWxlIiwidHVwbGVEaXJlY3Rpb25FbmFibGVkIiwidHVwbGVEaXJlY3Rpb24iLCJ0dXBsZURlbGltaXRlckVuYWJsZWQiLCJ0dXBsZURlbGltaXRlciIsInR1cGxlRmllbGRzRW5hYmxlZCIsInR1cGxlRmllbGRzIiwiZHBvcnRFbmFibGVkIiwiZHBvcnQiLCJzcG9ydEVuYWJsZWQiLCJzcG9ydCIsImFwb3J0RW5hYmxlZCIsImFwb3J0IiwiZGNjRW5hYmxlZCIsImRjYyIsInNjY0VuYWJsZWQiLCJzY2MiLCJwcm90b2NvbEVuYWJsZWQiLCJwcm90b2NvbCIsImZsYWdzQWxsRW5hYmxlZCIsImZsYWdzQWxsIiwiYWRkaXRpb25hbFBhcmFtZXRlcnNFbmFibGVkIiwiYWRkaXRpb25hbFBhcmFtZXRlcnMiLCJjbWQiLCJmaWx0ZXJPcHRpb25zIiwiZXhjbHVzaW9uc0NtZCIsImFkZGl0aW9uYWxFeGNsdXNpb25zQ21kRW5hYmxlZCIsImFkZGl0aW9uYWxFeGNsdXNpb25zQ21kIiwiY29tcGFjdCIsIm91dHB1dENvbW1hbmQiLCJvdXRwdXRSd2N1dENvbW1hbmQiLCJvdXRwdXRSd3N0YXRzQ29tbWFuZCIsIm91dHB1dFJ3Y291bnRDb21tYW5kIiwiY29tbWFuZHMiLCJyd2N1dE9wdGlvbnMiLCJyd2N1dE9wdGlvbnNTdHJpbmciLCJyd3NvcnRPcHRpb25zIiwicndzb3J0T3B0aW9uc1N0cmluZyIsInNvcnRGaWVsZCIsInNvcnRSZXZlcnNlIiwibnVtUmVjcyIsInN0YXJ0UmVjTnVtIiwiZmllbGRzIiwiaW50ZXJzZWN0aW9uIiwiZmllbGRzT3JkZXIiLCJkZWZhdWx0UndzdGF0c09wdGlvbnMiLCJyd3N0YXRzT3B0aW9ucyIsInJ3c3RhdHNPcHRpb25zU3RyaW5nIiwicndzdGF0c1ZhbHVlcyIsInJ3c3RhdHNWYWx1ZXNPcmRlciIsInZhbHVlcyIsInJ3c3RhdHNGaWVsZHMiLCJyd3N0YXRzRmllbGRzT3JkZXIiLCJyd3N0YXRzUHJpbWFyeVZhbHVlIiwicndzdGF0c0RpcmVjdGlvbiIsInJ3c3RhdHNNb2RlIiwicndzdGF0c0NvdW50TW9kZVZhbHVlIiwicndzdGF0c1RocmVzaG9sZE1vZGVWYWx1ZSIsInJ3c3RhdHNQZXJjZW50YWdlTW9kZVZhbHVlIiwicndzdGF0c0JpblRpbWVFbmFibGVkIiwicndzdGF0c0JpblRpbWUiLCJyd3N0YXRzQ21kIiwiZGVmYXVsdFJ3Y291bnRPcHRpb25zIiwiZmllbGRJbmRleCIsImhlYWRDb21tYW5kIiwiaGVhZE9wdGlvbnMiLCJyd2NvdW50T3B0aW9ucyIsInJ3Y291bnRPcHRpb25zU3RyaW5nIiwic29ydENvbW1hbmQiLCJzb3J0T3B0aW9ucyIsInRhaWxDb21tYW5kIiwidGFpbE9wdGlvbnMiLCJyd2NvdW50QmluU2l6ZUVuYWJsZWQiLCJyd2NvdW50QmluU2l6ZSIsInJ3Y291bnRMb2FkU2NoZW1lRW5hYmxlZCIsInJ3Y291bnRMb2FkU2NoZW1lIiwicndjb3VudFNraXBaZXJvZXMiLCJyd2NvdW50Q21kIiwicndzdGF0c0NvdW50TW9kZVZhbHVlSXNFbmFibGVkIiwicndzdGF0c1RocmVzaG9sZE1vZGVWYWx1ZUlzRW5hYmxlZCIsInJ3c3RhdHNQZXJjZW50YWdlTW9kZVZhbHVlSXNFbmFibGVkIiwiYXZhaWxhYmxlQ2hhcnRUeXBlcyIsInBhdGgiLCJJUFNldCIsIm9iamVjdFNlbGVjdE5hbWUiLCJvYmplY3RTZWxlY3RWYWx1ZSIsIlR1cGxlIiwiVHJhbnNmb3JtYXRpb25zIiwicXVlcnkiLCJpcHNldCIsInR1cGxlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQTtBQUFBLElBQUFBLE9BQUEsTUFBQUEsT0FBQTtBQUNNQyxLQUFLLENBQUNDLElBQU4sR0FBTixNQUFBQSxJQUFBO0FBQ0VDLGFBQWEsQ0FBQ0MsR0FBRDtBQUNYLFFBQUFDLEdBQUEsRUFBQUMsSUFBQTs7QUFBQUMsS0FBQyxDQUFDQyxNQUFGLENBQVMsSUFBVCxFQUFZSixHQUFaOztBQUNBLFNBQUNLLEtBQUQsSUFBQUosR0FBQSxRQUFBSyxNQUFBLGFBQUFKLElBQUEsR0FBQUQsR0FBQSxlQUFBQyxJQUFvQixDQUFFSyxPQUF0QixHQUFzQixNQUF0QixHQUFzQixNQUF0QjtBQUNBLFNBQUNDLElBQUQsR0FBUSxLQUFDQyxPQUFELENBQVNELElBQWpCO0FBQ0EsU0FBQ0UsU0FBRCxHQUFhLEtBQUNGLElBQUQsQ0FBTUcsS0FBTixDQUFZLEdBQVosRUFBaUJDLEtBQWpCLENBQXVCLENBQXZCLEVBQTBCLENBQTFCLEVBQTZCQyxJQUE3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QUFLLENBQUMyTixLQUF2QixJQUFnQyxDQUFJTSxLQUF2QztBQXNNRSxhQXRNZ0RBLEtBc01oRDtBQXRNRjtBQXdNRSxhQXhNMkQsSUFBSWpPLEtBQUssQ0FBQzJOLEtBQVYsQ0FBZ0JNLEtBQWhCLENBd00zRDtBQUNEO0FBaE5IO0FBUUFDLE9BQUEsRUFBTyxVQUFDQSxLQUFEO0FBQ0wsUUFBR0EsS0FBQSxZQUFpQmxPLEtBQUssQ0FBQzhOLEtBQXZCLElBQWdDLENBQUlJLEtBQXZDO0FBMk1FLGFBM01nREEsS0EyTWhEO0FBM01GO0FBNk1FLGFBN00yRCxJQUFJbE8sS0FBSyxDQUFDOE4sS0FBVixDQUFnQkksS0FBaEIsQ0E2TTNEO0FBQ0Q7QUEvTUk7QUFSUCxDQURGLEMiLCJmaWxlIjoiL2xpYi90cmFuc2Zvcm1hdGlvbnMuY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsiIyBub3QgdXNlZCBieSBkZWZhdWx0XG5jbGFzcyBzaGFyZS5Vc2VyXG4gIGNvbnN0cnVjdG9yOiAoZG9jKSAtPlxuICAgIF8uZXh0ZW5kKEAsIGRvYylcbiAgICBAZW1haWwgPSBAZW1haWxzP1swXT8uYWRkcmVzc1xuICAgIEBuYW1lID0gQHByb2ZpbGUubmFtZVxuICAgIEBmaXJzdE5hbWUgPSBAbmFtZS5zcGxpdCgnICcpLnNsaWNlKDAsIDEpLmpvaW4oJyAnKVxuICAgIEBsYXN0TmFtZSA9IEBuYW1lLnNwbGl0KCcgJykuc2xpY2UoMSkuam9pbignICcpXG5cbmNsYXNzIHNoYXJlLkNvbmZpZ1xuICBjb25zdHJ1Y3RvcjogKGRvYykgLT5cbiAgICBfLmV4dGVuZChALCBkb2MpXG4gIHdyYXBDb21tYW5kOiAoY29tbWFuZCkgLT5cbiAgICBcInNzaCBcIiArIEBnZXRTU0hPcHRpb25zKCkgKyBcIiAtcCBcIiArIEBwb3J0ICsgIFwiIFwiICsgQHVzZXIgKyBcIkBcIiArIEBob3N0ICsgXCIgXFxcIlwiICsgY29tbWFuZCArIFwiXFxcIlwiXG4gIGdldFNTSE9wdGlvbnM6IC0+XG4gICAgXCItbyBTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9bm8gLW8gVXNlcktub3duSG9zdHNGaWxlPS9kZXYvbnVsbCAtbyBMb2dMZXZlbD1lcnJvciAtaSBcIiArIEBnZXRJZGVudGl0eUZpbGUoKVxuICBnZXRJZGVudGl0eUZpbGU6IC0+XG4gICAgaWYgQGlkZW50aXR5RmlsZSB0aGVuIEBpZGVudGl0eUZpbGUgZWxzZSBwcm9jZXNzLmVudi5QV0QgKyBcIi9zZXR0aW5ncy9pZGVudGl0eVwiXG5cbmNsYXNzIHNoYXJlLlF1ZXJ5XG4gIGNvbnN0cnVjdG9yOiAoZG9jKSAtPlxuICAgIF8uZXh0ZW5kKEAsIGRvYylcbiAgICBAaGVhZGVyID0gW11cbiAgICBAcm93cyA9IFtdXG4gICAgaWYgQHJlc3VsdFxuICAgICAgcGFyc2VkUmVzdWx0ID0gc2hhcmUucGFyc2VSZXN1bHQoQHJlc3VsdClcbiAgICAgIGlmIEBvdXRwdXQgaXMgXCJyd3N0YXRzXCJcbiAgICAgICAgcGFyc2VkUmVzdWx0LnNoaWZ0KClcbiAgICAgICAgcGFyc2VkUmVzdWx0LnNoaWZ0KClcbiAgICAgICAgIyBzaGlmdC1zaGlmdCBvdXR0YSBoZXJlLCB5b3UgcmVkdW5kYW50IHJvd3NcbiAgICAgIGlmIEBvdXRwdXQgaXMgXCJyd2NvdW50XCJcbiAgICAgICAgcGFyc2VkUmVzdWx0LnVuc2hpZnQoc2hhcmUucndjb3VudEZpZWxkcylcbiAgICAgIHJhd0hlYWRlciA9IHBhcnNlZFJlc3VsdC5zaGlmdCgpXG4gICAgICBmb3IgbmFtZSBpbiByYXdIZWFkZXJcbiAgICAgICAgc3BlYyA9XG4gICAgICAgICAgX2lkOiBuYW1lXG4gICAgICAgICAgbmFtZTogbmFtZS50cmltKClcbiAgICAgICAgICBpc0Rpc3RpbmN0OiBmYWxzZVxuICAgICAgICAgIGlzUGVyY2VudGFnZTogZmFsc2VcbiAgICAgICAgaWYgc3BlYy5uYW1lLmluZGV4T2YoXCIlXCIpIGlzIDBcbiAgICAgICAgICBzcGVjLmlzUGVyY2VudGFnZSA9IHRydWVcbiAgICAgICAgICBzcGVjLm5hbWUgPSBzcGVjLm5hbWUuc3Vic3RyKDEpXG4gICAgICAgIGRpc3RpbmN0UmVnZXggPSAvLUQuKiQvaVxuICAgICAgICBpZiBzcGVjLm5hbWUubWF0Y2goZGlzdGluY3RSZWdleClcbiAgICAgICAgICBzcGVjLmlzRGlzdGluY3QgPSB0cnVlXG4gICAgICAgICAgc3BlYy5uYW1lID0gc3BlYy5uYW1lLnJlcGxhY2UoZGlzdGluY3RSZWdleCwgXCJcIilcbiAgICAgICAgaWYgc3BlYy5pc0Rpc3RpbmN0XG4gICAgICAgICAgc3BlYy5jaGFydFR5cGUgPSBcIm51bWJlclwiXG4gICAgICAgIGVsc2VcbiAgICAgICAgICBzcGVjLmNoYXJ0VHlwZSA9IHNoYXJlLmNoYXJ0RmllbGRUeXBlc1tzcGVjLm5hbWVdIG9yIFwic3RyaW5nXCJcbiAgICAgICAgQGhlYWRlci5wdXNoKHNwZWMpXG4gICAgICBpZiBAcHJlc2VudGF0aW9uIGlzIFwiY2hhcnRcIlxuICAgICAgICBmb3IgcGFyc2VkUm93IGluIHBhcnNlZFJlc3VsdFxuICAgICAgICAgIHJvdyA9IFtdXG4gICAgICAgICAgZm9yIHBhcnNlZFZhbHVlLCBpbmRleCBpbiBwYXJzZWRSb3dcbiAgICAgICAgICAgIHNwZWMgPSBAaGVhZGVyW2luZGV4XVxuICAgICAgICAgICAgaWYgQG91dHB1dCBpcyBcInJ3Y291bnRcIiBhbmQgc3BlYy5uYW1lIG5vdCBpbiBAcndjb3VudEZpZWxkc1xuICAgICAgICAgICAgICBjb250aW51ZVxuICAgICAgICAgICAgc3dpdGNoIHNwZWMuY2hhcnRUeXBlXG4gICAgICAgICAgICAgIHdoZW4gXCJudW1iZXJcIlxuICAgICAgICAgICAgICAgIHBhcnNlZFZhbHVlID0gcGFyc2VGbG9hdChwYXJzZWRWYWx1ZSlcbiAgICAgICAgICAgICAgd2hlbiBcImRhdGVcIiwgXCJkYXRldGltZVwiXG4gICAgICAgICAgICAgICAgbSA9IG1vbWVudC51dGMocGFyc2VkVmFsdWUsIFwiWVlZWS9NTS9ERFRISDptbTpzcy5TU1NcIilcbiAgICAgICAgICAgICAgICBwYXJzZWRWYWx1ZSA9IG0udG9EYXRlKClcbiAgICAgICAgICAgIHJvdy5wdXNoKHBhcnNlZFZhbHVlKVxuICAgICAgICAgIEByb3dzLnB1c2gocm93KVxuICAgICAgZWxzZVxuICAgICAgICBmb3IgcGFyc2VkUm93IGluIHBhcnNlZFJlc3VsdFxuICAgICAgICAgIHJvdyA9IFtdXG4gICAgICAgICAgZm9yIHBhcnNlZFZhbHVlLCBpbmRleCBpbiBwYXJzZWRSb3dcbiAgICAgICAgICAgIHNwZWMgPSBAaGVhZGVyW2luZGV4XVxuICAgICAgICAgICAgcm93LnB1c2goe19pZDogc3BlYy5faWQsIHZhbHVlOiBwYXJzZWRWYWx1ZSwgcXVlcnlJZDogQF9pZH0pXG4gICAgICAgICAgQHJvd3MucHVzaChyb3cpXG4gICAgICBmaWx0ZXJlZEhlYWRlciA9IFtdXG4gICAgICBmb3Igc3BlYyBpbiBAaGVhZGVyXG4gICAgICAgIGZpbHRlcmVkSGVhZGVyLnB1c2goc3BlYylcbiAgICAgIEBoZWFkZXIgPSBmaWx0ZXJlZEhlYWRlclxuICBkaXNwbGF5TmFtZTogLT5cbiAgICBpZiBAaXNRdWljayB0aGVuIFwiUXVpY2sgcXVlcnkgI1wiICsgQF9pZCBlbHNlIEBuYW1lIG9yIFwiI1wiICsgQF9pZFxuICBpbnB1dENvbW1hbmQ6IChjb25maWcsIHByb2ZpbGUsIGlzUHJlc2VudGF0aW9uID0gZmFsc2UpIC0+XG4gICAgY29tbWFuZCA9IFwicndmaWx0ZXJcIlxuICAgIGNvbW1hbmQgKz0gXCIgXCIgKyBAaW5wdXRPcHRpb25zKGNvbmZpZylcbiAgICAjIGRlZmF1bHRzIHRvIGhhdmluZyAtLXR5cGU9YWxsIGFzIHRoZSBzdGFuZGFyZCBpbnN0ZWFkIG9mIHRoZSBTaUxLIGRlZmF1bHQuXG4gICAgaWYgQGludGVyZmFjZSBpcyBcImNtZFwiXG4gICAgICB0eXBlVmFsaWRhdGUgPSBjb21tYW5kLnNlYXJjaChSZWdFeHAoJy0tdHlwZScsICdpJykpXG4gICAgICBpZiB0eXBlVmFsaWRhdGUgPCAwXG4gICAgICAgIGNvbW1hbmQgKz0gXCIgLS10eXBlPWFsbCBcIlxuICAgIGlmIGNvbmZpZy5zaXRlQ29uZmlnRmlsZVxuICAgICAgY29tbWFuZCArPSBcIiAtLXNpdGUtY29uZmlnLWZpbGU9XCIgKyBjb25maWcuc2l0ZUNvbmZpZ0ZpbGVcbiAgICAjIHJ3ZiBhbmQgcGNhcCBpbnRlZ3JhdGlvblxuICAgIHJ3RmlsZVZhbGlkYXRlID0gY29tbWFuZC5zZWFyY2goUmVnRXhwKCcgKFxcXFwvfFxcXFx3KSsoXFxcXC98XFxcXHd8XFxcXC0pKlxcXFwuKHJ3ZnxydyknLCAnaScpKVxuICAgIGlmIHJ3RmlsZVZhbGlkYXRlIDwgMFxuICAgICAgcGNhcEZpbGVWYWxpZGF0ZSA9IGNvbW1hbmQuc2VhcmNoKFJlZ0V4cCgnIChcXFxcL3xcXFxcdykrKFxcXFwvfFxcXFx3fFxcXFwtKSpcXFxcLihwY2FwKScsICdpJykpXG4gICAgICBpZiBwY2FwRmlsZVZhbGlkYXRlID49IDBcbiAgICAgICAgcGNhcEZpbGUgPSBjb21tYW5kLm1hdGNoKFJlZ0V4cCgnKFxcXFwvfFxcXFx3KSsoXFxcXC98XFxcXHd8XFxcXC0pKlxcXFwuKHBjYXApJywgJ2knKSlcbiAgICAgICAgY29tbWFuZCArPSBcIiAtLWlucHV0LXBpcGU9c3RkaW5cIlxuICAgICAgICBjb21tYW5kID0gY29tbWFuZC5yZXBsYWNlKHBjYXBGaWxlWzBdLFwiXCIpXG4gICAgICAgIGNvbW1hbmQgPSBcInJ3cDJ5YWYyc2lsayAtLWluPVwiICsgcGNhcEZpbGVbMF0gKyBcIiAtLW91dD0tIHxcIiArIGNvbW1hbmRcbiAgICAgIGVsc2VcbiAgICAgICAgaWYgY29uZmlnLmRhdGFSb290ZGlyXG4gICAgICAgICAgY29tbWFuZCArPSBcIiAtLWRhdGEtcm9vdGRpcj1cIiArIGNvbmZpZy5kYXRhUm9vdGRpclxuXG4gICAgY29tbWFuZCArPSBcIiAtLXBhc3M9c3Rkb3V0XCJcbiAgICBmb3IgZXhjbHVzaW9uIGluIEBpbnB1dEV4Y2x1c2lvbnMoKVxuICAgICAgY29tbWFuZCArPSBcIiB8IHJ3ZmlsdGVyIC0taW5wdXQtcGlwZT1zdGRpblwiXG4gICAgICBjb21tYW5kICs9IFwiIFwiICsgZXhjbHVzaW9uXG4gICAgICBpZiBjb25maWcuc2l0ZUNvbmZpZ0ZpbGVcbiAgICAgICAgY29tbWFuZCArPSBcIiAtLXNpdGUtY29uZmlnLWZpbGU9XCIgKyBjb25maWcuc2l0ZUNvbmZpZ0ZpbGVcbiAgICAgICMgY29uZmlnLmRhdGFSb290ZGlyIHNob3VsZG4ndCBiZSB1c2VkIHdpdGggZXhjbHVzaW9uc1xuICAgICAgY29tbWFuZCArPSBcIiAtLWZhaWw9c3Rkb3V0XCJcbiAgICBjb21tYW5kICs9IFwiID4gXCIgKyAoY29uZmlnLmRhdGFUZW1wZGlyIG9yIFwiL3RtcFwiKSArIFwiL1wiICsgQF9pZCArIFwiLnJ3ZlwiXG4gICAgaWYgY29uZmlnLmlzU1NIIGFuZCBub3QgaXNQcmVzZW50YXRpb25cbiAgICAgIGNvbW1hbmQgPSBjb25maWcud3JhcENvbW1hbmQoY29tbWFuZClcbiAgICBjb21tYW5kXG4gIGlucHV0T3B0aW9uczogKGNvbmZpZykgLT5cbiAgICBpZiBAaW50ZXJmYWNlIGlzIFwiYnVpbGRlclwiXG4gICAgICBwYXJhbWV0ZXJzID0gW11cbiAgICAgIGlmIEB0eXBlc0VuYWJsZWQgYW5kIEB0eXBlcy5sZW5ndGggYW5kIF8uZGlmZmVyZW5jZShzaGFyZS5xdWVyeVR5cGVzLCBAdHlwZXMpLmxlbmd0aFxuICAgICAgICB2YWx1ZSA9IEB0eXBlcy5qb2luKFwiLFwiKVxuICAgICAgZWxzZVxuICAgICAgICB2YWx1ZSA9IFwiYWxsXCJcbiAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tdHlwZT1cIiArIHZhbHVlKVxuICAgICAgaWYgQHN0YXJ0RGF0ZVR5cGUgaXMgXCJpbnRlcnZhbFwiXG4gICAgICAgIGlmIEBzdGFydERhdGVFbmFibGVkIGFuZCBAc3RhcnREYXRlXG4gICAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS1zdGFydC1kYXRlPVwiICsgQHN0YXJ0RGF0ZSlcbiAgICAgICAgaWYgQGVuZERhdGVFbmFibGVkIGFuZCBAZW5kRGF0ZVxuICAgICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tZW5kLWRhdGU9XCIgKyBAZW5kRGF0ZSlcbiAgICAgICAgaWYgQGFjdGl2ZVRpbWVFbmFibGVkIGFuZCBAYWN0aXZlVGltZVxuICAgICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tYWN0aXZlLXRpbWU9XCIgKyBAYWN0aXZlVGltZSlcbiAgICAgIGVsc2VcbiAgICAgICAgaWYgQHN0YXJ0RGF0ZU9mZnNldEVuYWJsZWQgYW5kIEBzdGFydERhdGVPZmZzZXRcbiAgICAgICAgICBzdGFydERhdGVPZmZzZXROdW1iZXIgPSBzaGFyZS5pbnR2YWwoQHN0YXJ0RGF0ZU9mZnNldClcbiAgICAgICAgICBlVGltZU1vbWVudCA9IG1vbWVudC51dGMoKVxuICAgICAgICAgIHNUaW1lTW9tZW50ID0gZVRpbWVNb21lbnQuY2xvbmUoKS5zdWJ0cmFjdChzdGFydERhdGVPZmZzZXROdW1iZXIsICdtaW51dGVzJylcbiAgICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXN0YXJ0LWRhdGU9XCIgKyBzVGltZU1vbWVudC5mb3JtYXQoXCJZWVlZL01NL0REOkhIXCIpKVxuICAgICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tZW5kLWRhdGU9XCIgKyBlVGltZU1vbWVudC5mb3JtYXQoXCJZWVlZL01NL0REOkhIXCIpKVxuICAgICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tYWN0aXZlLXRpbWU9XCIgKyBzVGltZU1vbWVudC5mb3JtYXQoXCJZWVlZL01NL0REVEhIOm1tOnNzLlNTU1wiKSArIFwiLVwiICsgZVRpbWVNb21lbnQuZm9ybWF0KFwiWVlZWS9NTS9ERFRISDptbTpzcy5TU1NcIikpXG4gICAgICBpZiBAc2Vuc29yRW5hYmxlZCBhbmQgQHNlbnNvclxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXNlbnNvcj1cIiArIEBzZW5zb3IpXG4gICAgICBpZiBAZGFkZHJlc3NFbmFibGVkIGFuZCBAZGFkZHJlc3NcbiAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS1kYWRkcmVzcz1cIiArIEBkYWRkcmVzcylcbiAgICAgIGlmIEBzYWRkcmVzc0VuYWJsZWQgYW5kIEBzYWRkcmVzc1xuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXNhZGRyZXNzPVwiICsgQHNhZGRyZXNzKVxuICAgICAgaWYgQGFueUFkZHJlc3NFbmFibGVkIGFuZCBAYW55QWRkcmVzc1xuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLWFueS1hZGRyZXNzPVwiICsgQGFueUFkZHJlc3MpXG4gICAgICBpZiBAZGlwU2V0RW5hYmxlZCBhbmQgQGRpcFNldFxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLWRpcHNldD1cIiArIChjb25maWcuZGF0YVRlbXBkaXIgb3IgXCIvdG1wXCIpICsgXCIvXCIgKyBAZGlwU2V0ICsgXCIucndzXCIpXG4gICAgICBpZiBAc2lwU2V0RW5hYmxlZCBhbmQgQHNpcFNldFxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXNpcHNldD1cIiArIChjb25maWcuZGF0YVRlbXBkaXIgb3IgXCIvdG1wXCIpICsgXCIvXCIgKyBAc2lwU2V0ICsgXCIucndzXCIpXG4gICAgICBpZiBAYW55U2V0RW5hYmxlZCBhbmQgQGFueVNldFxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLWFueXNldD1cIiArIChjb25maWcuZGF0YVRlbXBkaXIgb3IgXCIvdG1wXCIpICsgXCIvXCIgKyBAYW55U2V0ICsgXCIucndzXCIpXG4gICAgICBpZiBAdHVwbGVGaWxlRW5hYmxlZCBhbmQgQHR1cGxlRmlsZVxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXR1cGxlLWZpbGU9XCIgKyAoY29uZmlnLmRhdGFUZW1wZGlyIG9yIFwiL3RtcFwiKSArIFwiL1wiICsgQHR1cGxlRmlsZSArIFwiLnR1cGxlXCIpXG4gICAgICBpZiBAdHVwbGVEaXJlY3Rpb25FbmFibGVkIGFuZCBAdHVwbGVEaXJlY3Rpb25cbiAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS10dXBsZS1kaXJlY3Rpb249XCIgKyBAdHVwbGVEaXJlY3Rpb24pXG4gICAgICBpZiBAdHVwbGVEZWxpbWl0ZXJFbmFibGVkIGFuZCBAdHVwbGVEZWxpbWl0ZXJcbiAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS10dXBsZS1kZWxpbWl0ZXI9XCIgKyBAdHVwbGVEZWxpbWl0ZXIpXG4gICAgICBpZiBAdHVwbGVGaWVsZHNFbmFibGVkIGFuZCBAdHVwbGVGaWVsZHNcbiAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS10dXBsZS1maWVsZHM9XCIgKyBAdHVwbGVGaWVsZHMpXG4gICAgICBpZiBAZHBvcnRFbmFibGVkIGFuZCBAZHBvcnRcbiAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS1kcG9ydD1cIiArIEBkcG9ydClcbiAgICAgIGlmIEBzcG9ydEVuYWJsZWQgYW5kIEBzcG9ydFxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXNwb3J0PVwiICsgQHNwb3J0KVxuICAgICAgaWYgQGFwb3J0RW5hYmxlZCBhbmQgQGFwb3J0XG4gICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tYXBvcnQ9XCIgKyBAYXBvcnQpXG4gICAgICBpZiBAZGNjRW5hYmxlZCBhbmQgQGRjYy5sZW5ndGhcbiAgICAgICAgcGFyYW1ldGVycy5wdXNoKFwiLS1kY2M9XCIgKyBAZGNjLmpvaW4oXCIsXCIpKVxuICAgICAgaWYgQHNjY0VuYWJsZWQgYW5kIEBzY2MubGVuZ3RoXG4gICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tc2NjPVwiICsgQHNjYy5qb2luKFwiLFwiKSlcbiAgICAgIGlmIEBwcm90b2NvbEVuYWJsZWQgYW5kIEBwcm90b2NvbFxuICAgICAgICBwYXJhbWV0ZXJzLnB1c2goXCItLXByb3RvY29sPVwiICsgQHByb3RvY29sKVxuICAgICAgaWYgQGZsYWdzQWxsRW5hYmxlZCBhbmQgQGZsYWdzQWxsXG4gICAgICAgIHBhcmFtZXRlcnMucHVzaChcIi0tZmxhZ3MtYWxsPVwiICsgQGZsYWdzQWxsKVxuICAgICAgaWYgQGFkZGl0aW9uYWxQYXJhbWV0ZXJzRW5hYmxlZCBhbmQgQGFkZGl0aW9uYWxQYXJhbWV0ZXJzXG4gICAgICAgIHBhcmFtZXRlcnMucHVzaChAYWRkaXRpb25hbFBhcmFtZXRlcnMpXG4gICAgICBzdHJpbmcgPSBwYXJhbWV0ZXJzLmpvaW4oXCIgXCIpXG4gICAgZWxzZVxuICAgICAgc3RyaW5nID0gQGNtZFxuICAgIHNoYXJlLmZpbHRlck9wdGlvbnMoc3RyaW5nKVxuICBpbnB1dEV4Y2x1c2lvbnM6IC0+XG4gICAgZXhjbHVzaW9uc0NtZCA9IFwiXCJcbiAgICBpZiBAaW50ZXJmYWNlIGlzIFwiYnVpbGRlclwiXG4gICAgICBpZiBAYWRkaXRpb25hbEV4Y2x1c2lvbnNDbWRFbmFibGVkXG4gICAgICAgIGV4Y2x1c2lvbnNDbWQgPSBAYWRkaXRpb25hbEV4Y2x1c2lvbnNDbWRcbiAgICBlbHNlXG4gICAgICBleGNsdXNpb25zQ21kID0gQGV4Y2x1c2lvbnNDbWRcbiAgICBleGNsdXNpb25zQ21kID0gc2hhcmUuZmlsdGVyT3B0aW9ucyhleGNsdXNpb25zQ21kKVxuICAgIF8uY29tcGFjdChleGNsdXNpb25zQ21kLnNwbGl0KC9cXHMrKD86T1J8XFx8XFx8KVxccysvaSkpXG4gIG91dHB1dENvbW1hbmQ6IChjb25maWcsIHByb2ZpbGUsIGlzUHJlc2VudGF0aW9uID0gZmFsc2UpIC0+XG4gICAgc3dpdGNoIEBvdXRwdXRcbiAgICAgIHdoZW4gXCJyd2N1dFwiXG4gICAgICAgIEBvdXRwdXRSd2N1dENvbW1hbmQoY29uZmlnLCBwcm9maWxlLCBpc1ByZXNlbnRhdGlvbilcbiAgICAgIHdoZW4gXCJyd3N0YXRzXCJcbiAgICAgICAgQG91dHB1dFJ3c3RhdHNDb21tYW5kKGNvbmZpZywgcHJvZmlsZSwgaXNQcmVzZW50YXRpb24pXG4gICAgICB3aGVuIFwicndjb3VudFwiXG4gICAgICAgIEBvdXRwdXRSd2NvdW50Q29tbWFuZChjb25maWcsIHByb2ZpbGUsIGlzUHJlc2VudGF0aW9uKVxuICBvdXRwdXRSd2N1dENvbW1hbmQ6IChjb25maWcsIHByb2ZpbGUsIGlzUHJlc2VudGF0aW9uID0gZmFsc2UpIC0+XG4gICAgY29tbWFuZHMgPSBbXVxuICAgIGlmIEBzb3J0RmllbGRcbiAgICAgIHJ3c29ydE9wdGlvbnMgPSBbXCItLWZpZWxkcz1cIiArIEBzb3J0RmllbGRdXG4gICAgICBpZiBAc29ydFJldmVyc2VcbiAgICAgICAgcndzb3J0T3B0aW9ucy5wdXNoKFwiLS1yZXZlcnNlXCIpXG4gICAgICBpZiBjb25maWcuc2l0ZUNvbmZpZ0ZpbGVcbiAgICAgICAgcndzb3J0T3B0aW9ucy5wdXNoKFwiLS1zaXRlLWNvbmZpZy1maWxlPVwiICsgY29uZmlnLnNpdGVDb25maWdGaWxlKVxuICAgICAgcndzb3J0T3B0aW9uc1N0cmluZyA9IHJ3c29ydE9wdGlvbnMuam9pbihcIiBcIilcbiAgICAgIHJ3c29ydE9wdGlvbnNTdHJpbmcgPSBzaGFyZS5maWx0ZXJPcHRpb25zKHJ3c29ydE9wdGlvbnNTdHJpbmcpXG4gICAgICBjb21tYW5kcy5wdXNoKFwicndzb3J0IFwiICsgcndzb3J0T3B0aW9uc1N0cmluZylcbiAgICByd2N1dE9wdGlvbnMgPSBbXCItLW51bS1yZWNzPVwiICsgcHJvZmlsZS5udW1SZWNzLCBcIi0tc3RhcnQtcmVjLW51bT1cIiArIEBzdGFydFJlY051bSwgXCItLWRlbGltaXRlZFwiXVxuICAgIGlmIEBmaWVsZHMubGVuZ3RoXG4gICAgICByd2N1dE9wdGlvbnMucHVzaChcIi0tZmllbGRzPVwiICsgXy5pbnRlcnNlY3Rpb24oQGZpZWxkc09yZGVyLCBAZmllbGRzKS5qb2luKFwiLFwiKSlcbiAgICBpZiBjb25maWcuc2l0ZUNvbmZpZ0ZpbGVcbiAgICAgIHJ3Y3V0T3B0aW9ucy5wdXNoKFwiLS1zaXRlLWNvbmZpZy1maWxlPVwiICsgY29uZmlnLnNpdGVDb25maWdGaWxlKVxuICAgIHJ3Y3V0T3B0aW9uc1N0cmluZyA9IHJ3Y3V0T3B0aW9ucy5qb2luKFwiIFwiKVxuICAgIHJ3Y3V0T3B0aW9uc1N0cmluZyA9IHNoYXJlLmZpbHRlck9wdGlvbnMocndjdXRPcHRpb25zU3RyaW5nKVxuICAgIGNvbW1hbmRzLnB1c2goXCJyd2N1dCBcIiArIHJ3Y3V0T3B0aW9uc1N0cmluZylcbiAgICBjb21tYW5kc1swXSArPSBcIiBcIiArIChjb25maWcuZGF0YVRlbXBkaXIgb3IgXCIvdG1wXCIpICsgXCIvXCIgKyBAX2lkICsgXCIucndmXCJcbiAgICBjb21tYW5kID0gY29tbWFuZHMuam9pbihcIiB8IFwiKVxuICAgIGlmIGNvbmZpZy5pc1NTSCBhbmQgbm90IGlzUHJlc2VudGF0aW9uXG4gICAgICBjb21tYW5kID0gY29uZmlnLndyYXBDb21tYW5kKGNvbW1hbmQpXG4gICAgY29tbWFuZFxuICBvdXRwdXRSd3N0YXRzQ29tbWFuZDogKGNvbmZpZywgcHJvZmlsZSwgaXNQcmVzZW50YXRpb24gPSBmYWxzZSkgLT5cbiAgICBkZWZhdWx0UndzdGF0c09wdGlvbnMgPSBbXCItLWRlbGltaXRlZFwiXVxuICAgIGlmIEBpbnRlcmZhY2UgaXMgXCJidWlsZGVyXCJcbiAgICAgIHJ3c3RhdHNPcHRpb25zID0gZGVmYXVsdFJ3c3RhdHNPcHRpb25zXG4gICAgICBpZiBAcndzdGF0c0ZpZWxkcy5sZW5ndGhcbiAgICAgICAgcndzdGF0c09wdGlvbnMucHVzaChcIi0tZmllbGRzPVwiICsgXy5pbnRlcnNlY3Rpb24oQHJ3c3RhdHNGaWVsZHNPcmRlciwgQHJ3c3RhdHNGaWVsZHMpLmpvaW4oXCIsXCIpKVxuICAgICAgcndzdGF0c1ZhbHVlcyA9IEByd3N0YXRzVmFsdWVzLnNsaWNlKDApXG4gICAgICByd3N0YXRzVmFsdWVzT3JkZXIgPSBAcndzdGF0c1ZhbHVlc09yZGVyLnNsaWNlKDApXG4gICAgICBpZiBAcndzdGF0c1ByaW1hcnlWYWx1ZVxuICAgICAgICByd3N0YXRzVmFsdWVzLnVuc2hpZnQoQHJ3c3RhdHNQcmltYXJ5VmFsdWUpXG4gICAgICAgIHJ3c3RhdHNWYWx1ZXNPcmRlci51bnNoaWZ0KEByd3N0YXRzUHJpbWFyeVZhbHVlKVxuICAgICAgaWYgcndzdGF0c1ZhbHVlcy5sZW5ndGhcbiAgICAgICAgdmFsdWVzID0gXy5pbnRlcnNlY3Rpb24ocndzdGF0c1ZhbHVlc09yZGVyLCByd3N0YXRzVmFsdWVzKVxuICAgICAgICBmb3IgdmFsdWUsIGluZGV4IGluIHZhbHVlc1xuICAgICAgICAgIGlmIHZhbHVlIG5vdCBpbiBzaGFyZS5yd3N0YXRzVmFsdWVzXG4gICAgICAgICAgICB2YWx1ZXNbaW5kZXhdID0gXCJkaXN0aW5jdDpcIiArIHZhbHVlXG4gICAgICAgIHJ3c3RhdHNPcHRpb25zLnB1c2goXCItLXZhbHVlcz1cIiArIHZhbHVlcy5qb2luKFwiLFwiKSlcbiAgICAgICAgaWYgdmFsdWVzWzBdIG5vdCBpbiBzaGFyZS5yd3N0YXRzVmFsdWVzXG4gICAgICAgICAgcndzdGF0c09wdGlvbnMucHVzaChcIi0tbm8tcGVyY2VudHNcIilcbiAgICAgIHJ3c3RhdHNPcHRpb25zLnB1c2goXCItLVwiICsgQHJ3c3RhdHNEaXJlY3Rpb24pXG4gICAgICBzd2l0Y2ggQHJ3c3RhdHNNb2RlXG4gICAgICAgIHdoZW4gXCJjb3VudFwiXG4gICAgICAgICAgcndzdGF0c09wdGlvbnMucHVzaChcIi0tY291bnQ9XCIgKyBAcndzdGF0c0NvdW50TW9kZVZhbHVlKVxuICAgICAgICB3aGVuIFwidGhyZXNob2xkXCJcbiAgICAgICAgICByd3N0YXRzT3B0aW9ucy5wdXNoKFwiLS10aHJlc2hvbGQ9XCIgKyBAcndzdGF0c1RocmVzaG9sZE1vZGVWYWx1ZSlcbiAgICAgICAgd2hlbiBcInBlcmNlbnRhZ2VcIlxuICAgICAgICAgIHJ3c3RhdHNPcHRpb25zLnB1c2goXCItLXBlcmNlbnRhZ2U9XCIgKyBAcndzdGF0c1BlcmNlbnRhZ2VNb2RlVmFsdWUpXG4gICAgICBpZiBAcndzdGF0c0JpblRpbWVFbmFibGVkXG4gICAgICAgIGlmIEByd3N0YXRzQmluVGltZVxuICAgICAgICAgIHJ3c3RhdHNPcHRpb25zLnB1c2goXCItLWJpbi10aW1lPVwiICsgQHJ3c3RhdHNCaW5UaW1lKVxuICAgICAgICBlbHNlXG4gICAgICAgICAgcndzdGF0c09wdGlvbnMucHVzaChcIi0tYmluLXRpbWVcIilcbiAgICAgIGlmIGNvbmZpZy5zaXRlQ29uZmlnRmlsZVxuICAgICAgICByd3N0YXRzT3B0aW9ucy5wdXNoKFwiLS1zaXRlLWNvbmZpZy1maWxlPVwiICsgY29uZmlnLnNpdGVDb25maWdGaWxlKVxuICAgICAgcndzdGF0c09wdGlvbnNTdHJpbmcgPSByd3N0YXRzT3B0aW9ucy5qb2luKFwiIFwiKVxuICAgIGVsc2VcbiAgICAgIHJ3c3RhdHNPcHRpb25zU3RyaW5nID0gQHJ3c3RhdHNDbWQgKyBcIiBcIiArIGRlZmF1bHRSd3N0YXRzT3B0aW9ucy5qb2luKFwiIFwiKVxuICAgICAgcndzdGF0c09wdGlvbnNTdHJpbmcgPSBzaGFyZS5maWx0ZXJPcHRpb25zKHJ3c3RhdHNPcHRpb25zU3RyaW5nKVxuICAgIGNvbW1hbmQgPSBcInJ3c3RhdHMgXCIgKyByd3N0YXRzT3B0aW9uc1N0cmluZ1xuICAgIGNvbW1hbmQgKz0gXCIgXCIgKyAoY29uZmlnLmRhdGFUZW1wZGlyIG9yIFwiL3RtcFwiKSArIFwiL1wiICsgQF9pZCArIFwiLnJ3ZlwiXG4gICAgaWYgY29uZmlnLmlzU1NIIGFuZCBub3QgaXNQcmVzZW50YXRpb25cbiAgICAgIGNvbW1hbmQgPSBjb25maWcud3JhcENvbW1hbmQoY29tbWFuZClcbiAgICBjb21tYW5kXG4gIG91dHB1dFJ3Y291bnRDb21tYW5kOiAoY29uZmlnLCBwcm9maWxlLCBpc1ByZXNlbnRhdGlvbiA9IGZhbHNlKSAtPlxuICAgIGRlZmF1bHRSd2NvdW50T3B0aW9ucyA9IFtcIi0tZGVsaW1pdGVkXCIsIFwiLS1uby10aXRsZXNcIl0gIyAtLW5vLXRpdGxlcyBpcyBuZWNlc3NhcnksIGJlY2F1c2UgaGVhZGVyIGlzIGFkZGVkIGxhdGVyXG4gICAgaWYgQGludGVyZmFjZSBpcyBcImJ1aWxkZXJcIlxuICAgICAgcndjb3VudE9wdGlvbnMgPSBkZWZhdWx0Undjb3VudE9wdGlvbnNcbiAgICAgIGlmIEByd2NvdW50QmluU2l6ZUVuYWJsZWRcbiAgICAgICAgcndjb3VudE9wdGlvbnMucHVzaChcIi0tYmluLXNpemU9XCIgKyBAcndjb3VudEJpblNpemUpXG4gICAgICBpZiBAcndjb3VudExvYWRTY2hlbWVFbmFibGVkXG4gICAgICAgIHJ3Y291bnRPcHRpb25zLnB1c2goXCItLWxvYWQtc2NoZW1lPVwiICsgQHJ3Y291bnRMb2FkU2NoZW1lKVxuICAgICAgaWYgQHJ3Y291bnRTa2lwWmVyb2VzXG4gICAgICAgIHJ3Y291bnRPcHRpb25zLnB1c2goXCItLXNraXAtemVyb2VzXCIpXG4gICAgICBpZiBjb25maWcuc2l0ZUNvbmZpZ0ZpbGVcbiAgICAgICAgcndjb3VudE9wdGlvbnMucHVzaChcIi0tc2l0ZS1jb25maWctZmlsZT1cIiArIGNvbmZpZy5zaXRlQ29uZmlnRmlsZSlcbiAgICAgIHJ3Y291bnRPcHRpb25zU3RyaW5nID0gcndjb3VudE9wdGlvbnMuam9pbihcIiBcIilcbiAgICBlbHNlXG4gICAgICByd2NvdW50T3B0aW9uc1N0cmluZyA9IEByd2NvdW50Q21kICsgXCIgXCIgKyBkZWZhdWx0Undjb3VudE9wdGlvbnMuam9pbihcIiBcIilcbiAgICByd2NvdW50T3B0aW9uc1N0cmluZyA9IHNoYXJlLmZpbHRlck9wdGlvbnMocndjb3VudE9wdGlvbnNTdHJpbmcpXG4gICAgY29tbWFuZCA9IFwicndjb3VudCBcIiArIHJ3Y291bnRPcHRpb25zU3RyaW5nXG4gICAgY29tbWFuZCArPSBcIiBcIiArIChjb25maWcuZGF0YVRlbXBkaXIgb3IgXCIvdG1wXCIpICsgXCIvXCIgKyBAX2lkICsgXCIucndmXCJcbiAgICBpZiBAcHJlc2VudGF0aW9uIGlzIFwidGFibGVcIlxuICAgICAgaWYgQHNvcnRGaWVsZFxuICAgICAgICBmaWVsZEluZGV4ID0gc2hhcmUucndjb3VudEZpZWxkcy5pbmRleE9mKEBzb3J0RmllbGQpXG4gICAgICAgIHNvcnRPcHRpb25zID0gXCItLWZpZWxkLXNlcGFyYXRvcj1cXFxcXFx8IC0ta2V5PStcIiArIChmaWVsZEluZGV4ICsgMSkgKyBcIm5cIiArIChpZiBAc29ydFJldmVyc2UgdGhlbiBcInJcIiBlbHNlIFwiXCIpXG4gICAgICAgIHNvcnRPcHRpb25zID0gc2hhcmUuZmlsdGVyT3B0aW9ucyhzb3J0T3B0aW9ucywgXCJcXFxcXFxcXFxcXFx8XFxcXCtcIilcbiAgICAgICAgc29ydENvbW1hbmQgPSBcInNvcnQgXCIgKyBzb3J0T3B0aW9uc1xuICAgICAgICBjb21tYW5kICs9IFwiIHwgXCIgKyBzb3J0Q29tbWFuZFxuICAgICAgaWYgcHJvZmlsZS5udW1SZWNzXG4gICAgICAgIGhlYWRPcHRpb25zID0gXCItLWxpbmVzPVwiICsgKEBzdGFydFJlY051bSArIHByb2ZpbGUubnVtUmVjcyAtIDEpXG4gICAgICAgIGhlYWRPcHRpb25zID0gc2hhcmUuZmlsdGVyT3B0aW9ucyhoZWFkT3B0aW9ucylcbiAgICAgICAgaGVhZENvbW1hbmQgPSBcImhlYWQgXCIgKyBoZWFkT3B0aW9uc1xuICAgICAgICB0YWlsT3B0aW9ucyA9IFwiLS1saW5lcz1cIiArIHByb2ZpbGUubnVtUmVjc1xuICAgICAgICB0YWlsT3B0aW9ucyA9IHNoYXJlLmZpbHRlck9wdGlvbnModGFpbE9wdGlvbnMpXG4gICAgICAgIHRhaWxDb21tYW5kID0gXCJ0YWlsIFwiICsgdGFpbE9wdGlvbnNcbiAgICAgICAgY29tbWFuZCArPSBcIiB8IFwiICsgaGVhZENvbW1hbmQgKyBcIiB8IFwiICsgdGFpbENvbW1hbmRcbiAgICBpZiBjb25maWcuaXNTU0ggYW5kIG5vdCBpc1ByZXNlbnRhdGlvblxuICAgICAgY29tbWFuZCA9IGNvbmZpZy53cmFwQ29tbWFuZChjb21tYW5kKVxuICAgIGNvbW1hbmRcbiAgcndzdGF0c0NvdW50TW9kZVZhbHVlSXNFbmFibGVkOiAtPlxuICAgIEByd3N0YXRzTW9kZSBpcyBcImNvdW50XCJcbiAgcndzdGF0c1RocmVzaG9sZE1vZGVWYWx1ZUlzRW5hYmxlZDogLT5cbiAgICBAcndzdGF0c01vZGUgaXMgXCJ0aHJlc2hvbGRcIlxuICByd3N0YXRzUGVyY2VudGFnZU1vZGVWYWx1ZUlzRW5hYmxlZDogLT5cbiAgICBAcndzdGF0c01vZGUgaXMgXCJwZXJjZW50YWdlXCJcbiAgYXZhaWxhYmxlQ2hhcnRUeXBlczogLT5cbiAgICBzaGFyZS5hdmFpbGFibGVDaGFydFR5cGVzW0BvdXRwdXRdXG4gIHBhdGg6IC0+XG4gICAgXCIvcXVlcnkvXCIgKyBAX2lkXG5cbmNsYXNzIHNoYXJlLklQU2V0XG4gIGNvbnN0cnVjdG9yOiAoZG9jKSAtPlxuICAgIF8uZXh0ZW5kKEAsIGRvYylcbiAgZGlzcGxheU5hbWU6IC0+XG4gICAgQG5hbWUgb3IgXCIjXCIgKyBAX2lkXG4gIG9iamVjdFNlbGVjdE5hbWU6IC0+XG4gICAgQGRpc3BsYXlOYW1lKClcbiAgb2JqZWN0U2VsZWN0VmFsdWU6IC0+XG4gICAgQF9pZFxuICBwYXRoOiAtPlxuICAgIFwiL2lwc2V0L1wiICsgQF9pZFxuXG5jbGFzcyBzaGFyZS5UdXBsZVxuICBjb25zdHJ1Y3RvcjogKGRvYykgLT5cbiAgICBfLmV4dGVuZChALCBkb2MpXG4gIGRpc3BsYXlOYW1lOiAtPlxuICAgIEBuYW1lIG9yIFwiI1wiICsgQF9pZFxuICBvYmplY3RTZWxlY3ROYW1lOiAtPlxuICAgIEBkaXNwbGF5TmFtZSgpXG4gIG9iamVjdFNlbGVjdFZhbHVlOiAtPlxuICAgIEBfaWRcbiAgcGF0aDogLT5cbiAgICBcIi90dXBsZS9cIiArIEBfaWRcblxuc2hhcmUuVHJhbnNmb3JtYXRpb25zID1cbiAgdXNlcjogKHVzZXIpIC0+XG4gICAgaWYgdXNlciBpbnN0YW5jZW9mIHNoYXJlLlVzZXIgb3Igbm90IHVzZXIgdGhlbiB1c2VyIGVsc2UgbmV3IHNoYXJlLlVzZXIodXNlcilcbiAgY29uZmlnOiAoY29uZmlnKSAtPlxuICAgIGlmIGNvbmZpZyBpbnN0YW5jZW9mIHNoYXJlLkNvbmZpZyBvciBub3QgY29uZmlnIHRoZW4gY29uZmlnIGVsc2UgbmV3IHNoYXJlLkNvbmZpZyhjb25maWcpXG4gIHF1ZXJ5OiAocXVlcnkpIC0+XG4gICAgaWYgcXVlcnkgaW5zdGFuY2VvZiBzaGFyZS5RdWVyeSBvciBub3QgcXVlcnkgdGhlbiBxdWVyeSBlbHNlIG5ldyBzaGFyZS5RdWVyeShxdWVyeSlcbiAgaXBzZXQ6IChpcHNldCkgLT5cbiAgICBpZiBpcHNldCBpbnN0YW5jZW9mIHNoYXJlLklQU2V0IG9yIG5vdCBpcHNldCB0aGVuIGlwc2V0IGVsc2UgbmV3IHNoYXJlLklQU2V0KGlwc2V0KVxuICB0dXBsZTogKHR1cGxlKSAtPlxuICAgIGlmIHR1cGxlIGluc3RhbmNlb2Ygc2hhcmUuVHVwbGUgb3Igbm90IHR1cGxlIHRoZW4gdHVwbGUgZWxzZSBuZXcgc2hhcmUuVHVwbGUodHVwbGUpXG4iXX0=

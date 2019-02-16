(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// lib/app.coffee                                                      //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var object, share;
share = share || {}; //share.combine = (funcs...) ->
//  (args...) =>
//    for func in funcs
//      func.apply(@, args)

share.user = function (fields, userId = Meteor.userId()) {
  return Meteor.users.findOne(userId, {
    fields: fields
  });
};

share.intval = function (value) {
  return parseInt(value, 10) || 0;
};

share.minute = 60 * 1000;
share.hour = 60 * share.minute;
share.datetimeFormat = "YYYY/MM/DD HH:mm:ss.SSS";
share.rwcutFields = ["sIP", "dIP", "sPort", "dPort", "protocol", "packets", "bytes", "flags", "sTime", "duration", "eTime", "sensor", "class", "scc", "dcc", "initialFlags", "sessionFlags", "application", "type", "icmpTypeCode"];
share.rwstatsValues = ["Records", "Packets", "Bytes"];
share.rwcountFields = ["Date", "Records", "Bytes", "Packets"];
share.rwcountLoadSchemes = ["", "bin-uniform", "start-spike", "end-spike", "middle-spike", "time-proportional", "maximum-volume", "minimum-volume"];
share.tupleDirections = ["", "both", "forward", "reverse"];
share.availableChartTypes = {
  "rwcut": [],
  "rwstats": ["BarChart", "ColumnChart", "PieChart"],
  "rwcount": ["LineChart"]
};
share.chartFieldTypes = {
  "sPort": "number",
  "dPort": "number",
  "protocol": "number",
  "pro": "number",
  "packets": "number",
  "bytes": "number",
  "sTime": "datetime",
  "duration": "number",
  "dur": "number",
  "eTime": "datetime",
  "Records": "number",
  "Packets": "number",
  "Bytes": "number",
  "Date": "datetime",
  "cumul_%": "number"
};
share.startDateOffsets = {
  "Hour": 60..toString(),
  "Day": (24 * 60).toString(),
  "Week": (7 * 24 * 60).toString(),
  "Month": (30 * 24 * 60).toString()
};

share.parseResult = function (result) {
  var i, len, ref, row, rows;
  rows = [];
  ref = result.split("\n");

  for (i = 0, len = ref.length; i < len; i++) {
    row = ref[i];
    rows.push(row.split("|"));
  }

  return rows;
};

share.queryTypes = ["in", "out", "inweb", "outweb", "inicmp", "outicmp", "innull", "outnull", "int2int", "ext2ext", "other"];
share.inputFields = ["interface", "cmd", "exclusionsCmd", "startDateEnabled", "startDate", "endDateEnabled", "endDate", "sensorEnabled", "sensor", "typesEnabled", "types", "daddressEnabled", "daddress", "saddressEnabled", "saddress", "anyAddressEnabled", "anyAddress", "dipSetEnabled", "dipSet", "sipSetEnabled", "sipSet", "anySetEnabled", "anySet", "tupleFileEnabled", "tupleFile", "tupleDirectionEnabled", "tupleDirection", "tupleDelimiterEnabled", "tupleDelimiter", "tupleFieldsEnabled", "tupleFields", "dportEnabled", "dport", "sportEnabled", "sport", "aportEnabled", "aport", "dccEnabled", "dcc", "sccEnabled", "scc", "protocolEnabled", "protocol", "flagsAllEnabled", "flagsAll", "activeTimeEnabled", "activeTime", "additionalParametersEnabled", "additionalParameters", "additionalExclusionsCmdEnabled", "additionalExclusionsCmd"];

share.filterOptions = function (options, additionalPermittedCharacters = "") {
  var excludedOption, filter, i, len, ref, regexp;
  ref = ["--python-expr", "--python-file", "--pmap", "--dynamic-library", "--all-destination", "--fail-destination", "--pass-destination", "--print-statistics", "--print-volume-statistics", "--xargs"];

  for (i = 0, len = ref.length; i < len; i++) {
    excludedOption = ref[i];
    regexp = new RegExp(excludedOption + "=?[^\\s]*", "gi");
    options = options.replace(regexp, "");
  }

  filter = new RegExp("[^\\s\\=\\-\\/\\,\\.\\:0-9a-z_" + additionalPermittedCharacters + "]", "gi");
  options = options.replace(filter, "");
  return options;
};

share.isDebug = Meteor.settings.public.isDebug;
object = typeof window !== "undefined" ? window : global;
object.isDebug = share.isDebug;

if (typeof console !== "undefined" && console.log && _.isFunction(console.log)) {
  object.cl = _.bind(console.log, console);
} else {
  object.cl = function () {};
}
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/lib/app.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvbGliL2FwcC5jb2ZmZWUiXSwibmFtZXMiOlsib2JqZWN0Iiwic2hhcmUiLCJ1c2VyIiwiZmllbGRzIiwidXNlcklkIiwiTWV0ZW9yIiwidXNlcnMiLCJmaW5kT25lIiwiaW50dmFsIiwidmFsdWUiLCJwYXJzZUludCIsIm1pbnV0ZSIsImhvdXIiLCJkYXRldGltZUZvcm1hdCIsInJ3Y3V0RmllbGRzIiwicndzdGF0c1ZhbHVlcyIsInJ3Y291bnRGaWVsZHMiLCJyd2NvdW50TG9hZFNjaGVtZXMiLCJ0dXBsZURpcmVjdGlvbnMiLCJhdmFpbGFibGVDaGFydFR5cGVzIiwiY2hhcnRGaWVsZFR5cGVzIiwic3RhcnREYXRlT2Zmc2V0cyIsInRvU3RyaW5nIiwicGFyc2VSZXN1bHQiLCJyZXN1bHQiLCJpIiwibGVuIiwicmVmIiwicm93Iiwicm93cyIsInNwbGl0IiwibGVuZ3RoIiwicHVzaCIsInF1ZXJ5VHlwZXMiLCJpbnB1dEZpZWxkcyIsImZpbHRlck9wdGlvbnMiLCJvcHRpb25zIiwiYWRkaXRpb25hbFBlcm1pdHRlZENoYXJhY3RlcnMiLCJleGNsdWRlZE9wdGlvbiIsImZpbHRlciIsInJlZ2V4cCIsIlJlZ0V4cCIsInJlcGxhY2UiLCJpc0RlYnVnIiwic2V0dGluZ3MiLCJwdWJsaWMiLCJ3aW5kb3ciLCJnbG9iYWwiLCJjb25zb2xlIiwibG9nIiwiXyIsImlzRnVuY3Rpb24iLCJjbCIsImJpbmQiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBLElBQUFBLE1BQUEsRUFBQUMsS0FBQTtBQUFBQSxLQUFBLEdBQVFBLEtBQUEsSUFBUyxFQUFqQixDLENBSUE7QUFDQTtBQUNBO0FBQ0E7O0FBQUFBLEtBQUssQ0FBQ0MsSUFBTixHQUFhLFVBQUNDLE1BQUQsRUFBU0MsTUFBQSxHQUFTQyxNQUFNLENBQUNELE1BQVAsRUFBbEI7QUFFWCxTQURBQyxNQUFNLENBQUNDLEtBQVAsQ0FBYUMsT0FBYixDQUFxQkgsTUFBckIsRUFBNkI7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Q0EsT0FBTyxDQUFDQyxHQUExQyxJQUFpREMsQ0FBQyxDQUFDQyxVQUFGLENBQWFILE9BQU8sQ0FBQ0MsR0FBckIsQ0FBcEQ7QUFDRWpELFFBQU0sQ0FBQ29ELEVBQVAsR0FBWUYsQ0FBQyxDQUFDRyxJQUFGLENBQU9MLE9BQU8sQ0FBQ0MsR0FBZixFQUFvQkQsT0FBcEIsQ0FBWjtBQURGO0FBR0VoRCxRQUFNLENBQUNvRCxFQUFQLEdBQVksY0FBWjtBQWpFRCxDIiwiZmlsZSI6Ii9saWIvYXBwLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlID0gc2hhcmUgb3Ige31cblxuI3NoYXJlLmNvbWJpbmUgPSAoZnVuY3MuLi4pIC0+XG4jICAoYXJncy4uLikgPT5cbiMgICAgZm9yIGZ1bmMgaW4gZnVuY3NcbiMgICAgICBmdW5jLmFwcGx5KEAsIGFyZ3MpXG5cbnNoYXJlLnVzZXIgPSAoZmllbGRzLCB1c2VySWQgPSBNZXRlb3IudXNlcklkKCkpIC0+XG4gIE1ldGVvci51c2Vycy5maW5kT25lKHVzZXJJZCwge2ZpZWxkczogZmllbGRzfSlcblxuc2hhcmUuaW50dmFsID0gKHZhbHVlKSAtPlxuICBwYXJzZUludCh2YWx1ZSwgMTApIHx8IDBcblxuc2hhcmUubWludXRlID0gNjAgKiAxMDAwXG5zaGFyZS5ob3VyID0gNjAgKiBzaGFyZS5taW51dGVcblxuc2hhcmUuZGF0ZXRpbWVGb3JtYXQgPSBcIllZWVkvTU0vREQgSEg6bW06c3MuU1NTXCJcbnNoYXJlLnJ3Y3V0RmllbGRzID0gW1xuICBcInNJUFwiXG4gIFwiZElQXCJcbiAgXCJzUG9ydFwiXG4gIFwiZFBvcnRcIlxuICBcInByb3RvY29sXCJcbiAgXCJwYWNrZXRzXCJcbiAgXCJieXRlc1wiXG4gIFwiZmxhZ3NcIlxuICBcInNUaW1lXCJcbiAgXCJkdXJhdGlvblwiXG4gIFwiZVRpbWVcIlxuICBcInNlbnNvclwiXG4gIFwiY2xhc3NcIlxuICBcInNjY1wiXG4gIFwiZGNjXCJcbiAgXCJpbml0aWFsRmxhZ3NcIlxuICBcInNlc3Npb25GbGFnc1wiXG4gIFwiYXBwbGljYXRpb25cIlxuICBcInR5cGVcIlxuICBcImljbXBUeXBlQ29kZVwiXG5dXG5zaGFyZS5yd3N0YXRzVmFsdWVzID0gW1xuICBcIlJlY29yZHNcIlxuICBcIlBhY2tldHNcIlxuICBcIkJ5dGVzXCJcbl1cbnNoYXJlLnJ3Y291bnRGaWVsZHMgPSBbXG4gIFwiRGF0ZVwiXG4gIFwiUmVjb3Jkc1wiXG4gIFwiQnl0ZXNcIlxuICBcIlBhY2tldHNcIlxuXVxuc2hhcmUucndjb3VudExvYWRTY2hlbWVzID0gW1xuICBcIlwiXG4gIFwiYmluLXVuaWZvcm1cIlxuICBcInN0YXJ0LXNwaWtlXCJcbiAgXCJlbmQtc3Bpa2VcIlxuICBcIm1pZGRsZS1zcGlrZVwiXG4gIFwidGltZS1wcm9wb3J0aW9uYWxcIlxuICBcIm1heGltdW0tdm9sdW1lXCJcbiAgXCJtaW5pbXVtLXZvbHVtZVwiXG5dXG5zaGFyZS50dXBsZURpcmVjdGlvbnMgPSBbXG4gIFwiXCJcbiAgXCJib3RoXCJcbiAgXCJmb3J3YXJkXCJcbiAgXCJyZXZlcnNlXCJcbl1cbnNoYXJlLmF2YWlsYWJsZUNoYXJ0VHlwZXMgPVxuICBcInJ3Y3V0XCI6IFtdXG4gIFwicndzdGF0c1wiOiBbXCJCYXJDaGFydFwiLCBcIkNvbHVtbkNoYXJ0XCIsICBcIlBpZUNoYXJ0XCJdXG4gIFwicndjb3VudFwiOiBbXCJMaW5lQ2hhcnRcIl1cbnNoYXJlLmNoYXJ0RmllbGRUeXBlcyA9XG4gIFwic1BvcnRcIjogXCJudW1iZXJcIlxuICBcImRQb3J0XCI6IFwibnVtYmVyXCJcbiAgXCJwcm90b2NvbFwiOiBcIm51bWJlclwiXG4gIFwicHJvXCI6IFwibnVtYmVyXCJcbiAgXCJwYWNrZXRzXCI6IFwibnVtYmVyXCJcbiAgXCJieXRlc1wiOiBcIm51bWJlclwiXG4gIFwic1RpbWVcIjogXCJkYXRldGltZVwiXG4gIFwiZHVyYXRpb25cIjogXCJudW1iZXJcIlxuICBcImR1clwiOiBcIm51bWJlclwiXG4gIFwiZVRpbWVcIjogXCJkYXRldGltZVwiXG4gIFwiUmVjb3Jkc1wiOiBcIm51bWJlclwiXG4gIFwiUGFja2V0c1wiOiBcIm51bWJlclwiXG4gIFwiQnl0ZXNcIjogXCJudW1iZXJcIlxuICBcIkRhdGVcIjogXCJkYXRldGltZVwiXG4gIFwiY3VtdWxfJVwiOiBcIm51bWJlclwiXG5zaGFyZS5zdGFydERhdGVPZmZzZXRzID1cbiAgXCJIb3VyXCI6ICg2MCkudG9TdHJpbmcoKVxuICBcIkRheVwiOiAoMjQgKiA2MCkudG9TdHJpbmcoKVxuICBcIldlZWtcIjogKDcgKiAyNCAqIDYwKS50b1N0cmluZygpXG4gIFwiTW9udGhcIjogKDMwICogMjQgKiA2MCkudG9TdHJpbmcoKVxuXG5zaGFyZS5wYXJzZVJlc3VsdCA9IChyZXN1bHQpIC0+XG4gIHJvd3MgPSBbXVxuICBmb3Igcm93IGluIHJlc3VsdC5zcGxpdChcIlxcblwiKVxuICAgIHJvd3MucHVzaChyb3cuc3BsaXQoXCJ8XCIpKVxuICByb3dzXG5cbnNoYXJlLnF1ZXJ5VHlwZXMgPSBbXCJpblwiLCBcIm91dFwiLCBcImlud2ViXCIsIFwib3V0d2ViXCIsIFwiaW5pY21wXCIsIFwib3V0aWNtcFwiLCBcImlubnVsbFwiLCBcIm91dG51bGxcIiwgXCJpbnQyaW50XCIsIFwiZXh0MmV4dFwiLCBcIm90aGVyXCJdXG5zaGFyZS5pbnB1dEZpZWxkcyA9IFtcbiAgXCJpbnRlcmZhY2VcIlxuICBcImNtZFwiXG4gIFwiZXhjbHVzaW9uc0NtZFwiXG4gIFwic3RhcnREYXRlRW5hYmxlZFwiXG4gIFwic3RhcnREYXRlXCJcbiAgXCJlbmREYXRlRW5hYmxlZFwiXG4gIFwiZW5kRGF0ZVwiXG4gIFwic2Vuc29yRW5hYmxlZFwiXG4gIFwic2Vuc29yXCJcbiAgXCJ0eXBlc0VuYWJsZWRcIlxuICBcInR5cGVzXCJcbiAgXCJkYWRkcmVzc0VuYWJsZWRcIlxuICBcImRhZGRyZXNzXCJcbiAgXCJzYWRkcmVzc0VuYWJsZWRcIlxuICBcInNhZGRyZXNzXCJcbiAgXCJhbnlBZGRyZXNzRW5hYmxlZFwiXG4gIFwiYW55QWRkcmVzc1wiXG4gIFwiZGlwU2V0RW5hYmxlZFwiXG4gIFwiZGlwU2V0XCJcbiAgXCJzaXBTZXRFbmFibGVkXCJcbiAgXCJzaXBTZXRcIlxuICBcImFueVNldEVuYWJsZWRcIlxuICBcImFueVNldFwiXG4gIFwidHVwbGVGaWxlRW5hYmxlZFwiXG4gIFwidHVwbGVGaWxlXCJcbiAgXCJ0dXBsZURpcmVjdGlvbkVuYWJsZWRcIlxuICBcInR1cGxlRGlyZWN0aW9uXCJcbiAgXCJ0dXBsZURlbGltaXRlckVuYWJsZWRcIlxuICBcInR1cGxlRGVsaW1pdGVyXCJcbiAgXCJ0dXBsZUZpZWxkc0VuYWJsZWRcIlxuICBcInR1cGxlRmllbGRzXCJcbiAgXCJkcG9ydEVuYWJsZWRcIlxuICBcImRwb3J0XCJcbiAgXCJzcG9ydEVuYWJsZWRcIlxuICBcInNwb3J0XCJcbiAgXCJhcG9ydEVuYWJsZWRcIlxuICBcImFwb3J0XCJcbiAgXCJkY2NFbmFibGVkXCJcbiAgXCJkY2NcIlxuICBcInNjY0VuYWJsZWRcIlxuICBcInNjY1wiXG4gIFwicHJvdG9jb2xFbmFibGVkXCJcbiAgXCJwcm90b2NvbFwiXG4gIFwiZmxhZ3NBbGxFbmFibGVkXCJcbiAgXCJmbGFnc0FsbFwiXG4gIFwiYWN0aXZlVGltZUVuYWJsZWRcIlxuICBcImFjdGl2ZVRpbWVcIlxuICBcImFkZGl0aW9uYWxQYXJhbWV0ZXJzRW5hYmxlZFwiXG4gIFwiYWRkaXRpb25hbFBhcmFtZXRlcnNcIlxuICBcImFkZGl0aW9uYWxFeGNsdXNpb25zQ21kRW5hYmxlZFwiXG4gIFwiYWRkaXRpb25hbEV4Y2x1c2lvbnNDbWRcIlxuXVxuXG5zaGFyZS5maWx0ZXJPcHRpb25zID0gKG9wdGlvbnMsIGFkZGl0aW9uYWxQZXJtaXR0ZWRDaGFyYWN0ZXJzID0gXCJcIikgLT5cbiAgZm9yIGV4Y2x1ZGVkT3B0aW9uIGluIFtcIi0tcHl0aG9uLWV4cHJcIiwgXCItLXB5dGhvbi1maWxlXCIsIFwiLS1wbWFwXCIsIFwiLS1keW5hbWljLWxpYnJhcnlcIiwgXCItLWFsbC1kZXN0aW5hdGlvblwiLCBcIi0tZmFpbC1kZXN0aW5hdGlvblwiLCBcIi0tcGFzcy1kZXN0aW5hdGlvblwiLCBcIi0tcHJpbnQtc3RhdGlzdGljc1wiLCBcIi0tcHJpbnQtdm9sdW1lLXN0YXRpc3RpY3NcIiwgXCItLXhhcmdzXCJdXG4gICAgcmVnZXhwID0gbmV3IFJlZ0V4cChleGNsdWRlZE9wdGlvbiArIFwiPT9bXlxcXFxzXSpcIiwgXCJnaVwiKVxuICAgIG9wdGlvbnMgPSBvcHRpb25zLnJlcGxhY2UocmVnZXhwLCBcIlwiKVxuICBmaWx0ZXIgPSBuZXcgUmVnRXhwKFwiW15cXFxcc1xcXFw9XFxcXC1cXFxcL1xcXFwsXFxcXC5cXFxcOjAtOWEtel9cIiArIGFkZGl0aW9uYWxQZXJtaXR0ZWRDaGFyYWN0ZXJzICsgXCJdXCIsIFwiZ2lcIilcbiAgb3B0aW9ucyA9IG9wdGlvbnMucmVwbGFjZShmaWx0ZXIsIFwiXCIpXG4gIG9wdGlvbnNcblxuc2hhcmUuaXNEZWJ1ZyA9IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuaXNEZWJ1Z1xuXG5vYmplY3QgPSBpZiB0eXBlb2Yod2luZG93KSAhPSBcInVuZGVmaW5lZFwiIHRoZW4gd2luZG93IGVsc2UgZ2xvYmFsXG5vYmplY3QuaXNEZWJ1ZyA9IHNoYXJlLmlzRGVidWdcbmlmIHR5cGVvZihjb25zb2xlKSAhPSBcInVuZGVmaW5lZFwiICYmIGNvbnNvbGUubG9nICYmIF8uaXNGdW5jdGlvbihjb25zb2xlLmxvZylcbiAgb2JqZWN0LmNsID0gXy5iaW5kKGNvbnNvbGUubG9nLCBjb25zb2xlKVxuZWxzZVxuICBvYmplY3QuY2wgPSAtPlxuIl19

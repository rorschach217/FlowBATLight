(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/cron.coffee                                                  //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var emailIntervalId, setIntervals;

share.sendEmails = function () {
  if (share.sendEmailsRunning) {
    Meteor._debug("Send email already running; skipping");

    return;
  }

  share.sendEmailsRunning = true;

  try {
    return share.Emails.find().forEach(function (email) {
      if (!email.to.match(/@flowbat.com$/)) {
        //        if Meteor.settings.public.isDebug then Meteor._debug('Sending "'+email.subject+'" to "'+email.to+'"')
        Email.sendImmediate(email);
      }

      return share.Emails.remove(email._id);
    });
  } finally {
    share.sendEmailsRunning = false;
  }
};

emailIntervalId = null;

setIntervals = function () {
  var seconds;
  seconds = Meteor.settings.public.isDebug ? 5 : 60;
  return emailIntervalId = Meteor.setInterval(share.sendEmails, seconds * 1000);
};

Meteor.startup(function () {
  if (Meteor.settings.public.isDebug) {} else {
    //    setIntervals()
    return setIntervals();
  }
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/cron.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2Nyb24uY29mZmVlIl0sIm5hbWVzIjpbImVtYWlsSW50ZXJ2YWxJZCIsInNldEludGVydmFscyIsInNoYXJlIiwic2VuZEVtYWlscyIsInNlbmRFbWFpbHNSdW5uaW5nIiwiTWV0ZW9yIiwiX2RlYnVnIiwiRW1haWxzIiwiZmluZCIsImZvckVhY2giLCJlbWFpbCIsInRvIiwibWF0Y2giLCJFbWFpbCIsInNlbmRJbW1lZGlhdGUiLCJyZW1vdmUiLCJfaWQiLCJzZWNvbmRzIiwic2V0dGluZ3MiLCJwdWJsaWMiLCJpc0RlYnVnIiwic2V0SW50ZXJ2YWwiLCJzdGFydHVwIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQSxJQUFBQSxlQUFBLEVBQUFDLFlBQUE7O0FBQUFDLEtBQUssQ0FBQ0MsVUFBTixHQUFtQjtBQUNqQixNQUFHRCxLQUFLLENBQUNFLGlCQUFUO0FBQ0VDLFVBQU0sQ0FBQ0MsTUFBUCxDQUFjLHNDQUFkOztBQUNBO0FBR0Q7O0FBRkRKLE9BQUssQ0FBQ0UsaUJBQU4sR0FBMEIsSUFBMUI7O0FBQ0E7QUFJRSxXQUhBRixLQUFLLENBQUNLLE1BQU4sQ0FBYUMsSUFBYixHQUFvQkMsT0FBcEIsQ0FBNEIsVUFBQ0MsS0FBRDtBQUMxQixVQUFHLENBQUNBLEtBQUssQ0FBQ0MsRUFBTixDQUFTQyxLQUFULENBQWUsZUFBZixDQUFKO0FBSUU7QUFGQUMsYUFBSyxDQUFDQyxhQUFOLENBQW9CSixLQUFwQjtBQUlEOztBQUNELGFBSkFSLEtBQUssQ0FBQ0ssTUFBTixDQUFhUSxNQUFiLENBQW9CTCxLQUFLLENBQUNNLEdBQTFCLENBSUE7QUFSRixNQUdBO0FBSkY7QUFPRWQsU0FBSyxDQUFDRSxpQkFBTixHQUEwQixLQUExQjtBQU1EO0FBbEJnQixDQUFuQjs7QUFjQUosZUFBQSxHQUFrQixJQUFsQjs7QUFDQUMsWUFBQSxHQUFlO0FBQ2IsTUFBQWdCLE9BQUE7QUFBQUEsU0FBQSxHQUFhWixNQUFNLENBQUNhLFFBQVAsQ0FBZ0JDLE1BQWhCLENBQXVCQyxPQUF2QixHQUFvQyxDQUFwQyxHQUEyQyxFQUF4RDtBQVVBLFNBVEFwQixlQUFBLEdBQWtCSyxNQUFNLENBQUNnQixXQUFQLENBQW1CbkIsS0FBSyxDQUFDQyxVQUF6QixFQUFxQ2MsT0FBQSxHQUFVLElBQS9DLENBU2xCO0FBWGEsQ0FBZjs7QUFJQVosTUFBTSxDQUFDaUIsT0FBUCxDQUFlO0FBQ2IsTUFBR2pCLE1BQU0sQ0FBQ2EsUUFBUCxDQUFnQkMsTUFBaEIsQ0FBdUJDLE9BQTFCO0FBYUU7QUFDQSxXQVhBbkIsWUFBQSxFQVdBO0FBQ0Q7QUFoQkgsRyIsImZpbGUiOiIvc2VydmVyL2Nyb24uY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsic2hhcmUuc2VuZEVtYWlscyA9IC0+XG4gIGlmIHNoYXJlLnNlbmRFbWFpbHNSdW5uaW5nXG4gICAgTWV0ZW9yLl9kZWJ1ZyhcIlNlbmQgZW1haWwgYWxyZWFkeSBydW5uaW5nOyBza2lwcGluZ1wiKVxuICAgIHJldHVyblxuICBzaGFyZS5zZW5kRW1haWxzUnVubmluZyA9IHRydWVcbiAgdHJ5XG4gICAgc2hhcmUuRW1haWxzLmZpbmQoKS5mb3JFYWNoIChlbWFpbCkgLT5cbiAgICAgIGlmICFlbWFpbC50by5tYXRjaCgvQGZsb3diYXQuY29tJC8pXG4jICAgICAgICBpZiBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmlzRGVidWcgdGhlbiBNZXRlb3IuX2RlYnVnKCdTZW5kaW5nIFwiJytlbWFpbC5zdWJqZWN0KydcIiB0byBcIicrZW1haWwudG8rJ1wiJylcbiAgICAgICAgRW1haWwuc2VuZEltbWVkaWF0ZShlbWFpbClcbiAgICAgIHNoYXJlLkVtYWlscy5yZW1vdmUoZW1haWwuX2lkKVxuICBmaW5hbGx5XG4gICAgc2hhcmUuc2VuZEVtYWlsc1J1bm5pbmcgPSBmYWxzZVxuXG5lbWFpbEludGVydmFsSWQgPSBudWxsXG5zZXRJbnRlcnZhbHMgPSAtPlxuICBzZWNvbmRzID0gaWYgTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5pc0RlYnVnIHRoZW4gNSBlbHNlIDYwXG4gIGVtYWlsSW50ZXJ2YWxJZCA9IE1ldGVvci5zZXRJbnRlcnZhbChzaGFyZS5zZW5kRW1haWxzLCBzZWNvbmRzICogMTAwMClcblxuTWV0ZW9yLnN0YXJ0dXAgLT5cbiAgaWYgTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5pc0RlYnVnXG4jICAgIHNldEludGVydmFscygpXG4gIGVsc2VcbiAgICBzZXRJbnRlcnZhbHMoKVxuXG4iXX0=

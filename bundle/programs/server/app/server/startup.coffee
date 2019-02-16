(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/startup.coffee                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
process.env.MAIL_URL = Meteor.settings.mailUrl; //share.twilio = if Meteor.settings.twilio.sid then Twilio(Meteor.settings.twilio.sid, Meteor.settings.twilio.token) else null

Email.sendImmediate = Email.send;

Email.send = function (options) {
  share.Emails.insert(options);

  if (Meteor.settings.public.isDebug) {
    return Meteor.setTimeout(function () {
      return share.sendEmails();
    }, 1000);
  }
};

Accounts.emailTemplates.from = "Postman (FlowBAT) <postman@flowbat.com>";

Accounts.emailTemplates.resetPassword.subject = function (user) {
  return Handlebars.templates["resetPasswordSubject"]({
    user: user,
    settings: Meteor.settings
  }).trim();
};

Accounts.emailTemplates.resetPassword.text = function (user, url) {};

Accounts.emailTemplates.resetPassword.html = function (user, url) {
  return Handlebars.templates["resetPasswordHtml"]({
    user: user,
    url: url,
    settings: Meteor.settings
  }).trim();
};

Meteor.startup(function () {
  Meteor.users._ensureIndex({
    friendUserIds: 1
  }, {
    background: true
  });

  share.loadFixtures();

  if (Meteor.settings.public.isDebug) {
    Meteor.setInterval(share.loadFixtures, 300);
    Meteor.setInterval(share.cleanupQuickQueries, 500);
    Meteor.setInterval(share.cleanupCachedQueryResults, 500);
  } else {
    Meteor.setInterval(share.cleanupQuickQueries, 60 * 60 * 1000);
    Meteor.setInterval(share.cleanupCachedQueryResults, 60 * 60 * 1000);
  }

  return share.periodicExecution.execute();
}); //    Apm.connect(Meteor.settings.apm.appId, Meteor.settings.apm.secret)
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/startup.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3N0YXJ0dXAuY29mZmVlIl0sIm5hbWVzIjpbInByb2Nlc3MiLCJlbnYiLCJNQUlMX1VSTCIsIk1ldGVvciIsInNldHRpbmdzIiwibWFpbFVybCIsIkVtYWlsIiwic2VuZEltbWVkaWF0ZSIsInNlbmQiLCJvcHRpb25zIiwic2hhcmUiLCJFbWFpbHMiLCJpbnNlcnQiLCJwdWJsaWMiLCJpc0RlYnVnIiwic2V0VGltZW91dCIsInNlbmRFbWFpbHMiLCJBY2NvdW50cyIsImVtYWlsVGVtcGxhdGVzIiwiZnJvbSIsInJlc2V0UGFzc3dvcmQiLCJzdWJqZWN0IiwidXNlciIsIkhhbmRsZWJhcnMiLCJ0ZW1wbGF0ZXMiLCJ0cmltIiwidGV4dCIsInVybCIsImh0bWwiLCJzdGFydHVwIiwidXNlcnMiLCJfZW5zdXJlSW5kZXgiLCJmcmllbmRVc2VySWRzIiwiYmFja2dyb3VuZCIsImxvYWRGaXh0dXJlcyIsInNldEludGVydmFsIiwiY2xlYW51cFF1aWNrUXVlcmllcyIsImNsZWFudXBDYWNoZWRRdWVyeVJlc3VsdHMiLCJwZXJpb2RpY0V4ZWN1dGlvbiIsImV4ZWN1dGUiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBQSxPQUFPLENBQUNDLEdBQVIsQ0FBWUMsUUFBWixHQUF1QkMsTUFBTSxDQUFDQyxRQUFQLENBQWdCQyxPQUF2QyxDLENBRUE7O0FBQ0FDLEtBQUssQ0FBQ0MsYUFBTixHQUFzQkQsS0FBSyxDQUFDRSxJQUE1Qjs7QUFDQUYsS0FBSyxDQUFDRSxJQUFOLEdBQWEsVUFBQ0MsT0FBRDtBQUNYQyxPQUFLLENBQUNDLE1BQU4sQ0FBYUMsTUFBYixDQUFvQkgsT0FBcEI7O0FBQ0EsTUFBR04sTUFBTSxDQUFDQyxRQUFQLENBQWdCUyxNQUFoQixDQUF1QkMsT0FBMUI7QUFFRSxXQURBWCxNQUFNLENBQUNZLFVBQVAsQ0FBa0I7QUFFaEIsYUFEQUwsS0FBSyxDQUFDTSxVQUFOLEVBQ0E7QUFGRixPQUVFLElBRkYsQ0FDQTtBQUdEO0FBUFUsQ0FBYjs7QUFPQUMsUUFBUSxDQUFDQyxjQUFULENBQXdCQyxJQUF4QixHQUErQix5Q0FBL0I7O0FBQ0FGLFFBQVEsQ0FBQ0MsY0FBVCxDQUF3QkUsYUFBeEIsQ0FBc0NDLE9BQXRDLEdBQWdELFVBQUNDLElBQUQ7QUFLOUMsU0FKQUMsVUFBVSxDQUFDQyxTQUFYLENBQXFCLHNCQUFyQixFQUE2QztBQUFBRixRQUFBLEVBQU1BLElBQU47QUFBWWxCLFlBQUEsRUFBVUQsTUFBTSxDQUFDQztBQUE3QixHQUE3QyxFQUFvRnFCLElBQXBGLEVBSUE7QUFMOEMsQ0FBaEQ7O0FBRUFSLFFBQVEsQ0FBQ0MsY0FBVCxDQUF3QkUsYUFBeEIsQ0FBc0NNLElBQXRDLEdBQTZDLFVBQUNKLElBQUQsRUFBT0ssR0FBUCxJQUE3Qzs7QUFDQVYsUUFBUSxDQUFDQyxjQUFULENBQXdCRSxhQUF4QixDQUFzQ1EsSUFBdEMsR0FBNkMsVUFBQ04sSUFBRCxFQUFPSyxHQUFQO0FBVzNDLFNBVkFKLFVBQVUsQ0FBQ0MsU0FBWCxDQUFxQixtQkFBckIsRUFBMEM7QUFBQUYsUUFBQSxFQUFNQSxJQUFOO0FBQVlLLE9BQUEsRUFBS0EsR0FBakI7QUFBc0J2QixZQUFBLEVBQVVELE1BQU0sQ0FBQ0M7QUFBdkMsR0FBMUMsRUFBMkZxQixJQUEzRixFQVVBO0FBWDJDLENBQTdDOztBQUdBdEIsTUFBTSxDQUFDMEIsT0FBUCxDQUFlO0FBQ2IxQixRQUFNLENBQUMyQixLQUFQLENBQWFDLFlBQWIsQ0FBMEI7QUFBQ0MsaUJBQUEsRUFBZTtBQUFoQixHQUExQixFQUE4QztBQUFDQyxjQUFBLEVBQVk7QUFBYixHQUE5Qzs7QUFDQXZCLE9BQUssQ0FBQ3dCLFlBQU47O0FBQ0EsTUFBRy9CLE1BQU0sQ0FBQ0MsUUFBUCxDQUFnQlMsTUFBaEIsQ0FBdUJDLE9BQTFCO0FBQ0VYLFVBQU0sQ0FBQ2dDLFdBQVAsQ0FBbUJ6QixLQUFLLENBQUN3QixZQUF6QixFQUF1QyxHQUF2QztBQUNBL0IsVUFBTSxDQUFDZ0MsV0FBUCxDQUFtQnpCLEtBQUssQ0FBQzBCLG1CQUF6QixFQUE4QyxHQUE5QztBQUNBakMsVUFBTSxDQUFDZ0MsV0FBUCxDQUFtQnpCLEtBQUssQ0FBQzJCLHlCQUF6QixFQUFvRCxHQUFwRDtBQUhGO0FBS0VsQyxVQUFNLENBQUNnQyxXQUFQLENBQW1CekIsS0FBSyxDQUFDMEIsbUJBQXpCLEVBQThDLEtBQUssRUFBTCxHQUFVLElBQXhEO0FBQ0FqQyxVQUFNLENBQUNnQyxXQUFQLENBQW1CekIsS0FBSyxDQUFDMkIseUJBQXpCLEVBQW9ELEtBQUssRUFBTCxHQUFVLElBQTlEO0FBb0JEOztBQUNELFNBcEJBM0IsS0FBSyxDQUFDNEIsaUJBQU4sQ0FBd0JDLE9BQXhCLEVBb0JBO0FBOUJGLEcsQ0FsQkEsd0UiLCJmaWxlIjoiL3NlcnZlci9zdGFydHVwLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInByb2Nlc3MuZW52Lk1BSUxfVVJMID0gTWV0ZW9yLnNldHRpbmdzLm1haWxVcmxcbiNzaGFyZS50d2lsaW8gPSBpZiBNZXRlb3Iuc2V0dGluZ3MudHdpbGlvLnNpZCB0aGVuIFR3aWxpbyhNZXRlb3Iuc2V0dGluZ3MudHdpbGlvLnNpZCwgTWV0ZW9yLnNldHRpbmdzLnR3aWxpby50b2tlbikgZWxzZSBudWxsXG5cbkVtYWlsLnNlbmRJbW1lZGlhdGUgPSBFbWFpbC5zZW5kXG5FbWFpbC5zZW5kID0gKG9wdGlvbnMpIC0+XG4gIHNoYXJlLkVtYWlscy5pbnNlcnQob3B0aW9ucylcbiAgaWYgTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5pc0RlYnVnXG4gICAgTWV0ZW9yLnNldFRpbWVvdXQoLT5cbiAgICAgIHNoYXJlLnNlbmRFbWFpbHMoKVxuICAgICwgMTAwMClcblxuQWNjb3VudHMuZW1haWxUZW1wbGF0ZXMuZnJvbSA9IFwiUG9zdG1hbiAoRmxvd0JBVCkgPHBvc3RtYW5AZmxvd2JhdC5jb20+XCJcbkFjY291bnRzLmVtYWlsVGVtcGxhdGVzLnJlc2V0UGFzc3dvcmQuc3ViamVjdCA9ICh1c2VyKSAtPlxuICBIYW5kbGViYXJzLnRlbXBsYXRlc1tcInJlc2V0UGFzc3dvcmRTdWJqZWN0XCJdKHVzZXI6IHVzZXIsIHNldHRpbmdzOiBNZXRlb3Iuc2V0dGluZ3MpLnRyaW0oKVxuQWNjb3VudHMuZW1haWxUZW1wbGF0ZXMucmVzZXRQYXNzd29yZC50ZXh0ID0gKHVzZXIsIHVybCkgLT5cbkFjY291bnRzLmVtYWlsVGVtcGxhdGVzLnJlc2V0UGFzc3dvcmQuaHRtbCA9ICh1c2VyLCB1cmwpIC0+XG4gIEhhbmRsZWJhcnMudGVtcGxhdGVzW1wicmVzZXRQYXNzd29yZEh0bWxcIl0odXNlcjogdXNlciwgdXJsOiB1cmwsIHNldHRpbmdzOiBNZXRlb3Iuc2V0dGluZ3MpLnRyaW0oKVxuXG5NZXRlb3Iuc3RhcnR1cCAtPlxuICBNZXRlb3IudXNlcnMuX2Vuc3VyZUluZGV4KHtmcmllbmRVc2VySWRzOiAxfSwge2JhY2tncm91bmQ6IHRydWV9KVxuICBzaGFyZS5sb2FkRml4dHVyZXMoKVxuICBpZiBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmlzRGVidWdcbiAgICBNZXRlb3Iuc2V0SW50ZXJ2YWwoc2hhcmUubG9hZEZpeHR1cmVzLCAzMDApXG4gICAgTWV0ZW9yLnNldEludGVydmFsKHNoYXJlLmNsZWFudXBRdWlja1F1ZXJpZXMsIDUwMClcbiAgICBNZXRlb3Iuc2V0SW50ZXJ2YWwoc2hhcmUuY2xlYW51cENhY2hlZFF1ZXJ5UmVzdWx0cywgNTAwKVxuICBlbHNlXG4gICAgTWV0ZW9yLnNldEludGVydmFsKHNoYXJlLmNsZWFudXBRdWlja1F1ZXJpZXMsIDYwICogNjAgKiAxMDAwKVxuICAgIE1ldGVvci5zZXRJbnRlcnZhbChzaGFyZS5jbGVhbnVwQ2FjaGVkUXVlcnlSZXN1bHRzLCA2MCAqIDYwICogMTAwMClcbiAgc2hhcmUucGVyaW9kaWNFeGVjdXRpb24uZXhlY3V0ZSgpXG4jICAgIEFwbS5jb25uZWN0KE1ldGVvci5zZXR0aW5ncy5hcG0uYXBwSWQsIE1ldGVvci5zZXR0aW5ncy5hcG0uc2VjcmV0KVxuIl19

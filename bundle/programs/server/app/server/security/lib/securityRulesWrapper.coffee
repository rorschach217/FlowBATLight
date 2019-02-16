(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/security/lib/securityRulesWrapper.coffee                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.securityRulesWrapper = function (func) {
  return function () {
    var exception, user;
    user = Meteor.user();

    if (user) {
      root.i18n.setLng(user.profile.locale);
      moment.lang(user.profile.locale);
    }

    try {
      return func.apply(this, arguments);
    } catch (error) {
      exception = error;

      Meteor._debug(exception);

      Meteor._debug(arguments);

      throw exception;
    }
  };
};
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/security/lib/securityRulesWrapper.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL3NlY3VyaXR5L2xpYi9zZWN1cml0eVJ1bGVzV3JhcHBlci5jb2ZmZWUiXSwibmFtZXMiOlsic2hhcmUiLCJzZWN1cml0eVJ1bGVzV3JhcHBlciIsImZ1bmMiLCJleGNlcHRpb24iLCJ1c2VyIiwiTWV0ZW9yIiwicm9vdCIsImkxOG4iLCJzZXRMbmciLCJwcm9maWxlIiwibG9jYWxlIiwibW9tZW50IiwibGFuZyIsImFwcGx5IiwiYXJndW1lbnRzIiwiZXJyb3IiLCJfZGVidWciXSwibWFwcGluZ3MiOiI7Ozs7Ozs7OztBQUFBQSxLQUFLLENBQUNDLG9CQUFOLEdBQTZCLFVBQUNDLElBQUQ7QUFDM0IsU0FBTztBQUNMLFFBQUFDLFNBQUEsRUFBQUMsSUFBQTtBQUFBQSxRQUFBLEdBQU9DLE1BQU0sQ0FBQ0QsSUFBUCxFQUFQOztBQUNBLFFBQUdBLElBQUg7QUFDRUUsVUFBSSxDQUFDQyxJQUFMLENBQVVDLE1BQVYsQ0FBaUJKLElBQUksQ0FBQ0ssT0FBTCxDQUFhQyxNQUE5QjtBQUNBQyxZQUFNLENBQUNDLElBQVAsQ0FBWVIsSUFBSSxDQUFDSyxPQUFMLENBQWFDLE1BQXpCO0FBRUQ7O0FBREQ7QUFDRSxhQUFPUixJQUFJLENBQUNXLEtBQUwsQ0FBVyxJQUFYLEVBQWNDLFNBQWQsQ0FBUDtBQURGLGFBQUFDLEtBQUE7QUFFTVosZUFBQSxHQUFBWSxLQUFBOztBQUNKVixZQUFNLENBQUNXLE1BQVAsQ0FBY2IsU0FBZDs7QUFDQUUsWUFBTSxDQUFDVyxNQUFQLENBQWNGLFNBQWQ7O0FBQ0EsWUFBTVgsU0FBTjtBQUlEO0FBZEksR0FBUDtBQUQyQixDQUE3QixDIiwiZmlsZSI6Ii9zZXJ2ZXIvc2VjdXJpdHkvbGliL3NlY3VyaXR5UnVsZXNXcmFwcGVyLmNvZmZlZSIsInNvdXJjZXNDb250ZW50IjpbInNoYXJlLnNlY3VyaXR5UnVsZXNXcmFwcGVyID0gKGZ1bmMpIC0+XG4gIHJldHVybiAtPlxuICAgIHVzZXIgPSBNZXRlb3IudXNlcigpXG4gICAgaWYgdXNlclxuICAgICAgcm9vdC5pMThuLnNldExuZyh1c2VyLnByb2ZpbGUubG9jYWxlKVxuICAgICAgbW9tZW50LmxhbmcodXNlci5wcm9maWxlLmxvY2FsZSlcbiAgICB0cnlcbiAgICAgIHJldHVybiBmdW5jLmFwcGx5KEAsIGFyZ3VtZW50cylcbiAgICBjYXRjaCBleGNlcHRpb25cbiAgICAgIE1ldGVvci5fZGVidWcoZXhjZXB0aW9uKVxuICAgICAgTWV0ZW9yLl9kZWJ1Zyhhcmd1bWVudHMpXG4gICAgICB0aHJvdyBleGNlcHRpb25cbiJdfQ==

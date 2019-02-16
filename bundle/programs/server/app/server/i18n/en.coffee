(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// server/i18n/en.coffee                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
i18n.addResourceBundle("en", {
  name: "English",
  dateFormat: "MMMM D, YYYY, h:mm A",
  messages: {
    resetPassword: {
      subject: 'Reset your password on flowbat.com',
      html: '<div>Hey {{user.profile.name}},</div> <div style="margin: 7px 0 0 0;">To reset your password, simply click the link below. Thanks.</div> <div style="margin: 7px 0 0 0;"><a href="{{url}}">{{url}}</a></div>'
    },
    newUser: {
      subject: 'You have been registered on flowbat.com',
      html: '<div>Hey {{user.profile.name}},</div> <div style="margin: 7px 0 0 0;">You have been registered on <a href="{{settings.baseUrl}}">flowbat.com</a></div> <div style="margin: 7px 0 0 0;">Your login: {{email}}</div> <div style="margin: 7px 0 0 0;">Your password: {{password}}</div>'
    },
    postman: "Postman"
  }
});
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/server/i18n/en.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvc2VydmVyL2kxOG4vZW4uY29mZmVlIl0sIm5hbWVzIjpbImkxOG4iLCJhZGRSZXNvdXJjZUJ1bmRsZSIsIm5hbWUiLCJkYXRlRm9ybWF0IiwibWVzc2FnZXMiLCJyZXNldFBhc3N3b3JkIiwic3ViamVjdCIsImh0bWwiLCJuZXdVc2VyIiwicG9zdG1hbiJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0FBQUFBLElBQUksQ0FBQ0MsaUJBQUwsQ0FBdUIsSUFBdkIsRUFDRTtBQUFBQyxNQUFBLEVBQU0sU0FBTjtBQUNBQyxZQUFBLEVBQVksc0JBRFo7QUFFQUMsVUFBQSxFQUNFO0FBQUFDLGlCQUFBLEVBQ0U7QUFBQUMsYUFBQSxFQUFTLG9DQUFUO0FBQ0FDLFVBQUEsRUFBTTtBQUROLEtBREY7QUFPQUMsV0FBQSxFQUNFO0FBQUFGLGFBQUEsRUFBUyx5Q0FBVDtBQUNBQyxVQUFBLEVBQU07QUFETixLQVJGO0FBZUFFLFdBQUEsRUFBUztBQWZUO0FBSEYsQ0FERixFIiwiZmlsZSI6Ii9zZXJ2ZXIvaTE4bi9lbi5jb2ZmZWUiLCJzb3VyY2VzQ29udGVudCI6WyJpMThuLmFkZFJlc291cmNlQnVuZGxlIFwiZW5cIixcbiAgbmFtZTogXCJFbmdsaXNoXCJcbiAgZGF0ZUZvcm1hdDogXCJNTU1NIEQsIFlZWVksIGg6bW0gQVwiXG4gIG1lc3NhZ2VzOlxuICAgIHJlc2V0UGFzc3dvcmQ6XG4gICAgICBzdWJqZWN0OiAnUmVzZXQgeW91ciBwYXNzd29yZCBvbiBmbG93YmF0LmNvbSdcbiAgICAgIGh0bWw6ICdcbiAgICAgICAgPGRpdj5IZXkge3t1c2VyLnByb2ZpbGUubmFtZX19LDwvZGl2PlxuICAgICAgICA8ZGl2IHN0eWxlPVwibWFyZ2luOiA3cHggMCAwIDA7XCI+VG8gcmVzZXQgeW91ciBwYXNzd29yZCwgc2ltcGx5IGNsaWNrIHRoZSBsaW5rIGJlbG93LiBUaGFua3MuPC9kaXY+XG4gICAgICAgIDxkaXYgc3R5bGU9XCJtYXJnaW46IDdweCAwIDAgMDtcIj48YSBocmVmPVwie3t1cmx9fVwiPnt7dXJsfX08L2E+PC9kaXY+XG4gICAgICAnXG4gICAgbmV3VXNlcjpcbiAgICAgIHN1YmplY3Q6ICdZb3UgaGF2ZSBiZWVuIHJlZ2lzdGVyZWQgb24gZmxvd2JhdC5jb20nXG4gICAgICBodG1sOiAnXG4gICAgICAgIDxkaXY+SGV5IHt7dXNlci5wcm9maWxlLm5hbWV9fSw8L2Rpdj5cbiAgICAgICAgPGRpdiBzdHlsZT1cIm1hcmdpbjogN3B4IDAgMCAwO1wiPllvdSBoYXZlIGJlZW4gcmVnaXN0ZXJlZCBvbiA8YSBocmVmPVwie3tzZXR0aW5ncy5iYXNlVXJsfX1cIj5mbG93YmF0LmNvbTwvYT48L2Rpdj5cbiAgICAgICAgPGRpdiBzdHlsZT1cIm1hcmdpbjogN3B4IDAgMCAwO1wiPllvdXIgbG9naW46IHt7ZW1haWx9fTwvZGl2PlxuICAgICAgICA8ZGl2IHN0eWxlPVwibWFyZ2luOiA3cHggMCAwIDA7XCI+WW91ciBwYXNzd29yZDoge3twYXNzd29yZH19PC9kaXY+XG4gICAgICAnXG4gICAgcG9zdG1hbjogXCJQb3N0bWFuXCJcbiJdfQ==

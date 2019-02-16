(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// lib/regexps.coffee                                                  //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.linkRegExp = new RegExp([// The groups
'(', // 1. Character before the link
'\\s|[^a-zA-Z0-9.\\+_\\/"\\>\\-]|^', ')(?:', // Main group
'(', // 2. Email address (optional)
'[a-zA-Z0-9\\+_\\-]+', '(?:', '\\.[a-zA-Z0-9\\+_\\-]+', ')*@', ')?(', // 3. Protocol (optional)
'http:\\/\\/|https:\\/\\/|ftp:\\/\\/', ')?(?:(', // 4. Domain & Subdomains
'(?:(?:[a-z0-9_%\\-_+]*[a-z][a-z0-9_%\\-_+]*[.:])+)', ')(', // 5. Top-level domain - http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
'(?:com|ca|co|edu|gov|net|org|dev|biz|cat|int|pro|tel|mil|aero|asia|coop|info|jobs|mobi|museum|name|post|travel|local|[0-9]{2,}|[a-z]{2})', ')|file:\\/\\/)(', // 6. Query string (optional)
'(?:', '[\\/|\\?]', '(?:', '[\\-a-zA-Z0-9_%#*&+=~!?,;:.\\/]*', ')*', ')', '[\\-\\/a-zA-Z0-9_%#*&+=~]', '|', '\\/?', ')?', ')(', // 7. Character after the link
'[^a-zA-Z0-9\\+_\\/"\\<\\-]|$', ')'].join(''), 'mg');
share.emailLinkRegExp = /(<[a-z]+ href=\")(http:\/\/)([a-zA-Z0-9\+_\-]+(?:\.[a-zA-Z0-9\+_\-]+)*@)/g;
share.emailRegex = /^[^@]+@[^@]+$/gi;

share.createTextSearchRegexp = function (text, bounds = false) {
  text = share.escapeRegexp(text);

  if (bounds) {
    if (bounds === "left") {
      text = "^" + text;
    } else if (bounds === "right") {
      text = text + "$";
    } else {
      text = "^" + text + "$";
    }
  }

  return new RegExp(text, "i");
};

share.escapeRegexp = function (text) {
  return text.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1");
};
/////////////////////////////////////////////////////////////////////////

}).call(this);

//# sourceURL=meteor://💻app/app/lib/regexps.coffee
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvbGliL3JlZ2V4cHMuY29mZmVlIl0sIm5hbWVzIjpbInNoYXJlIiwibGlua1JlZ0V4cCIsIlJlZ0V4cCIsImpvaW4iLCJlbWFpbExpbmtSZWdFeHAiLCJlbWFpbFJlZ2V4IiwiY3JlYXRlVGV4dFNlYXJjaFJlZ2V4cCIsInRleHQiLCJib3VuZHMiLCJlc2NhcGVSZWdleHAiLCJyZXBsYWNlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7QUFBQUEsS0FBSyxDQUFDQyxVQUFOLEdBQW1CLElBQUlDLE1BQUosQ0FBVyxDQUM1QjtBQUNBLEdBRjRCO0FBRzVCLG1DQUg0QixFQUk1QixNQUo0QjtBQUs1QixHQUw0QjtBQU01QixxQkFONEIsRUFPNUIsS0FQNEIsRUFRNUIsd0JBUjRCLEVBUzVCLEtBVDRCLEVBVTVCLEtBVjRCO0FBVzVCLHFDQVg0QixFQVk1QixRQVo0QjtBQWE1QixvREFiNEIsRUFjNUIsSUFkNEI7QUFlNUIsMElBZjRCLEVBZ0I1QixpQkFoQjRCO0FBaUI1QixLQWpCNEIsRUFrQjVCLFdBbEI0QixFQW1CNUIsS0FuQjRCLEVBb0I1QixrQ0FwQjRCLEVBcUI1QixJQXJCNEIsRUFzQjVCLEdBdEI0QixFQXVCNUIsMkJBdkI0QixFQXdCNUIsR0F4QjRCLEVBeUI1QixNQXpCNEIsRUEwQjVCLElBMUI0QixFQTJCNUIsSUEzQjRCO0FBNEI1Qiw4QkE1QjRCLEVBNkI1QixHQTdCNEIsRUE4QjVCQyxJQTlCNEIsQ0E4QnZCLEVBOUJ1QixDQUFYLEVBOEJQLElBOUJPLENBQW5CO0FBZ0NBSCxLQUFLLENBQUNJLGVBQU4sR0FBd0IsMkVBQXhCO0FBRUFKLEtBQUssQ0FBQ0ssVUFBTixHQUFtQixpQkFBbkI7O0FBRUFMLEtBQUssQ0FBQ00sc0JBQU4sR0FBK0IsVUFBQ0MsSUFBRCxFQUFPQyxNQUFBLEdBQVMsS0FBaEI7QUFDN0JELE1BQUEsR0FBT1AsS0FBSyxDQUFDUyxZQUFOLENBQW1CRixJQUFuQixDQUFQOztBQUNBLE1BQUdDLE1BQUg7QUFDRSxRQUFHQSxNQUFBLEtBQVUsTUFBYjtBQUNFRCxVQUFBLEdBQU8sTUFBTUEsSUFBYjtBQURGLFdBRUssSUFBR0MsTUFBQSxLQUFVLE9BQWI7QUFDSEQsVUFBQSxHQUFPQSxJQUFBLEdBQU8sR0FBZDtBQURHO0FBR0hBLFVBQUEsR0FBTyxNQUFNQSxJQUFOLEdBQWEsR0FBcEI7QUFOSjtBQVFDOztBQUNELFNBRkEsSUFBSUwsTUFBSixDQUFXSyxJQUFYLEVBQWlCLEdBQWpCLENBRUE7QUFYNkIsQ0FBL0I7O0FBV0FQLEtBQUssQ0FBQ1MsWUFBTixHQUFxQixVQUFDRixJQUFEO0FBSW5CLFNBSEFBLElBQUksQ0FBQ0csT0FBTCxDQUFhLHdCQUFiLEVBQXVDLE1BQXZDLENBR0E7QUFKbUIsQ0FBckIsQyIsImZpbGUiOiIvbGliL3JlZ2V4cHMuY29mZmVlIiwic291cmNlc0NvbnRlbnQiOlsic2hhcmUubGlua1JlZ0V4cCA9IG5ldyBSZWdFeHAoW1xuICAjIFRoZSBncm91cHNcbiAgJygnLCAjIDEuIENoYXJhY3RlciBiZWZvcmUgdGhlIGxpbmtcbiAgJ1xcXFxzfFteYS16QS1aMC05LlxcXFwrX1xcXFwvXCJcXFxcPlxcXFwtXXxeJyxcbiAgJykoPzonLCAjIE1haW4gZ3JvdXBcbiAgJygnLCAjIDIuIEVtYWlsIGFkZHJlc3MgKG9wdGlvbmFsKVxuICAnW2EtekEtWjAtOVxcXFwrX1xcXFwtXSsnLFxuICAnKD86JyxcbiAgJ1xcXFwuW2EtekEtWjAtOVxcXFwrX1xcXFwtXSsnLFxuICAnKSpAJyxcbiAgJyk/KCcsICMgMy4gUHJvdG9jb2wgKG9wdGlvbmFsKVxuICAnaHR0cDpcXFxcL1xcXFwvfGh0dHBzOlxcXFwvXFxcXC98ZnRwOlxcXFwvXFxcXC8nLFxuICAnKT8oPzooJywgIyA0LiBEb21haW4gJiBTdWJkb21haW5zXG4gICcoPzooPzpbYS16MC05XyVcXFxcLV8rXSpbYS16XVthLXowLTlfJVxcXFwtXytdKlsuOl0pKyknLFxuICAnKSgnLCAjIDUuIFRvcC1sZXZlbCBkb21haW4gLSBodHRwOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL0xpc3Rfb2ZfSW50ZXJuZXRfdG9wLWxldmVsX2RvbWFpbnNcbiAgJyg/OmNvbXxjYXxjb3xlZHV8Z292fG5ldHxvcmd8ZGV2fGJpenxjYXR8aW50fHByb3x0ZWx8bWlsfGFlcm98YXNpYXxjb29wfGluZm98am9ic3xtb2JpfG11c2V1bXxuYW1lfHBvc3R8dHJhdmVsfGxvY2FsfFswLTldezIsfXxbYS16XXsyfSknLFxuICAnKXxmaWxlOlxcXFwvXFxcXC8pKCcsICMgNi4gUXVlcnkgc3RyaW5nIChvcHRpb25hbClcbiAgJyg/OicsXG4gICdbXFxcXC98XFxcXD9dJyxcbiAgJyg/OicsXG4gICdbXFxcXC1hLXpBLVowLTlfJSMqJis9fiE/LDs6LlxcXFwvXSonLFxuICAnKSonLFxuICAnKScsXG4gICdbXFxcXC1cXFxcL2EtekEtWjAtOV8lIyomKz1+XScsXG4gICd8JyxcbiAgJ1xcXFwvPycsXG4gICcpPycsXG4gICcpKCcsICMgNy4gQ2hhcmFjdGVyIGFmdGVyIHRoZSBsaW5rXG4gICdbXmEtekEtWjAtOVxcXFwrX1xcXFwvXCJcXFxcPFxcXFwtXXwkJyxcbiAgJyknXG5dLmpvaW4oJycpLCAnbWcnKVxuXG5zaGFyZS5lbWFpbExpbmtSZWdFeHAgPSAvKDxbYS16XSsgaHJlZj1cXFwiKShodHRwOlxcL1xcLykoW2EtekEtWjAtOVxcK19cXC1dKyg/OlxcLlthLXpBLVowLTlcXCtfXFwtXSspKkApL2dcblxuc2hhcmUuZW1haWxSZWdleCA9IC9eW15AXStAW15AXSskL2dpXG5cbnNoYXJlLmNyZWF0ZVRleHRTZWFyY2hSZWdleHAgPSAodGV4dCwgYm91bmRzID0gZmFsc2UpIC0+XG4gIHRleHQgPSBzaGFyZS5lc2NhcGVSZWdleHAodGV4dClcbiAgaWYgYm91bmRzXG4gICAgaWYgYm91bmRzIGlzIFwibGVmdFwiXG4gICAgICB0ZXh0ID0gXCJeXCIgKyB0ZXh0XG4gICAgZWxzZSBpZiBib3VuZHMgaXMgXCJyaWdodFwiXG4gICAgICB0ZXh0ID0gdGV4dCArIFwiJFwiXG4gICAgZWxzZVxuICAgICAgdGV4dCA9IFwiXlwiICsgdGV4dCArIFwiJFwiXG4gIG5ldyBSZWdFeHAodGV4dCwgXCJpXCIpXG5cbnNoYXJlLmVzY2FwZVJlZ2V4cCA9ICh0ZXh0KSAtPlxuICB0ZXh0LnJlcGxhY2UoLyhbLj8qK14kW1xcXVxcXFwoKXt9fC1dKS9nLCBcIlxcXFwkMVwiKVxuIl19

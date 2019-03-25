(function () {
  var mraid = window.mraid = {
    vast: %@
  };

  // Constants.
  var VERSION = mraid.VERSION = '2.0';

  var STATES = mraid.STATES = {
    DEFAULT: 'default',
  };

  // property
  var isViewable = true;

  // state
  var state = STATES.DEFAULT;

  mraid.close = function() {
    bridge.executeNativeCall(['close']);
  };

  mraid.useCustomClose = function(shouldUseCustomClose) {
    bridge.executeNativeCall(['usecustomclose', 'shouldUseCustomClose', shouldUseCustomClose]);
  };

  mraid.getVersion = function() {
    return mraid.VERSION;
  };

  mraid.isViewable = function() {
    return isViewable;
  };

  mraid.setIsViewable = function(_isViewable) {
    isViewable = _isViewable;
  };

  mraid.getState = function() {
    return state;
  };

  mraid.removeEventListener = function(event, listener) {
  };

  mraid.addEventListener = function(event, listener) {
  };

  mraid.open = function(URL) {
    bridge.executeNativeCall(['open', 'url', URL]);
  };

  var bridge = window.mraidbridge = {
    nativeCallQueue: [],
    nativeCallInFlight: false,
  };

  bridge.setVast = function(vast) {
    mraid.vast = JSON.parse(vast);
  };

  bridge.executeNativeCall = function(args) {
    var command = args.shift();
    var call = 'mraid://' + command;

    var key, value;
    var isFirstArgument = true;

    for (var i = 0; i < args.length; i += 2) {
      key = args[i];
      value = args[i + 1];

      if (value === null) {
        continue;
      }

      if (isFirstArgument) {
        call += '?';
        isFirstArgument = false;
      } else {
        call += '&';
      }

      call += encodeURIComponent(key) + '=' + encodeURIComponent(value);
    }

    if (this.nativeCallInFlight) {
      this.nativeCallQueue.push(call);
    } else {
      this.nativeCallInFlight = true;
      window.location = call;
    }
  };

  bridge.nativeCallComplete = function(command) {
    if (this.nativeCallQueue.length === 0) {
      this.nativeCallInFlight = false;
      return;
    }

    var nextCall = this.nativeCallQueue.pop();
    window.location = nextCall;
  };

}());

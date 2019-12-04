(function () {
  //////////////////////////
  /// MRAID
  var mraid = window.mraid = {
    vast: %@,
    fluctExt: {}
  };
  //////////////////////////

  //////////////////////////
  /// MRAID Constants.
  var VERSION = mraid.VERSION = '3.0';

  var STATES = mraid.STATES = {
    LOADING: 'loading',
    DEFAULT: 'default',
    EXPANDED: 'expanded',
    HIDDEN: 'hidden',
    RESIZED: 'resized'
  };

  var EVENTS = mraid.EVENTS = {
    ERROR: 'error',
    INFO: 'info',
    READY: 'ready',
    STATECHANGE: 'stageChange',
    VIEWABLECHANGE: 'viewableChange',
    EXPOSURECHANGE: 'exposureChange'
  };

  var PLACEMENT_TYPES = mraid.PLACEMENT_TYPES = {
    INLINE: 'inline',
    INTERSTITIAL: 'interstitial'
  };

  var MRAID_ENV = mraid.MRAID_ENV = {
    version: '3.0',
    sdk: 'FluctSDK',
    sdkVersion: '',
    appId: '',
    ifa: '',
    limitAdTracking: false,
    coppa: false
  };
  //////////////////////////

  //////////////////////////
  /// MRAID property
  var expandProperties = {
    width: 0,
    height: 0,
    useCustomClose: false,
    isModal: false
  };

  var resizeProperties = {
    width: 0,
    height: 0,
    offsetX: 0,
    offsetY: 0,
    customClosePosition: 'top-right',
    allowOffscreen: false
  };

  var orientationProperties = {
    allowOrientationChange: true,
    forceOrientation: "none"
  };

  var exposureProperties = {
    exposedPercentage: 0,
    visibleRectangle: null,
    occlusionRectangles: null
  };

  var supportProperties = {
    sms: false,
    tel: false,
    calendar: false,
    storePicture: false,
    inlineVideo: true 
  };

  var maxSize = {
    width: 0,
    height: 0
  };

  var currentPosition = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };

  var defaultPosition = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };

  var screenSize = {
    width: 0,
    height: 0
  };

  // 外部注入
  var isViewable = false;
  var hasSetCustomClose = false;
  var listeners = {};
  var state = STATES.LOADING;
  var placementType = PLACEMENT_TYPES.INLINE;
  var hostSDKVersion = {
    major: 0,
    minor: 0,
    patch: 0
  };
  //////////////////////////

  //////////////////////////
  /// MRAID methods
  mraid.addEventListener = function(event, listener) {
    if (!event || !listener) {
      broadcastEvent(EVENTS.ERROR, 'Both event and listener are required.', 'addEventListener');
    } else if (!contains(event, EVENTS)) {
      broadcastEvent(EVENTS.ERROR, 'Unknown MRAID event: ' + event, 'addEventListener');
    } else {
      if (!listeners[event]) {
        listeners[event] = new EventListeners(event);
      }
      listeners[event].add(listener);
      bridge.executeNativeCall(COMMAND.ADD_EVENTLISTENER, ['event', event]);
    }
  };

  mraid.removeEventListener = function(event, listener) {
    if (!event) {
      broadcastEvent(EVENTS.ERROR, 'Event is required.', 'removeEventListener');
      return;
    }

    if (listener) {
      // If we have a valid event, we'll try to remove the listener from it.
      var success = false;
      if (listeners[event]) {
        success = listeners[event].remove(listener);
      }

      // If we didn't have a valid event or couldn't remove the listener from the event, broadcast an error and return early.
      if (!success) {
        broadcastEvent(EVENTS.ERROR, 'Listener not currently registered for event.', 'removeEventListener');
        return;
      }

    } else if (!listener && listeners[event]) {
      listeners[event].removeAll();
    }

    if (listeners[event] && listeners[event].count === 0) {
      listeners[event] = null;
      delete listeners[event];
    }
  };

  mraid.open = function(URL) {
    bridge.executeNativeCall(COMMAND.OPEN, ['url', URL]);
  };

  mraid.expand = function(URL) {
    bridge.notifyUnsupportedEvent('expand');
  };

  mraid.close = function() {
    bridge.executeNativeCall(COMMAND.CLOSE)
  };

  mraid.useCustomClose = function(shouldUseCustomClose) {
    expandProperties.useCustomClose = shouldUseCustomClose;
    hasSetCustomClose = true;
    bridge.executeNativeCall(COMMAND.USE_CUSTOM_CLOSE, ['shouldUseCustomClose', shouldUseCustomClose]);
  };

  mraid.resize = function() {
    bridge.notifyUnsupportedEvent('resize');
  };

  mraid.playVideo = function(URL) {
    if (!URL) {
      broadcastEvent(EVENTS.ERROR, 'playVideo must be called with a valid URI', 'playVideo');
      return;
    }

    bridge.executeNativeCall(COMMAND.PLAY_VIDEO, ['url', URL]);
  };

  mraid.getVersion = function() {
    return mraid.VERSION;
  };

  mraid.isViewable = function() {
    return isViewable;
  };

  mraid.getState = function() {
    return state;
  };

  mraid.supports = function(feature) {
    return supportProperties[feature];
  };

  mraid.getExpandProperties = function() {
    return {
      width: expandProperties.width,
      height: expandProperties.height,
      useCustomClose: expandProperties.useCustomClose,
      isModal: expandProperties.isModal
    };
  };

  mraid.setExpandProperties = function(properties) {
    if (validate(properties, expandPropertyValidators, 'setExpandProperties', true)) {
      if (properties.hasOwnProperty('useCustomClose')) {
        expandProperties.useCustomClose = properties.useCustomClose;
      }
    }
  };

  mraid.getCurrentPosition = function() {
    return {
      x: currentPosition.x,
      y: currentPosition.y,
      width: currentPosition.width,
      height: currentPosition.height
    };
  };

  mraid.getDefaultPosition = function() {
    return {
      x: defaultPosition.x,
      y: defaultPosition.y,
      width: defaultPosition.width,
      height: defaultPosition.height
    };
  };

  var bridge = window.mraidbridge = {
    nativeCallQueue: [],
    nativeCallInFlight: false,
  };

  mraid.getMaxSize = function() {
    return {
      width: maxSize.width,
      height: maxSize.height
    };
  };

  mraid.getPlacementType = function() {
    return placementType;
  };

  mraid.getScreenSize = function() {
    return {
      width: screenSize.width,
      height: screenSize.height
    };
  };

  mraid.getOrientationProperties = function() {
    return {
      allowOrientationChange: orientationProperties.allowOrientationChange,
      forceOrientation: orientationProperties.forceOrientation
    };
  };

  mraid.setOrientationProperties = function(properties) {
    if (properties.hasOwnProperty('allowOrientationChange')) {
      orientationProperties.allowOrientationChange = properties.allowOrientationChange;
    }

    if (properties.hasOwnProperty('forceOrientation')) {
      orientationProperties.forceOrientation = properties.forceOrientation;
    }

    var args = [
      'allowOrientationChange', orientationProperties.allowOrientationChange,
      'forceOrientation', orientationProperties.forceOrientation
    ];
    bridge.executeNativeCall(COMMAND.SET_ORIENTATION_PROPERITES, args);
  };

  mraid.getResizeProperties = function() {
    return {
      width: resizeProperties.width,
      height: resizeProperties.height,
      offsetX: resizeProperties.offsetX,
      offsetY: resizeProperties.offsetY,
      customClosePosition: resizeProperties.customClosePosition,
      allowOffscreen: resizeProperties.allowOffscreen
    };
  };

  mraid.setResizeProperties = function(properties) {
    if (validate(properties, resizePropertyValidators, 'setResizeProperties', true)) {
      var desiredProperties = ['width', 'height', 'offsetX', 'offsetY', 'customClosePosition', 'allowOffscreen'];
      var length = desiredProperties.length;
      for (var i = 0; i < length; i++) {
        var propname = desiredProperties[i];
        if (properties.hasOwnProperty(propname)) {
          resizeProperties[propname] = properties[propname];
        }
      }
    }
  };

  mraid.getHostSDKVersion = function() {
    return {
      major: hostSDKVersion.major,
      minor: hostSDKVersion.minor,
      patch: hostSDKVersion.patch
    }
  };
 
  /// fluct original
  mraid.fluctExt.refresh = function() {
    expandProperties = {
      width: 0,
      height: 0,
      useCustomClose: false,
      isModal: false
    };

    resizeProperties = {
      width: 0,
      height: 0,
      offsetX: 0,
      offsetY: 0,
      customClosePosition: 'top-right',
      allowOffscreen: false
    };

    orientationProperties = {
      allowOrientationChange: true,
      forceOrientation: "none"
    };

    exposureProperties = {
      exposedPercentage: null,
      visibleRectangle: null,
      occlusionRectangles: null
    };

    isViewable = false;
    hasSetCustomClose = false;
    listeners = {};
  };
  //////////////////////////

  //////////////////////////
  /// MRAID Event Listeners
  var EventListeners = function(event) {
    this.event = event;
    this.count = 0;
    var listeners = {};

    this.add = function (func) {
      var id = String(func);
      if (!listeners[id]) {
        listeners[id] = func;
        this.count++;
      }
    };

    this.remove = function (func) {
      var id = String(func);
      if (listeners[id]) {
        listeners[id] = null;
        delete listeners[id];
        this.count--;
        return true;
      } else {
        return false;
      }
    };

    this.removeAll = function () {
      for (var id in listeners) {
        if (listeners.hasOwnProperty(id)) this.remove(listeners[id]);
      }
    };

    this.broadcast = function(args) {
      for (var id in listeners) {
        if (listeners.hasOwnProperty(id)) listeners[id].apply(mraid, args);
      }
    };

    this.toString = function() {
      var out = [event, ':'];
      for (var id in listeners) {
        if (listeners.hasOwnProperty(id)) out.push('|', id, '|');
      }
      return out.join('');
    };
  };

  var broadcastEvent = function() {
    var args = new Array(arguments.length);
    var l = arguments.length;
    for (var i = 0; i < l; i++) args[i] = arguments[i];
    var event = args.shift();
    if (listeners[event]) listeners[event].broadcast(args);
  };

  var contains = function(value, array) {
    for (var i in array) {
      if (array[i] === value) return true;
    }
    return false;
  };

  var stringify = function(obj) {
    if (typeof obj === 'object') {
      var out = [];
      if (obj.push) {
        // Array.
        for (var p in obj) out.push(obj[p]);
        return '[' + out.join(',') + ']';
      } else {
        // Other object.
        for (var p in obj) out.push("'" + p + "': " + obj[p]);
        return '{' + out.join(',') + '}';
      }
    } else return String(obj);
  };
  //////////////////////////

  //////////////////////////
  /// Validate
  var validate = function(obj, validators, action, merge) {
    if (!merge) {
      // Check to see if any required properties are missing.
      if (obj === null) {
        broadcastEvent(EVENTS.ERROR, 'Required object not provided.', action);
        return false;
      } else {
        for (var i in validators) {
          if (validators.hasOwnProperty(i) && obj[i] === undefined) {
            broadcastEvent(EVENTS.ERROR, 'Object is missing required property: ' + i, action);
            return false;
          }
        }
      }
    }

    for (var prop in obj) {
      var validator = validators[prop];
      var value = obj[prop];
      if (validator && !validator(value)) {
        // Failed validation.
        broadcastEvent(EVENTS.ERROR, 'Value of property ' + prop + ' is invalid: ' + value, action);
        return false;
      }
    }
    return true;
  };

  var expandPropertyValidators = {
    useCustomClose: function (v) { return (typeof v === 'boolean'); },
  };

  var resizePropertyValidators = {
    width: function (v) {
      return !isNaN(v) && v > 0;
    },
    height: function (v) {
      return !isNaN(v) && v > 0;
    },
    offsetX: function (v) {
      return !isNaN(v);
    },
    offsetY: function (v) {
      return !isNaN(v);
    },
    customClosePosition: function(v) {
      return (typeof v === 'string' &&
        ['top-right', 'bottom-right', 'top-left', 'bottom-left', 'center', 'top-center', 'bottom-center'].indexOf(v) > -1);
    },
    allowOffscreen: function(v) {
      return (typeof v === 'boolean');
    }
  };
  //////////////////////////

  //////////////////////////
  /// Bridge
  var bridge = window.mraidbridge = {
    nativeSDKFiredReady: false,
    nativeCallQueue: [],
    nativeCallInFlight: false,
    lastSizeChangeProperties: {
      width: 0,
      height: 0
    }
  };
  //////////////////////////

  //////////////////////////
  /// Bridge Constants
  var COMMAND = bridge.COMMAND = {
    OPEN: 'open',
    CLOSE: 'close',
    USE_CUSTOM_CLOSE: 'usecustomclose',
    PLAY_VIDEO: 'playVideo',
    EXPAND: 'expand',
    RESIZE: 'resize',
    ADD_EVENTLISTENER: 'addEventListener',
    SET_ORIENTATION_PROPERITES: 'setOrientationProperties'
  }
  //////////////////////////

  //////////////////////////
  /// Bridge native call
  bridge.executeNativeCall = function(command, args) {
    var call = 'mraid://' + command;

    if (typeof args !== 'undefined') {

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
  //////////////////////////


  //////////////////////////
  /// bridge set
  bridge.setCurrentPosition = function(x, y, width, height) {
    currentPosition = {
      x: x,
      y: y,
      width: width,
      height: height
    };
    broadcastEvent(EVENTS.INFO, 'Set current position to ' + stringify(currentPosition));
  };

  bridge.setDefaultPosition = function(x, y, width, height) {
    defaultPosition = {
      x: x,
      y: y,
      width: width,
      height: height
    };
    broadcastEvent(EVENTS.INFO, 'Set default position to ' + stringify(defaultPosition));
  };

  bridge.setMaxSize = function(width, height) {
    maxSize = {
      width: width,
      height: height
    };

    expandProperties.width = width;
    expandProperties.height = height;

    broadcastEvent(EVENTS.INFO, 'Set max size to ' + stringify(maxSize));
  };

  bridge.setPlacementType = function(_placementType) {
    placementType = _placementType;
    broadcastEvent(EVENTS.INFO, 'Set placement type to ' + stringify(placementType));
  };

  bridge.setScreenSize = function(width, height) {
    screenSize = {
      width: width,
      height: height
    };
    broadcastEvent(EVENTS.INFO, 'Set screen size to ' + stringify(screenSize));
  };

  bridge.setState = function(_state) {
    state = _state;
    broadcastEvent(EVENTS.INFO, 'Set state to ' + stringify(state));
    broadcastEvent(EVENTS.STATECHANGE, state);
  };

  bridge.setIsViewable = function(_isViewable) {
    if (isViewable == _isViewable) {
      return;
    }
    isViewable = _isViewable;
    broadcastEvent(EVENTS.INFO, 'Set isViewable to ' + stringify(isViewable));
    broadcastEvent(EVENTS.VIEWABLECHANGE, isViewable);
  };

  bridge.setSupports = function(sms, tel, calendar, storePicture, inlineVideo) {
    supportProperties = {
      sms: sms,
      tel: tel,
      calendar: calendar,
      storePicture: storePicture,
      inlineVideo: inlineVideo
    };
  };

  bridge.setEnv = function(sdkVersion, appId, ifa, limitAdTracking, coppa) {
    MRAID_ENV.sdkVersion = sdkVersion;
    MRAID_ENV.appId = appId;
    MRAID_ENV.ifa = ifa;
    MRAID_ENV.limitAdTracking = limitAdTracking;
    MRAID_ENV.coppa = coppa;

    var versions = sdkVersion.split('.').map(function (version) {
      return parseInt(version, 10);
    }).filter(function (version) {
      return version >= 0;
    });

    if (versions.length >= 3) {
      hostSDKVersion['major'] = parseInt(versions[0], 10);
      hostSDKVersion['minor'] = parseInt(versions[1], 10);
      hostSDKVersion['patch'] = parseInt(versions[2], 10);
      broadcastEvent(EVENTS.INFO, 'Set hostSDKVersion to ' + stringify(hostSDKVersion));
    }

    broadcastEvent(EVENTS.INFO, 'Set MRAID_ENV to' + stringify(MRAID_ENV));
  };

  bridge.setExposure = function(exposedPercentage) {
    var visibleRectangle = {
      x: 0,
      y: 0,
      width: currentPosition.width,
      height: currentPosition.height
    }
    exposureProperties.exposedPercentage = exposedPercentage;
    if (0 < exposedPercentage) {
      exposureProperties.visibleRectangle = visibleRectangle;
      exposureProperties.occlusionRectangles = null;
    } else {
      exposureProperties.visibleRectangle = null;
      exposureProperties.occlusionRectangles = visibleRectangle;
    }
    broadcastEvent(EVENTS.EXPOSURECHANGE, exposureProperties.exposedPercentage, exposureProperties.visibleRectangle, exposureProperties.occlusionRectangles);
  };
  //////////////////////////

  //////////////////////////
  /// used Playable Rewarded Video
  bridge.setVast = function(vast) {
    mraid.vast = JSON.parse(vast);
  };
  //////////////////////////

  //////////////////////////
  /// notify
  bridge.notifyReadyEvent = function() {
    this.nativeSDKFiredReady = true;
    broadcastEvent(EVENTS.READY);
  };

  bridge.notifyErrorEvent = function(message, action) {
    broadcastEvent(EVENTS.ERROR, message, action);
  };

  bridge.notifyUnsupportedEvent = function(action) {
    this.notifyErrorEvent('Attempt to do Unsupported MRAID Method ' + action, action);
  };

  bridge.fireReadyEvent = bridge.notifyReadyEvent;
  bridge.fireErrorEvent = bridge.notifyErrorEvent;
  //////////////////////////

}());

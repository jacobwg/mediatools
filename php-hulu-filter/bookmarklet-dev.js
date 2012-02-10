// 2:30


var HuluFilter = function() {

var FlyJSONP = (function (global) {
    "use strict";
    /*jslint bitwise: true*/
    var self,
        addEvent,
        garbageCollectGet,
        parametersToString,
        generateRandomName,
        callError,
        callSuccessGet,
        callSuccessPost,
        callComplete;
    
    addEvent = function (element, event, fn) {
        if (element.addEventListener) {
            element.addEventListener(event, fn, false);
        } else if (element.attachEvent) {
            element.attachEvent('on' + event, fn);
        } else {
            element['on' + event] = fn;
        }
    };
    
    garbageCollectGet = function (callbackName, script) {
        self.log("Garbage collecting!");
        script.parentNode.removeChild(script);
        global[callbackName] = undefined;
        try {
            delete global[callbackName];
        } catch (e) { }
    };
    
    parametersToString = function (parameters, encodeURI) {
        var str = "",
            key,
            parameter;
            
        for (key in parameters) {
            if (parameters.hasOwnProperty(key)) {
                key = encodeURI ? encodeURIComponent(key) : key;
                parameter = encodeURI ? encodeURIComponent(parameters[key]) : parameters[key];
                str += key + "=" + parameter + "&";
            }
        }
        return str.replace(/&$/, "");
    };
    
    //Thanks to Kevin Hakanson
    //http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript/873856#873856
    generateRandomName = function () {
        var uuid = '',
            s = [],
            hexDigits = "0123456789ABCDEF",
            i = 0;
            
        for (i = 0; i < 32; i += 1) {
            s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
        }
        
        s[12] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
        s[16] = hexDigits.substr((s[16] & 0x3) | 0x8, 1); // bits 6-7 of the clock_seq_hi_and_reserved to 01

        uuid = 'flyjsonp_' + s.join("");
        return uuid;
    };
    
    callError = function (callback, errorMsg) {
        self.log(errorMsg);
        if (typeof (callback) !== 'undefined') {
            callback(errorMsg);
        }
    };
    
    callSuccessGet = function (callback, data) {
        self.log("GET success");
        if (typeof (callback) !== 'undefined') {
            callback(data);
        }
        self.log(data);
    };
    
    callSuccessPost = function (callback, data) {
        self.log("POST success");
        if (typeof (callback) !== 'undefined') {
            callback(data);
        }
        self.log(data);
    };
    
    callComplete = function (callback) {
        self.log("Request complete");
        if (typeof (callback) !== 'undefined') {
            callback();
        }
    };
    
    self = {};
    
    //settings
    self.options = {
        debug: false
    };
    
    self.init = function (options) {
        var key;
        self.log("Initializing!");
        
        for (key in options) {
            if (options.hasOwnProperty(key)) {
                self.options[key] = options[key];
            }
        }
        
        self.log("Initialization options");
        self.log(self.options);
        return true;
    };
    
    self.log = function (log) {
        if (global.console && self.options.debug) {
            global.console.log(log);
        }
    };
    
    self.get = function (options) {
        options = options || {};
        var url = options.url,
            callbackParameter = options.callbackParameter || 'callback',
            parameters = options.parameters || {},
            script = global.document.createElement('script'),
            callbackName = generateRandomName(),
            prefix = "?";
            
        if (!url) {
            throw new Error('URL must be specified!');
        }
        
        parameters[callbackParameter] = callbackName;
        if (url.indexOf("?") >= 0) {
            prefix = "&";
        }
        url += prefix + parametersToString(parameters, true);
        
        global[callbackName] = function (data) {
            if (typeof (data) === 'undefined') {
                callError(options.error, 'Invalid JSON data returned');
            } else {
                if (options.httpMethod === 'post') {
                    data = data.query.results;
                    if (!data || !data.postresult) {
                        callError(options.error, 'Invalid JSON data returned');
                    } else {
                        if (data.postresult.json) {
                            data = data.postresult.json;
                        } else {
                            data = data.postresult;
                        }
                        callSuccessPost(options.success, data);
                    }
                } else {
                    callSuccessGet(options.success, data);
                }
            }
            garbageCollectGet(callbackName, script);
            callComplete(options.complete);
        };
        
        self.log("Getting JSONP data");
        script.setAttribute('src', url);
        global.document.getElementsByTagName('head')[0].appendChild(script);
        
        addEvent(script, 'error', function () {
            garbageCollectGet(callbackName, script);
            callComplete(options.complete);
            callError(options.error, 'Error while trying to access the URL');
        });
    };
    
    self.post = function (options) {
        options = options || {};
        var url = options.url,
            parameters = options.parameters || {},
            yqlQuery,
            yqlURL,
            getOptions = {};
        
        if (!url) {
            throw new Error('URL must be specified!');
        }
        
        yqlQuery = encodeURIComponent('select * from jsonpost where url="' + url + '" and postdata="' + parametersToString(parameters, false) + '"');
        yqlURL = 'http://query.yahooapis.com/v1/public/yql?q=' + yqlQuery + '&format=json' + '&env=' + encodeURIComponent('store://datatables.org/alltableswithkeys');
        
        getOptions.url = yqlURL;
        getOptions.httpMethod = 'post';
        
        if (typeof (options.success) !== 'undefined') {
            getOptions.success = options.success;
        }
        
        if (typeof (options.error) !== 'undefined') {
            getOptions.error = options.error;
        }
        
        if (typeof (options.complete) !== 'undefined') {
            getOptions.complete = options.complete;
        }
        
        self.get(getOptions);
    };
    
    return self;
}(this));

;(function(win,doc){
    var eventOn, eventOff;
    if (win.addEventListener) {
       eventOn = function(obj,type,fn){obj.addEventListener(type,fn,false)};
       eventOff = function(obj,type,fn){obj.removeEventListener(type,fn,false)};
    } else {
       eventOn = function(obj,type,fn){obj.attachEvent('on'+type,fn)};
       eventOff = function(obj,type,fn){obj.detachEvent('on'+type,fn)};
    }

    var eventing = false,
        animationInProgress = false,
        humaneEl = null,
        timeout = null,
        useFilter = /msie [678]/i.test(navigator.userAgent), // ua sniff for filter support
        isSetup = false,
        queue = [];

    eventOn(win,'load',function(){
        var transitionSupported = (function(style){
            var prefixes = ['MozT','WebkitT','OT','msT','KhtmlT','t'];
            for(var i = 0, prefix; prefix = prefixes[i]; i++){
                if(prefix+'ransition' in style) return true;
            }
            return false;
        }(doc.body.style));

        if(!transitionSupported) animate = jsAnimateOpacity; // override animate
        setup();
        run();
    });

    function setup() {
        humaneEl = doc.createElement('div');
        humaneEl.id = 'humane';
        humaneEl.className = 'humane';
        doc.body.appendChild(humaneEl);
        if(useFilter) humaneEl.filters.item('DXImageTransform.Microsoft.Alpha').Opacity = 0; // reset value so hover states work
        isSetup = true;
    }

    function remove() {
        eventOff(doc.body,'mousemove',remove);
        eventOff(doc.body,'click',remove);
        eventOff(doc.body,'keypress',remove);
        eventOff(doc.body,'touchstart',remove);
        eventing = false;
        if(animationInProgress) animate(0);
    }

    function run() {
        if(animationInProgress && !win.humane.forceNew) return;
        if(!queue.length){
            remove();
            return;
        }

        animationInProgress = true;

        if(timeout){
            clearTimeout(timeout);
            timeout = null;
        }

        timeout = setTimeout(function(){ // allow notification to stay alive for timeout
            if(!eventing){
                eventOn(doc.body,'mousemove',remove);
                eventOn(doc.body,'click',remove);
                eventOn(doc.body,'keypress',remove);
                eventOn(doc.body,'touchstart',remove);
                eventing = true;
                if(!win.humane.waitForMove) remove();
            }
        }, win.humane.timeout);

        humaneEl.innerHTML = queue.shift();
        animate(1);
    }

    function animate(level){
        if(level === 1){
            humaneEl.className = "humane humane-show";
        } else {
            humaneEl.className = "humane";
            end();
        }
    }

    function end(){
        setTimeout(function(){
            animationInProgress = false;
            run();
        },500);
    }

    // if CSS Transitions not supported, fallback to JS Animation
    var setOpacity = (function(){
        if(useFilter){
            return function(opacity){
                humaneEl.filters.item('DXImageTransform.Microsoft.Alpha').Opacity = opacity*100;
            }
        } else {
            return function(opacity){
                humaneEl.style.opacity = String(opacity);
            }
        }
    }());
    function jsAnimateOpacity(level,callback){
        var interval;
        var opacity;

        if (level === 1) {
            opacity = 0;
            if(win.humane.forceNew){
                opacity = useFilter ? humaneEl.filters.item('DXImageTransform.Microsoft.Alpha').Opacity/100|0 : humaneEl.style.opacity|0;
            }
            humaneEl.style.zIndex = 100000;
            interval = setInterval(function(){
                if(opacity < 1) {
                    opacity += 0.1;
                    if (opacity>1) opacity = 1;
                    setOpacity(opacity);
                }
                else {
                    clearInterval(interval);
                }
            }, 200 / 20);
        } else {
            opacity = 1;
            interval = setInterval(function(){
                if(opacity > 0) {
                    opacity -= 0.1;
                    if (opacity<0) opacity = 0;
                    setOpacity(opacity);
                }
                else {
                    clearInterval(interval);
                    humaneEl.style.zIndex = -1;
                    end();
                }
            }, 200 / 20);
        }
    }

    function notify(message){
        queue.push(message);
        if(isSetup) run();
    }

    win.humane = notify;
    win.humane.timeout = 2500;
    win.humane.waitForMove = false;
    win.humane.forceNew = false;

}(window,document));


  
  var my = {};
  var block_list = [];
  var timer;
  
  my.filterEvent = function(playing) {
    if (playing) {
      //console.info("Player state changed to playing");
      stopTimer();
      startTimer();
    } else {
      //console.info("Player state changed to paused");
      stopTimer();
    }
  }

  my.setBlockList = function(bl) {
    //console.info("Set blocklist to a new value:");
    //console.debug(bl);
    block_list = bl;
  }

  my.startTimer = function() {
    //console.info('Timer started...');
    timer = setInterval(function(){
      var current_position = document.player.getCurrentTime();
      //console.info(current_position);
      for( i = 0; i < block_list.length; i++ ) {
      	if (current_position > block_list[i].start && current_position < block_list[i].end) {
      	  //console.info('Matched a mute section...');
      	  document.player.setVolume(0);
      	  return;
    	  }
      }
      //console.info('Did not match a mute section...');
  	  document.player.setVolume(1);
    }, 200);
  }

  my.stopTimer = function() {
    //console.info('Timer stopped...');
    clearInterval(timer);
  }

  my.readBlockList = function(fn) {
    FlyJSONP.get({
      url: 'http://tmfdb.org/filter.php',
      parameters: {uri: window.location},
      success: function(data) {
        fn(data);
      },
      error: function(errorMsg) {
        humane(errorMsg);
      }
    });
  }
  
  my.start = function() {
    var el = document.createElement('link');
    el.setAttribute('rel', 'stylesheet');
    el.setAttribute('type', 'text/css');
    el.setAttribute('href', 'http://tmfdb.org/notify.css');
    document.head.appendChild(el);
    humane("Loading filter data...");
    HuluFilter.readBlockList(function(data) {
      humane("Filtering data loaded!");
      HuluFilter.setBlockList(data);
      HuluFilter.startTimer();
    });
  }
  
  return my;
  
}();

var old_dispatch_events = dispatchPlayerEvent;
var dispatchPlayerEvent = function(a, b) { if (a == 'playbackStateChanged') { HuluFilter.filterEvent(b.pauseable); } old_dispatch_events(a, b);};
HuluFilter.start();



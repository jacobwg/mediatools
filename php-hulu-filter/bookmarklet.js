var HuluFilter=function(){var k=function(e){var d,t,c,l,q,n,f,g,m;t=function(a,b,d){a.addEventListener?a.addEventListener(b,d,false):a.attachEvent?a.attachEvent("on"+b,d):a["on"+b]=d};c=function(a,b){d.log("Garbage collecting!");b.parentNode.removeChild(b);e[a]=void 0;try{delete e[a]}catch(c){}};l=function(a,b){var d="",e,c;for(e in a)a.hasOwnProperty(e)&&(e=b?encodeURIComponent(e):e,c=b?encodeURIComponent(a[e]):a[e],d+=e+"="+c+"&");return d.replace(/&$/,"")};q=function(){for(var a="",a=[],b=0,b=
0;b<32;b+=1)a[b]="0123456789ABCDEF".substr(Math.floor(Math.random()*16),1);a[12]="4";a[16]="0123456789ABCDEF".substr(a[16]&3|8,1);return a="flyjsonp_"+a.join("")};n=function(a,b){d.log(b);typeof a!=="undefined"&&a(b)};f=function(a,b){d.log("GET success");typeof a!=="undefined"&&a(b);d.log(b)};g=function(a,b){d.log("POST success");typeof a!=="undefined"&&a(b);d.log(b)};m=function(a){d.log("Request complete");typeof a!=="undefined"&&a()};d={options:{debug:false}};d.init=function(a){var b;d.log("Initializing!");
for(b in a)a.hasOwnProperty(b)&&(d.options[b]=a[b]);d.log("Initialization options");d.log(d.options);return true};d.log=function(a){e.console&&d.options.debug&&e.console.log(a)};d.get=function(a){var a=a||{},b=a.url,o=a.callbackParameter||"callback",p=a.parameters||{},h=e.document.createElement("script"),j=q(),r="?";if(!b)throw Error("URL must be specified!");p[o]=j;b.indexOf("?")>=0&&(r="&");b+=r+l(p,true);e[j]=function(b){typeof b==="undefined"?n(a.error,"Invalid JSON data returned"):a.httpMethod===
"post"?(b=b.query.results,!b||!b.postresult?n(a.error,"Invalid JSON data returned"):(b=b.postresult.json?b.postresult.json:b.postresult,g(a.success,b))):f(a.success,b);c(j,h);m(a.complete)};d.log("Getting JSONP data");h.setAttribute("src",b);e.document.getElementsByTagName("head")[0].appendChild(h);t(h,"error",function(){c(j,h);m(a.complete);n(a.error,"Error while trying to access the URL")})};d.post=function(a){var a=a||{},b=a.url,e=a.parameters||{},c={};if(!b)throw Error("URL must be specified!");
b="http://query.yahooapis.com/v1/public/yql?q="+encodeURIComponent('select * from jsonpost where url="'+b+'" and postdata="'+l(e,false)+'"')+"&format=json&env="+encodeURIComponent("store://datatables.org/alltableswithkeys");c.url=b;c.httpMethod="post";if(typeof a.success!=="undefined")c.success=a.success;if(typeof a.error!=="undefined")c.error=a.error;if(typeof a.complete!=="undefined")c.complete=a.complete;d.get(c)};return d}(this);(function(e,d){function c(){g(d.body,"mousemove",c);g(d.body,"click",
c);g(d.body,"keypress",c);g(d.body,"touchstart",c);m=false;a&&l(0)}function k(){if(!a||e.humane.forceNew)j.length?(a=true,o&&(clearTimeout(o),o=null),o=setTimeout(function(){m||(f(d.body,"mousemove",c),f(d.body,"click",c),f(d.body,"keypress",c),f(d.body,"touchstart",c),m=true,e.humane.waitForMove||c())},e.humane.timeout),b.innerHTML=j.shift(),l(1)):c()}function l(a){a===1?b.className="humane humane-show":(b.className="humane",q())}function q(){setTimeout(function(){a=false;k()},500)}function n(a){var d,
c;a===1?(c=0,e.humane.forceNew&&(c=p?b.filters.item("DXImageTransform.Microsoft.Alpha").Opacity/100|0:b.style.opacity|0),b.style.zIndex=1E5,d=setInterval(function(){c<1?(c+=0.1,c>1&&(c=1),r(c)):clearInterval(d)},10)):(c=1,d=setInterval(function(){c>0?(c-=0.1,c<0&&(c=0),r(c)):(clearInterval(d),b.style.zIndex=-1,q())},10))}var f,g;e.addEventListener?(f=function(a,b,d){a.addEventListener(b,d,false)},g=function(a,b,d){a.removeEventListener(b,d,false)}):(f=function(a,b,d){a.attachEvent("on"+b,d)},g=function(a,
b,d){a.detachEvent("on"+b,d)});var m=false,a=false,b=null,o=null,p=/msie [678]/i.test(navigator.userAgent),h=false,j=[];f(e,"load",function(){var a;a:{a="MozT,WebkitT,OT,msT,KhtmlT,t".split(",");for(var c=0,e;e=a[c];c++)if(e+"ransition"in d.body.style){a=true;break a}a=false}a||(l=n);b=d.createElement("div");b.id="humane";b.className="humane";d.body.appendChild(b);if(p)b.filters.item("DXImageTransform.Microsoft.Alpha").Opacity=0;h=true;k()});var r=function(){return p?function(a){b.filters.item("DXImageTransform.Microsoft.Alpha").Opacity=
a*100}:function(a){b.style.opacity=String(a)}}();e.humane=function(a){j.push(a);h&&k()};e.humane.timeout=2500;e.humane.waitForMove=false;e.humane.forceNew=false})(window,document);var c={},s=[],u;c.filterEvent=function(c){c?(stopTimer(),startTimer()):stopTimer()};c.setBlockList=function(c){s=c};c.startTimer=function(){u=setInterval(function(){var c=document.player.getCurrentTime();for(i=0;i<s.length;i++)if(c>s[i].start&&c<s[i].end){document.player.setVolume(0);return}document.player.setVolume(1)},
200)};c.stopTimer=function(){clearInterval(u)};c.readBlockList=function(c){k.get({url:"http://tmfdb.org/filter.php",parameters:{uri:window.location},success:function(d){c(d)},error:function(c){humane(c)}})};c.start=function(){var c=document.createElement("link");c.setAttribute("rel","stylesheet");c.setAttribute("type","text/css");c.setAttribute("href","http://tmfdb.org/notify.css");document.head.appendChild(c);humane("Loading filter data...");HuluFilter.readBlockList(function(c){humane("Filtering data loaded!");
HuluFilter.setBlockList(c);HuluFilter.startTimer()})};return c}(),old_dispatch_events=dispatchPlayerEvent,dispatchPlayerEvent=function(k,c){k=="playbackStateChanged"&&HuluFilter.filterEvent(c.pauseable);old_dispatch_events(k,c)};HuluFilter.start();
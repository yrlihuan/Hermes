package { // no special packages needed to organize this single file project
  import flash.display.Sprite; // the application is built upon Sprite
  import flash.desktop.NativeApplication;
  import flash.events.InvokeEvent;
  import flash.text.TextField; // needed to display the project's text
  import mx.utils.StringUtil;
  import flash.filesystem.FileStream;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.utils.*;

 
  public class SinaFinanceDecoder extends Sprite // must match the file's name!
  {  
    // initialize text label
    private var ourExampleText:TextField = new TextField();

    private var outputText:String = "";

    public function print(s:Object) : void {
      //var stdout : FileStream = new FileStream();
      //stdout.open(new File("/dev/stdout"), FileMode.WRITE);
      //stdout.writeUTFBytes(s.toString());
      //stdout.close();
      trace(s);
    }

    public function outputLine(s:Object) : void {
      outputText += s.toString() + "\n";
    }

    public function printOutput(): void {
      //var stdout : FileStream = new FileStream();
      //stdout.open(new File("/dev/stdout"), FileMode.WRITE);
      //stdout.writeUTFBytes(outputText);
      //stdout.close();
      trace(outputText);
    }

    // read from stdin doesn't work
    // public function readInput(): String {
    //   var stdin : FileStream = new FileStream();
    //   stdin.open(new File("/dev/stdin"), FileMode.READ);
    //   var content:String = stdin.readUTFBytes(stdin.bytesAvailable);
    //   stdin.close();

    //   print("content");
    //   print(content);

    //   return content;
    // }

    public function formatMinDataOutput(decoded:Array): void
    {
      if (decoded.length != 243) {
        outputLine("wrong number of results. Expected: 243, Actual: " + String(decoded.length));
      }

      // output the header if necessary
      // outputLine("time,price,avg price,volume");

      var date:Date = decoded[0].date;
      var i:int = 0;
      while (i < 243) {
        var o:Object = decoded[i];

        var minutes_from_sod:int;
        if (i <= 121) {
          minutes_from_sod = 9*60 + 30 + i - 1;
        }
        else {
          minutes_from_sod = 9*60 + 30 + i + 90 - 2; // skip 89 minutes break
        }

        var monthS:String = date.month < 10 ? "0" + String(date.month) : String(date.month);
        var dayS:String = date.date < 10 ? "0" + String(date.date) : String(date.date);
        var hour:int = minutes_from_sod / 60;
        var minute:int = minutes_from_sod % 60;
        var hourS:String = hour < 10 ? "0" + String(hour) : String(hour);
        var minuteS:String = minute < 10 ? "0" + String(minute) : String(minute);
        var t:String = StringUtil.substitute("{0}/{1}/{2} {3}:{4}:00", date.fullYear, monthS, dayS, hourS, minuteS);
        var line:String = StringUtil.substitute("{0},{1},{2},{3}", t, o.price, o.avg_price, o.volume);

        outputLine(line);

        ++i;
      }
    }

    public function decodeInputString(encoded:String) : Array
    {
      // sample decode data
      // encoded = "IC+I/BAYQTSfQgYDgII8AnzD5wZGEI3IQhiHQeas+CIQOFJIBCsnJM6Ogdh46Zh0tDEIuwQ8KXjYA8CNhYgcwDHCsCGwADgYnQmfgcChmjAXSG0J4ZI6oB2+CjxUBVCB9KcF7IjXhUZAYPBGvAmYXgcS3LtA8E1ouB5xr+4gVsGqpaILbK9Jw0XAtyFINmguDsid9kQBiSAv/BZhieKYOKZOgCgleQWAz7DjPj5eKgdQUyCkAOoSgsAUOJwV4BxxEiC+bKgxFxE0lhkDEg9IMpCiA2vDEH9hMEZ0JECmdW8ABGvA8fLQSo9cEQgWmIgLkKwAZuzdBGBYHEBS2DXFHIyw2TCIhKrgASogsBBOeNYEANnCJ4DlDO4AYAtQhUCcnFnPYBonFsC0qvBEwrPDIMGchA0XQNcGoSoD6gZIpMBDNwLQ2J4uCzQQVkDOcMw1ACZQ80By9QURCsgmdFMfwl4BEB/ecANhXgCc4L3ABcSKQBxZC8Fw7mg5Ap1BPQOjACKEJwXoO+DkP60ABTxJ6oFIWQsLFY8SoKhhIHs2IIBO/HwLD+EMQCGlgA2jacHQ4bdDCSOLAwdhwMUo6wK2nkdSgoEJeUghq5DUoq/AH+VJIGBORgZhB/E4F40vAHEjkgbA5BBigGpC7G5FrgdvEUaXIzHuDmATCtZJwBOUGEQywBwRqAEoBCTChDIe0hHB49gNpBqgAoBSAo9DHPQQpQBKdOYBiSGM7IItAOw5WBCCaVwAvGBcA3pADW6HQhLLCcgkTBF4mGQgx+FYoJ4BeBTMKIBK7HQwI+B0OO8GgD67EIwF3CHBsi2ADDowPADwDKCksHQZYQCMLLQWA1WBsjEVCcBmvDwBoIMwQorABa5IYzA9DCklgDxA8wyaYJDvBHMw1KhAP9OsD3OEwAFPDCYhJQg82BWWQf9BxDD7BZkkKgFcSUAHHlHsJgqYAxh97AJAulg9F4qLQcI6ygAIcHmFoSDOQZGC0zE2NYLXYEGjIaAGCvoIEDtMM4wk/ABGyZYHQjNwBwBDcAlEhAJNEQYeLsbkBbAZojEBcovYCwLgpqD4Js+hgsDjbFYBwfIEHMgEsJ42ohRE85LQB9fHssjLGGigXNGWCwweQMOWlAmw1pDKYgUgBrpJIQhaC+OKRSQCG/WIG+wkgDB2gvAlAY3Dg14FWBtaF8FQFSQ8RX9EYVCIuN4O+QIIC0bX44DoFPIFENJgApcCYAmTBCwqJgB+vHEQC8BHcqRIgBxB7G8JVgxLwMdQBAdJwwuUCsL4r0AbYc6BcBq1HEFeF4aAAI+DG6Rwi";

      return S_KLC_D(encoded);
    }

    public function SinaFinanceDecoder() // program execution begins here
    {
      NativeApplication.nativeApplication.addEventListener(
        InvokeEvent.INVOKE, onInvokeEvent);

      function onInvokeEvent(invocation:InvokeEvent):void {
        var args:Array = invocation.arguments;
        if (args.length != 0) {
          formatMinDataOutput(decodeInputString(args[0]));
        }
        else {
          outputLine("Usage:");
          outputLine("  adl SinaFinanceDecoder.swf -- <encoded string>");
        }

        printOutput();
        NativeApplication.nativeApplication.exit();
      }

    } // end of SinaFinanceDecoder() function

    public function S_KLC_D(_arg1:String):Array{
            var C:* = undefined;
            var z:* = undefined;
            var q:* = undefined;
            var h:* = undefined;
            var A:* = undefined;
            var i:* = undefined;
            var j:* = undefined;
            var w:* = undefined;
            var b:* = undefined;
            var s:* = undefined;
            var l:* = undefined;
            var p:* = undefined;
            var r:* = undefined;
            var f:* = undefined;
            var g:* = undefined;
            var t:* = undefined;
            var u:* = undefined;
            var e:* = undefined;
            var v:* = undefined;
            var c:* = undefined;
            var n:* = _arg1;
            var arguments:* = arguments;
            var k:* = arguments;
            b = 86400000;
            s = 7657;
            l = [];
            p = [];
            r = ~((3 << 30));
            f = (1 << 30);
            g = [0, 3, 5, 6, 9, 10, 12, 15, 17, 18, 20, 23, 24, 27, 29, 30];
            t = Math;
            var o:* = function ():* {
                var E:* = undefined;
                var D:* = undefined;
                E = 0;
                while (E < 64) {
                    p[E] = t.pow(2, E);
                    if (E < 26){
                        l[E] = x((E + 65));
                        l[(E + 26)] = x((E + 97));
                        if (E < 10){
                            l[(E + 52)] = x((E + 48));
                        };
                    };
                    E = (E + 1);
                };
                l.push("+", "/");
                l = l.join("");
                z = n.split("");
                q = z.length;
                E = 0;
                while (E < q) {
                    z[E] = l.indexOf(z[E]);
                    E = (E + 1);
                };
                h = {};
                C = (j = 0);
                i = {};
                D = B([12, 6]);
                w = (63 ^ D[1]);
                return ((({
                    _1479:v,
                    _136:e,
                    _200:u,
                    _139:c
                }[("_" + D[0])]) || (function ():*{
                    return ([]);
                })));
            };
            var x:* = String.fromCharCode;
            var y:* = function (_arg1:*):* {
                return ((_arg1 === {}._));
            };
            var a:* = function ():* {
                //var _local1:*;
                //var _local2:*;
                //_local1 = d();
                //_local2 = 1;
                //if (d()){
                //    _local2++;
                //} else {
                //    return ((_local2 * ((_local1 * 2) - 1)));
                //};
                //unresolved jump
               var _loc1_:* = undefined;
               var _loc2_:* = undefined;
               _loc1_=d();
               _loc2_=1;
               while(d())
               {
                     _loc2_++;
               }
               return _loc2_*(_loc1_*2-1);
            };
            var d:* = function ():* {
                var _local1:*;
                if (C >= q){
                    return (0);
                };
                _local1 = (z[C] & (1 << j));
                j++;
                if (j >= 6){
                    j = (j - 6);
                    C++;
                };
                return (!(!(_local1)));
            };
            var B:* = function (_arg1:Array, _arg2:*=undefined, _arg3:*=undefined):* {
                var _local4:*;
                var _local5:*;
                var _local6:*;
                var _local7:*;
                var _local8:*;
                _local5 = [];
                _local6 = 0;
                if (!_arg2){
                    _arg2 = [];
                };
                if (!_arg3){
                    _arg3 = [];
                };
                _local4 = 0;
                while (_local4 < _arg1.length) {
                    _local7 = _arg1[_local4];
                    _local6 = 0;
                    if (!_local7){
                        _local5[_local4] = 0;
                    } else {
                        if (C >= q){
                            return (_local5);
                        };
                        if (_arg1[_local4] <= 0){
                            _local6 = 0;
                        } else {
                            if (_arg1[_local4] <= 30){
                                while (true) {
                                    _local8 = (6 - j);
                                    _local8 = (((_local8 < _local7)) ? _local8 : _local7);
                                    _local6 = (_local6 | (((z[C] >> j) & ((1 << _local8) - 1)) << (_arg1[_local4] - _local7)));
                                    j = (j + _local8);
                                    if (j >= 6){
                                        j = (j - 6);
                                        C++;
                                    };
                                    _local7 = (_local7 - _local8);
                                    if (_local7 <= 0){
                                        break;
                                    };
                                };
                                if (((_arg2[_local4]) && ((_local6 >= p[(_arg1[_local4] - 1)])))){
                                    _local6 = (_local6 - p[_arg1[_local4]]);
                                };
                            } else {
                                _local6 = B([30, (_arg1[_local4] - 30)], [0, _arg2[_local4]]);
                                if (!_arg3[_local4]){
                                    _local6 = (_local6[0] + (_local6[1] * p[30]));
                                };
                            };
                        };
                        _local5[_local4] = _local6;
                    };
                    _local4++;
                };
                return (_local5);
            };
            var m:* = function (_arg1:*):* {
                var _local2:*;
                var _local3:*;
                var _local4:*;
                if (_arg1 > 1){
                    _local2 = 0;
                };
                _local2 = 0;
                while (_local2 < _arg1) {
                    h.d++;
                    _local4 = (h.d % 7);
                    if ((((_local4 == 3)) || ((_local4 == 4)))){
                        h.d = (h.d + (5 - _local4));
                    };
                    _local2++;
                };
                _local3 = new Date();
                _local3.setTime(((s + h.d) * b));
                return (_local3);
            };
            u = function ():*{
                var _local1:*;
                var _local2:*;
                var _local3:*;
                var _local4:*;
                var _local5:*;
                var _local6:*;
                if (w >= 1){
                    return ([]);
                };
                h.d = (B([18], [1])[0] - 1);
                _local4 = B([3, 3, 30, 6]);
                h.p = _local4[0];
                h.ld = _local4[1];
                h.cd = _local4[2];
                h.c = _local4[3];
                h.m = t.pow(10, h.p);
                h.pc = (h.cd / h.m);
                _local3 = [];
                _local1 = 0;
                while (true) {
                    _local5 = {d:1};
                    if (d()){
                        _local4 = B([3])[0];
                        if (_local4 == 0){
                            _local5.d = B([6])[0];
                        } else {
                            if (_local4 == 1){
                                h.d = B([18])[0];
                                _local5.d = 0;
                            } else {
                                _local5.d = _local4;
                            };
                        };
                    };
                    _local6 = {date:m(_local5.d)};
                    if (d()){
                        h.ld = (h.ld + a());
                    };
                    _local4 = B([(h.ld * 3)], [1]);
                    h.cd = (h.cd + _local4[0]);
                    _local6.close = (h.cd / h.m);
                    _local3.push(_local6);
                    if ((((C >= q)) || ((((C == (q - 1))) && (!(((h.c ^ (_local1 + 1)) & 63))))))){
                        break;
                    };
                    _local1++;
                };
                _local3[0].prevclose = h.pc;
                return (_local3);
            };
            e = function ():* {
                var _local1:*;
                var _local2:*;
                var _local3:*;
                var _local4:*;
                var _local5:*;
                var _local6:*;
                var _local7:*;
                var _local8:*;
                var _local9:*;
                var _local10:*;
                var _local11:*;
                if (w >= 2){
                    return ([]);
                };
                _local7 = [];
                _local9 = {
                    v:"volume",
                    p:"price",
                    a:"avg_price"
                };
                h.d = (B([18], [1])[0] - 1);
                _local8 = {date:m(1)};
                _local3 = B((((w < 1)) ? [3, 3, 4, 1, 1, 1, 5] : [4, 4, 4, 1, 1, 1, 3]));
                _local1 = 0;
                while (_local1 < 7) {
                    h[["la", "lp", "lv", "tv", "rv", "zv", "pp"][_local1]] = _local3[_local1];
                    _local1++;
                };
                h.m = t.pow(10, h.pp);
                if (w >= 1){
                    _local3 = B([3, 3]);
                    h.c = _local3[0];
                    _local3 = _local3[1];
                } else {
                    _local3 = 5;
                    h.c = 2;
                };
                h.pc = B([(_local3 * 6)])[0];
                _local8.pc = (h.pc / h.m);
                h.cp = h.pc;
                h.da = 0;
                h.sa = (h.sv = 0);
                _local1 = 0;
                while (true) {
                    if ((((C >= q)) || ((((C == (q - 1))) && (!(((h.c ^ _local1) & 7))))))){
                        break;
                    };
                    _local5 = {};
                    _local4 = {};
                    _local10 = ((h.tv) ? d() : 1);
                    _local2 = 0;
                    while (_local2 < 3) {
                        _local11 = ["v", "p", "a"][_local2];
                        if (((_local10) ? d() : 0)){
                            _local3 = a();
                            h[("l" + _local11)] = (h[("l" + _local11)] + _local3);
                        };
                        _local6 = (((((_local11 == "v")) && (h.rv))) ? d() : 1);
                        _local3 = (B([((h[("l" + _local11)] * 3) + (((_local11 == "v")) ? (_local6 * 7) : 0))], [!(!(_local2))])[0] * ((_local6) ? 1 : 100));
                        _local4[_local11] = _local3;
                        if (_local11 == "v"){
                            if (((((!((_local5[_local9[_local11]] = _local3))) && ((_local1 < 241)))) && (((h.zv) ? !(d()) : 1)))){
                                _local4.p = 0;
                                break;
                            };
                        } else {
                            if (_local11 == "a"){
                                h.da = ((((w < 1)) ? 0 : h.da) + _local4.a);
                            };
                        };
                        _local2++;
                    };
                    h.sv = (h.sv + _local4.v);
                    _local5[_local9.p] = ((h.cp = (h.cp + _local4.p)) / h.m);
                    h.sa = (h.sa + (_local4.v * h.cp));
                    _local5[_local9.a] = ((y(_local4.a)) ? ((_local1) ? _local7[(_local1 - 1)][_local9.a] : _local5[_local9.p]) : ((h.sv) ? (((t.floor((((h.sa * (2000 / h.m)) + h.sv) / h.sv)) >> 1) + h.da) / 1000) : (_local5[_local9.p] + (h.da / 1000))));
                    _local7.push(_local5);
                    _local1++;
                };
                _local7[0].date = _local8.date;
                _local7[0].prevclose = _local8.pc;
                return (_local7);
            };
            v = function ():*{
                var _local1:*;
                var _local2:*;
                var _local3:*;
                var _local4:*;
                var _local5:*;
                var _local6:*;
                var _local7:*;
                var _local8:*;
                if (w >= 1){
                    return ([]);
                };
                h.lv = 0;
                h.ld = 0;
                h.cd = 0;
                h.cv = [0, 0];
                h.p = B([6])[0];
                h.d = (B([18], [1])[0] - 1);
                h.m = t.pow(10, h.p);
                _local6 = B([3, 3]);
                h.md = _local6[0];
                h.mv = _local6[1];
                _local1 = [];
                while (true) {
                    _local6 = B([6]);
                    if (!_local6.length){
                        break;
                    };
                    _local4 = {c:_local6[0]};
                    _local5 = {};
                    _local4.d = 1;
                    if ((_local4.c & 32)){
                        while (true) {
                            _local6 = B([6])[0];
                            if ((_local6 | 16) == 63){
                                _local8 = (((_local6 & 16)) ? "x" : "u");
                                _local6 = B([3, 3]);
                                _local4[(_local8 + "_d")] = (_local6[0] + h.md);
                                _local4[(_local8 + "_v")] = (_local6[1] + h.mv);
                                break;
                            };
                            if ((_local6 & 32)){
                                _local7 = (((_local6 & 8)) ? "d" : "v");
                                _local8 = (((_local6 & 16)) ? "x" : "u");
                                _local4[((_local8 + "_") + _local7)] = ((_local6 & 7) + h[("m" + _local7)]);
                                break;
                            };
                            _local7 = (_local6 & 15);
                            if (_local7 == 0){
                                _local4.d = B([6])[0];
                            } else {
                                if (_local7 == 1){
                                    _local7 = B([18])[0];
                                    h.d = _local7;
                                    _local4.d = 0;
                                } else {
                                    _local4.d = _local7;
                                };
                            };
                            if (!(_local6 & 16)){
                                break;
                            };
                        };
                    };
                    _local5.date = m(_local4.d);
                    for (_local7 in {
                        v:0,
                        d:0
                    }) {
                        if (!y(_local4[("x_" + _local7)])){
                            h[("l" + _local7)] = _local4[("x_" + _local7)];
                        };
                        if (y(_local4[("u_" + _local7)])){
                            _local4[("u_" + _local7)] = h[("l" + _local7)];
                        };
                    };
                    _local4.l_l = [_local4.u_d, _local4.u_d, _local4.u_d, _local4.u_d, _local4.u_v];
                    _local8 = g[(_local4.c & 15)];
                    if ((_local4.u_v & 1)){
                        _local8 = (31 - _local8);
                    };
                    if ((_local4.c & 16)){
                        _local4.l_l[4] = (_local4.l_l[4] + 2);
                    };
                    _local3 = 0;
                    while (_local3 < 5) {
                        if ((_local8 & (1 << (4 - _local3)))){
                            var _local9:* = _local4.l_l;
                            var _local10:* = _local3;
                            var _local11:* = (_local9[_local10] + 1);
                            _local9[_local10] = _local11;
                        };
                        _local4.l_l[_local3] = (_local4.l_l[_local3] * 3);
                        _local3++;
                    };
                    _local4.d_v = B(_local4.l_l, [1, 0, 0, 1, 1], [0, 0, 0, 0, 1]);
                    _local7 = (h.cd + _local4.d_v[0]);
                    _local5.open = (_local7 / h.m);
                    _local5.high = ((_local7 + _local4.d_v[1]) / h.m);
                    _local5.low = ((_local7 - _local4.d_v[2]) / h.m);
                    _local5.close = ((_local7 + _local4.d_v[3]) / h.m);
                    _local6 = _local4.d_v[4];
                    if (typeof(_local6) == "number"){
                        _local6 = [_local6, (((_local6 >= 0)) ? 0 : -1)];
                    };
                    h.cd = (_local7 + _local4.d_v[3]);
                    _local8 = (h.cv[0] + _local6[0]);
                    h.cv = [(_local8 & r), ((h.cv[1] + _local6[1]) + !(!((((h.cv[0] & r) + (_local6[0] & r)) & f))))];
                    _local5.volume = ((h.cv[0] & (f - 1)) + (h.cv[1] * f));
                    _local1.push(_local5);
                };
                return (_local1);
            };
            c = function ():* {
                var _local1:*;
                var _local2:*;
                var _local3:*;
                var _local4:*;
                if (w > 1){
                    return ([]);
                };
                h.l = 0;
                _local4 = -1;
                h.d = (B([18])[0] - 1);
                _local3 = B([18])[0];
                while (h.d < _local3) {
                    _local2 = m(1);
                    if (_local4 <= 0){
                        if (d()){
                            h.l = (h.l + a());
                        };
                        _local4 = (B([(h.l * 3)], [0])[0] + 1);
                        if (!_local1){
                            _local1 = [_local2];
                            _local4--;
                        };
                    } else {
                        _local1.push(_local2);
                    };
                    _local4--;
                };
                return (_local1);
            };
            return (o()());
        }
        
  } // end of ShortExample class definition
    
} // end of file/program

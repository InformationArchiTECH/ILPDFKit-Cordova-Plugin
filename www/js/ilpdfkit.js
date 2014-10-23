var ILPDFKit = new function() {
    
    //utilities
    
    var self = this;
    function addMethods(methods) {
        for (var name in methods) {
            (function() {
                var methodName = name;
                var methodArgs = methods[methodName];
                self[methodName] = function() {
                    var successCallback = null;
                    var errorCallback = null;
                    var argArray = [];
                    for (var i = 0; i < arguments.length; i++) {
                        if (methodArgs[i] == 'successCallback') {
                            successCallback = arguments[i];
                        }
                        else if (methodArgs[i] == 'errorCallback') {
                            errorCallback = arguments[i];
                        }
                        else {
                            argArray.push(arguments[i]);
                        }
                    }
                    cordova.exec(function (result) {
                                    if (successCallback) {
                                        successCallback(result);
                                    }
                                 },
                                 function (error) {
                                    if (errorCallback) {
                                        errorCallback(error);
                                    }
                                 }, 'ILPDFKit', methodName, argArray);
                }
             })();
        }
    }
    
    //events
    
    var listeners = {};
    
    this.dispatchEvent = function(event) {
        var result = undefined;
        var functions = listeners[event.type];
        for (var i = 0; i < functions.length; i++) {
            result = functions[i](event);
            if (typeof result != 'undefined') {
                if (!result) return result;
            }
        }
        return result;
    }
    
    this.addEventListener = function(type, listener) {
        var existing = listeners[type];
        if (!existing) {
            existing = [];
            listeners[type] = existing;
        }
        existing.push(listener);
    }
    
    this.addEventListeners = function(listeners) {
        for (type in listeners) {
            this.addEventListener(type, listeners[type]);
        }
    }
    
    this.removeEventListener = function(type, listener)
    {
        var existing = listeners[type];
        if (existing) {
            var index;
            while (index = existing.indexOf(listener)) {
                existing.splice(index,1);
            }
        }
    }
    
    //document methods
    
    addMethods({
               present: ["path", "options", "successCallback", "errorCallback"],
    });
};


module.exports = ILPDFKit;
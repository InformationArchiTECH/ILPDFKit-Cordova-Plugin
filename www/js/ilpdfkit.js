var ILPDFKit = {
    showPdfFromResource: function(resource, success, failure) {
        cordova.exec(success, failure, "ILPDFKit", "openPdfFromResource", [resource]);
    },
    
    showPdfFromPath: function(path, success, failure) {
        cordova.exec(success, failure, "ILPDFKit", "openPdfFromPath", [path]);
    }
};

module.exports = ILPDFKit;
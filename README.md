ILPDFKit-Cordova
================

Cordova plugin for [ILPDFKit](https://github.com/iwelabs/ILPDFKit)

Install
=======
cordova plugin add https://gennick@bitbucket.org/informationarchitech/ilpdfkit-cordova.git

or

phonegap local plugin add https://gennick@bitbucket.org/informationarchitech/ilpdfkit-cordova.git

Usage
=====

Example how to open pdf
```javascript
var options = {"showSaveButton" : true, "fileNameToSave" : "saved.pdf"};

ILPDFKit.present("pdf/test.pdf", options, function(result) {
    // pdf successfully opened
}, function(error) {
    // failed to open pdf
    alert(error);
});
```

Possible options
```
useDocumentsFolder - true/false. (If true we will serch for pdf in app's Documents folder otherwise in www folder)
showSaveButton - true/false.
fileNameToSave - file name of saved pdf. If not specified original pdf name used.
```

Event listener for Save functionality
```javascript
ILPDFKit.addEventListener('savePdf', function(event) {
    if (event.success) {
        setTimeout(function(){
            alert("saved to " + event.savedPath);
        }, 0);
    }
    else {
        setTimeout(function(){
            alert("failed to save");
        }, 0);
    }
});
```
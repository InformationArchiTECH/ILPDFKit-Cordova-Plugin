ILPDFKit-Cordova
================

Cordova plugin for [ILPDFKit](https://github.com/iwelabs/ILPDFKit)

Install
=======
cordova plugin add https://github.com/gennick/ILPDFKit-Cordova.git

or

phonegap local plugin add https://github.com/gennick/ILPDFKit-Cordova.git

Usage
=====

Example how to open pdf from Xcode project resources
```javascript
ILPDFKit.showPdfFromResource("test.pdf", function() {                                                                                                       
	// pdf successfully opened
}, function() {
	// failed to open pdf
	alert("Failure");
});
```

Example how to open pdf from some path (files in www folder, e.g. www/pdf/test.pdf)
```javascript
ILPDFKit.showPdfFromPath("pdf/test.pdf", function() {
	// pdf successfully opened
}, function() {
	// failed to open pdf
	alert("Failure");
});
```

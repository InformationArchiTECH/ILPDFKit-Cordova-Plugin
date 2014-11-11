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
autoSave - true/false
askToSaveBeforeClose - true/false (If true and any form field changed alert massage will appear on close)
backgroundMode - true/false (Present or not pdf view controller)
```

Example how to set/get form values

```javascript
var formName = "Given Name Text Box";
var formValue = "value";
ILPDFKit.setFormValue(formName, formValue);

ILPDFKit.getFormValue(formName, function(value) {
    console.log(value);
});

ILPDFKit.getAllForms(function(forms) {
    for (i = 0; i < forms.length; ++i) {
        var form = forms[i];
        console.log(form.name + "=" + form.value);
    }
});
```

Example how to save pdf
```
ILPDFKit.save();
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
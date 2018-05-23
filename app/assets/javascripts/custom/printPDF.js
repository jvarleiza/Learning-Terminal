/* global jsPDF, $, showMessage */
function printPDFInitialize() {
    var content = $('.main-content-show-section');
    
    if(content.length) {
        var doc = new jsPDF();
        var data = JSON.parse($('#data-to-print').text());
        var title = data.name ? data.name + '.pdf' : 'Learning Terminal.pdf';
        
        // We'll make our own renderer to skip this editor
        var specialElementHandlers = {
            '#editor': function (element, renderer) { return true; }
        };
        // All units are in the set measurement for the document
        // This can be changed to "pt" (points), "mm" (Default), "cm", "in"
        doc.fromHTML(content.get(0), 8, 8, {
        	'width': 170, 
        	'elementHandlers': specialElementHandlers
        });
        doc.save(title);
    } else {
        showMessage('Cannot print this page');
    }
}
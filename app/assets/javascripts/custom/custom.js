var ajaxCall = function(url, method, dataType, data, successFn, errorFn) {
    $.ajax({ url: url, type: method, dataType: dataType, data: data, success: successFn, error: errorFn });
};
function contains(str, word) {
    return str.indexOf(word) > -1;
}
Array.prototype.clean = function(deleteValue) {
  for (var i = 0; i < this.length; i++) {
    if (this[i] == deleteValue) {         
      this.splice(i, 1);
      i--;
    }
  }
  return this;
};
String.prototype.format = function (args) {
    var str = this;
    return str.replace(String.prototype.format.regex, function(item) {
    	var intVal = parseInt(item.substring(1, item.length - 1));
    	var replace;
    	if (intVal >= 0) {
    		replace = args[intVal];
    	} else if (intVal === -1) {
    		replace = "{";
    	} else if (intVal === -2) {
    		replace = "}";
    	} else {
    		replace = "";
    	}
    	return replace;
    });
};
String.prototype.format.regex = new RegExp("{-?[0-9]+}", "g");
function showMessage(message) {
    var toast = $('#info-toast');
    toast.html('<p>'+ message +'</p>');
    toast.slideToggle();
    setTimeout(function(){
        toast.slideToggle('slow');    
    }, 3000);
}
function getCookie(name) {
  var value = "; " + document.cookie;
  var parts = value.split("; " + name + "=");
  if (parts.length == 2) return parts.pop().split(";").shift();
}

/*jslint browser: true*/
/* global $, jQuery, alert, ENVIRONMENT, initializeCalendar, initializeHomePage,
    summernote, initFormsFunctionality, printPDFInitialize, initProcessFormFunctionality, initializeFormActions,
    initializeBookmarkFn*/
$(document).ready(function () {
    "use strict";
    
    var urlPathname = window.location.pathname;
    $('[data-toggle="tooltip"]').tooltip();   
    
    /* ================================================================= 
         goTo Function
     ================================================================= */
    
    (function($) {
        $.fn.goTo = function() {
            $('html, body').animate({
                scrollTop: $(this).offset().top + 'px'
            }, 'fast');
            return this; // for chaining...
        }
    })(jQuery);
    
    /* ================================================================= 
         Process Content Editing - Summernote
     ================================================================= */
     
    summernote.initialize();
    
    /* ================================================================= 
         Settings sidebar selects and header dropdowns click change
     ================================================================= */
     
    function changeOnSelectFn() {
        var ctrySl = $('#countries-filter-select option:selected');
        var depSl = $('#department-selected-on-header');
        var buSl = $('#business-unit-filter-select option:selected');
        var langSl = $('#country-selected-on-header');
        
        window.location.href = window.location.origin + window.location.pathname +
                                '?c=' + encodeURIComponent(ctrySl.val()) + 
                                '&d=' + encodeURIComponent(depSl.data('code')) + 
                                '&b=' + encodeURIComponent(buSl.val()) +
                                '&lang=' + encodeURIComponent(langSl.data('code'));
    }
    
    $('#countries-filter-select').change(changeOnSelectFn);
    $('#departments-filter-select').change(changeOnSelectFn);
    $('#business-unit-filter-select').change(changeOnSelectFn);
    $('.language-dropdown-header').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        var langSl = $('#country-selected-on-header');
        langSl.text($(this).text());
        langSl.attr('data-code', $(this).data('code'));
        changeOnSelectFn();
    });
    $('.department-dropdown-header').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        var deptSl = $('#department-selected-on-header');
        deptSl.text($(this).text());
        deptSl.attr('data-code', $(this).data('code'));
        changeOnSelectFn();
    });
    
    
    /* ================================================================= 
         Index functions
     ================================================================= */
    
    initializeHomePage();
    
    /* ================================================================= 
         Change Skin to light yellow
     ================================================================= */
    
    var mySkins = ['skin-yellow-light', 'skin-blue', 'skin-black', 'skin-red', 'skin-yellow', 'skin-purple', 'skin-green', 
    'skin-blue-light', 'skin-black-light', 'skin-red-light','skin-purple-light', 'skin-green-light'];
    $.each(mySkins, function (i) { $('body').removeClass(mySkins[i]) });
    $('body').addClass('skin-yellow-light');
    
    /* ================================================================= 
         Character counters for text areas
     ================================================================= */
    
    $('.textarea-restricted').keyup(function() {
        var msge = $('.characters-left-counter'),
            max = 200,
            len = $(this).val().length;
            
        msge.removeClass('hidden');
        
        if (len >= max) {
            msge.text(len + ': you have reached the limit');
        } else {
            var char = max - len;
            msge.text(char + ' characters left');
        }
    });
    // $('.note-editable.panel-body').
    // $('.note-editable.panel-body').html().length - 500
    
    /* ================================================================= 
         Calendar Render for tasks
     ================================================================= */
     
    if (urlPathname === '/tasks') {
        initializeCalendar();
    }
     
    /* ================================================================= 
        Notice messages                            
     ================================================================= */
    var notice = $('#notice'); 
    if (!(notice && notice.find('p').length && notice.find('p').text() === '')) {
        notice.toggle();
        setTimeout(function() {
            notice.slideToggle();
        }, 3000);
    }
    
     
    /* ================================================================= 
        Entities form Submit
    ================================================================= */
    if ((contains(urlPathname, '/roles/') && (contains(urlPathname, 'edit') || contains(urlPathname, 'new'))) ||
        (contains(urlPathname, '/process_lts/') && (contains(urlPathname, 'edit') || contains(urlPathname, 'new'))) ||
        (contains(urlPathname, '/quality_tips/') && (contains(urlPathname, 'edit') || contains(urlPathname, 'new'))) ||
        (contains(urlPathname, '/tasks/') && (contains(urlPathname, 'edit') || contains(urlPathname, 'new'))) ||
        (contains(urlPathname, '/roles/duplicate/') || contains(urlPathname, '/process_lts/duplicate/') || contains(urlPathname, '/tasks/duplicate/'))) {
        
        initFormsFunctionality(urlPathname);
        $('.select2').select2({ placeholder: "Select..." });
        // Duplicating entity
        if (contains(urlPathname, '/duplicate/')) {
            form.roles.multi.select2();
            form.processes.multi.select2();
            form.tasks.multi.select2();
        }
    }
    
    /* ================================================================= 
        Print Page
    ================================================================= */
    
    $('.print-btn-on-header').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        printPDFInitialize();
    });
    
    /* ================================================================= 
        Tasks to be done in any day not specified.
    ================================================================= */
    
    // jQuery UI sortable for the todo list
    $('.todo-list').sortable({
        placeholder: 'sort-highlight',
        handle: '.handle',
        forcePlaceholderSize: true,
        zIndex: 999999
    });
    
    /* ================================================================= 
        Initialize specific functionalities on forms
    ================================================================= */
    
    if (contains(urlPathname, '/process_lts/') && (contains(urlPathname, 'edit') || contains(urlPathname, 'new'))) {
        initProcessFormFunctionality();
    }
    
    if (contains(urlPathname, '/tasks/') && (contains(urlPathname, 'edit') || contains(urlPathname, 'new'))) {
        initializeFormActions();
    }
    
    /* ================================================================= 
        Initialize bookmark functionality
    ================================================================= */
    if (contains(urlPathname, '/roles/') || 
        contains(urlPathname, '/process_lts/') ||
        contains(urlPathname, '/tasks/')) {
        initializeBookmarkFn();
    }
    
    
    /* ================================================================= 
        Initialize data tables on 
    ================================================================= */
    $('.data-table-listing').DataTable({
        'paging'      : true,
        'lengthChange': true,
        'searching'   : true,
        'ordering'    : true,
        'info'        : true,
        'autoWidth'   : false
      });
      
      
    /* ================================================================= 
        Custom JQuery styles changes
    ================================================================= */  
    $('td:has(.fa)').css('text-align', 'center');
    
    
    /* ================================================================= 
        List entities that need to be translated
    ================================================================= */  
    if (getCookie('language_code') == 'en' && 
        (contains(urlPathname, '/roles_admin') || 
        contains(urlPathname, '/process_lts_admin') || 
        contains(urlPathname, '/tasks_admin'))) {
        
        $('.lang-select').change(function(e) {
            var $target = $(e.target);
            var arrowBtn = $target.parent().parent().find('.duplicate-btn');
            var oldUrlSplit = arrowBtn.attr('href').split('/');
            oldUrlSplit[oldUrlSplit.length - 1] = $target.val();
            arrowBtn.attr('href', oldUrlSplit.join('/'));
        });
    }
});

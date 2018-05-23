/*global $, ajaxCall, _*/
function initializeHomePage() {
    var $processBox = $('.index-processes-box');
    var $roleBox = $('.index-roles-box');
    
    var $clickableRow = $(".clickable-row");
    var $clickableRowForRelated = $(".click-to-highlight-related");
    
    var $taskBox = $('.index-small-boxes-home-page .bg-yellow');
    var $qtBox = $('.index-small-boxes-home-page .bg-gray');
    
    $processBox.click(function() {
        window.location.href = '/listing/process_lts'
    });
    
    $roleBox.click(function() {
        window.location.href = '/listing/roles'
    });
    
    $taskBox.click(function() {
        window.location.href = '/tasks'
    });
    $qtBox.click(function() {
        window.location.href = '/quality_tips'
    });
    
    $clickableRow.click(function() {
        window.location = $(this).data("href");
    });
    
    $clickableRowForRelated.click(function() {
        var id = $(this).data("id");
        var type = $(this).data("type");
        var roles = $(this).data("roles");
        var processes = $(this).data("processes");
        var tasks = $(this).data("tasks");
        
        $('.role').find('tr').css('background-color', 'transparent');
        $('.process_lt').find('tr').css('background-color', 'transparent');
        $('.task').find('tr').css('background-color', 'transparent');
        
        $(this).css('background-color', 'lightgray');
        
        highlightRelated(roles, '.role');
        highlightRelated(processes, '.process_lt');
        highlightRelated(tasks, '.task');
    });
}

function highlightRelated(list, type) {
    _.each(list, function(itemId) {
        $(type).find('[data-id="{0}"]'.format([itemId])).css('background-color', 'gray');
    });
}
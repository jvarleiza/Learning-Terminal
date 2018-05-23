/*global $, _, ajaxCall, showMessage */
function initializeBookmarkFn() {
    $('.bookmark-star').click(function (e) {
        e.preventDefault();
        var $this = $(this).find("a > i");
        var $bookmarkInfo = $('#bookmark-info');
        
        var user = $bookmarkInfo.data('user');
        var entityId = $bookmarkInfo.data('id');
        var entityType = $bookmarkInfo.data('type');
        
        $this.toggleClass("fa-star");
        $this.toggleClass("fa-star-o");
        
        if ($this.hasClass('fa-star')) {
          addBookmark(user, entityType, entityId);
        } else {
          removeBookmark(user, entityType, entityId);
        }
    });
}

function addBookmark(user, entityType, entityId) {
     ajaxCall('/bookmarks', 'POST', 'json', {
        user: user,
        entId: entityId,
        entType: entityType
      }, function(data) {
        showMessage('Successfully added to bookmarks');
      }, function(err) {
        console.log(err.responseText);
      });
}

function removeBookmark(user, entityType, entityId) {
    ajaxCall('/bookmarks/1', 'PUT', 'json', {
        user: user,
        entId: entityId,
        entType: entityType
      }, function(data) {
        showMessage('Successfully removed from bookmarks');
      }, function(err) {
        console.log(err.responseText);
      });
}


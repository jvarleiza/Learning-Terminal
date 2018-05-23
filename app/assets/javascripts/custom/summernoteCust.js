/* global $ */
var summernote = {
    initialize: function() {
        var summernoteSelector = $('#summernote');
        if (summernoteSelector.length) {
            summernoteSelector.summernote({
                height: 300,
                callbacks: {
                    onKeyup: function(e) {
                        var html = summernoteSelector.summernote('code').replace(/'/g, "\\'").trim(),
                            msge = $('#summernote-counter'),
                            max = 1000,
                            len = html.length;
                            
                        if (len >= max) {
                            msge.text(len + ': you have reached the limit');
                        } else {
                            var char = max - len;
                            msge.text(char + ' characters left');
                        }
                    }
                }
            });
            var markupStr = $('#process_lt_content').val();
            summernoteSelector.summernote('code', markupStr);
        }
        
        $('#saveSummernote').click(function onSaveClickFn() {
            var html = summernoteSelector.summernote('code').replace(/'/g, "\\'").trim();
            $('#process_lt_content').val(html)
            backSummernote();
        });
        
        function backSummernote() {
          summernoteSelector.summernote('destroy');
          $('.edit-mode').css('display','inline-block');
          $('.save-mode').css('display','none');
        };
        
        $("#backSummernote").click(function backSummernoteFn() {
            backSummernote();
        });
        
        $("#editSummernote").click(function editSummernoteFn() {
            summernoteSelector.summernote({
              focus: true,
              height: 500
            });
            $('.edit-mode').css('display','none');
            $('.save-mode').css('display','inline-block');
        });
    }
};
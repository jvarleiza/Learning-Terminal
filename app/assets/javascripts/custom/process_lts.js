/*global $*/
function initProcessFormFunctionality() {
    $('#video-url-1').keyup(keyUpFn);
    $('#video-url-2').keyup(keyUpFn);
    $('#video-url-3').keyup(keyUpFn);
    $('#video-url-4').keyup(keyUpFn);
}

function keyUpFn(e) {
    var videos = [];
    var v1 = getVideoId($('#video-url-1').val());
    var v2 = getVideoId($('#video-url-2').val());
    var v3 = getVideoId($('#video-url-3').val());
    var v4 = getVideoId($('#video-url-4').val());
    if (v1) videos.push(v1);
    if (v2) videos.push(v2);
    if (v3) videos.push(v3);
    if (v4) videos.push(v4);
    $('#process_lt_embeded_video').val(videos.join('@@'));
}

function getVideoId(url) {
    var urlSplit = url.split('/');
    return urlSplit[urlSplit.length - 1];
}
// bytesconv.js
.pragma library

function bytesToSize(bytes) {
    var sizes = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    if (bytes == 0) return 'n/a';
    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
    if (i == 0) { return (bytes / Math.pow(1024, i)) + ' ' + sizes[i]; }
    return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
}

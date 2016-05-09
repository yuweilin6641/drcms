$(function () {
    $('#fileupload').fileupload({
        dataType: 'json',
        
        done: function (e, data) {
            $.each(data.result, function (index, file) {
                    
                    
                $("#uploaded-files").append(
                                $('<tr/>')
                                .append($('<td/>').text(file.fileName))
                                .append($('<td/>').text(file.fileSize))
                                .append($('<td/>').text(file.mimeType))
                                .append($('<td/>').html("<a href='/wissue/fileController/get/"+index+"'>Click</a>"))
                                )//end $("#uploaded-files").append()
            }); 
        },
        
        progressall: function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('#progress .bar').css(
                    'width',
                    progress + '%'
                );
                   },
                   
                dropZone: $('#dropzone')
    });
});
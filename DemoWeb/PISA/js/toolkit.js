$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "http://140.112.106.232:17777/queryId",
        data: {
            'name': url('?name')
            //'0x2ecc452e01f748183d697be4cb1db0531cc8f38f'
        },
        dataType: "json",
        success: function(data) {
            if(data.text != '')
                $("#ad_block").append('<img class="d-block img-fluid w-100" src="' + data.text + '" alt="">');
            else
                $("#ad_block").append('<img class="d-block img-fluid w-100" src="img/slide-1.jpg" alt="">');
        },
        error: function() {
            $("#ad_block").append('<img class="d-block img-fluid w-100" src="img/slide-1.jpg" alt="">');
        }
    })
});
$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "http://localhost:8899/rest_pdogs",
        data: {
            'website':'IMProjectDEMO'
        },
        dataType: "json",
        success: function(data) {
            $("#ad_block_1").append('<p>' + data.text + '</p>');
        },
        error: function() {
            $("#ad_block_1").append("<p>ERROR</p>");
            alert("Error : No response.");
        }
    })
});

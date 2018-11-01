function save() {
    $.notify("✔ با موفقیت انجام شد", {
        className: 'success',
        clickToHide: false,
        autoHide: true,
        position: 'bottom center'
    });
}
function cancel() {
    $.notify("☓ خطا در ورود اطاعات", {
        className: 'error',
        clickToHide: false,
        autoHide: true,
        position: 'bottom center'
    });
}
var modall = document.getElementById('aboutUsmodal');
var btnn = document.getElementById('aboutUs');
var spann = document.getElementById('closeAboutUs');
btnn.onclick = function () {
    modall.style.display = "block";
}
spann.onclick = function () {
    modall.style.display = "none";
}
var modal = document.getElementById('contactUsmodal');
var btn = document.getElementById('ContactUs');
var span = document.getElementById('closeContactUs');
btn.onclick = function () {
    modal.style.display = "block";
}
span.onclick = function () {
    modal.style.display = "none";
}
$('#txtName').focus(function () { $('#lblName').animate({ 'right': '35px' }); $('#lblName').css({ 'color': '#43383e' }) });
$('#txtEmail').focus(function () { $('#lblEmail').animate({ 'right': '-10px' }); $('#lblEmail').css({ 'color': '#43383e' }) });
$('#txtPhone').focus(function () { $('#lblPhone').animate({ 'right': '-10px' }); $('#lblPhone').css({ 'color': '#43383e' }) });
$('#txtMessage').focus(function () { $('#lblMessage').animate({ 'right': '35px' }); $('#lblMessage').css({ 'color': '#43383e' }) });
$('#txtName').blur(function () {
    if ($('#txtName').val() == '') {
        $('#lblName').animate({ 'right': '80px' });
        $('#lblName').css({ 'color': '#888888' });
    }
});
$('#txtEmail').blur(function () {
    if ($('#txtEmail').val() == '') {
        $('#lblEmail').animate({ 'right': '85px' });
        $('#lblEmail').css({ 'color': '#888888' });
    }
});
$('#txtPhone').blur(function () {
    if ($('#txtPhone').val() == '') {
        $('#lblPhone').animate({ 'right': '85px' });
        $('#lblPhone').css({ 'color': '#888888' });
    }
});
$('#txtMessage').blur(function () {
    if ($('#txtMessage').val() == '') {
        $('#lblMessage').animate({ 'right': '80px' });
        $('#lblMessage').css({ 'color': '#888888' });
    }
});
$('#txtEmail').on('keyup', function () {
    var pattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;
    var email = $('#txtEmail').val();
    if (email.match(pattern) == null) {
        $('#emailValidation').attr('class', 'fa fa-remove');
    } else {
        $('#emailValidation').attr('class', 'fa fa-check');
    }
});

$('#txtPhone').on('keyup', function () {
    var phone = $('#txtPhone').val();
    if (phone.length != 11) {
        $('#phoneValidation').attr('class', 'fa fa-remove');
    } else {
        $('#phoneValidation').attr('class', 'fa fa-check');
    }
});
$('#txtName').on('keyup', function () {
    var name = $('#txtName').val();
    if (name.length == '') {
        $('#nameValidation').attr('class', 'fa fa-remove');
    } else {
        $('#nameValidation').attr('class', 'fa fa-check');
    }
});
$('#txtMessage').on('keyup', function () {
    var message = $('#txtMessage').val();
    if (message.length == '') {
        $('#messsageValidateion').attr('class', 'fa fa-remove');
    } else {
        $('#messsageValidateion').attr('class', 'fa fa-check');
    }
});
$("#btnSend").click(function () {
    var name = $('#txtName').val();
    var phone = $('#txtPhone').val();
    var message = $('#txtMessage').val();
    var email = $('#txtEmail').val();
    if (name != '' && phone != '' && message != '' && email != '') {
        sendEmail();
    } else {
        $('#lblWarning').fadeIn(50);
        $('#lblWarning').animate({ 'bottom': '27px' });
        $('#lblWarning').html('لطفا فیلدهای خالی را پر کنید!');
        $('#lblWarning').css({ 'color': 'red' });
        setInterval(function () { myTimer() }, 2000);
    }
    if ($('#nameValidation').hasClass('fa fa-check') && $('#phoneValidation').hasClass('fa fa-check')
        && $('#emailValidation').hasClass('fa fa-check') && $('#messsageValidateion').hasClass('fa fa-check')) {
        sendEmail();
    } else {
        $('#lblWarning').fadeIn(50);
        $('#lblWarning').animate({ 'bottom': '27px' });
        $('#lblWarning').html('لطفا فیلدهای خالی را پر کنید!');
        $('#lblWarning').css({ 'color': 'red' });
        setInterval(function () { myTimer() }, 2000);
    }
    function sendEmail() {
        $('#btnSend').animate({ 'padding-left': '55px', 'padding-right': '15px' });
        $('#imgLoading').fadeIn(10);
        var namee = $('#txtName').val();
        var phonee = $('#txtPhone').val();
        var messagee = $('#txtMessage').val();
        var emaill = $('#txtEmail').val();
        $.ajax({
            type: "POST",
            url: "WebService.asmx/Send",
            data: "{ name : '" + namee + "' , phone : '" + phonee + "' " +
            ", message : '" + messagee + "' , email : '" + emaill + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                if (data.d == "0") {
                    $('#btnSend').animate({ 'padding-left': '35px', 'padding-right': '35px' });
                    $('#imgLoading').fadeOut(10);
                    $('#lblWarning').fadeIn(50);
                    $('#lblWarning').animate({ 'bottom': '27px' });
                    $('#lblWarning').html('** خطا در ارسال ایمیل **');
                    $('#lblWarning').css({ 'color': 'red' });
                    setInterval(function () { myTimer(); }, 2000);
                }
                if (data.d == "1") {
                    $('#btnSend').animate({ 'padding-left': '35px', 'padding-right': '35px' });
                    $('#imgLoading').fadeOut(10);
                    $('#lblWarning').fadeIn(50);
                    $('#lblWarning').animate({ 'bottom': '27px' });
                    $('#lblWarning').html('با موفقیت ارسال شد.');
                    $('#lblWarning').css({ 'color': 'green' });
                    setInterval(function () { myTimer(); }, 2000);
                    $('#txtName').val('');
                    $('#txtPhone').val('');
                    $('#txtMessage').val('');
                    $('#txtEmail').val('');
                    $('#nameValidation').removeClass();
                    $('#phoneValidation').removeClass();
                    $('#messsageValidateion').removeClass();
                    $('#emailValidation').removeClass();   
                }
            },
            error: function () {
                $('#btnSend').animate({ 'padding-left': '35px', 'padding-right': '35px' });
                $('#imgLoading').fadeOut(10);
                $('#lblWarning').fadeIn(50);
                $('#lblWarning').animate({ 'bottom': '27px' });
                $('#lblWarning').html('** خطا در ارسال ایمیل **');
                $('#lblWarning').css({ 'color': 'red' });
                setInterval(function () { myTimer(); }, 3000);
            }
        });
    }
    function myTimer() {
        $('#lblWarning').animate({ 'bottom': '0px' });
        $('#lblWarning').fadeOut(200);
    }
});
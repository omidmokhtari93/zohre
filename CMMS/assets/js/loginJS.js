$(function () {
  var widthh = $(window).width();
  widthh = (widthh / 2) + 25;
  $('#pnl_login').animate({ 'left': widthh }, { duration: 2000, easing: "easeOutBack" });
});
function validation() { $('#loading').show(); }
$("#showPassword").click(function () {
  var x = document.getElementById("Password");
  if (x.type === "password") {
    x.type = "text";
    $("#showPassword").attr('class', 'fa fa-eye-slash');
  } else {
    x.type = "password";
    $("#showPassword").attr('class', 'fa fa-eye');
  }
});
$('#UserName').focus(function () { $(this).val(''); });
$('#Password').click(function () { $(this).val(''); });
$('#txtEmailAddress').on('keyup', function () {
  var pattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;
  var email = $('#txtEmailAddress').val();
  if (email.match(pattern) == null) {
    $('#emailValidation').css('color', 'red');
    $('#emailValidation').attr('class', 'fa fa-exclamation');
  } else {
    $('#emailValidation').css('color', 'green');
    $('#emailValidation').attr('class', 'fa fa-check');
  }
});

$('#txtPhoneNumber').on('keyup', function () {
  var phone = $('#txtPhoneNumber').val();
  if (phone.length != 11) {
    $('#phoneValidation').css('color', 'red');
    $('#phoneValidation').attr('class', 'fa fa-exclamation');
  } else {
    $('#phoneValidation').css('color', 'green');
    $('#phoneValidation').attr('class', 'fa fa-check');
  }
});
$('#pnl_login').keypress(function (e) {
  if (e.keyCode == '13') {
    $(this).find('#btnLogin').click();
  }
});
function auth(ele) {
  $('#loginloading').show();
  var username = $('#UserName').val();
  var password = $('#Password').val();
  $.ajax({
    type: 'POST',
    url: 'WebService.asmx/Authentication',
    data: JSON.stringify({ 'username': username, 'password': password }),
    contentType: 'application/json;',
    dataType: 'json',
    success: function (e) {
      var data = JSON.parse(e.d);
      if (data.flag === 0) {
        $(ele).notify(data.message, { position: "bottom center", className: "error" });
        $('#loginloading').hide();
      } else {
        $('#loginloading').hide();
        window.location.replace(data.message);
      }
    },
    error: function () {
      console.log('error');
    }
  });
}
function SendMail(ele) {
  if ($('#txtEmailAddress').val() == '' || $('#txtPhoneNumber').val() == '') {
    $(ele).notify('!!لطفا فیلدهای ورودی را بررسی نمایید', { position: "bottom center", className: "error" });
    return;
  }
  $('#Emailloading').show();
  var email = $('#txtEmailAddress').val();
  var phone = $('#txtPhoneNumber').val();
  $.ajax({
    type: 'POST',
    url: 'WebService.asmx/SendUserAndPass',
    data: JSON.stringify({ 'email': email, 'phone': phone }),
    contentType: 'application/json;',
    dataType: 'json',
    success: function (e) {
      var data = JSON.parse(e.d);
      if (data.flag === 0) {
        $(ele).notify(data.message, { position: "bottom center", className: "error" });
        $('#Emailloading').hide();
      } else {
        $(ele).notify(data.message, { position: "bottom center", className: "success" });
        $('#Emailloading').hide();
      }
    },
    error: function () {
      console.log('error');
    }
  });
}
function RememberPassword() {
  $('#pnl_login').hide();
  $('#pnlForgetPassword').fadeIn();
}

function login() {
  $('#pnl_login').fadeIn();
  $('#pnlForgetPassword').hide();
}

$('.input-container').on('click', function (e) {
  if ($(this).find('input').attr('id') == 'UserName') {
    $('#UserName').focus();
  } else {
    if (e.target.id != 'showPassword') {
      $('#Password').focus();
    }
  }
});
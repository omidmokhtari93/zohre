
$("#btnSend").click(function () {
  if (!Checkinputs('contactinputarea')) {
    sendEmail();
  } else {
    RedAlert('n', 'لطفا فیلدهای خالی را تکمیل نمایید')
  }
  function sendEmail() {
    $('#loading').show();
    AjaxData({
      url: "WebService.asmx/Send",
      param: {
        name: $('#txtName').val(),
        phone: $('#txtPhone').val(),
        message: $('#txtMessage').val(),
        email: $('#txtEmail').val()
      },
      func: messageStatus
    })

    function messageStatus(data) {
      if (data.d == "0") {
        RedAlert('n', 'خطا در ارسال ایمیل');
        $('#loading').hide();
      }
      if (data.d == "1") {
        GreenAlert('n', 'ایمیل با موفقیت ارسال شد');
        $('#loading').hide();
        ClearFields('contactinputarea');
      }
    }
  }
});
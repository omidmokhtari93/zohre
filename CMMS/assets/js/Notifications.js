$(document).ready(function() {
    setInterval(function() {
        var data = [];
        data.push({
            url: 'WebService.asmx/CheckReminders',
            parameters: [],
            func: createNotify
        });
        AjaxCall(data);
        function createNotify(e) {
            if (e.d === "0") {
                return;
            } else {
                NotifyMe();
            }
        }
    }, 60000);
});

function NotifyMe() {
    $.notify.addStyle('foo', {
        html:
            "<div>" +
                "<div class='clearfix'>" +
                "<div class='title' data-notify-html='title'/>" +
                "<div class='buttons'>" +
                "<button class='no'>مشاهده</button>" +
                "<button class='yes' data-notify-text='button'></button>" +
                "</div>" +
                "</div>" +
                "</div>"
    });
    $(document).on('click', '.notifyjs-foo-base .no', function () {
        $(this).trigger('notify-hide');
    });
    $(document).on('click', '.notifyjs-foo-base .yes', function () {
        alert($(this).text() + " clicked!");
        $(this).trigger('notify-hide');
    });
    $.notify({
        title: 'یادآوری گزارش کارها',
        button: 'انصراف'
    }, {
        style: 'foo',
        autoHide: false,
        clickToHide: false,
        position: 'bottom right'
    });
    $('.title').append(' ' + JalaliDateTime() + ' ');
}
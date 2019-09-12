var remindId = 0;
var tarikh = '';
$(document).ready(function () {
    setInterval(function () {
        AjaxData({
            url: 'WebService.asmx/CheckReminders',
            param: {},
            func: createNotify
        });
        function createNotify(e) {
            if (e.d === "0") {
                return;
            } else {
                var data = JSON.parse(e.d);
                remindId = data.id;
                tarikh = data.tarikh;
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
            "<button class='yes'>مشاهده</button>" +
            "<button class='no' data-notify-text='button'></button>" +
            "</div>" +
            "</div>" +
            "</div>"
    });
    $(document).on('click', '.notifyjs-foo-base .no', function () {
        $(this).trigger('notify-hide');
        updateReminder(true);
    });
    $(document).on('click', '.notifyjs-foo-base .yes', function () {
        $(this).trigger('notify-hide');
        updateReminder(false);
    });

    $.notify({
        title: 'یادآوری گزارش کارها',
        button: 'انصراف'
    }, {
            style: 'foo',
            autoHide: true,
            clickToHide: false,
            autoHideDelay: 10000,
            position: 'bottom right'
        });
    $('.title').append(' ' + tarikh + ' ');
}

function updateReminder(cancel) {
    AjaxData({
        url: 'WebService.asmx/UpdateReminders',
        param: { id: remindId },
        func: updated
    });

    function updated(e) {
        if (!cancel) {
            window.open("/DailyReportPrint?id=" + remindId,'_blank');
        } else {
            $(this).trigger('notify-hide');
        }
    }
}
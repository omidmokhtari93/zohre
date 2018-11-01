FillDailyReportTable();
var target_tr;
var Id;
var dailyData = [];
$(document).ready(function () {
    var customOptions = {
        placeholder: "روز / ماه / سال"
        , twodigit: true
        , closeAfterSelect: true
        , nextButtonIcon: "fa fa-arrow-circle-right"
        , previousButtonIcon: "fa fa-arrow-circle-left"
        , buttonsColor: "blue"
        , forceFarsiDigits: true
        , markToday: true
        , markHolidays: true
        , highlightSelectedDay: true
        , sync: true
        , gotoToday: true
    }
    kamaDatepicker('txtDate', customOptions);
    kamaDatepicker('txtRemindTime', customOptions);
});

function SaveDailyReport(id) {
    if ($('#txtReportExplain').val() == '') {
        RedAlert('txtReportExplain', '!!لطفا شرح گزارش را تکمیل نمایید');
        return;
    }
    dailyData.push({
        Date: $('#txtDate').val(),
        ReportProducer: $('#txtReportProducer').val(),
        ReportExplain: $('#txtReportExplain').val(),
        ReportTips: $('#txtReportTips').val(),
        RemindTime: $('#txtRemindTime').val(),
        Subject: $('#txtSubject').val()
    });
    $.ajax({
        type: "POST",
        url: "WebService.asmx/SaveDailyReport",
        data: JSON.stringify({ 'dailyDate': dailyData, 'editFlag': id }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function () {
            GreenAlert('no', '.با موفقیت ثبت شد');
            $('#gridDailyReport tbody').empty();
            FillDailyReportTable();
            CancelEditDaily();
        },
        error: function () {
            RedAlert('n', '!!خطا در ثبت');
            dailyData = [];
        }
    });
}

function FillDailyReportTable() {
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetDailyReport",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (e) {
            var data = JSON.parse(e.d);
            if (data.length > 0) {
                var header = '<tr>' +
                    '<th>ردیف</th>' +
                    '<th>تاریخ</th>' +
                    '<th>تهیه کننده</th>' +
                    '<th>شرح گزارش</th>' +
                    '<th>نکات مهم گزارش</th>' +
                    '<th>موضوع</th>' +
                    '<th>تاریخ یادآوری</th>' +
                    '<th></th>' +
                    '</tr>';
                $('#gridDailyReport tbody').append(header);
                for (var i = 0; i < data.length; i++) {
                    var body = '<tr>' +
                        '<td style="display:none;">' + data[i].Id + '</td>' +
                        '<td style="display:none;">' + data[i].Date + '</td>' +
                        '<td style="display:none;">' + data[i].ReportProducer + '</td>' +
                        '<td style="display:none;">' + data[i].ReportExplain + '</td>' +
                        '<td style="display:none;">' + data[i].ReportTips + '</td>' +
                        '<td style="display:none;">' + data[i].Subject + '</td>' +
                        '<td style="display:none;">' + data[i].RemindTime + '</td>' +
                        '<td>' + parseInt(i + 1) + '</td>' +
                        '<td>' + data[i].Date + '</td>' +
                        '<td>' + data[i].ReportProducer + '</td>' +
                        '<td>' + data[i].ReportExplain.substring(0, 20) + ' ...' + '</td>' +
                        '<td>' + data[i].ReportTips.substring(0, 15) + ' ...' + '</td>' +
                        '<td>' + data[i].Subject.substring(0, 15) + ' ...' + '</td>' +
                        '<td>' + data[i].RemindTime + '</td>' +
                        '<td><a id="edit">ویرایش</a></td>' +
                        '</tr>';
                    $('#gridDailyReport tbody').append(body);
                }
            }
        },
        error: function () {
            RedAlert('n', '!!خطا در دریافت اطلاعات');
        }
    });
}
$("#gridDailyReport").on("click", "tr a#edit", function () {
    $(target_tr).css('background-color', '');
    target_tr = $(this).parent().parent();
    $(target_tr).css('background-color', 'lightgreen');
    Id = $(this).parent().parent().find('td:eq(0)').text();
    $('#txtDate').val($(this).parent().parent().find('td:eq(1)').text());
    $('#txtReportProducer').val($(this).parent().parent().find('td:eq(2)').text());
    $('#txtReportExplain').val($(this).parent().parent().find('td:eq(3)').text());
    $('#txtReportTips').val($(this).parent().parent().find('td:eq(4)').text());
    $('#txtSubject').val($(this).parent().parent().find('td:eq(5)').text());
    $('#txtRemindTime').val($(this).parent().parent().find('td:eq(6)').text());
    $('#btnEdit').show();
    $('#btnCancel').show();
    $('#btnSave').hide();
});

function CancelEditDaily() {
    ClearFields('FormArea');
    $('#txtReportProducer').val('');
    $('#btnEdit').hide();
    $('#btnCancel').hide();
    $('#btnSave').show();
    $(target_tr).css('background-color', '');
    Id = 0;
    dailyData = [];
}
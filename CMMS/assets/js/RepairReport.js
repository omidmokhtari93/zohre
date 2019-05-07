$('#drunitreptime').on('change',function() {
        if ($('#drunitreptime :selected').val() !== '-1') {
            $('#drlinereptime').val('-1');
            $('#drfazreptime').val('-1');
        }
});
$('#drlinereptime').on('change', function () {
    if ($('#drlinereptime :selected').val() !== '-1') {
        $('#drunitreptime').val('-1');
        $('#drfazreptime').val('-1');
    }
});
$('#drfazreptime').on('change', function () {
    if ($('#drfazreptime :selected').val() !== '-1') {
        ('#drunitreptime').val('-1');
        $('#drlinereptime').val('-1');
    }
});
function CreateRepairTimeTable() {
    var data = [];
    var sDate = $('#txtRepairTimeStartDate').val();
    var eDate = $('#txtRepairTimeEndDate').val();
    var count = $('#txtRepairTimeCount').val();
    var drVal = $('#drRepiarTime :selected').val();
    var unitt = $('#drunitreptime :selected').val();
    var linee = $('#drlinereptime :selected').val();
    var fazz = $('#drfazreptime :selected').val();
    if (sDate == '' || eDate == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if ($('#drRepiarTime :selected').val() != '0' && (sDate === '' || eDate === '' || count === '')) {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
   
    $('#lblRepairTime').text($('#drRepiarTime :selected').text());
    if (drVal === '0') {
      AjaxData({
        url: 'Reports.asmx/TotalTimeRepStop',
        param: { line: linee, unit: unitt, faz: fazz, dateS: sDate, dateE: eDate },
        func: CreateTimeRepairTables
      })
    }
    if (drVal === '1') {
        AjaxData({
            url: 'Reports.asmx/MaxTimeRep_perMachine',
            param: { line: linee, unit: unitt, faz: fazz,dateS: sDate, dateE: eDate, count: count },
            func: CreateTimeRepairTables
        });
    }
    if (drVal === '2') {
        AjaxData({
            url: 'Reports.asmx/MaxTimeStop_perMachine',
            param: { line: linee, unit: unitt, faz: fazz, dateS: sDate, dateE: eDate, count: count },
            func: CreateTimeRepairTables
        });
    }
    if (drVal === '3') {
        AjaxData({
            url: 'Reports.asmx/MaxTimeRep_Detail',
            param: { line: linee, unit: unitt, faz: fazz, dateS: sDate, dateE: eDate, count: count },
            func: CreateTimeRepairTables
        });
    }
    if (drVal === '4') {
        AjaxData({
            url: 'Reports.asmx/MaxTimeStop_Detail',
            param: { line: linee, unit: unitt, faz: fazz,dateS: sDate, dateE: eDate, count: count },
            func: CreateTimeRepairTables
        });
    }
}

function CreateTimeRepairTables(e) {
    var data = JSON.parse(e.d);
    var body = [];
    $('#gridRepairTime tbody').empty();
    if (data.flag === 0) {
        body.push('<tr><th>مدت زمان توقفات(ساعت)</th><th>مدت زمان تعمیرات(ساعت)</th></tr>');
        body.push('<tr><td>' + data.Total[0][0] + '</td><td>' + data.Total[0][1] + '</td></tr>');
        $('#gridRepairTime tbody').append(body.join(''));
    }
    if (data.flag === 1) {
        body.push('<tr><th>نام دستگاه</th><th>کد دستگاه</th><th>مدت زمان تعمیر(ساعت)</th></tr>');
        for (var i = 0; i < data.Total.length; i++) {
            body.push('<tr>' +
                '<td>' + data.Total[i][0] + '</td>' +
                '<td>' + data.Total[i][1] + '</td>' +
                '<td>' + data.Total[i][2] + '</td>' +
                '</tr>');
        }

        $('#gridRepairTime tbody').append(body.join(''));
    }
    if (data.flag === 2) {
        body.push('<tr><th>نام دستگاه</th><th>کد دستگاه</th><th>مدت زمان توقف(ساعت)</th></tr>');
        for (i = 0; i < data.Total.length; i++) {
            body.push('<tr>' +
                '<td>' + data.Total[i][0] + '</td>' +
                '<td>' + data.Total[i][1] + '</td>' +
                '<td>' + data.Total[i][2] + '</td>' +
                '</tr>');
        }
        $('#gridRepairTime tbody').append(body.join(''));
    }
    if (data.flag === 3) {
        body.push('<tr><th>شماره درخواست</th><th>نام دستگاه</th><th>کد دستگاه</th><th>مدت زمان توقف(ساعت)</th><th>مدت زمان تعمیر(ساعت)</th><th>نوع درخواست</th></tr>');
        for (i = 0; i < data.Total.length; i++) {
            body.push('<tr>' +
                '<td>' + data.Total[i][0] + '</td>' +
                '<td>' + data.Total[i][1] + '</td>' +
                '<td>' + data.Total[i][2] + '</td>' +
                '<td>' + data.Total[i][3] + '</td>' +
                '<td>' + data.Total[i][4] + '</td>' +
                '<td>' + data.Total[i][5] + '</td>' +
                '</tr>');
        }
        $('#gridRepairTime tbody').append(body.join(''));
    }
    if (data.flag === 4) {
        body.push('<tr><th>شماره درخواست</th><th>نام دستگاه</th><th>کد دستگاه</th><th>مدت زمان توقف(ساعت)</th><th>مدت زمان تعمیر(ساعت)</th><th>نوع درخواست</th></tr>');
        for (i = 0; i < data.Total.length; i++) {
            body.push('<tr>' +
                '<td>' + data.Total[i][0] + '</td>' +
                '<td>' + data.Total[i][1] + '</td>' +
                '<td>' + data.Total[i][2] + '</td>' +
                '<td>' + data.Total[i][3] + '</td>' +
                '<td>' + data.Total[i][4] + '</td>' +
                '<td>' + data.Total[i][5] + '</td>' +
                '</tr>');
        }
        $('#gridRepairTime tbody').append(body.join(''));
    }
}

$('#drRepiarTime').on('change', function () {
    if ($('#drRepiarTime :selected').val() == '0') {
        $('#txtRepairTimeCount').attr('disabled', 'disabled');
    } else {
        $('#txtRepairTimeCount').removeAttr('disabled');
    }
});

$(document).ready(function () {
    kamaDatepicker('txtRepReqTypeStartDate', customOptions);
    kamaDatepicker('txtRepReqTypeEndDate', customOptions);
    kamaDatepicker('txtMostRepReqEndDate', customOptions);
    kamaDatepicker('txtMostRepReqStartDate', customOptions);  
    kamaDatepicker('txtMostDelaysEndDate', customOptions);
    kamaDatepicker('txtMostDelaysStartDate', customOptions);
    kamaDatepicker('txtRepairActionEndDate', customOptions);
    kamaDatepicker('txtRepairActionStartDate', customOptions);
    kamaDatepicker('txtRepairTimeEndDate', customOptions);
    kamaDatepicker('txtRepairTimeStartDate', customOptions);

    if ($('#drRepiarTime :selected').val() === '0') {
        $('#txtRepairTimeCount').attr('disabled', 'disabled');
    } else {
        $('#txtRepairTimeCount').removeAttr('disabled');
    }
});
//=================================================================Table 
function CreateTableForChart(data) {
    
    if ($('#RepReqTypes').hasClass('active')) {
        $('#gridRepReqTypes').empty();
        if (data.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نوع درخواست تعمیر</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data[i][0] + '</td>' +
                    '<td>' + data[i][1] + '</td>' +
                    '</tr>');
            }
            $('#gridRepReqTypes').append(body.join(''));
        }
    }
    if ($('#MostRepReq').hasClass('active')) {
        $('#gridMostRepReq').empty();
        if (data.Strings.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نام دستگاه</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.Strings.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data.Strings[i] + '</td>' +
                    '<td>' + data.Integers[i] + '</td>' +
                    '</tr>');
            }
            $('#gridMostRepReq').append(body.join(''));
        }
    }
    
    if ($('#RepairAction').hasClass('active')) {
        $('#gridRepairAction').empty();
        if (data.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>عملیات تعمیرکاری</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data[i][0] + '</td>' +
                    '<td>' + data[i][1] + '</td>' +
                    '</tr>');
            }
            $('#gridRepairAction').append(body.join(''));
        }
    }
    

}
//=================================================================


$('#drunitreqtype').on('change', function () {
    if ($('#drunitreqtype :selected').val() !== '-1') {
        $('#drlinereqtype').val('-1');
        $('#drfazreqtype').val('-1');
    }
});
$('#drlinereqtype').on('change', function () {
    if ($('#drlinereqtype :selected').val() !== '-1') {
        $('#drunitreqtype').val('-1');
        $('#drfazreqtype').val('-1');
    }
});
$('#drfazreqtype').on('change', function () {
    if ($('#drfazreqtype :selected').val() !== '-1') {
        $('#drunitreqtype').val('-1');
        $('#drlinereqtype').val('-1');
    }
});
function CreateRepReqChart() {
    var unitt = $('#drunitreqtype :selected').val();
    var linee = $('#drlinereqtype :selected').val();
    var fazz = $('#drfazreqtype :selected').val();
    var sDate = $('#txtRepReqTypeStartDate').val();
    var eDate = $('#txtRepReqTypeEndDate').val();
    if ($('#txtRepReqTypeEndDate').val() == '' || $('#txtRepReqTypeStartDate').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
   
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
  
    GetChartData({
        url: 'EmPmCm',
        param: {
            line: linee,
            unit: unitt,
            faz: fazz,
            dateS: $('#txtRepReqTypeStartDate').val(),
            dateE: $('#txtRepReqTypeEndDate').val()
        },
        element: 'RepReqTypeChart',
        header: 'نوع درخواست تعمیر',
        chartype: 'pie'
    });
}

function CreateMostRepReqChart() {
    var sDate = $('#txtMostRepReqStartDate').val();
    var eDate = $('#txtMostRepReqEndDate').val();
    if ($('#txtMostRepReqEndDate').val() == '' || $('#txtMostRepReqStartDate').val() == '' || $('#txtMostRepReqCount').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        lblkind: 'تعداد',
        url: 'MaxRequest',
        param: {
            count: $('#txtMostRepReqCount').val(),
            unit: $('#drunitrepreq :selected').val(),
            dateS: $('#txtMostRepReqStartDate').val(),
            dateE: $('#txtMostRepReqEndDate').val()
        },
        element: 'MostRepReqChart',
        header: 'بیشترین درخواست تعمیر',
        chartype: 'column'
    });
}



$('#drunitmostdelay').on('change', function () {
    if ($('#drunitmostdelay :selected').val() !== '-1') {
        $('#drlinemostdelay').val('-1');
        $('#drfazmostdelay').val('-1');
    }
});
$('#drlinemostdelay').on('change', function () {
    if ($('#drlinemostdelay :selected').val() !== '-1') {
        $('#drunitmostdelay').val('-1');
        $('#drfazmostdelay').val('-1');
    }
});
$('#drfazmostdelay').on('change', function () {
    if ($('#drfazmostdelay :selected').val() !== '-1') {
        $('#drunitmostdelay').val('-1');
        $('#drlinemostdelay').val('-1');
    }
});
function CreateMostDelaysChart() {
    var unitt = $('#drunitmostdelay :selected').val();
    var linee = $('#drlinemostdelay :selected').val();
    var fazz = $('#drfazmostdelay :selected').val();
    var sDate = $('#txtMostDelaysStartDate').val();
    var eDate = $('#txtMostDelaysEndDate').val();
   
    if ($('#txtMostDelaysEndDate').val() == '' || $('#txtMostDelaysStartDate').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        lblkind: 'تعداد',
        url: 'RDelay',
        param: {
            line: linee,
            unit: unitt,
            faz: fazz,
            dateS: $('#txtMostDelaysStartDate').val(),
            dateE: $('#txtMostDelaysEndDate').val()
        },
        element: 'MostDelaysChart',
        header: 'علت تاخیر',
        chartype: 'column'
    });

    AjaxData({
        url: 'Reports.asmx/TimeDelay',
        param: { line: linee,unit:unitt,faz:fazz, dateS: sDate, dateE: eDate },
        func: delay
    });

    function delay(e) {
        $('#gridDelayTime tbody').empty();
        var pc = JSON.parse(e.d);
        if (pc.length > 0) {
            var body = [];

            body.push('<tr><th>ردیف</th><th>نام ماشین</th><th>شماره درخواست</th><th>علت تاخیر</th><th>مدت زمان تاخیر(دقیقه)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
               body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][3] + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '</tr>');
            }

            $('#gridDelayTime tbody').append(body.join(''));
        }
        //$('#gridRequestCost').text(total + ' ریال ');
    }
}


$('#drunitrepaction').on('change', function () {
    if ($('#drunitrepaction :selected').val() !== '-1') {
        $('#drlinerepction').val('-1');
        $('#drfazrepction').val('-1');
    }
});
$('#drlinerepction').on('change', function () {
    if ($('#drlinerepction :selected').val() !== '-1') {
        $('#drunitrepaction').val('-1');
        $('#drfazrepction').val('-1');
    }
});
$('#drfazrepction').on('change', function () {
    if ($('#drfazrepction :selected').val() !== '-1') {
        $('#drunitrepaction').val('-1');
        $('#drlinerepction').val('-1');
    }
});
function CreateRepairActionChart() {
    var unitt = $('#drunitrepaction :selected').val();
    var linee = $('#drlinerepction :selected').val();
    var fazz = $('#drfazrepction :selected').val();
    var sDate = $('#txtRepairActionStartDate').val();
    var eDate = $('#txtRepairActionEndDate').val();
    
    if ($('#txtRepairActionStartDate').val() == '' || $('#txtRepairActionEndDate').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        url: 'Actrep',
        param: {
            line: linee,
            unit: unitt,
            faz: fazz,
            dateS: $('#txtRepairActionStartDate').val(),
            dateE: $('#txtRepairActionEndDate').val()
        },
        element: 'RepairActionChart',
        header: 'عملیات تعمیرکاری',
        chartype: 'pie'
    });
}
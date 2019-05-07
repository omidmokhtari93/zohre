$(document).ready(function () {
    kamaDatepicker('txtFailTypeStartDate', customOptions);
    kamaDatepicker('txtFailTypeEndDate', customOptions);   
    kamaDatepicker('txtMostFailsEndDate', customOptions);
    kamaDatepicker('txtMostFailsStartDate', customOptions);
    kamaDatepicker('txtSubStartDate', customOptions);
    kamaDatepicker('txtSubEndDate', customOptions);
    kamaDatepicker('txtPreFailStartDate', customOptions);
    kamaDatepicker('txtPreFailEndDate', customOptions);
});
//=================================================================Table 
function CreateTableForChart(data) {
    if ($('#FailTypes').hasClass('active')) {
        $('#gridFailTypes').empty();
        if (data.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نوع خرابی</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data[i][0] + '</td>' +
                    '<td>' + data[i][1] + '</td>' +
                    '</tr>');
            }
            $('#gridFailTypes').append(body.join(''));
        }
    }
    
    if ($('#MostFails').hasClass('active')) {
        $('#gridMostFails').empty();
        if (data.Strings.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>علت خرابی</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.Strings.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data.Strings[i] + '</td>' +
                    '<td>' + data.Integers[i] + '</td>' +
                    '</tr>');
            }
            $('#gridMostFails').append(body.join(''));
        }
    }
   
    if ($('#RepairSub').hasClass('active')) {
        $('#gridRepairSub').empty();
        if (data.Strings.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نام اجزاء</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.Strings.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data.Strings[i] + '</td>' +
                    '<td>' + data.Integers[i] + '</td>' +
                    '</tr>');
            }
            $('#gridRepairSub').append(body.join(''));
        }
    }

}
//=================================================================
$('#drunitfail').on('change', function () {
    if ($('#drunitfail :selected').val() !== '-1') {
        $('#drlinefail').val('-1');
        $('#drfazfail').val('-1');
    }
});
$('#drlinefail').on('change', function () {
    if ($('#drlinefail :selected').val() !== '-1') {
        $('#drunitfail').val('-1');
        $('#drfazfail').val('-1');
    }
});
$('#drfazfail').on('change', function () {
    if ($('#drfazfail :selected').val() !== '-1') {
        $('#drunitfail').val('-1');
        $('#drlinefail').val('-1');
    }
});
function CreateFailTypeChart() {
    var unitt = $('#drunitfail :selected').val();
    var linee = $('#drlinefail :selected').val();
    var fazz = $('#drfazfail :selected').val();
    var sDate = $('#txtFailTypeStartDate').val();
    var eDate = $('#txtFailTypeEndDate').val();
    if ($('#txtFailTypeEndDate').val() == '' || $('#txtFailTypeStartDate').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }

    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        url: 'Typefailreason',
        param: {
            line: linee,
            unit: unitt,
            faz: fazz,
            dateS: $('#txtFailTypeStartDate').val(),
            dateE: $('#txtFailTypeEndDate').val()
        },
        element: 'FailTypeChart',
        header: 'نوع خرابی',
        chartype: 'pie'
    });
}

$('#drunitmostfail').on('change', function () {
    if ($('#drunitmostfail :selected').val() !== '-1') {
        $('#drlinemostfail').val('-1');
        $('#drfazmostfail').val('-1');
    }
});
$('#drlinemostfail').on('change', function () {
    if ($('#drlinemostfail :selected').val() !== '-1') {
        $('#drunitmostfail').val('-1');
        $('#drfazmostfail').val('-1');
    }
});
$('#drfazmostfail').on('change', function () {
    if ($('#drfazmostfail :selected').val() !== '-1') {
        $('#drunitmostfail').val('-1');
        $('#drlinemostfail').val('-1');
    }
});

function CreateMostFailsChart() {
    var unitt = $('#drunitmostfail :selected').val();
    var linee = $('#drlinemostfail :selected').val();
    var fazz = $('#drlinemostfail :selected').val();
    var sDate = $('#txtMostFailsStartDate').val();
    var eDate = $('#txtMostFailsEndDate').val();

    if ($('#txtMostFailsEndDate').val() == '' || $('#txtMostFailsStartDate').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        lblkind: 'تعداد',
        url: 'Failreason',
        param: {
            line: linee,
            unit: unitt,
            faz: fazz,
            dateS: sDate,
            dateE: eDate
        },
        element: 'MostFailsChart',
        header: 'علت خرابی',
        chartype: 'column'
    });
}
$('#drunitrepsub').on('change', function () {
    if ($('#drunitrepsub :selected').val() !== '-1') {
        $('#drlinerepsub').val('-1');
        $('#drfazrepsub').val('-1');
    }
});
$('#drlinerepsub').on('change', function () {
    if ($('#drlinerepsub :selected').val() !== '-1') {
        $('#drunitrepsub').val('-1');
        $('#drfazrepsub').val('-1');
    }
});
$('#drfazrepsub').on('change', function () {
    if ($('#drfazrepsub :selected').val() !== '-1') {
        $('#drunitrepsub').val('-1');
        $('#drlinerepsub').val('-1');
    }
});
function CreateSubsystemChart() {
    var unitt = $('#drunitrepsub :selected').val();
    var linee = $('#drlinerepsub :selected').val();
    var fazz = $('#drfazrepsub :selected').val();
    var count = $('#txtSubCount').val();
    var sDate = $('#txtSubStartDate').val();
    var eDate = $('#txtSubEndDate').val();

    if ($('#txtSubEndDate').val() == '' || $('#txtSubStartDate').val() == '' || $('#txtSubCount').val() == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        lblkind: 'تعداد',
        url: 'Maxsubsystem',
        param: {
            line: linee,
            unit: unitt,
            faz: fazz,
            count: count,
            dateS: sDate,
            dateE: eDate
        },
        element: 'RepairsubChart',
        header: 'بیشترین خرابی اجزاء',
        chartype: 'column'
    });
}
function CreatePreFailTable() {
    var sDate = $('#txtPreFailStartDate').val();
    var eDate = $('#txtPreFailEndDate').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }

    AjaxData({
        url: 'Reports.asmx/PremanurelyFail',
        param: {dateS: sDate, dateE: eDate },
        func: premanturely
    });

    function premanturely(e) {
        $('#gridPreFail tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];

            body.push('<tr><th>ردیف</th><th>نام ماشین</th><th>نام قطعه</th><th>برنامه زمانی تعویض</th><th>تاریخ تعویض اجباری</th><th>علت خرابی</th><th>نکات مهم</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][3] + '</td>' +
                    '<td>' + pc[i][4] + '</td>' +
                    '<td>' + pc[i][5] + '</td>' +
                    '</tr>');
            }

            $('#gridPreFail tbody').append(body.join(''));
        }
       
    }
}


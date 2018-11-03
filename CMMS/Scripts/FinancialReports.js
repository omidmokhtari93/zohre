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
    kamaDatepicker('txtEndDatePersonelCost', customOptions);
    kamaDatepicker('txtStartDatePersonelCost', customOptions);
    kamaDatepicker('txtEndDateRepairCost', customOptions);
    kamaDatepicker('txtStartDateRepairCost', customOptions);
    kamaDatepicker('txtEndDateContractorCost', customOptions);
    kamaDatepicker('txtStartDateContractorCost', customOptions);
    kamaDatepicker('txtEndDateToolsCost', customOptions);
    kamaDatepicker('txtStartDateToolsCost', customOptions);
    kamaDatepicker('txtEndDateReqCost', customOptions);
    kamaDatepicker('txtStartDateReqCost', customOptions);
});
$('#drPersonelUnit').on('change', function () {
    if ($('#drPersonelUnit :selected').val() !== '-1') {
        $('#drPersonelLine').val('-1');
    }
});
$('#drPersonelLine').on('change', function () {
    if ($('#drPersonelLine :selected').val() !== '-1') {
        $('#drPersonelUnit').val('-1');
    }
});
function PersonelCost() {
    var linee = $('#drPersonelLine :selected').val();
    var unitt = $('#drPersonelUnit :selected').val();
    var sDate = $('#txtStartDatePersonelCost').val();
    var eDate = $('#txtEndDatePersonelCost').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
   
    var data = [];
    data.push({
        url: 'Reports.asmx/PersonleCost',
        parameters: [{line:linee,unit:unitt,dateS: sDate, dateE: eDate  }],
        func: personleCost
    });
    AjaxCall(data);

    function personleCost(e) {
        $('#gridPersonelCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];
            
            body.push('<tr><th>ردیف</th><th>نام پرسنل</th><th>شماره پرسنلی</th><th>هزینه(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '</tr>');
            }
           
            $('#gridPersonelCost tbody').append(body.join(''));
        }
        $('#lblPersonelCostTotal').text(total + ' ریال ');
    }
}
$('#drContractUnit').on('change', function () {
    if ($('#drContractUnit :selected').val() !== '-1') {
        $('#drContractLine').val('-1');
    }
});
$('#drContractLine').on('change', function () {
    if ($('#drContractLine :selected').val() !== '-1') {
        $('#drContractUnit').val('-1');
    }
});
function ContractorCost() {
    var linee = $('#drContractLine :selected').val();
    var unitt = $('#drContractUnit :selected').val();
    var sDate = $('#txtStartDateContractorCost').val();
    var eDate = $('#txtEndDateContractorCost').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
   
    var data = [];
    data.push({
        url: 'Reports.asmx/ContractorCost',
        parameters: [{ line: linee, unit: unitt,dateS: sDate, dateE: eDate }],
        func: contractorCostt
    });
    AjaxCall(data);

    function contractorCostt(e) {
        $('#gridContractorCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];
           
            body.push('<tr><th>ردیف</th><th>نام پیمانکار</th><th>هزینه(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '</tr>');
            }
           
            $('#gridContractorCost tbody').append(body.join(''));
        }
        $('#lblContractorCost').text(total + ' ریال ');
    }
}
$('#drToolsUnit').on('change', function () {
    if ($('#drToolsUnit :selected').val() !== '-1') {
        $('#drToolsLine').val('-1');
    }
});
$('#drToolsLine').on('change', function () {
    if ($('#drToolsLine :selected').val() !== '-1') {
        $('#drToolsUnit').val('-1');
    }
});
function ToolsCost() {
    var linee = $('#drToolsLine :selected').val();
    var unitt = $('#drToolsUnit :selected').val();
    var sDate = $('#txtStartDateToolsCost').val();
    var eDate = $('#txtEndDateToolsCost').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
   
    var data = [];
    data.push({
        url: 'Reports.asmx/ToolsCost',
        parameters: [{ line: linee, unit: unitt,dateS: sDate, dateE: eDate }],
        func: toolsCostt
    });
    AjaxCall(data);

    function toolsCostt(e) {
        $('#gridToolsCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];
           
            body.push('<tr><th>ردیف</th><th>نام قطعه</th><th>تعداد</th><th>فی</th><th>مبلغ کل(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][3] + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '</tr>');
            }
           
            $('#gridToolsCost tbody').append(body.join(''));
        }
        $('#lblToolsCost').text(total + ' ریال ');
    }
}
$('#drRepairUnit').on('change', function () {
    if ($('#drRepairUnit :selected').val() !== '-1') {
        $('#drRepairLine').val('-1');
    }
});
$('#drRepairLine').on('change', function () {
    if ($('#drRepairLine :selected').val() !== '-1') {
        $('#drRepairUnit').val('-1');
    }
});
function RepairCost() {
    var linee = $('#drRepairLine :selected').val();
    var unitt = $('#drRepairUnit :selected').val();
    var sDate = $('#txtStartDateRepairCost').val();
    var eDate = $('#txtEndDateRepairCost').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
   
    var data = [];
    data.push({
        url: 'Reports.asmx/TotalCost',
        parameters: [{ line: linee, unit: unitt,dateS: sDate, dateE: eDate }],
        func: repairCostt
    });
    AjaxCall(data);

    function repairCostt(e) {
        $('#gridRepairCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];
           
            body.push('<tr><th>ردیف</th><th>هزینه</th><th>مبلغ کل(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '</tr>');
            }
           
            $('#gridRepairCost tbody').append(body.join(''));
        }
        $('#lblRepairCost').text(total + ' ریال ');
    }
}
function RequestCost() {
    var count = $('#txtMosReqCount').val();
    var sDate = $('#txtStartDateReqCost').val();
    var eDate = $('#txtEndDateReqCost').val();
    if (sDate === '' || eDate === ''||count==='') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }

    var data = [];
    data.push({
        url: 'Reports.asmx/RequestCost',
        parameters: [{ count:count, dateS: sDate, dateE: eDate }],
        func: reqCost
    });
    AjaxCall(data);

    function reqCost(e) {
        $('#gridRequestCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];

            body.push('<tr><th>ردیف</th><th>نام ماشین</th><th>شماره درخواست</th><th>هزینه(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '</tr>');
            }

            $('#gridRequestCost tbody').append(body.join(''));
        }
        //$('#gridRequestCost').text(total + ' ریال ');
    }
}
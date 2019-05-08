$(document).ready(function () {
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
    kamaDatepicker('txtEndDateRStopCost', customOptions);
    kamaDatepicker('txtStartDateRStopCost', customOptions);
    kamaDatepicker('txtEndDatePrStopCost', customOptions);
    kamaDatepicker('txtStartDatePrStopCost', customOptions);
    
});
$('#drRepairUnit').change(function () {
    FilterMachineByUnit('drRepairUnit', 'drMachines');
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
   
    AjaxData({
      url: 'Reports.asmx/PersonleCost',
      param: { line: linee, unit: unitt, dateS: sDate, dateE: eDate },
      func: personleCost
    });

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
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
                    '</tr>');
            }
           
            $('#gridPersonelCost tbody').append(body.join(''));
        }
        $('#lblPersonelCostTotal').text(parseInt(total).toLocaleString() + ' ریال ');
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
   
    AjaxData({
      url: 'Reports.asmx/ContractorCost',
      param: { line: linee, unit: unitt, dateS: sDate, dateE: eDate },
      func: contractorCostt
    });

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
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
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
   
    AjaxData({
      url: 'Reports.asmx/ToolsCost',
      param: { line: linee, unit: unitt, dateS: sDate, dateE: eDate },
      func: toolsCostt
    });

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
                    '<td>' + parseInt(pc[i][1]).toLocaleString() + '</td>' +
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
                    '</tr>');
            }
           
            $('#gridToolsCost tbody').append(body.join(''));
        }
        $('#lblToolsCost').text(parseInt(total).toLocaleString() + ' ریال ');
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
        $('#drMachines').val('');
    }
});
function RepairCost() {
    var linee = $('#drRepairLine :selected').val();
    var unitt = $('#drRepairUnit :selected').val();
    var machinee = $('#drMachines').val();
    if (machinee === null)
        machinee = '-1';
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
   
    AjaxData({
      url: 'Reports.asmx/TotalCost',
      param: { line: linee, unit: unitt, machine: machinee, dateS: sDate, dateE: eDate },
      func: repairCostt
    });

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
                    '<td>' + pc[i][1].toLocaleString() + '</td>' +
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
                    '</tr>');
            }
           
            $('#gridRepairCost tbody').append(body.join(''));
        }
        $('#lblRepairCost').text(parseInt(total).toLocaleString() + ' ریال ');
        if ($('#drRepairUnit').val() !== '-1')
            var U = ' واحد '+$('#drRepairUnit :selected').text();
        else
            U = '';
        if ($('#drRepairLine').val() !== '-1')
            var L = $('#drRepairLine :selected').text();
        else
            L = '';
        if ($('#drMachines').val() !== '-1' && $('#drMachines').val() !=null )
            var M = ' ماشین ' +$('#drMachines :selected').text();
        else
            M = '';
        $('#lblTotalComment').text('گزاش هزینه تعمیرات  ' + U + L + M + '    از تاریخ:  ' + $('#txtStartDateRepairCost').val() + '   تا تاریخ:   ' + $('#txtEndDateRepairCost').val());
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
  
    AjaxData({
      url: 'Reports.asmx/RequestCost',
      param: { count: count, dateS: sDate, dateE: eDate },
      func: reqCost
    });

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
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
                    '</tr>');
            }

            $('#gridRequestCost tbody').append(body.join(''));
        }
        //$('#gridRequestCost').text(total + ' ریال ');
    }
}
$('#drRStopUnits').on('change', function () {
    if ($('#drRStopUnits :selected').val() !== '-1') {
        $('#drRStopLine').val('-1');
        $('#drRStopfaz').val('-1');
    }
});
$('#drRStopLine').on('change', function () {
    if ($('#drRStopLine :selected').val() !== '-1') {
        $('#drRStopUnits').val('-1');
        $('#drRStopfaz').val('-1');
    }
});
$('#drRStopfaz').on('change', function () {
    if ($('#drRStopfaz :selected').val() !== '-1') {
        $('#drRStopUnits').val('-1');
        $('#drRStopLine').val('-1');
    }
});
function RStopCost() {
    var linee = $('#drRStopLine :selected').val();
    var unitt = $('#drRStopUnits :selected').val();
    var fazz = $('#drRStopfaz :selected').val();
    var sDate = $('#txtStartDateRStopCost').val();
    var eDate = $('#txtEndDateRStopCost').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    AjaxData({
      url: 'Reports.asmx/RepairStopCost',
      param: { faz: fazz, line: linee, unit: unitt, dateS: sDate, dateE: eDate },
      func: rStopCostt
    });

    function rStopCostt(e) {
        $('#gridRStopCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];

            body.push('<tr><th>ردیف</th><th>ماشین</th><th>توقفات مکانیکی</th><th>توقفات برقی</th><th>مبلغ کل(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][3] + '</td>' +
                    '<td>' + parseInt(pc[i][2]).toLocaleString() + '</td>' +
                    '<td>' + parseInt(pc[i][1]).toLocaleString() + '</td>' +
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
                    '</tr>');
            }

            $('#gridRStopCost tbody').append(body.join(''));
        }
        $('#lblRStopCost').text(parseInt(total).toLocaleString() + ' ریال ');
    }
}
$('#drPrStopCostUnit').on('change', function () {
    if ($('#drPrStopCostUnit :selected').val() !== '-1') {
        $('#drPrStopCostLine').val('-1');
        $('#drPrStopCostFaz').val('-1');
    }
});
$('#drPrStopCostLine').on('change', function () {
    if ($('#drPrStopCostLine :selected').val() !== '-1') {
        $('#drPrStopCostUnit').val('-1');
        $('#drPrStopCostFaz').val('-1');
    }
});
$('#drPrStopCostFaz').on('change', function () {
    if ($('#drPrStopCostFaz :selected').val() !== '-1') {
        $('#drPrStopCostUnit').val('-1');
        $('#drPrStopCostLine').val('-1');
    }
});
function prStopCost() {
    var linee = $('#drPrStopCostLine :selected').val();
    var unitt = $('#drPrStopCostLine :selected').val();
    var fazz = $('#drPrStopCostFaz :selected').val();
    var sDate = $('#txtStartDatePrStopCost').val();
    var eDate = $('#txtEndDatePrStopCost').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
  
    AjaxData({
      url: 'Reports.asmx/ProductStopCost',
      param: { faz: fazz, line: linee, unit: unitt, dateS: sDate, dateE: eDate },
      func: prStopCostt
    });

    function prStopCostt(e) {
        $('#gridPrStopCost tbody').empty();
        var pc = JSON.parse(e.d);
        var total = 0;
        if (pc.length > 0) {
            var body = [];

            body.push('<tr><th>ردیف</th><th>ماشین</th><th>مبلغ کل(ریال)</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                total += parseInt(pc[i][0]);
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + parseInt(pc[i][0]).toLocaleString() + '</td>' +
                    '</tr>');
            }

            $('#gridPrStopCost tbody').append(body.join(''));
        }
        $('#lblPrStopCost').text(parseInt(total).toLocaleString() + ' ریال ');
    }
}
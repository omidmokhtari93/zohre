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
    kamaDatepicker('txtStartDate', customOptions);
    kamaDatepicker('txtEndDate', customOptions);
});
$('#drUnits').change(function () {
    if ($('#drUnits :selected').val() === '-1') {
        $('#drMachines').empty();
    } else {
        $.ajax({
            type: "POST",
            url: "WebService.asmx/FilterMachineOrderByLocation",
            data: "{loc : " + $('#drUnits :selected').val() + "}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (e) {
                var data = JSON.parse(e.d);
                $('#drMachines').empty();
                $('#drMachines').append($("<option></option>").attr("value", -1).text('انتخاب کنید'));
                for (var i = 0; i < data.length; i++) {
                    $('#drMachines').append($("<option></option>").attr("value", data[i].MachineId).text(data[i].MachineName));
                }
            },
            error: function () {
            }
        });
    }
});
function printDiv() {
    var divToPrint = document.getElementById('ReportArea');
    var newWin = window.open('', 'Print-Window');
    newWin.document.open();
    newWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
    newWin.document.close();
    setTimeout(function () { newWin.close(); }, 10);
}

function GetProgram() {
    var ss = $('#txtStartDate').val();
    var ee = $('#txtEndDate').val();
    var midd = $('#drMachines :selected').val();
    var unit = $('#drUnits :selected').val();
    var type = parseInt($('#drType :selected').val());
    var flag = 0;
    if (!CheckPastTime(ss, '12:00', ee, '12:00')) {
        RedAlert('no', 'تاریخ شروع باید بزرگتر از تاریخ پایان باشد');
        flag = 1;
    }
    if (unit === '-1') {
        RedAlert('drUnits', '!!لطفا نام واحد را انتخاب کنید');
        flag = 1;
    }
    if (midd === '-1') {
        RedAlert('drMachines', '!!لطفا ماشین را انتخاب کنید');
        flag = 1;
    }
    if (ee === '' || ss === '') {
        RedAlert('txtEndDate', '!!لطفا بازه زمانی را مشخص نمایید');
        RedAlert('txtStartDate', '');
        flag = 1;
    }
    if (flag === 0) {
        var data = [];
        data.push({
            url: 'Reports.asmx/GetPmControlProgram',
            parameters: [{ s: ss, e: ee, mid: midd ,opr : $('#drOpr :selected').val()}],
            func: createProgram
        });
        AjaxCall(data);
        function createProgram(e) {
            $('#pnlReportArea').show();
            $('#tblcontrols tbody').empty();
            $('#tbldates tbody').empty();
            $('#tblsubheader tbody').empty();
            $('#pStartDate').text(ss);
            $('#pEndDate').text(ee);
            $('#lblUnitName').text(' واحد ' + $('#drUnits :selected').text() + ' (' + $('#drMachines :selected').text() + ')');
            switch (type) {
            case 0:
                createDailyProgram(JSON.parse(e.d));
                break;
            case 1:
                createWeekOtherProgram(JSON.parse(e.d));
                break;
            case 2:
                createMonthlyProgram(JSON.parse(e.d));
                break;
            default:
                break;
            }

            function createDailyProgram(p) {
                var dates = DatesBetween2Date(ss, ee);
                var dailyLength = p.daily.length;
                var body = [];
                $('#tblsubheader tbody').append('<tr style="text-align: right;">' +
                    '<td style="width:40%;">نام مجری : </td>' +
                    '<td >دوره بازدید : روزانه</td>' +
                    '<td > نوع عملیات : '+$('#drOpr :selected').text()+'</td>' +
                    '</tr>');
                body.push('<tr><td colspan="5" style="background: #d6d5d5;text-align:center;">شرح بازدید , کنترل و سرویس</td></tr>');
                for (var i = 0; i < dailyLength; i++) {
                    body.push('<tr style="border:none;text-align:right;">' +
                        '<td style="width:35px;text-align:center;">' + parseInt(i + 1) + '</td>' +
                        '<td colspan="4">' + p.daily[i].ControlName + '</td><tr>');
                }
                $('#tblcontrols tbody').append(body.join(''));
                body = [];
                body.push('<tr><td style="background: #d6d5d5;text-align:center;" colspan="20">موارد کنترلی</td></tr>');
                body.push('<tr><td style="width:80px;text-align:center;">تاریخ بازدید</td>');
                for (var j = 0; j < dailyLength; j++) {
                    body.push('<td style="text-align:center;">' + parseInt(j + 1) + '</td>');
                }
                body.push('<td style="width:50%;text-align:center;">تاریخ و امضای مجری</td>');
                body.push('</tr>');
                $('#tbldates tbody').append(body.join(''));
                body = [];
                for (var k = 0; k < dates.length; k++) {
                    body.push('<tr><td style="padding:15px 5px">' + dates[k] + '</td>');
                    for (var m = 0; m < dailyLength; m++) {
                        body.push('<td style="padding:10px 5px;text-align:center;"><div class="square"></div></td>');
                    }
                    body.push('<td style="width:50%;"></td>');
                    body.push('</tr>');
                }
                $('#tbldates tbody').append(body.join(''));
            }

            function createWeekOtherProgram(p) {
                var body = [];
                var radif = 1;
                $('#tblsubheader tbody').append('<tr style="text-align: right;">' +
                    '<td style="width:40%;">نام مجری : </td>' +
                    '<td>دوره بازدید : هفتگی / متفرقه</td>' +
                    '<td > نوع عملیات : ' + $('#drOpr :selected').text() + '</td>' +
                    '</tr>');
                body.push('<tr><td colspan="5" style="background: #d6d5d5;text-align:center;">شرح بازدید , کنترل و سرویس</td></tr>');
                for (var i = 0; i < p.week.length; i++) {
                    body.push('<tr style="border:none;text-align:right;">' +
                        '<td style="width:35px;text-align:center;">' + radif + '</td>' +
                        '<td colspan="4">' + p.week[i].ControlName + '</td><tr>');
                    radif++;
                }
                for (var i = 0; i < p.other.length; i++) {
                    body.push('<tr style="border:none;text-align:right;">' +
                        '<td style="width:35px;text-align:center;">' + radif + '</td>' +
                        '<td colspan="4">' + p.other[i].ControlName + '</td><tr>');
                    radif++;
                }
                $('#tblcontrols tbody').append(body.join(''));
                body = [];
                body.push('<tr><td style="background: #d6d5d5;text-align:center;" colspan="20">موارد کنترلی</td></tr>');
                radif = 1;
                for (var j = 0; j < p.week.length; j++) {
                    body.push('<tr><td style="text-align:center;">' + radif + '</td>');
                    for (var i = 0; i < p.week[j].Date.length; i++) {
                        body.push('<td style="text-align:center;">' + p.week[j].Date[i] + ' <div class="square"></div> </td>');
                    }
                    radif++;
                }
                body.push('</tr>');
                for (var j = 0; j < p.other.length; j++) {
                    body.push('<tr><td style="text-align:center;">' + radif + '</td>');
                    for (var i = 0; i < p.other[j].Date.length; i++) {
                        body.push('<td style="text-align:center;">' + p.other[j].Date[i] + ' <div class="square"></div> </td>');
                    }
                    radif++;
                }
                body.push('</tr>');
                $('#tbldates tbody').append(body.join(''));
            }

            function createMonthlyProgram(p) {
                var body = [];
                var radif = 1;
                $('#tblsubheader tbody').append('<tr style="text-align: right;">' +
                    '<td style="width:40%;">نام مجری : </td>' +
                    '<td>دوره بازدید : ماهیانه /سه ماهه /شش ماهه /سالیانه</td>' +
                    '<td > نوع عملیات : ' + $('#drOpr :selected').text() + '</td>' +
                    '</tr>');
                body.push('<tr><td colspan="5" style="background: #d6d5d5;text-align:center;">شرح بازدید , کنترل و سرویس</td></tr>');
                for (var i = 0; i < p.monthly.length; i++) {
                    body.push('<tr style="border:none;text-align:right;">' +
                        '<td style="width:35px;text-align:center;">' + radif + '</td>' +
                        '<td colspan="4">' + p.monthly[i].ControlName + '</td><tr>');
                    radif++;
                }
                $('#tblcontrols tbody').append(body.join(''));
                body = [];
                body.push('<tr><td style="background: #d6d5d5;text-align:center;" colspan="20">موارد کنترلی</td></tr>');
                radif = 1;
                for (var j = 0; j < p.monthly.length; j++) {
                    body.push('<tr><td style="text-align:center;">' + radif + '</td>');
                    for (var i = 0; i < p.monthly[j].Date.length; i++) {
                        body.push('<td style="text-align:center;">' + p.monthly[j].Date[i] + ' <div class="square"></div> </td>');
                    }
                    radif++;
                }
                body.push('</tr>');
                $('#tbldates tbody').append(body.join(''));
            }
        }
    }
}
$('#drCategory').on('change', function () {
    var obj = {
        url: 'Activemachin',
        data: [],
        element: 'ActiveMachineChart',
        header: 'ماشین آلات فعال',
        chartype: 'pie'
    };
    obj.data.push({
        kind: $('#drCategory :selected').val()
    });
    GetChartData(obj);
});

function machineTypes() {
    var obj = {
        url: 'MachinType',
        data: [],
        element: 'MachineTypesChart',
        header: 'نوع ماشین آلات',
        chartype: 'pie'
    };
    GetChartData(obj);
}
function CreateTableForChart(data) {
    if ($('#ActiveMachine').hasClass('active')) {
        $('#gridActMachine').empty();
        if (data.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th> وضعیت</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data[i][0] + '</td>' +
                    '<td>' + data[i][1] + '</td>' +                   
                    '</tr>');
            }
            $('#gridActMachine').append(body.join(''));
        }
    }
    if ($('#MachineTypes').hasClass('active')) {
        $('#gridTypMachine').empty();
        if (data.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نوع دستگاه</th><th>تعداد</th></tr>');
            for (var i = 0; i < data.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data[i][0] + '</td>' +
                    '<td>' + data[i][1] + '</td>' +
                    '</tr>');
            }
            $('#gridTypMachine').append(body.join(''));
        }
    }
   

}


function SubsystemReport() {
    var unit;
    if ($('#drsubsystemunits :selected').val() !== '0') {
        unit = 'واحد ' + $('#drsubsystemunits :selected').text();
    } else {
        unit = $('#drsubsystemunits :selected').text();
    }
    $.get("Content/A4.html", function (e) {
        e = e.replace('#ReportArea#', 'subsystem');
        e = e.replace('printDiv', 'printDiv(1);');
        e = e.replace('ExportToExcel();', 'ExportToExcel(\'subbodycontent\');');
        e = e.replace('#RP#', 'لیست تجهیزات');
        e = e.replace('#cnt#', 'subbodycontent');
        e = e.replace('#unit#', unit);
        fill(e);
    }, 'html');

    function fill(d) {
        $('#SubsystemListPrint').empty();
        $('#SubsystemListPrint').append(d);
        var e = [];
        e.push({
            url: 'Reports.asmx/FilterSubSystems',
            parameters: [{ loc: $('#drsubsystemunits :selected').val() }],
            func: createSubsystemReport
        });
        AjaxCall(e);
        function createSubsystemReport(s) {
            var d = JSON.parse(s.d);
            var body = [];
            body.push('<table><tr><th>ردیف</th><th>نام تجهیز</th><th>کد تجهیز</th></tr>');
            if (d.length > 0) {
                for (var i = 0; i < d.length; i++) {
                    body.push('<tr>' +
                        '<td>' + (i+1) + '</td>' +
                        '<td>' + d[i].SubSystemName + '</td>' +
                        '<td>' + d[i].SubSystemId + '</td>' +
                        '</tr>');
                }
                body.push('</table>');
                $('.sDate').text(JalaliDateTime);
                $('#subbodycontent').append(body.join(''));
            }
        }
    }
}
$('#drmachineunits').on('change',
    function () {
        $('#drline').val(-1);
        $('#drfaz').val(-1);
    });
$('#drline').on('change',
    function () {
        $('#drmachineunits').val(0);
        $('#drfaz').val(-1);
    });
$('#drfaz').on('change',
    function () {
        $('#drline').val(-1);
        $('#drmachineunits').val(0);
    });
function MachineReport() {
    var unit;
    if ($('#drline :selected').val() !== '-1')
        unit = $('#drline :selected').text();
    else if ($('#drfaz :selected').val() !== '-1')
        unit = $('#drfaz :selected').text();
    else if ($('#drmachineunits :selected').val() !== '0') {
        unit = 'واحد ' + $('#drmachineunits :selected').text();
    } else {
        unit = $('#drmachineunits :selected').text();
    }
    $.get("Content/A4.html", function (e) {
        e = e.replace('#ReportArea#', 'machine');
        e = e.replace('printDiv', 'printDiv(0);');
        e = e.replace('#RP#', 'لیست ماشین آلات');
        e = e.replace('#cnt#', 'machinebodycontent');
        e = e.replace('#unit#', unit);
        fillmachine(e);
    }, 'html');

    function fillmachine(d) {
        $('#MachineListPrint').empty();
        $('#MachineListPrint').append(d);
        var e = [];
        e.push({
            url: 'Reports.asmx/FilterMachines',
            parameters: [{ loc: $('#drmachineunits :selected').val(), line: $('#drline :selected').val(),faz:$('#drfaz :selected').val()}],
            func: createmachineReport
        });
        AjaxCall(e);
        function createmachineReport(s) {
            var d = JSON.parse(s.d);
            var body = [];
            if (d.length > 0) {
                body.push('<table><tr><th>ردیف</th><th>نام دستگاه</th><th>کد دستگاه</th><th>محل اسقرار</th>' +
                    '<th>کلیدی</th><th>سازنده</th><th>مدل</th><th>تاریخ بهره برداری</th></tr>');
                for (var i = 0; i < d.length; i++) {
                    var imp = d[i].Ahamiyat == 'True' ? '<input type="checkbox" checked disabled/>' : '<input type="checkbox" disabled/>';
                    body.push('<tr>' +
                        '<td>' + (i+1) + '</td>' +
                        '<td>' + d[i].Name + '</td>' +
                        '<td>' + d[i].Code + '</td>' +
                        '<td>' + d[i].LocationName + '</td>' +
                        '<td>' + imp + '</td>' +
                        '<td>' + d[i].Creator + '</td>' +
                        '<td>' + d[i].Model + '</td>' +
                        '<td>' + d[i].Tarikh + '</td>' +
                        '</tr>');
                }
                body.push('</table>');
                $('.sDate').text(JalaliDateTime);
                $('#machinebodycontent').append(body.join(''));
            }
        }
    }
}

function printDiv(div) {
    var ele;
    switch (div) {
    case 1:
        ele = $('#subsystem')[0];
        break;
    case 0:
        ele = $('#machine')[0];
        break;
    case 2:
        ele = $('#MachineControlsPanel')[0];
        break;
    default:
    }
    var newWin = window.open('', 'Print-Window');
    newWin.document.open();
    newWin.document.write('<html><body onload="window.print()">' + ele.innerHTML + '</body></html>');
    newWin.document.close();
    setTimeout(function () { newWin.close(); }, 10);
}
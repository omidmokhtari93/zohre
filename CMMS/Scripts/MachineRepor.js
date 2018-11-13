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

function MachineReport() {
    var unit;
    if ($('#drmachineunits :selected').val() !== '0') {
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
            parameters: [{ loc: $('#drmachineunits :selected').val() }],
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
    var ele = div === 1 ? $('#subsystem')[0] : $('#machine')[0];
    var newWin = window.open('', 'Print-Window');
    newWin.document.open();
    newWin.document.write('<html><body onload="window.print()">' + ele.innerHTML + '</body></html>');
    newWin.document.close();
    setTimeout(function () { newWin.close(); }, 10);
}
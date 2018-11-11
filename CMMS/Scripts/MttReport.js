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
    kamaDatepicker('txtMtbfEndDate', customOptions);
    kamaDatepicker('txtMtbfStartDate', customOptions);
    kamaDatepicker('txtrepEndDate', customOptions);
    kamaDatepicker('txtrepStartDate', customOptions);
    kamaDatepicker('txtstopEndDate', customOptions);
    kamaDatepicker('txtstopStartDate', customOptions);
    kamaDatepicker('txtReportEndDate', customOptions);
    kamaDatepicker('txtReportStartDate', customOptions);
});

function ClearReprtArea() {
    $("#MtbfReportArea").empty();
    $("#MttrPerRepiarReport").empty();
    $("#MttrPerStopReport").empty();
}
$('#drMTBFUnits').on('change', function () {
    if ($('#drMTBFUnits :selected').val() !== '-1') {
        $('#drMTBFLine').val('-1');
        $('#drMTBFfaz').val('-1');
    } 
    
});
$('#drMTBFLine').on('change', function () {
    if ($('#drMTBFLine :selected').val() !== '-1') {
        $('#drMTBFUnits').val('-1');
        $('#drMTBFfaz').val('-1');
    }

});
$('#drMTBFfaz').on('change', function () {
    if ($('#drMTBFfaz :selected').val() !== '-1') {
        $('#drMTBFUnits').val('-1');
        $('#drMTBFLine').val('-1');
    }

});
function Mtbf() {
    ClearReprtArea();
    var startDate = $('#txtMtbfStartDate').val();
    var endDate = $('#txtMtbfEndDate').val();
    var unitt = $('#drMTBFUnits :selected').val();
    var linee = $('#drMTBFLine :selected').val();
    var fazz = $('#drMTBFfaz :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee === '-1' && fazz === '-1') {
        RedAlert('no', 'لطفا فاز ، خط یا واحد مورد نظر را انتخاب کنید');
        return;
    }
    var obj = {
        url: 'MTBF_Report',
        data: [],
        kind: 'روز',
        comment1: 'MTBF',
        comment2: 'Target MTBF',
        label:'Days',
        element: 'MtbfChart',
        header: 'MTBF گزارش',
        chartype: 'categorycolumn'
    };
    obj.data.push({
        dateS: startDate,
        dateE: endDate,
        unit: unitt,
        line: linee,
        faz:fazz
    });
    GetChartData(obj);
    $.get("Content/report.html", function (data) {
        data = data.replace("#btn#", 'onclick="MtbfReport();"');
        $("#MtbfReportArea").html(data);
    });
}

$('#drMttrPerRepiar').on('change', function() {
    if ($('#drMttrPerRepiar :selected').val() !== '-1') {
        $('#drMTTRRLine').val('-1');
        $('#drMTTRRFaz').val('-1');
    }
});
$('#drMTTRRLine').on('change', function () {
    if ($('#drMTTRRLine :selected').val() !== '-1') {
        $('#drMttrPerRepiar').val('-1');
        $('#drMTTRRFaz').val('-1');
    }
});
$('#drMTTRRFaz').on('change', function () {
    if ($('#drMTTRRFaz :selected').val() !== '-1') {
        $('#drMttrPerRepiar').val('-1');
        $('#drMTTRRLine').val('-1');
    }
});
function MttrPerRepiar() {
    ClearReprtArea();
    var startDate = $('#txtrepStartDate').val();
    var endDate = $('#txtrepEndDate').val();
    var unitt = $('#drMttrPerRepiar :selected').val();
    var linee = $('#drMTTRRLine :selected').val();
    var fazz = $('#drMTTRRFaz :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee === '-1' && fazz === '-1') {
        RedAlert('no', 'لطفا فاز ، خط یا واحد مورد نظر را انتخاب کنید');
        return;
    }
    var obj = {
        url: 'MTTR_Per_Repair',
        data: [],
        kind: 'ساعت',
        comment1: 'MTTR',
        comment2: 'Target MTTR',
        label: 'Hour',
        element: 'MttrPerRepiarChart',
        header: 'گزارش مدت زمان تعمیر_بر مبنای تعمیر',
        chartype: 'categorycolumn'
    };
    obj.data.push({
        dateS: startDate,
        dateE: endDate,
        unit: unitt,
        line: linee,
        faz:fazz
    });
    GetChartData(obj);
    $.get("Content/report.html", function (data) {
        data = data.replace("#btn#", 'onclick="MttrPerRepairReport();"');
        $("#MttrPerRepiarReport").html(data);
    });
}

$('#drMttrPerStop').on('change', function () {
    if ($('#drMttrPerStop :selected').val() !== '-1') {
        $('#drMTTRSLine').val('-1');
        $('#drMTTRSFaz').val('-1');
    }
});   
$('#drMTTRSLine').on('change', function () {
    if ($('#drMTTRSLine :selected').val() !== '-1') {
        $('#drMttrPerStop').val('-1');
        $('#drMTTRSFaz').val('-1');
    }
});   
$('#drMTTRSFaz').on('change', function () {
    if ($('#drMTTRSFaz :selected').val() !== '-1') {
        $('#drMttrPerStop').val('-1');
        $('#drMTTRSLine').val('-1');
    }
});  

function MttrPerStop() {
    ClearReprtArea();
    var startDate = $('#txtstopStartDate').val();
    var endDate = $('#txtstopEndDate').val();
    var unitt =$('#drMttrPerStop :selected').val();
    var linee = $('#drMTTRSLine :selected').val();
    var fazz = $('#drMTTRSFaz :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee === '-1' && fazz === '-1') {
        RedAlert('no', 'لطفا فاز ، خط یا واحد مورد نظر را انتخاب کنید');
        return;
    }
    var obj = {
        url: 'MTTR_Per_stop',
        data: [],
        kind: 'ساعت',
        comment1: 'MTTR',
        comment2: 'Target MTTR',
        label: 'Hour',
        element: 'MttrPerstopChart',
        header: 'گزارش مدت زمان تعمیر_بر مبنای توقف',
        chartype: 'categorycolumn'
    };
    obj.data.push({
        dateS: startDate,
        dateE: endDate,
        unit: unitt,
        line: linee,
        faz:fazz
    });
    GetChartData(obj);
    $.get("Content/report.html", function (data) {
        data = data.replace("#btn#", 'onclick="MttrPerStopReport();"');
        $("#MttrPerStopReport").html(data);
    });
}

function MtbfReport() {
    if (CheckInputs()) {
        RedAlert('no', 'لطفا فیلد خالی را تکمیل کنید');
    } else {
        var data = [];
        data.push({
            url: 'WebService.asmx/MtbfReports',
            parameters: [{ obj: CollectData(1) }],
            func: mtbfReportDone
        });
        AjaxCall(data);

        function mtbfReportDone() {
            GreenAlert('no', 'با موفقیت ثبت شد MTBF گزارش');
            $('#MtbfReportArea').empty();
        }
    }
}

function MttrPerRepairReport() {
    if (CheckInputs()) {
        RedAlert('no', 'لطفا فیلد خالی را تکمیل کنید');
    } else {
        var data = [];
        data.push({
            url: 'WebService.asmx/MtbfReports',
            parameters: [{ obj: CollectData(2) }],
            func: mttrPerRepairReportDone
        });
        AjaxCall(data);

        function mttrPerRepairReportDone() {
            GreenAlert('no', 'گزارش مدت زمان تعمیر_بر مبنای تعمیر با موفقیت ثبت شد');
            $('#MttrPerRepiarReport').empty();
        }
    }
}

function MttrPerStopReport() {
    if (CheckInputs()) {
        RedAlert('no', 'لطفا فیلد خالی را تکمیل کنید');
    } else {
        var data = [];
        data.push({
            url: 'WebService.asmx/MtbfReports',
            parameters: [{ obj: CollectData(3) }],
            func: mttrPerStopReportDone
        });
        AjaxCall(data);

        function mttrPerStopReportDone() {
            GreenAlert('no', 'گزارش مدت زمان تعمیر_بر مبنای توقف با موفقیت ثبت شد');
            $('#MttrPerStopReport').empty();
        }
    }
}

function CollectData(type) {
    var inp = {
        Type: type,
        Tarikh: $('#tarikh').val(),
        ReportName: $('#txtReportname').val(),
        Producer: $('#txtproducer').val(),
        Manager: $('#txtmanager').val(),
        Exp: $('#txtReportExp').val(),
        Analyse: $('#txtReportAnalyse').val()
    };
    return inp;
}

function GetFilteredReportTable(s, e, d) {
    var startDate = $('#' + s).val();
    var endDate = $('#' + e).val();
    var typee = $('#' + d + ' :selected').val();
    var data = [];
    data.push({
        url: 'WebService.asmx/GetFilteredReportTable',
        parameters: [{ dateS: startDate, dateE: endDate, type: typee }],
        func: createtbl
    });
    AjaxCall(data);

    function createtbl(e) {
        $('#gridReports tbody').empty();
        var d = JSON.parse(e.d);
        if (d.length > 0) {
            var body = [];
            body.push('<tr>' +
                '<th>نام گزارش</th>' +
                '<th>تهیه کننده</th>' +
                '<th>تاریخ تهیه</th>' +
                '<th>مدیر فرآیند</th>' +
                '<th>شرح گزارش</th>' +
                '<th>تحلیل گزارش</th>' +
                '<th></th>' +
                '<th></th>' +
                '<th></th>' +
                '</tr>');
            for (var i = 0; i < d.length; i++) {
                body.push('<tr>' +
                    '<td style="display:none;">' + d[i].Id + '</td>' +
                    '<td style="display:none;">' + d[i].Exp + '</td>' +
                    '<td style="display:none;">' + d[i].Analyse + '</td>' +
                    '<td>' + d[i].ReportName + '</td>' +
                    '<td>' + d[i].Producer + '</td>' +
                    '<td>' + d[i].Tarikh + '</td>' +
                    '<td>' + d[i].Manager + '</td>' +
                    '<td>' + d[i].Exp.substring(0, 15) + ' ...' + '</td>' +
                    '<td>' + d[i].Analyse.substring(0, 15) + ' ...' + '</td>' +
                    '<td><a class="fa fa-print" id="print"></a></td>' +
                    '<td><a id="ed">ویرایش</a></td>' +
                    '<td><a id="del">حذف</a></td>' +
                    '</tr>');
            }
            $('#gridReports tbody').append(body.join(''));
        }
    }
}

var reportId;
$('table').on('click', 'tr a#ed', function () {
    $('#modalBody').empty();
    reportId = $(this).parent().parent().find('td:eq(0)').text();
    var tbl = this;
    $.get("Content/report.html", function (data) {
        data = data.replace("#btn#", 'onclick="editReport();"');
        data = $(data).find('div#collapse1');
        $(data).find('button').html('ویرایش');
        $('#modalBody').append('<div class="panel-heading">ویرایش گزارش</div>');
        $('#modalBody').append($(data).html());
        $('#reportModal').show();
        $('#tarikh').val($(tbl).parent().parent().find('td:eq(5)').text());
        $('#txtmanager').val($(tbl).parent().parent().find('td:eq(6)').text());
        $('#txtproducer').val($(tbl).parent().parent().find('td:eq(4)').text());
        $('#txtReportname').val($(tbl).parent().parent().find('td:eq(3)').text());
        $('#txtReportExp').val($(tbl).parent().parent().find('td:eq(1)').text());
        $('#txtReportAnalyse').val($(tbl).parent().parent().find('td:eq(2)').text());
    });
});

$('table').on('click', 'tr a#del', function () {
    $('#deletereportModal').show();
    reportId = $(this).parent().parent().find('td:eq(0)').text();
});

$('table').on('click', 'tr a#print', function () {
    reportId = $(this).parent().parent().find('td:eq(0)').text();
    window.open('MttReportPrint.aspx?repid=' + reportId, '_blank');
});

function editReport() {
    if (CheckInputs()) {
        RedAlert('no', 'لطفا فیلد خالی را تکمیل کنید');
    } else {
        var updata = {
            Id: reportId,
            Tarikh: $('#tarikh').val(),
            ReportName: $('#txtReportname').val(),
            Producer: $('#txtproducer').val(),
            Manager: $('#txtmanager').val(),
            Exp: $('#txtReportExp').val(),
            Analyse: $('#txtReportAnalyse').val()
        };
        var data = [];
        data.push({
            url: 'WebService.asmx/UpdateReport',
            parameters: [{ obj: updata }],
            func: updateReport
        });
        AjaxCall(data);

        function updateReport(e) {
            $('#reportModal').hide();
            GreenAlert('no', 'با موفقیت ویرایش شد');
            GetFilteredReportTable('txtReportStartDate', 'txtReportEndDate', 'drRepiarTime');
        }
    }
}

function DeleteReport() {
    var data = [];
    data.push({
        url: 'WebService.asmx/DeleteReport',
        parameters: [{ reportIdd: reportId }],
        func: deleteReport
    });
    AjaxCall(data);

    function deleteReport() {
        $('#deletereportModal').hide();
        GreenAlert('no', 'با موفقیت حذف شد');
        GetFilteredReportTable('txtReportStartDate', 'txtReportEndDate', 'drRepiarTime');
    }
}

function CheckInputs() {
    var flag = false;
    if ($('#tarikh').val() === '') {
        RedAlert('tarikh', '');
        flag = true;
    }
    if ($('#txtproducer').val() === '') {
        RedAlert('txtproducer', '');
        flag = true;
    }
    if ($('#txtReportname').val() === '') {
        RedAlert('txtReportname', '');
        flag = true;
    }
    if ($('#txtReportExp').val() === '') {
        RedAlert('txtReportExp', '');
        flag = true;
    }
    return flag;
}
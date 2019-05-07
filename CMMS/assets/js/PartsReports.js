$(document).ready(function () {
    kamaDatepicker('txtStartDate', customOptions);
    kamaDatepicker('txtEndDate', customOptions);
    kamaDatepicker('txtPartStartDate', customOptions);
    kamaDatepicker('txtPartEndDate', customOptions);
});
$('#drPartsUnit').on('change', function () {
    if ($('#drPartsUnit :selected').val() !== '-1') {
        $('#drPartsLine').val('-1');
    }
});
$('#drPartsLine').on('change', function () {
    if ($('#drPartsLine :selected').val() !== '-1') {
        $('#drPartsUnit').val('-1');
    }
});

function CreatePartsChart() {
    var linee = $('#drPartsLine :selected').val();
    var unitt = $('#drPartsUnit :selected').val();
    var sDate = $('#txtStartDate').val();
    var eDate = $('#txtEndDate').val();
    if ($('#txtEndDate').val() == '' || $('#txtStartDate').val() == '' || $('#txtCount').val() == '') {
        RedAlert('no', '!!لطفا همه ی فیلدها را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    GetChartData({
        url: 'MaxTools',
        param: {
            line: linee,
            unit: unitt,
            count: $('#txtCount').val(),
            dateS: $('#txtStartDate').val(),
            dateE: $('#txtEndDate').val()
        },
        lblkind: 'تعداد',
        element: 'PartsChart',
        header: 'قطعات پر مصرف',
        chartype: 'column'
    });
}
function CreateTableForChart(data) {
    $('#gridParts').empty();
    if (data.Strings.length > 0) {
        var body = [];
        body.push('<tr><th>ردیف</th><th> نام قطعه</th><th>تعداد</th></tr>');
        for (var i = 0; i < data.Strings.length; i++) {
            body.push('<tr>' +
                '<td>' + (i + 1) + '</td>' +
                '<td>' + data.Strings[i] + '</td>' +
                '<td>' + data.Integers[i] + '</td>' +
                '</tr>');
        }
        $('#gridParts').append(body.join(''));
    }
}
//===========search Part ===========
var nav;//page number
var value;
var rowss;
var typingTimer;
var doneTypingInterval = 2000;
var $input = $('#txtPartsSearch');
$input.on('keyup', function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
    $('#partsLoading').show();
    $('#gridPart tbody').empty();
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
    }
});
$input.on('keydown', function () {
    clearTimeout(typingTimer);
});
function doneTyping() {
    if (($input).val().length <= 2 && ($input).val() != '') {
        $.notify("!!حداقل سه حرف از نام قطعه را وارد نمایید", { globalPosition: 'top left' });
    }
    if (($input).val().length > 2) {
        AjaxData({
          url: 'WebService.asmx/PartsFilter',
          param: { partName: $input.val() },
          func: createPartTable
        });
        function createPartTable(e) {
            var tableRows = '';
            var filteredParts = JSON.parse(e.d);
            for (var i = 0; i < filteredParts.length; i++) {
                tableRows += '<tr><td partid="' + filteredParts[i].PartId + '">' + filteredParts[i].PartName + '</td></tr>';
            }
            $('#gridPart tbody').append(tableRows);
            rowss = $('#gridPart tr').clone();
            $('#gridPart').show();

        }
    }
    $('#partsLoading').hide();
    $('#PartsSearchResulat').show();

}
$('#txtSubSearchPart').keyup(function () {
    var val = $(this).val();
    $('#gridPart tbody').empty();
    rowss.filter(function (idx, el) {
        return val === '' || $(el).text().indexOf(val) >= 0;
    }).appendTo('#gridPart');
});
$('#gridPart').on('click', 'td', function () {
    var $text = this.innerText;
    value = $(this).attr('partid');
    $('#txtPartsSearch').val($text);
    $('#gridPart').hide();
});
//============Second Report==============
function CreateTableTools() {

    var sDate = $('#txtPartStartDate').val();
    var eDate = $('#txtPartEndDate').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if ($('#txtPartsSearch').val() === '') {
        value = -1;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    AjaxData({
        url: 'Reports.asmx/ToolsReport',
        param: { toolsId: value, dateS: sDate, dateE: eDate },
        func: reportPartId
    });

    function reportPartId(e) {
        $('#gridReportTools tbody').empty();
        var pc = JSON.parse(e.d);

        if (pc.length > 0) {
            var body = [];

            body.push(
                '<tr><th>ردیف</th><th>واحد</th><th>ماشین</th><th>نام قطعه/کالا</th><th>تعداد مصرفی</th></tr>');
            for (var i = 0; i < pc.length; i++) {
                if (i % 15 === 0 && i !== 0) {
                    body.push('<tr><th>ردیف</th><th>واحد</th><th>ماشین</th><th>نام قطعه/کالا</th><th>تعداد مصرفی</th></tr>');
                }
                body.push('<tr>' + '<td>' + (i + 1) + '</td>' +
                    '<td>' + pc[i][0] + '</td>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][3] + '  ' + pc[i][4] + '</td>' +
                    '</tr>');
            }

            $('#gridReportTools tbody').append(body.join(''));
        }
        if (nav !== undefined) {
            $('#nav').remove();
        }
        nav = $('<div id="nav"></div>');
        $('#gridReportTools').after(nav);
        var rowsShown = 16;
        var rowsTotal = $('#gridReportTools  tr').length;
        var numPages = rowsTotal / rowsShown;
        for (j = 0; j < numPages; j++) {
            var pageNum = j + 1;
            $('#nav').append('<a  href="#" rel="' + j + '">' + pageNum + '</a> ');
        }
        $('#gridReportTools  tr').hide();
        $('#gridReportTools  tr').slice(0, rowsShown).show();
        $('#nav a:first').addClass('active');
        $('#nav a').bind('click', function () {

            $('#nav a').removeClass('active');
            $(this).addClass('active');
            var currPage = $(this).attr('rel');
            var startItem = currPage * rowsShown;
            var endItem = startItem + rowsShown;
            $('#gridReportTools  tr').css('opacity', '0.0').hide().slice(startItem, endItem).
                css('display', 'table-row').animate({ opacity: 1 }, 300);
        });

    }

}
//============Print Report =========
function SendParameterstoPrint() {
    var sDate = $('#txtPartStartDate').val();
    var eDate = $('#txtPartEndDate').val();
    if (sDate == '' || eDate == '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if ($('#txtPartsSearch').val() === '') {
        value = -1;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    window.open('PartsReportPrint.aspx?part=' + value + '&sdate=' + sDate + '&edate=' + eDate + '', '_blank');
}
$(document).ready(function () {
    kamaDatepicker('txtunitlineEndDate', customOptions);
    kamaDatepicker('txtunitlineStartDate', customOptions);
    kamaDatepicker('txtSubEndDate', customOptions);
    kamaDatepicker('txtSubStartDate', customOptions);
    kamaDatepicker('txtProductEndDate', customOptions);
    kamaDatepicker('txtProductStartDate', customOptions);
   });
function ClearReprtArea() {
    $("#UnitLineReportArea").empty();
   
}
$('#drStopUnits').on('change', function () {
    if ($('#drStopUnits :selected').val() !== '-1') {
        $('#drStopLine').val('-1');
        $('#drStopfaz').val('-1');
    }
});
$('#drStopLine').on('change', function () {
    if ($('#drStopLine :selected').val() !== '-1') {
        $('#drStopUnits').val('-1');
        $('#drStopfaz').val('-1');
    }
});
$('#drStopfaz').on('change', function () {
    if ($('#drStopfaz :selected').val() !== '-1') {
        $('#drStopUnits').val('-1');
        $('#drStopLine').val('-1');
    }
});
function CreateTableForChart(data) {
    if ($('#StopPerline').hasClass('active')) {
        $('#gridStopPerline').empty();
        if (data.Machine.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نام دستگاه </th><th>توقف الکتریکی</th><th>توقف مکانیکی</th></tr>');
            for (var i = 0; i < data.Machine.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data.Machine[i] + '</td>' +
                    '<td>' + data.Mtt[i] + '  دقیقه</td>' +
                    '<td>' + data.MttH[i] + '  دقیقه</td>' +
                    '</tr>');
            }
            $('#gridStopPerline').append(body.join(''));
        }
    }
    if ($('#StopPerSubsystem').hasClass('active')) {
        $('#gridStopPerSubsystem').empty();
        if (data.Machine.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نام تجهیز</th><th>توقف الکتریکی</th><th>توقف مکانیکی</th></tr>');
            for (var i = 0; i < data.Machine.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data.Machine[i] + '</td>' +
                    '<td>' + data.Mtt[i] + '  دقیقه</td>' +
                    '<td>' + data.MttH[i] + '  دقیقه</td>' +
                    '</tr>');
            }
            $('#gridStopPerSubsystem').append(body.join(''));
        }
    }
    if ($('#StopProduct').hasClass('active')) {
        $('#gridStopProduct').empty();
        if (data.Strings.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نام دستگاه</th><th>توقف تولید</th></tr>');
            for (var i = 0; i < data.Strings.length; i++) {
                body.push('<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + data.Strings[i] + '  دقیقه</td>' +
                    '<td>' + data.Integers[i] + '  دقیقه</td>' +
                   
                    '</tr>');
            }
            $('#gridStopProduct').append(body.join(''));
        }
    }

}
function Stop() {
    ClearReprtArea();
    var startDate = $('#txtunitlineStartDate').val();
    var endDate = $('#txtunitlineEndDate').val();
    var unitt = $('#drStopUnits :selected').val();
    var linee = $('#drStopLine :selected').val();
    var fazz = $('#drStopfaz :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee==='-1' && fazz==='-1') {
        RedAlert('no', 'لطفا فاز، خط یا واحد مورد نظر را انتخاب کنید');
        return;
    }
    var obj = {
        url: 'Stopunitline_Report',
        data: [],
        kind: 'دقیقه',
        comment1: 'الکتریکی',
        comment2: 'مکانیکی',
        label: 'دقیقه',
        element: 'StopChart',
        header: 'گزارش توقفات',
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
   
}
$('#drStopSubUnit').on('change', function () {
    if ($('#drStopSubUnit :selected').val() !== '-1') {
        $('#drStopSubLine').val('-1');
        $('#drStopSubfaz').val('-1');
    }
});
$('#drStopSubLine').on('change', function () {
    if ($('#drStopSubLine :selected').val() !== '-1') {
        $('#drStopSubUnit').val('-1');
        $('#drStopSubfaz').val('-1');
    }
});
$('#drStopSubfaz').on('change', function () {
    if ($('#drStopSubfaz :selected').val() !== '-1') {
        $('#drStopSubUnit').val('-1');
        $('#drStopSubLine').val('-1');
    }
});
function StopSub() {
    ClearReprtArea();
    var startDate = $('#txtSubStartDate').val();
    var endDate = $('#txtSubEndDate').val();
    var unitt = $('#drStopSubUnit :selected').val();
    var linee = $('#drStopSubLine :selected').val();
    var fazz = $('#drStopSubfaz :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee === '-1' && fazz === '-1') {
        RedAlert('no', 'لطفا فاز ، خط یا واحد مورد نظر را انتخاب کنید');
        return;
    }
    var obj = {
        url: 'StopSub_Report',
        data: [],
        kind: 'دقیقه',
        comment1: 'الکتریکی',
        comment2: 'مکانیکی',
        label: 'دقیقه',
        element: 'StopSubChart',
        header: 'گزارش توقفات تجهیزات',
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

}
$('#drStopproductUnit').on('change', function () {
    if ($('#drStopproductUnit :selected').val() !== '-1') {
        $('#drStopProductLine').val('-1');
        $('#drStopproductfaz').val('-1');
    }
});
$('#drStopProductLine').on('change', function () {
    if ($('#drStopProductLine :selected').val() !== '-1') {
        $('#drStopproductUnit').val('-1');
        $('#drStopproductfaz').val('-1');
    }
});
$('#drStopProductfaz').on('change', function () {
    if ($('#drStopProductfaz :selected').val() !== '-1') {
        $('#drStopproductUnit').val('-1');
        $('#drStopProductLine').val('-1');
    }
});
function StopProduct() {
    ClearReprtArea();
    var startDate = $('#txtProductStartDate').val();
    var endDate = $('#txtProductEndDate').val();
    var unitt = $('#drStopproductUnit :selected').val();
    var linee = $('#drStopProductLine :selected').val();
    var fazz = $('#drStopProductfaz :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
   
    var obj = {
        lblkind:'دقیقه',
        url: 'StopProduct',
        data: [],
        element: 'StopProductChart',
        header: 'گزارش توقفات فنی منجر به توقف تولید',
        chartype: 'column'
    };
    obj.data.push({
        dateS: startDate,
        dateE: endDate,
        unit: unitt,
        line: linee,
        faz:fazz
    });
    GetChartData(obj);

}

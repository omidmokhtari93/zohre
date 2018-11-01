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
    }
});
$('#drStopLine').on('change', function () {
    if ($('#drStopLine :selected').val() !== '-1') {
        $('#drStopUnits').val('-1');
    }
});
function Stop() {
    ClearReprtArea();
    var startDate = $('#txtunitlineStartDate').val();
    var endDate = $('#txtunitlineEndDate').val();
    var unitt = $('#drStopUnits :selected').val();
    var linee = $('#drStopLine :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee==='-1') {
        RedAlert('no', 'لطفا خط یا واحد مورد نظر را انتخاب کنید');
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
        line: linee
    });
    GetChartData(obj);
   
}
$('#drStopSubUnit').on('change', function () {
    if ($('#drStopSubUnit :selected').val() !== '-1') {
        $('#drStopSubLine').val('-1');
    }
});
$('#drStopSubLine').on('change', function () {
    if ($('#drStopSubLine :selected').val() !== '-1') {
        $('#drStopSubUnit').val('-1');
    }
});
function StopSub() {
    ClearReprtArea();
    var startDate = $('#txtSubStartDate').val();
    var endDate = $('#txtSubEndDate').val();
    var unitt = $('#drStopSubUnit :selected').val();
    var linee = $('#drStopSubLine :selected').val();
    if (startDate == '' || endDate == '') {
        RedAlert('no', 'لطفا فیلد های خالی را تکمیل نمایید');
        return;
    }
    if (unitt === '-1' && linee === '-1') {
        RedAlert('no', 'لطفا خط یا واحد مورد نظر را انتخاب کنید');
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
        line: linee
    });
    GetChartData(obj);

}
$('#drStopproductUnit').on('change', function () {
    if ($('#drStopproductUnit :selected').val() !== '-1') {
        $('#drStopProductLine').val('-1');
    }
});
$('#drStopProductLine').on('change', function () {
    if ($('#drStopProductLine :selected').val() !== '-1') {
        $('#drStopproductUnit').val('-1');
    }
});
function StopProduct() {
    ClearReprtArea();
    var startDate = $('#txtProductStartDate').val();
    var endDate = $('#txtProductEndDate').val();
    var unitt = $('#drStopproductUnit :selected').val();
    var linee = $('#drStopProductLine :selected').val();
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
        line: linee
    });
    GetChartData(obj);

}

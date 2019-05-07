$(document).ready(function () {
    kamaDatepicker('txtHistoryEndDate', customOptions);
    kamaDatepicker('txtHistoryStartDate', customOptions);
   
});
$('#drUnits').change(function () {
    FilterMachineByUnit('drUnits', 'drMachines');
});
function CreateTableHistory() {
    var machinee = $('#drMachines :selected').val();
    var unitt = $('#drUnits :selected').val();
    var sDate = $('#txtHistoryStartDate').val();
    var eDate = $('#txtHistoryEndDate').val();
    if (sDate === '' || eDate === '') {
        RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
        return;
    }
    if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
        RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
        return;
    }
    
    AjaxData({
        url: 'Reports.asmx/RepairHistory',
        param: { machine: machinee, unit: unitt, dateS: sDate, dateE: eDate },
        func: repairHistory
    });

    function repairHistory(e) {
        $('#gridRepairHistory tbody').empty();
        var pc = JSON.parse(e.d);
       
        if (pc.length > 0) {
            var body = [];

            body.push('<tr><th>شماره درخواست</th><th>نام ماشین</th><th>تاریخ تعمیر/سرویس</th><th>نوع درخواست</th><th>مورد تعمیر</th><th>مدت زمان تعمیر</th><th>مدت زمان توقف</th><th>مشاهده</th></tr>');
            for (var i = 0; i < pc.length; i++) {
               
                body.push('<tr>' +
                    '<td>' + pc[i][1] + '</td>' +
                    '<td>' + pc[i][2] + '</td>' +
                    '<td>' + pc[i][3] + '</td>' +
                    '<td>' + pc[i][4] + '</td>' +
                    '<td>' + pc[i][5] + '</td>' +
                    '<td>' + pc[i][6] + '</td>' +
                    '<td>' + pc[i][7] + '</td>' +
                    '<td><a href="ReplyPrint.aspx?reqid= ' + pc[i][0] + '" target="_blank">مشاهده</a></td>' +
                    '</tr>');
            }
            
            $('#gridRepairHistory tbody').append(body.join(''));
        }
       
    }
}
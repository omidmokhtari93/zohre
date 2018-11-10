var data = [];
var body = [];
var targetTr;
var itemId;
$(function () {
    FillFazTable();
    FilllineTable();
   
});
function FillFazTable() {
    $('#FazTable tbody').empty();
    data = [];
    data.push({
        url: 'WebService.asmx/GetFazTable',
        parameters: [],
        func: fillFaz
    });
    AjaxCall(data);
    function fillFaz(e) {
        data = JSON.parse(e.d);
        body = [];
        if (data.length > 0) {
            body.push('<tr><th>ردیف</th><th>نام فاز</th><th></th></tr>');
            CreateBody(data, body);
            $('#FazTable tbody').append(body.join(''));
        }
    }
}

function FilllineTable() {
    $('#LineTable tbody').empty();
    data = [];
    data.push({
        url: 'WebService.asmx/GetLineTable',
        parameters: [],
        func: fillLine
    });
    AjaxCall(data);
    function fillLine(e) {
        data = JSON.parse(e.d);
        if (data.length > 0) {
            body = [];
            body.push('<tr><th>ردیف</th><th>نام خط</th><th></th></tr>');
            CreateBody(data, body);
            $('#LineTable tbody').append(body.join(''));
        }
    }
}





function CreateBody(data, body) {
    for (var i = 0; i < data.length; i++) {
        body.push('<tr>' +
            '<td style="display:none;">' + data[i][0] + '</td>' +
            '<td>' + parseInt(i + 1) + '</td>' +
            '<td>' + data[i][1] + '</td>' +
            '<td><a id="edit">ویرایش</a></td></tr>');
    }
}

function insertOrUpdateData(ele, ed, add) {
    var textt = $('#' + ele).val();
    if (textt === '') { RedAlert(ele, '!!لطفا فیلد خالی را تکمیل کنید'); return; }
    var obj = [];
    obj.push({
        url: 'WebService.asmx/' + add,
        parameters: [{ text: textt, editId: ed }],
        func: output
    });
    AjaxCall(obj);
    function output(e) {
        if (e.d === 'i') {
            GreenAlert('no', '.با موفقیت ثبت شد');
        } else {
            GreenAlert('no', '.با موفقیت ویرایش شد');
        }
        if (ele == 'txtFaz') {
            FillFazTable();
        } if (ele == 'txtLine') {
            FilllineTable();
        } 
        ClearFields('opFrom');
        var btn = $('#' + ele).parent().parent().find('button');
        $(btn[0]).show();
        $(btn[1]).hide();
        $(btn[2]).hide();
    }
}
$('#FazTable').on('click', 'tr a#edit', function () {
    $(targetTr).css('background-color', '');
    targetTr = $(this).closest('tr');
    itemId = $(this).closest('tr').find('td:eq(0)').text();
    $('#txtFaz').val($(this).closest('tr').find('td:eq(2)').text());
    $(targetTr).css('background-color', 'lightgreen');
    $('#btninsertFaz').hide();
    $('#btneditFaz').show();
    $('#btncanselFaz').show();
});
$('#LineTable').on('click', 'tr a#edit', function () {
    $(targetTr).css('background-color', '');
    targetTr = $(this).closest('tr');
    itemId = $(this).closest('tr').find('td:eq(0)').text();
    $('#txtLine').val($(this).closest('tr').find('td:eq(2)').text());
    $(targetTr).css('background-color', 'lightgreen');
    $('#btnInsertLine').hide();
    $('#btneditLine').show();
    $('#btncanselLine').show();
});


function CancelOperation(btni, btne, btnc) {
    $(targetTr).css('background-color', '');
    $('#' + btni).show();
    $('#' + btne).hide();
    $('#' + btnc).hide();
    ClearFields('opFrom');
}
var tr;
var typingTimer;
var doneTypingInterval = 2000;
var $input = $('#txtPartsSearch');
$input.on('keyup', function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
    $('#partsLoading').show();
    $('#txtSubSearchPart').val('');
    $('#gridParts tbody').empty();
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
    }
});
$input.on('keydown', function () {
    clearTimeout(typingTimer);
});
function doneTyping() {
    if (($input).val().length > 2) {
        $.ajax({
            type: "POST",
            url: "WebService.asmx/PartsFilter",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ 'partName': $input.val() }),
            success: function (e) {
                var tableRows = '';
                var filteredParts = JSON.parse(e.d);
                for (var i = 0; i < filteredParts.length; i++) {
                    tableRows += '<tr><td partid="' + filteredParts[i].PartId + '">' + filteredParts[i].PartName + '</td></tr>';
                }
                $('#gridParts tbody').append(tableRows);
                tr = $('#gridParts tr').clone();
                $('#partsLoading').hide();
                $('#PartsSearchResulat').show();
            },
            error: function () {
            }
        });
    } if (($input).val().length <= 1 && ($input).val() != '') {
        $.notify("!!حداقل دو حرف از نام قطعه را وارد نمایید", { globalPosition: 'top left' });
    }
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
        $('#partsLoading').hide();
    }
}
var partData = [];
$('.PartsTable').on('click', 'tr', function () {
    var $row = $(this).find("td");
    var $text = $row.text();
    var $value = $row.attr('partid');
    $('#PartsSearchResulat').hide();
    $('#txtPartsSearch').val('');
    $('#txtPartsSearch').removeAttr('placeholder');
    createPartBadge($text, $value);
});
function createPartBadge(text, val) {
    var badgeHtml = '<div class="PartsBadge" ' +
        'onclick="RemovePartBadge($(this));$(this).remove();">' +
        '<label style="direction:rtl;white-space:nowrap;">' + text + '</label> &times;' +
        '</div>';
    $('#PartBadgeArea').append(badgeHtml);
    partData.push({ PartName: text, PartId: val });
    $('#txtPartsSearch').attr('readonly','readonly');
}

function RemovePartBadge(e) {
    $('#txtPartsSearch').attr('placeholder', 'جستجو کنید ...');
    $('#txtPartsSearch').removeAttr('readonly');
    partData = [];
}

$('#txtSubSearchPart').keyup(function () {
    var val = $(this).val();
    $('#gridParts tbody').empty();
    tr.filter(function (idx, el) {
        return val === '' || $(el).text().indexOf(val) >= 0;
    }).appendTo('#gridParts');
});

var ele = $('#no');
$('#gridParts').on('mouseenter', 'tr', function () {
    ele.css({ 'background-color': '' , 'color': ''});
    ele = $(this);
    ele.css({ 'background-color': '#5186d7', 'color': 'white'});
});
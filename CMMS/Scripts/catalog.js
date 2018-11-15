$(function () {
    getAllFiles();
});
function getAllFiles() {
    $('.bodyarea').empty();
    var d = [];
    var midd = -1;
    if ($('#drmachinesearch :selected').val() !== undefined) {
        midd = $('#drmachinesearch :selected').val();
    }
    d.push({
        url: 'WebService.asmx/GetCatalogFiles',
        parameters: [{
            name: $('#txtSearch').val(),
            code: $('#txtCodeSearch').val(),
            unit: $('#drUnits :selected').val(),
            mid: midd
        }],
        func: createDownloadLinks
    });
    AjaxCall(d);
    function createDownloadLinks(e) {
        var file = JSON.parse(e.d);
        var html = [];
        for (var i = 0; i < file.length; i++) {
            html.push('<div class="img-thumbnail">' +
                '<a class="fa fa-download" href="' + file[i].Address + '" target="_blank"></a>' +
                '<span class="filetype">' + fileType(file[i].Address) + '</span>' +
                '<span class="filename">' + file[i].Filename + '</span>' +
                '<span class="filecode">' + file[i].FileCode + '</span>' +
                '<span id="' + file[i].Id + '" class="fa fa-trash delete"></span>' +
                '</div>');
        }
        $('.bodyarea').append(html.join(''));
    }

    function fileType(url) {
        var extension = url.substr((url.lastIndexOf('.') + 1));
        switch (extension) {
            case 'jpg':
                return 'JPG';
            case 'png':
                return 'PNG';
            case 'gif':
                return 'GIF';
            case 'zip':
                return 'ZIP';
            case 'rar':
                return 'RAR';
            case 'pdf':
                return 'PDF';
            default:
                return 'Unknown';
        }
    }
}

$('#drunit').change(function () {
    FilterMachineByUnit('drunit','drMachines');
});

$('#drUnits').change(function () {
    FilterMachineByUnit('drUnits', 'drmachinesearch');
});

$('#drmachinesearch').change(function () {
    getAllFiles();
});

function uploadFile() {
    if ($('#drunit :selected').val() === '-1') {
        RedAlert('drunit', 'لطفا واحد را مشخص نمایید');
        return;
    }
    if ($('#drMachines :selected').val() === '-1') {
        RedAlert('drMachines', 'لطفا دستگاه را مشخص نمایید');
        return;
    }
    if ($('#catfile').val() == '') {
        RedAlert('catalgBorder', 'هیچ فایلی انتخاب نشده است');
        return;
    }
    if ($('#txtcatname').val() == '') {
        RedAlert('txtcatname', 'لطفا نام فایل را مشخص نمایید');
        return;
    }
    var fileUpload = $("#catfile").get(0);
    var files = fileUpload.files;
    if (files.length > 0) {
        var fData = new FormData();
        for (var i = 0; i < files.length; i++) {
            fData.append(files[i].name, files[i]);
        }
        var obj = {
            MachineId: $('#drMachines :selected').val(),
            FileName: $('#txtcatname').val(),
            FileCode: $('#txtcatcode').val()
        };
        fData.append('catData', JSON.stringify(obj));
        $.ajax({
            url: "FileUploader.ashx",
            type: "POST",
            contentType: false,
            processData: false,
            data: fData,
            success: function (e) {
                GreenAlert('n', 'با موفقیت ثبت شد');
                ClearFields('inputsarea');
                getAllFiles();
            },
            error: function () {
                RedAlert('n', "!!خطا در آپلود فایل");
            }
        });
    }
}

var fileId;
$(document).on('click', '.delete', function () {
    fileId = $(this).attr('id');
    $('#deleteModal').show();
});

function deleteFile() {
    var e = [];
    e.push({
        url: 'WebService.asmx/DeleteCatFile',
        parameters: [{ id: fileId }],
        func: successfullyDelete
    });
    AjaxCall(e);

    function successfullyDelete() {
        $('#deleteModal').hide();
        GreenAlert('n', 'با موفقیت حذف شد');
        getAllFiles();
    }
}
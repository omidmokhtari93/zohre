<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="catalog.aspx.cs" Inherits="CMMS.catalog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #drUnits {
            border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;
        }
        .searchbox {
            border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;
        }
        .searchButton {
            position: absolute;
            background-image: url(/Images/Search_Dark.png);
            background-repeat: no-repeat;
            background-size: 15px;
            background-color: transparent;
            width: 15px;
            height: 15px;
            border: none;
            left: 3px;
            top: 3px;
            z-index: 900;
            outline: none;
        }
        .bodyarea {
            padding: 0px 15px 15px 15px;
            max-height: 400px;
            overflow: auto;
        }
        .img-thumbnail {
            position: relative;
            width: 168px;
            height: 100px;
            margin: 5px;
        }
        .img-thumbnail:hover {
            box-shadow: 0 3px 2px rgba(0,0,0,0.09);
        }
        .fa-download {
            position: absolute;
            left: 10px;
            top: 10px;
            font-size: 20pt;
        }
        .filetype {
            padding: 5px 10px 2px 10px;
            background-color: #dfecfe;
            color: black;
            position: absolute;
            top: 10px;
            right: 10px;
            border-radius: 3px;
        }
        .filename {
            position: absolute;
            bottom: 30px;right: 10px;
            color: black;
        }
        .filecode {
            position: absolute;
            bottom: 10px;
            right: 10px;
            color: black;
        }
        .searcharea {
            margin: 0; border: 1px solid rgb(190, 190, 190); border-radius: 5px; background-color: #dfecfe;margin-top: 5px;
        }
        .brdr {
            border: 1px solid darkgray; border-radius: 5px; position: relative;
        }
        .inputsarea {
            border: 1px solid darkgray;
            border-radius: 5px;
        }
        .elemArea {
            padding: 10px;
        }
        .lbl{display: block; text-align: right;}
    </style>
<div class="panel panel-primary">
    <div class="panel-heading">کاتالوگ دستگاه ها</div>
    <div class="panel-body">
        <div class="inputsarea" id="inputsarea">
            <div class="elemArea">
                <div class="row">
                    <div class="col-md-6">
                        ماشین
                        <select class="form-control" dir="rtl" id="drMachines"></select>
                    </div>
                    <div class="col-md-6">
                        واحد
                        <asp:DropDownList runat="server" ID="drunit" CssClass="form-control" ClientIDMode="Static" AppendDataBoundItems="True" 
                                        dir="rtl"  DataSourceID="sqlUnits" DataTextField="unit_name" DataValueField="unit_code" >
                            <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row" style="direction: rtl;">
                    <div class="col-md-4">
                        کد مدرک :
                        <input class="form-control" id="txtcatcode"/>
                    </div>
                    <div class="col-md-4">
                        نام مدرک :
                        <input class="form-control" id="txtcatname"/>
                    </div>
                    <div class="col-md-4">
                        انتخاب فایل
                        <div style="padding: 5px 4px 3px 0;" class="form-control" id="catalgBorder">
                            <input type="file" id="catfile" style="outline: none; width: 200px;"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel-footer">
                <button type="button" class="button" onclick="uploadFile();">ثبت</button>
            </div>
        </div>
        <div class="row searcharea">
            <div class="col-lg-3" style="padding: 5px;">
                <label class="lbl"> : کد مدرک</label>
                <div class="brdr">
                    <input type="text" id="txtCodeSearch" class="searchbox"/>
                    <button type="button" class="searchButton" id="btnSearchCode" onclick="getAllFiles();"></button>
                </div>
            </div>
            <div class="col-lg-3" style="padding: 5px;">
                <label class="lbl"> : نام مدرک</label>
                <div class="brdr">
                    <input type="text" id="txtSearch" class="searchbox"/>
                    <button type="button" class="searchButton" id="btnSearch" onclick="getAllFiles();"></button>
                </div>
            </div>
            <div class="col-lg-3" style="padding: 5px;">
                <label class="lbl">نام ماشین</label>
                <div class="brdr">
                    <select class="searchbox" dir="rtl" id="drmachinesearch"></select>
                </div>
            </div>
            <div class="col-lg-3" style="padding: 5px;">
                <label class="lbl"> : محل استقرار</label>
                <div class="brdr">
                    <asp:DropDownList runat="server" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code" ID="drUnits">
                        <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                </div>
            </div>
        </div>
    </div>
    <div class="bodyarea"></div>
</div>
    <script>
        $(function() {
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
                func:createDownloadLinks
            });
            AjaxCall(d);
            function createDownloadLinks(e) {
                var file = JSON.parse(e.d);
                var html = [];
                for (var i = 0; i < file.length; i++) {
                    html.push('<a class="img-thumbnail" href="'+file[i].Address+'" target="_blank">' +
                        '<span class="fa fa-download"></span>' +
                        '<span class="filetype">' + fileType(file[i].Address)+'</span>' +
                        '<span class="filename">' + file[i].Filename+'</span>' +
                        '<span class="filecode">'+file[i].FileCode+'</span></a>');
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
            if ($('#drunit :selected').val() === '-1') {
                $('#drMachines').empty();
            } else {
                var data = [];
                data.push({
                    url: "WebService.asmx/FilterMachineOrderByLocation",
                    parameters: [{ loc: $('#drunit :selected').val() }],
                    func: createDrmachineCopy
                });
                AjaxCall(data);
                function createDrmachineCopy(e) {
                    var data = JSON.parse(e.d);
                    $('#drMachines').empty();
                    $('#drMachines').append($("<option></option>").attr("value", -1).text('انتخاب کنید'));
                    for (var i = 0; i < data.length; i++) {
                        $('#drMachines').append($("<option></option>").attr("value", data[i].MachineId).text(data[i].MachineName));
                    }
                }
            }
        });

        $('#drUnits').change(function () {
            if ($('#drUnits :selected').val() === '-1') {
                $('#drmachinesearch').empty();
            } else {
                var data = [];
                data.push({
                    url: "WebService.asmx/FilterMachineOrderByLocation",
                    parameters: [{ loc: $('#drUnits :selected').val() }],
                    func: createDrmachineCopy
                });
                AjaxCall(data);
                function createDrmachineCopy(e) {
                    var data = JSON.parse(e.d);
                    $('#drmachinesearch').empty();
                    $('#drmachinesearch').append($("<option></option>").attr("value", -1).text('انتخاب کنید'));
                    for (var i = 0; i < data.length; i++) {
                        $('#drmachinesearch').append($("<option></option>").attr("value", data[i].MachineId).text(data[i].MachineName));
                    }
                }
            }
        });

        $('#drmachinesearch').change(function() {
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
                    success: function(e) {
                        GreenAlert('n', 'با موفقیت ثبت شد');
                        ClearFields('inputsarea');
                        getAllFiles();
                    },
                    error: function() {
                        RedAlert('n', "!!خطا در آپلود فایل");
                    }
                });
            }
        }
    </script>
</asp:Content>

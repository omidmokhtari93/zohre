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
        .delete {
            position: absolute;
            left: 5px;
            bottom: 5px;
            cursor: pointer;
            color: red;
        }
    </style>
<div class="panel panel-primary">
    <div class="panel-heading">کاتالوگ دستگاه ها</div>
    <div class="panel-body">
        <div class="inputsarea" id="inputsarea">
            <div class="elemArea">
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
            <div class="col-md-6" style="padding: 5px;">
                <label class="lbl"> : کد مدرک</label>
                <div class="brdr">
                    <input type="text" id="txtCodeSearch" class="searchbox"/>
                    <button type="button" class="searchButton" id="btnSearchCode" onclick="getAllFiles();"></button>
                </div>
            </div>
            <div class="col-md-6" style="padding: 5px;">
                <label class="lbl"> : نام مدرک</label>
                <div class="brdr">
                    <input type="text" id="txtSearch" class="searchbox"/>
                    <button type="button" class="searchButton" id="btnSearch" onclick="getAllFiles();"></button>
                </div>
            </div>
        </div>
    </div>
    <div class="bodyarea"></div>
    <div id="deleteModal" class="modal" style="direction: rtl;">
        <div class="modal-content">
            <div class="panel panel-danger" style="margin-bottom: 0;">
                <div class="panel-heading" style="font-weight: 800;">حذف کاتالوگ</div>
                <div class="panel-body" style="text-align: center;">
                    <p style="font-weight: 800;">آیا مایل به حذف هستید؟</p>
                    <div style="text-align: center;">
                        <button class="button" type="button" onclick="deleteFile();">حذف</button>
                        <button class="button" type="button" onclick="$('#deleteModal').hide();">انصراف</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <script src="Scripts/catalog.js"></script>
</asp:Content>

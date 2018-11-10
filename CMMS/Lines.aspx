<%@ Page Title="فاز / خطوط تولید" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Lines.aspx.cs" Inherits="CMMS.Lines" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label{ margin: 0;margin-right: 5px;}
        .panel-info{ margin-bottom: 0;}
        #FazTable tr td a:hover{ cursor: pointer;}
        #LineTable tr td a:hover{ cursor: pointer;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">تعریف فاز / خط جدید </div>
        <div class="panel-body">
            <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px;">
                <li class="active"><a data-toggle="tab" href="#NewFaz">تعریف فاز</a></li>
                <li><a data-toggle="tab" href="#NewLine">تعریف خط</a></li>               
            </ul>
            <div class="tab-content" id="opFrom">
                <div id="NewFaz" class="tab-pane fade in active">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="panel-body">
                                <label style="display: block; text-align: right;">نام فاز</label>
                                <input class="form-control" style="direction: rtl;" id="txtFaz"/>
                            </div>
                            <div class="panel-footer">
                                <button id="btninsertFaz" type="button" class="button" onclick="insertOrUpdateData('txtFaz',0,'InsertAndUpdatefaz');">ثبت</button>
                                <button id="btneditFaz" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtFaz',itemId,'InsertAndUpdatefaz')">ویرایش</button>
                                <button id="btncanselFaz" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertFaz','btneditFaz','btncanselFaz');">انصراف</button>
                            </div>
                            <div class="panel-footer">
                                <div class="tablescroll">
                                    <table id="FazTable" class="table">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                

                <div id="NewLine" class="tab-pane fade">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="panel-body">
                                <label style="display: block; text-align: right;">نام خط</label>
                                <input class="form-control" style="direction: rtl;" id="txtLine"/>
                            </div>
                            <div class="panel-footer">
                                <button id="btnInsertLine" class="button" type="button" onclick="insertOrUpdateData('txtLine',0,'InsertAndUpdateline');">ثبت</button>
                                <button id="btneditLine" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtLine',itemId,'InsertAndUpdateline');">ویرایش</button>
                                <button id="btncanselLine" style="display: none;" type="button" class="button" onclick="CancelOperation('btnInsertLine','btneditLine','btncanselLine');">انصراف</button>
                            </div>
                            <div class="panel-footer">
                                <div class="tablescroll">
                                    <table id="LineTable" class="table">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  

               
        </div>
        </div>
    </div>
    <script src="Scripts/Fazline.js"></script>
</asp:Content>


<%@ Page Title="ثبت دلائل وقفه" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="intrupt.aspx.cs" Inherits="CMMS.intrupt" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label{ margin: 0;margin-right: 5px;}
        .panel-info{ margin-bottom: 0;}
        #failTable tr td a:hover{ cursor: pointer;}
        #delayTable tr td a:hover{ cursor: pointer;}
        #stopTable tr td a:hover{ cursor: pointer;}
        #repairTable tr td a:hover{ cursor: pointer;}
        ul.sans {
            direction: rtl;
        }
    </style>
    <div class="card">
        <div class="card-header text-white bg-primary">ثبت دلایل تاخیر / خرابی / توقف / سرویس کاری-تعمیرات </div>
        <div class="card-body">
            <ul class="nav nav-tabs sans" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="StopReason-tab" data-toggle="tab" href="#StopReason" role="tab" aria-controls="home"
                       aria-selected="true">دلایل توقف</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="FailReason-tab" data-toggle="tab" href="#FailReason" role="tab" aria-controls="profile"
                       aria-selected="false">دلایل خرابی</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="DelayReason-tab" data-toggle="tab" href="#DelayReason" role="tab" aria-controls="contact"
                       aria-selected="false">دلایل تاخیر</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="RepairList-tab" data-toggle="tab" href="#RepairList" role="tab" aria-controls="contact"
                       aria-selected="false">لیست سرویسکاری / تعمیرکاری</a>
                </li>
            </ul>
            <div class="tab-content" id="opFrom">
                <div id="StopReason" class="tab-pane fade show  active">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="card-body">
                                <label style="display: block; text-align: right;">دلیل توقف</label>
                                <input class="form-control" style="direction: rtl;" id="txtStop"/>
                            </div>
                            <div class="card-footer">
                                <button id="btninsertStop" type="button" class="button" onclick="insertOrUpdateData('txtStop',0,'InsertAndUpdateStopReason');">ثبت</button>
                                <button id="btneditstop" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtStop',itemId,'InsertAndUpdateStopReason')">ویرایش</button>
                                <button id="btncanselstop" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertStop','btneditstop','btncanselstop');">انصراف</button>
                            </div>
                            <div class="card-footer">
                                <div class="tablescroll">
                               <table id="stopTable" class="table">
                                   <tbody></tbody>
                               </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                

                <div id="FailReason" class="tab-pane fade">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="card-body">
                                <label style="display: block; text-align: right;">دلیل خرابی</label>
                                <input class="form-control" style="direction: rtl;" id="txtFail"/>
                            </div>
                            <div class="card-footer">
                                <button id="btnInsertFail" class="button" type="button" onclick="insertOrUpdateData('txtFail',0,'InsertAndUpdateFailReason');">ثبت</button>
                                <button id="btneditfail" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtFail',itemId,'InsertAndUpdateFailReason');">ویرایش</button>
                                <button id="btncanselfail" style="display: none;" type="button" class="button" onclick="CancelOperation('btnInsertFail','btneditfail','btncanselfail');">انصراف</button>
                            </div>
                            <div class="card-footer">
                                <div class="tablescroll">
                                <table id="failTable" class="table">
                                    <tbody></tbody>
                                </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  

                <div id="DelayReason" class="tab-pane fade">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="card-body">
                                <label style="display: block; text-align: right;">دلیل تاخیر</label>
                                <input class="form-control" style="direction: rtl;" id="txtDelay"/>
                            </div>
                            <div class="card-footer">
                                <button id="btninsertDelay" class="button" type="button" onclick="insertOrUpdateData('txtDelay',0,'InsertAndUpdateDelayReason');">ثبت</button>
                                <button id="btneditdelay" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtDelay',itemId,'InsertAndUpdateDelayReason');">ویرایش</button>
                                <button id="btncanceldelay" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertDelay','btneditdelay','btncanceldelay');">انصراف</button>
                            </div>
                            <div class="card-footer">
                                <div class="tablescroll">
                                <table id="delayTable" class="table">
                                    <tbody></tbody>
                                </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                

                <div id="RepairList" class="tab-pane fade">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="card-body">
                                <label style="display: block; text-align: right;">عملیات سرویسکاری / تعمیرکاری</label>
                                <input class="form-control" style="direction: rtl;" id="txtrepairlist"/>
                            </div>
                            <div class="card-footer">
                                <button id="btninsertrepair" class="button" type="button" onclick="insertOrUpdateData('txtrepairlist',0,'InsertAndUpdateRepair');">ثبت</button>
                                <button id="btneditrepair" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtrepairlist',itemId,'InsertAndUpdateRepair');">ویرایش</button>
                                <button id="btncancelrepair" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertrepair','btneditrepair','btncancelrepair');">انصراف</button>
                            </div>
                            <div class="card-footer">
                                <div class="tablescroll">
                                <table id="repairTable" class="table">
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
    <script src="assets/js/Intrupt.js"></script>
</asp:Content>


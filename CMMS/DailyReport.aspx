<%@ Page Title="گزارش کار روزانه" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="DailyReport.aspx.cs" Inherits="CMMS.daily_report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label{ margin: 0;}
        table tr a{ cursor: pointer;}
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">ثبت گزارش کار روزانه</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6"></div>
                <div class="col-md-3">
                    <label style="display: block; text-align: right;">تهیه کننده گزارش</label>
                    <input class="form-control text-right" dir="rtl" id="txtReportProducer"/>
                </div>
                <div class="col-md-3 text-right">
                    <label style="display: block; text-align: right;">تاریخ</label>
                    <input id="txtDate" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
            </div>
            <hr/>
            <div id="FormArea">
            <div class="row mt-3">
                <div class="col-md-12">
                    <label style="display: block; text-align: right;">شرح گزارش</label>
                    <textarea class="form-control text-right" id="txtReportExplain" style="resize: none; direction: rtl;" rows="4"></textarea>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-12">
                    <label style="display: block; text-align: right;">نکات مهم گزارش</label>
                    <input class="form-control text-right" dir="rtl" id="txtReportTips"/>
                </div>
            </div>
            <hr/>
                <p class="sans">یادآوری ها</p>
            <div class="row">
                <div class="col-md-6">
                    <label style="display: block; text-align: right;">تاریخ یادآوری</label>
                    <input class="form-control text-center" id="txtRemindTime" readonly style="cursor: pointer;"/>
                </div>
                <div class="col-md-6">
                    <label style="display: block; text-align: right;">موضوع</label>
                    <input class="form-control text-right" dir="rtl" id="txtSubject"/>
                </div>
            </div>
            </div>
        </div>
        <div class="card-footer">
            <button class="button" type="button" id="btnSave" onclick="SaveDailyReport(0);">ثبت</button>
            <button class="button" type="button" id="btnEdit" style="display: none;" onclick="SaveDailyReport(Id);">ویرایش</button>
            <button class="button" type="button" id="btnCancel" style="display: none;" onclick="CancelEditDaily();">انصراف</button>
        </div>
        <div class="card-footer">
            <table id="gridDailyReport" class="table">
                <tbody></tbody>
            </table>
        </div>
    </div>
    <script src="assets/js/DailyReport.js"></script>
</asp:Content>

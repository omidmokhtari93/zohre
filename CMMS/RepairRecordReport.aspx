<%@ Page Title="سوابق سرویس کاری" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="RepairRecordReport.aspx.cs" Inherits="CMMS.RepairRecordReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
      label{margin-bottom: 0;}
    </style>
    <div class="card" style="text-align: center;">
        <div class="card-header text-white bg-primary">
            گزارش تعمیرات / سرویس کاری
        </div>
    </div>
    
    <ul class="nav nav-tabs sans mt-1 rtl" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" data-toggle="tab" href="#ServisHistroy" role="tab" aria-controls="home"
               aria-selected="true">سوابق سرویس کاری</a>
        </li>
    </ul>

    <div class="tab-content">
        <div id="ServisHistroy" class="tab-pane fade show active">
            <div class="menubody">
                <div class="row ltr text-right">
                    <div class="col-md-3">
                        <label style="display: block; text-align: right;">: نام ماشین</label>
                        <select class="form-control dr" id="drMachines"></select>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block; text-align: right;">: نام واحد</label>
                        <asp:dropdownlist runat="server" id="drUnits" cssclass="form-control adr" clientidmode="Static" appenddatabounditems="True"
                            datasourceid="SqlUnits" datatextfield="unit_name" datavaluefield="unit_code">
                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                    </asp:dropdownlist>
                        <asp:sqldatasource id="SqlUnits" runat="server" connectionstring="<%$ ConnectionStrings:CMMS %>" selectcommand="SELECT unit_name, unit_code FROM i_units"></asp:sqldatasource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtHistoryEndDate" />
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtHistoryStartDate" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateTableHistory();">دریافت گزارش</button>
                </div>
                <div id="RepairTable" style="margin: 10px auto;"></div>
                <hr />
                <table dir="rtl" id="gridRepairHistory" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="assets/js/RepairRecordReport.js"></script>
</asp:Content>

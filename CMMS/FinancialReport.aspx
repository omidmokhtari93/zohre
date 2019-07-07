<%@ Page Title="گزارشات مالی" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="FinancialReport.aspx.cs" Inherits="CMMS.FinancialReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .badgelbl {
            background-color: lightblue;
            padding: 2px 5px;
            border-radius: 5px;
        }

        label {
            margin: 0;
        }

        .TotalArea {
            display: block;
            text-align: left;
            direction: rtl;
            vertical-align: middle;
            padding: 15px;
        }
    </style>
    <div class="card" style="text-align: center;">
        <div class="card-header bg-primary text-white">
            گزارش هزینه ها
        </div>
    </div>

    <ul class="nav nav-tabs sans mt-1 rtl" role="tablist">
        <li class="nav-item">
            <a class="nav-link active"  data-toggle="tab" href="#RepairCost" role="tab" aria-controls="home"
                aria-selected="true">هزینه کلی تعمیرات</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#ToolsCost" role="tab" aria-controls="profile"
                aria-selected="false">هزینه قطعات</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#ContractorCost" role="tab" aria-controls="profile"
                aria-selected="false">هزینه پیمانکاران</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#PersonelCost" role="tab" aria-controls="profile"
                aria-selected="false">هزینه پرسنل</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#RequestCost" role="tab" aria-controls="profile"
               aria-selected="false">تعمیرات پر هزینه</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#RepairStopCost" role="tab" aria-controls="profile"
               aria-selected="false">هزینه توقفات تعمیرات</a>
        </li>
        <li class="nav-item">
            <a class="nav-link"  data-toggle="tab" href="#ProductStopCost" role="tab" aria-controls="profile"
               aria-selected="false">هزینه توقفات تولید</a>
        </li>
    </ul>

    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[line_name] FROM [dbo].[i_lines]"></asp:SqlDataSource>
    <div class="tab-content">
        <div id="RepairCost" class="tab-pane fade show active">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateRepairCost" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateRepairCost" />
                    </div>

                </div>
                <div class="row ltr text-right" >
                    <div class="col-md-4">
                        <label style="display: block;">: ماشین</label>
                        <select class="form-control dr" id="drMachines"></select>
                    </div>

                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRepairLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRepairUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>

                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="RepairCost();">دریافت گزارش</button>
                </div>
                <div style="padding: 5px;">
                    <label id="lblTotalComment" class="badgelbl"></label>
                </div>
                <table dir="rtl" id="gridRepairCost" class="table">
                    <tbody></tbody>
                </table>
                <div class="TotalArea">
                    <label>جمع کل : </label>
                    <label class="badgelbl" id="lblRepairCost"></label>
                </div>
            </div>
        </div>
        <div id="ToolsCost" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-3">
                        <label style="display: block;">: خط</label>

                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drToolsLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drToolsUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateToolsCost" />
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateToolsCost" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="ToolsCost();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridToolsCost" class="table">
                    <tbody></tbody>
                </table>
                <div class="TotalArea">
                    <label>جمع کل : </label>
                    <label class="badgelbl" id="lblToolsCost"></label>
                </div>
            </div>
        </div>
        <div id="ContractorCost" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-3">
                        <label style="display: block;">: خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drContractLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drContractUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateContractorCost" />
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateContractorCost" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="ContractorCost();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridContractorCost" class="table">
                    <tbody></tbody>
                </table>
                <div class="TotalArea">
                    <label>جمع کل : </label>
                    <label class="badgelbl" id="lblContractorCost"></label>
                </div>
            </div>
        </div>
        <div id="PersonelCost" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-3">
                        <label style="display: block;">: خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPersonelLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPersonelUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDatePersonelCost" />
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDatePersonelCost" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="PersonelCost();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridPersonelCost" class="table">
                    <tbody></tbody>
                </table>
                <div class="TotalArea">
                    <label>جمع کل : </label>
                    <label class="badgelbl" id="lblPersonelCostTotal"></label>
                </div>
            </div>
        </div>
        <div id="RequestCost" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-4">
                        <label style="display: block;">: تعداد نتایج</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMosReqCount" />
                    </div>

                    <div class="col-md-4">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateReqCost" />
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateReqCost" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="RequestCost();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridRequestCost" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
        <div id="RepairStopCost" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateRStopCost" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateRStopCost" />
                    </div>

                </div>
                <div class="row ltr text-right" style="margin: 0; margin-top: 5px; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRStopUnits" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>

                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRStopLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRStopfaz" CssClass="form-control" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id">
                            <asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlFaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,faz_name FROM i_faz"></asp:SqlDataSource>
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" title="هزینه توقفات تعمیراتی" onclick="RStopCost();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridRStopCost" class="table">
                    <tbody></tbody>
                </table>
                <div class="TotalArea">
                    <label>جمع کل : </label>
                    <label class="badgelbl" id="lblRStopCost"></label>
                </div>
            </div>
        </div>
        <div id="ProductStopCost" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDatePrStopCost" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDatePrStopCost" />
                    </div>

                </div>
                <div class="row ltr text-right" style="margin: 0; margin-top: 5px; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPrStopCostUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>

                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPrStopCostLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPrStopCostFaz" CssClass="form-control" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id">
                            <asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" title='هزینه توقفات منجر به توقف تولید' onclick="prStopCost();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridPrStopCost" class="table">
                    <tbody></tbody>
                </table>
                <div class="TotalArea">
                    <label>جمع کل : </label>
                    <label class="badgelbl" id="lblPrStopCost"></label>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/FinancialReports.js"></script>
</asp:Content>

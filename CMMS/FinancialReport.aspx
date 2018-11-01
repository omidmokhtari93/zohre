<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="FinancialReport.aspx.cs" Inherits="CMMS.FinancialReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .badgelbl{ background-color: lightblue;padding: 2px 5px;border-radius: 5px;}
        label{ margin: 0;}
        .TotalArea{display: block; text-align: left; direction: rtl; vertical-align: middle; padding: 15px;}
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارش هزینه ها
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#RepairCost">هزینه کلی تعمیرات</a></li>
        <li ><a data-toggle="tab" href="#ToolsCost">هزینه قطعات</a></li>
        <li ><a data-toggle="tab" href="#ContractorCost">هزینه پیمانکاران</a></li>
        <li><a data-toggle="tab" href="#PersonelCost">هزینه پرسنل</a></li>
    </ul>
    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[line_name] FROM [dbo].[i_lines]"></asp:SqlDataSource>
    <div class="tab-content">
        <div id="RepairCost" class="tab-pane fade in active">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label>
                        
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRepairLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRepairUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateRepairCost"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateRepairCost"/>
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="RepairCost();">دریافت گزارش</button>
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
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label>
                        
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drToolsLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                        
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drToolsUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateToolsCost"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateToolsCost"/>
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
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label> 
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drContractLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                        
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drContractUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDateContractorCost"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDateContractorCost"/>
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
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPersonelLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                      
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPersonelUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDatePersonelCost"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDatePersonelCost"/>
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
    </div>
    <script src="Scripts/FinancialReports.js"></script>
</asp:Content>

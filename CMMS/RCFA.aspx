<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="RCFA.aspx.cs" Inherits="CMMS.RCFA" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .nav li a {
            font-size: 14px;padding: 10px 5px!important
        }
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارشات خرابی
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#FailTypes">نوع خرابی</a></li>
        <li><a data-toggle="tab" href="#MostFails">علت خرابی</a></li>     
        <li><a data-toggle="tab" href="#RepairSub">بیشترین خرابی اجزاء </a></li>
        <li><a data-toggle="tab" href="#PremanturelyFail">خرابی های زودتر از موعد </a></li>
    </ul>
    <asp:SqlDataSource ID="SqlUnit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name],[unit_code] FROM [dbo].[i_units]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[line_name] FROM [dbo].[i_lines]">
    </asp:SqlDataSource>
<div class="tab-content">
<div id="FailTypes" class="tab-pane fade in active">
    <div class="menubody">
        <div class="row" style="margin: 0; text-align: right; direction: ltr;">
            <div class="col-md-3">
                <label style="display: block;"> : خط</label>
                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinefail" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : واحد</label>
                <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitfail" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : تا تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtFailTypeEndDate"/>
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : از تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtFailTypeStartDate"/>
            </div>
        </div>
        <div style="padding: 15px;">
            <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateFailTypeChart();">دریافت گزارش</button>
        </div>
        <div id="FailTypeChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
        <hr 5/>
        <table dir="rtl" id="gridFailTypes" class="table">
            <tbody></tbody>
        </table>
    </div>
</div>
<div id="MostFails" class="tab-pane fade">
    <div class="menubody">
        <div class="row" style="margin: 0; text-align: right; direction: ltr;">
            <div class="col-md-3">
                <label style="display: block;"> : خط</label>
                      
                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinemostfail" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                        
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : واحد</label>
                <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitmostfail" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                      
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : تا تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtMostFailsEndDate"/>
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : از تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtMostFailsStartDate"/>
            </div>
        </div>
        <div style="padding: 15px;">
            <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateMostFailsChart();">دریافت گزارش</button>
        </div>
        <div id="MostFailsChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
        <hr 5/>
        <table dir="rtl" id="gridMostFails" class="table">
            <tbody></tbody>
        </table>
    </div>
</div>
<div id="RepairSub" class="tab-pane fade">
    <div class="menubody">
        <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                   
            <div class="col-md-6">
                <label style="display: block;"> : تا تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtSubEndDate"/>
            </div>
            <div class="col-md-6">
                <label style="display: block;"> : از تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtSubStartDate"/>
            </div>
        </div>
        <div class="row" style="margin: 0;margin-top: 3px; text-align: right; direction: ltr;">
            <div class="col-md-4">
                <label style="display: block;"> : تعداد نتایج</label>
                <input class="form-control text-center" autocomplete="off" id="txtSubCount"/>
            </div>
            <div class="col-md-4">
                <label style="display: block;"> : خط</label>
                       
                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinerepsub" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                      
            </div>
            <div class="col-md-4">
                <label style="display: block;"> : واحد</label>
                <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitrepsub" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                      
            </div>
                   
        </div>  
        <div style="padding: 15px;">
            <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateSubsystemChart();">دریافت گزارش</button>
        </div>
        <div id="RepairsubChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
        <hr 5/>
        <table dir="rtl" id="gridRepairSub" class="table">
            <tbody></tbody>
        </table>
    </div>
</div>
    <div id="PremanturelyFail" class="tab-pane fade">
        <div class="menubody">
            <div class="row" style="margin: 0; text-align: right; direction: ltr;">
               
                <div class="col-md-6">
                    <label style="display: block;"> : تا تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtPreFailEndDate"/>
                </div>
                <div class="col-md-6">
                    <label style="display: block;"> : از تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtPreFailStartDate"/>
                </div>
            </div>
            <div style="padding: 15px;">
                <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreatePreFailTable();">دریافت گزارش</button>
            </div>

            <table dir="rtl" id="gridPreFail" class="table">
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>
    <script src="Scripts/RCFA.js"></script>
</asp:Content>

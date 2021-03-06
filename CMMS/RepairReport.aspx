﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="RepairReport.aspx.cs" Inherits="CMMS.RepairReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .nav li a {
            font-size: 14px;padding: 10px 5px!important
        }
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارش تعمیرات
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        
        <li class="active"><a data-toggle="tab" href="#RepReqTypes">نوع درخواست تعمیر</a></li>
        <li><a data-toggle="tab" href="#MostRepReq">بیشترین درخواست تعمیر</a></li>       
        <li><a data-toggle="tab" href="#MostDelays">علت تاخیر</a></li>
        <li><a data-toggle="tab" href="#RepairAction">عملیات تعمیرکاری</a></li>      
        <li><a data-toggle="tab" href="#RepairTime">مدت زمان تعمیرات / توقفات</a></li>
    </ul>
    <asp:SqlDataSource ID="SqlUnit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name],[unit_code] FROM [dbo].[i_units]">
    </asp:SqlDataSource>
<asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[line_name] FROM [dbo].[i_lines]">
</asp:SqlDataSource>
<asp:SqlDataSource ID="Sqlfaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[faz_name] FROM [dbo].[i_faz]">
</asp:SqlDataSource>

    <div class="tab-content">
     
        <div id="RepReqTypes" class="tab-pane fade in active">
            <div class="menubody">
                
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-6">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtRepReqTypeEndDate"/>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtRepReqTypeStartDate"/>
                    </div>
                </div>
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                         <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drfazreqtype" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>
                      
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label>
                         
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinereqtype" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                      
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitreqtype" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                      
                    </div>
                   
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateRepReqChart();">دریافت گزارش</button>
                </div>
                <div id="RepReqTypeChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <hr 5/>
                <table dir="rtl" id="gridRepReqTypes" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
        <div id="MostRepReq" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">                   
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitrepreq" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                      
                    </div>     
                    <div class="col-md-3">
                        <label style="display: block;"> : تعداد نتایج</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMostRepReqCount"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMostRepReqEndDate"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMostRepReqStartDate"/>
                    </div>      
                    
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateMostRepReqChart();">دریافت گزارش</button>
                </div>
                <div id="MostRepReqChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div> 
                <hr 5/>
                <table dir="rtl" id="gridMostRepReq" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <div id="MostDelays" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-6">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMostDelaysEndDate"/>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMostDelaysStartDate"/>
                    </div>
                </div>
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drfazmostdelay" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>
                      </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinemostdelay" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitmostdelay" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                      </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateMostDelaysChart();">دریافت گزارش</button>
                </div>
                <div id="MostDelaysChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <hr 5/>
                <table dir="rtl" id="gridDelayTime" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
        <div id="RepairAction" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-6">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtRepairActionEndDate"/>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtRepairActionStartDate"/>
                    </div>
                </div>
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drfazrepction" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinerepction" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitrepaction" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    </div>
                   
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateRepairActionChart();">دریافت گزارش</button>
                </div>
                <div id="RepairActionChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <hr 5/>
                <table dir="rtl" id="gridRepairAction" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <div id="RepairTime" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtRepairTimeEndDate"/>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtRepairTimeStartDate"/>
                    </div>
                   <div class="col-md-4">
                       
                           <label style="display: block;"> : انتخاب نوع گزارش</label>
                           <select class="form-control" dir="rtl" id="drRepiarTime">
                               <option value="0">مجموع مدت زمان تعمیر / توقف</option>
                               <option value="1">مدت زمان تعمیرات ماشین</option>
                               <option value="2">مدت زمان توقفات ماشین</option>
                               <option value="3">مدت زمان تعمیر بر مبنای درخواست</option>
                               <option value="4">مدت زمان توقف بر مبنای درخواست</option>
                           </select>
                      
                   </div>
                   
                </div>
                <div class="row" style="margin: 0;margin-top: 3px; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : تعداد نتایج</label>
                        <input class="form-control text-center" type="number" autocomplete="off" id="txtRepairTimeCount"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drfazreptime" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label>
                        
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drlinereptime" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                      
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drunitreptime" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlUnit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                      
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateRepairTimeTable();">دریافت گزارش</button>
                </div>
                <label id="lblRepairTime" style="display: block; color: white;" class="label-primary"></label>
                <table id="gridRepairTime" dir="rtl" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="Scripts/RepairReport.js"></script>
</asp:Content>

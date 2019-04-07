<%@ Page Title="گزراش توقفات" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="StopReport.aspx.cs" Inherits="CMMS.StopReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        table tr a { cursor: pointer;}
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارش توقفات
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#StopPerline">گزارش توقفات مکانیکی/الکتریکی</a></li>
        <li><a data-toggle="tab" href="#StopPerSubsystem">گزارش توقفات تجهیزات </a></li>
        <li><a data-toggle="tab" href="#StopProduct">گزارش توقفات تولید </a></li>
        
    </ul>
    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[line_name] FROM [dbo].[i_lines]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Sqlfaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[faz_name] FROM [dbo].[i_faz]">
    </asp:SqlDataSource>
    <div class="tab-content">
        <div id="StopPerline" class="tab-pane fade in active">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-6">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtunitlineEndDate"/>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtunitlineStartDate"/>
                    </div>
                </div>
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopfaz" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>                     
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label> 
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopUnits" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                   
               
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="Stop();">دریافت گزارش</button>
                </div>
                <div id="StopChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <hr 5/>
                <table dir="rtl" id="gridStopPerline" class="table">
                    <tbody></tbody>
                </table>
               
               
            </div>
        </div>
        <div id="StopPerSubsystem" class="tab-pane fade " >
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
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopSubfaz" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>                     
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label>
                        
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopSubLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopSubUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                  
               
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="StopSub();">دریافت گزارش</button>
                </div>
                <div id="StopSubChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <hr 5/>
                <table dir="rtl" id="gridStopPerSubsystem" class="table">
                    <tbody></tbody>
                </table>
               
               
            </div>
        </div>
        <div id="StopProduct" class="tab-pane fade">
            <div class="menubody">
                <div class="alert alert-info" align="center" style="margin-top: 10px;">گزارش توقفات فنی منجر به توقف تولید</div>
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-6">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtProductEndDate"/>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtProductStartDate"/>
                    </div>
                </div>
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopProductfaz" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id"><asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem></asp:DropDownList>                     
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label>
                        
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopProductLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drStopproductUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                   
               
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="StopProduct();">دریافت گزارش</button>
                </div>
                <div id="StopProductChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <hr 5/>
                <table dir="rtl" id="gridStopProduct" class="table">
                    <tbody></tbody>
                </table>
               
               
            </div>
        </div>
    </div>
    <script src="Scripts/StopReport.js"></script>
</asp:Content>

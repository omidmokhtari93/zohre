<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="RepairRecordReport.aspx.cs" Inherits="CMMS.RepairRecordReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<style>
    .nav li a {
        font-size: 14px;padding: 10px 5px!important
    }
</style>
<div class="panel panel-primary" style="text-align: center;">
    <div class="panel-heading">
     گزارش تعمیرات / سرویس کاری
    </div>
</div>
<ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
    <li class="active"><a data-toggle="tab" href="#ServisHistroy">سوابق سرویس کاری</a></li>
   
   
</ul>

<div class="tab-content">
<div id="ServisHistroy" class="tab-pane fade in active">
    <div class="menubody">
        <div class="row" style="margin: 0; text-align: right; direction: ltr;">
            <div class="col-md-3">
                <label style="display: block; text-align: right;"> : نام ماشین</label>
               
                    <select class="form-control dr" id="drMachines"></select>
             
            </div>
            <div class="col-md-3">
                <label style="display: block; text-align: right;"> : نام واحد</label>
                
                    <asp:DropDownList runat="server" ID="drUnits" CssClass="form-control dr" ClientIDMode="Static" AppendDataBoundItems="True" 
                                      DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code" >
                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
            
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : تا تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtHistoryEndDate"/>
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : از تاریخ</label>
                <input class="form-control text-center" autocomplete="off" id="txtHistoryStartDate"/>
            </div>
        </div>
        <div style="padding: 15px;">
            <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateTableHistory();">دریافت گزارش</button>
        </div>
        <div id="RepairTable" style=" margin: 10px auto;"></div>  
        <hr 5/>
        <table dir="rtl" id="gridRepairHistory" class="table">
            <tbody></tbody>
        </table>
    </div>
</div>

</div>

<script src="Scripts/RepairRecordReport.js"></script>
</asp:Content>

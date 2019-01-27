<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MachineReports.aspx.cs" Inherits="CMMS.MachineReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .btns{width: 100%; font-weight: 500; margin-top: 10px; color: #323232;font-weight: 800;}
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارشات ماشین آلات
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#ActiveMachine">گزارش تجهیزات فعال</a></li>
        <li><a data-toggle="tab" href="#MachineTypes">نوع ماشین آلات</a></li>
        <li><a data-toggle="tab" href="#machinelist">لیست دستگاه ها</a></li>
        <li><a data-toggle="tab" href="#subsystemlist">لیست تجهیزات</a></li>
    </ul>
    <div class="tab-content">
        <div id="ActiveMachine" class="tab-pane fade in active">
            <div class="menubody">
                <select class="form-control" id="drCategory" dir="rtl">
                    <option value="-1">انتخاب کنید</option>
                    <option value="1">ماشین آلات تولید</option>
                    <option value="2">تاسیسات و برق</option>
                    <option value="3">ساختمان</option>
                    <option value="4">حمل و نقل</option>
                </select>
                <div id="ActiveMachineChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <div>
                    <table id="gridActMachine" dir="rtl" class="table">
                    </table>
                </div>
            </div>
        </div>
        <div id="MachineTypes" class="tab-pane fade">
            <div class="menubody">
                <button type="button" style="width: 100%;" class="btn btn-info" onclick="machineTypes();">دریافت گزارش</button>
                <div id="MachineTypesChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <div>
                    <table id="gridTypMachine" dir="rtl" class="table">
                    </table>
                </div>
            </div>
        </div>
        <div id="machinelist" class="tab-pane fade">
            <div class="menubody">
                <asp:DropDownList dir="rtl" runat="server" ID="drmachineunits" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code">
                    <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                </asp:DropDownList>
                <a class="btn btn-info btns" onclick="MachineReport();">مشاهده</a>
                <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                <div id="MachineListPrint">
                </div>
            </div>
        </div>
        <div id="subsystemlist" class="tab-pane fade">
            <div class="menubody">
                <asp:DropDownList dir="rtl" ID="drsubsystemunits" runat="server" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code">
                    <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                </asp:DropDownList>
                <a class="btn btn-info btns" onclick="SubsystemReport();">مشاهده</a>
                <div id="SubsystemListPrint">
                </div>
            </div>
        </div>
    </div>
    <script src="Scripts/MachineRepor.js"></script>
</asp:Content>

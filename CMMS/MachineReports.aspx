<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MachineReports.aspx.cs" Inherits="CMMS.MachineReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .btns{width: 100%; font-weight: 500; margin-top: 10px; color: #323232;font-weight: 800;}

    </style>
    <div class="card" style="text-align: center;">
        <div class="card-header bg-primary text-white">
            گزارشات ماشین آلات
        </div>
    </div>
    
    <ul class="nav nav-tabs sans-small mt-1 rtl" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="Mtbf-tab" data-toggle="tab" href="#ActiveMachine" role="tab" aria-controls="home"
               aria-selected="true">گزارش تجهیزات فعال</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrPerRepiar-tab" data-toggle="tab" href="#MachineTypes" role="tab" aria-controls="profile"
               aria-selected="false">نوع ماشین آلات</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrPerStop-tab" data-toggle="tab" href="#machinelist" role="tab" aria-controls="profile"
               aria-selected="false">لیست دستگاه ها/ماشین آلات</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrReport-tab" data-toggle="tab" href="#subsystemlist" role="tab" aria-controls="profile"
               aria-selected="false">لیست تجهیزات</a>
        </li>
    </ul>
    
    <div class="tab-content">
        <div id="ActiveMachine" class="tab-pane fade show active">
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
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : خط</label>
                         
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drline" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                      
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : فاز</label>
                        <asp:DropDownList dir="rtl" runat="server" AppendDataBoundItems="True" ID="drfaz" ClientIDMode="Static" CssClass="form-control" DataSourceID="Sqlfaz" DataTextField="faz_name" DataValueField="id">
                            <asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>  
                      
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList dir="rtl" runat="server" ID="drmachineunits" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                        </asp:DropDownList>
                    </div>
               </div>
                <div style="padding: 15px;">
                     <a class="btn btn-info btns" onclick="MachineReport();">مشاهده</a>
                    
                     <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, line_name FROM i_lines"></asp:SqlDataSource>
                    <asp:SqlDataSource ID="Sqlfaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, faz_name FROM i_faz"></asp:SqlDataSource>
                
                    <div id="MachineListPrint" >
                  </div>
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
    <script src="assets/js/MachineReport.js"></script>
   
</asp:Content>

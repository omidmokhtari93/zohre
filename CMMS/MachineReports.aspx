<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MachineReports.aspx.cs" Inherits="CMMS.MachineReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارشات ماشین آلات
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#ActiveMachine">گزارش تجهیزات فعال</a></li>
        <li><a data-toggle="tab" href="#MachineTypes" onclick="machineTypes();">نوع ماشین آلات</a></li>
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
            </div>
        </div>
        <div id="MachineTypes" class="tab-pane fade">
            <div class="menubody">
                <div id="MachineTypesChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
            </div>
        </div>
    </div>
    <script>
        $('#drCategory').on('change',function() {
            var obj = {
                url: 'Activemachin',
                data: [],    
                element: 'ActiveMachineChart',
                header: 'ماشین آلات فعال',
                chartype: 'pie'
            };
            obj.data.push({
                kind: $('#drCategory :selected').val()
            });
            GetChartData(obj);
        });

        function machineTypes() {
            var obj = {
                url: 'MachinType',
                data: [],  
                element: 'MachineTypesChart',
                header: 'نوع ماشین آلات',
                chartype: 'pie'
            };
            GetChartData(obj);
        }
    </script>
</asp:Content>

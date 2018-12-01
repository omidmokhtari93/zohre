<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="EditMainMachine.aspx.cs" Inherits="CMMS.EditMainMachine" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<style>
    .searchButton {
        position: absolute;
        background-image: url(/Images/Search_Dark.png);
        background-repeat: no-repeat;
        background-size: 15px;
        background-color: transparent;
        width: 15px;
        height: 15px;
        border: none;
        left: 3px;
        top: 3px;
        z-index: 900;
        outline: none;
    }
    .gridButton{ padding: 1px 2px;background-color: #2461be;color: white;font-weight: 500;border-radius: 2px;}
    .gridButton:hover{ color: white;text-decoration: none;background-color: #1b498e;}
    label{ margin: 0;}
    #gridDailyCM td:nth-child(0){ display: none;}
    #gridEnergy tr td a{ cursor: pointer;}
    #gridRepairRecord tr td a{ cursor: pointer;}
    #gridRepairRequest tr td a{ cursor: pointer;}
    #gridMachines table { text-align: center;border: 1px solid #c6cdd5;}
    #gridMachines table tr td{ padding: 0 3px!important;}
    #gridMachines tr td{ padding: 2px 0!important;}
    .fa-trash{ color: red;}
</style>
  
<div class="panel panel-primary" runat="server" ID="pnlMachineInfo">
    <div class="panel-heading">ویرایش اطلاعات اولیه ماشین آلات</div>
    <div class="panel-body">
        <div style="width: 100%; padding: 2px 15px 2px 15px; text-align: center;">
           
            <asp:GridView runat="server" dir="rtl" ID="gridMainMachines" CssClass="table" AutoGenerateColumns="False" ClientIDMode="Static"
                          DataKeyNames="id" DataSourceID="SqlEditMachine" OnRowCommand="gridMainMachines_OnRowCommand" AllowPaging="True" PageSize="15">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <input type="hidden" id="machineId" value='<%# Eval("id") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="rw" HeaderText="ردیف" SortExpression="rw" />
                    <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name" />
                   
                  
                    <asp:ButtonField CommandName="Ed">
                        <ControlStyle CssClass="fa fa-pencil"></ControlStyle>
                    </asp:ButtonField>
                    
                    <asp:ButtonField CommandName="del">
                        <ControlStyle CssClass="fa fa-trash"></ControlStyle>
                    </asp:ButtonField>
                </Columns>
                <PagerStyle HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlEditMachine" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
            SELECT ROW_NUMBER() OVER (Order by id) AS rw,dbo.b_machine.name,dbo.b_machine.id FROM dbo.b_machine "></asp:SqlDataSource>
        </div>
    </div>
</div>
    
<div class="panel panel-danger" style="width: 50%;" runat="server" ID="pnlDeleteMachine" Visible="False">
    <div class="panel-heading" style="text-align: center;">حذف ماشین</div>
    <div class="panel-body">
        <asp:Label runat="server" ID="lblMachineName" CssClass="label label-danger"></asp:Label>
        <label style="text-align: center; display: block; color: black; margin-top: 15px;" >
            کاربر گرامی در صورت حذف دستگاه / ماشین کلیه موارد ثبت شده برای این دستگاه حذف خواهد شد
            <br>
            آیا مایل به حذف هستید؟
        </label>
        <div class="row" style="margin: 0; margin-top: 15px;">
            <div class="col-lg-6">
                <asp:Button runat="server" Width="100%" CssClass="greenbutton" Text="انصراف" ID="no" OnClick="no_OnClick"/>
            </div>
            <div class="col-lg-6">
                <asp:Button runat="server" Width="100%" CssClass="redbutton" Text="حذف اطلاعات ماشین" ID="yes" OnClick="yes_OnClick"/>
            </div>
        </div>
    </div>
</div>

<script src="Scripts/EditMachine.js"></script>

</asp:Content>

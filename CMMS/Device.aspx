<%@ Page Title="کد گزاری تجهیزات" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Device.aspx.cs" Inherits="CMMS.Device" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .hidethis{ display: none;}
        label{ margin: 0;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">لیست دستگاه/ماشین

        </div>
        <div class="panel-body">
            <div class="row" style="margin: 0; direction: rtl; text-align: right;">
                <div class="col-md-6">
                    <label>کد دستگاه</label>
                    <asp:TextBox runat="server" ClientIDMode="Static" placeholder="عدد سه رقمی وارد نمایید" CssClass="form-control" TabIndex="1" ID="txtDeviceCode"></asp:TextBox>        
                </div>
                <div class="col-md-6">
                    <label>نام دستگاه</label>
                    <asp:TextBox CssClass="form-control" ClientIDMode="Static" runat="server" TabIndex="2" ID="txtDeviceName"></asp:TextBox>        
                </div>
            </div>
        </div>
        <div class="panel-footer">
            <asp:Button runat="server" ClientIDMode="Static" CssClass="button" TabIndex="4" Text="ثبت" ID="btnSave" OnClick="btnSave_OnClick"/>
            <asp:Button id="btnedit" runat="server" Visible="False" CssClass="button" Text="ویرایش" TabIndex="6" OnClick="btnedit_OnClick" OnClientClick="getRadio();getactRadio();"/>
            <asp:Button id="btncancel" runat="server" Visible="False" CssClass="button" Text="انصراف" TabIndex="7" OnClick="btncancel_OnClick"/>
        </div>
        <div class="panel-footer">
            <div class="tablescroll">
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="SqlDevice" DataKeyNames="id" ID="gridDevice" OnRowCommand="gridDevice_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="id">
                        <ItemStyle CssClass="hidethis"></ItemStyle>
                        <HeaderStyle CssClass="hidethis"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" ReadOnly="True"/>
                    <asp:BoundField DataField="DeviceName" HeaderText="نام دستگاه" SortExpression="DeviceName" />
                    <asp:BoundField DataField="DeviceCode" HeaderText="کد دستگاه" SortExpression="DeviceCode" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                    
                </Columns>
            </asp:GridView>
            </div>
            <asp:SqlDataSource ID="SqlDevice" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER() OVER (ORDER BY id) AS rownum, id, DeviceName, DeviceCode FROM i_devices" >
                <UpdateParameters>
                    <asp:Parameter Name="DeviceName" />
                    <asp:Parameter Name="DeviceCode" />
                    <asp:Parameter Name="id" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    <script>
        function CodeError() {
            $.notify("☓ کد دستگاه تکراری می باشد", {
                className: 'error',
                clickToHide: false,
                autoHide: true,
                position: 'top left'
            });
        }
        function NameError() {
            $.notify("☓ نام دستگاه تکراری می باشد", {
                className: 'error',
                clickToHide: false,
                autoHide: true,
                position: 'top left'
            });
        }
        function Err() {
            if ($('#txtDeviceName').val() == '') {
                $('#txtDeviceName').addClass('form-controlError');
                setTimeout(function () { $('#txtDeviceName').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام دستگاه را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtDeviceCode').val() == '') {
                $('#txtDeviceCode').addClass('form-controlError');
                setTimeout(function () { $('#txtDeviceCode').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا کد دستگاه را وارد نمایید", { globalPosition: 'top left' });
            }
           
        }
    </script>
</asp:Content>

<%@ Page Title="مدیریت واحد ها" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="addunit.aspx.cs" Inherits="CMMS.addunit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .hidethis{ display: none;}
        .print{display: block; text-align: center; font-size: 15pt; color: black; padding: 5px;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">ثبت واحد جدید</div>
        <div class="panel-body">
            <div class="row" style="margin: 0; direction: rtl; text-align: right;">
                <div class="col-md-4">
                    <label>نام سرپرست واحد</label>
                    <asp:TextBox CssClass="form-control" ClientIDMode="Static" runat="server" TabIndex="3" ID="txtunitmanager"></asp:TextBox>        
                </div>
                <div class="col-md-4">
                    <label>نام واحد</label>
                    <asp:TextBox runat="server" ClientIDMode="Static" CssClass="form-control" TabIndex="2" ID="txtunitName"></asp:TextBox>        
                </div>
                <div class="col-md-4">
                    <label>کد واحد</label>
                    <asp:TextBox runat="server" ClientIDMode="Static" placeholder="عدد دو رقمی وارد نمایید" CssClass="form-control" TabIndex="1" ID="txtUnitCode"></asp:TextBox>        
                </div>
            </div> 
        </div>
        <div class="panel-footer">
            <asp:Button runat="server" ClientIDMode="Static" CssClass="button" TabIndex="4" Text="ثبت" ID="btnSave" OnClick="btnSave_OnClick"/>
        </div>
        <div class="panel-footer">
            <a href="UnitPrint.aspx" class="fa fa-print print" target="_blank" title="پرینت"></a>
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="SqlUnits" DataKeyNames="id" ID="gridUnits">
                <Columns>
                    <asp:BoundField DataField="id">
                        <ItemStyle CssClass="hidethis"></ItemStyle>
                        <HeaderStyle CssClass="hidethis"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" ReadOnly="True"/>
                    <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name" />
                    <asp:BoundField DataField="unit_manager" HeaderText="سرپرست واحد" SortExpression="unit_manager" />
                    <asp:BoundField DataField="unit_code" HeaderText="کد واحد" SortExpression="unit_code" />
                    <asp:CommandField EditText="ویرایش" CancelText="لغو" ShowEditButton="True" UpdateText="ویرایش"/>
                    
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER() OVER (ORDER BY id) AS rownum, id, unit_name, unit_manager,unit_code FROM i_units" UpdateCommand="UPDATE i_units SET unit_name = @unit_name, unit_manager = @unit_manager, unit_code=@unit_code WHERE (id = @id)">
                <UpdateParameters>
                    <asp:Parameter Name="unit_name" />
                    <asp:Parameter Name="unit_manager" />
                    <asp:Parameter Name="unit_code" />
                    <asp:Parameter Name="id" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    <script>
        function CodeError() {
            $.notify("☓ کد واحد تکراری می باشد", {
                className: 'error',
                clickToHide: false,
                autoHide: true,
                position: 'bottom center'
            });
        }
        function Err() {
            if ($('#txtunitName').val() == '') {
                $('#txtunitName').addClass('form-controlError');
                setTimeout(function () { $('#txtunitName').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام واحد را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtunitmanager').val() == '') {
                $('#txtunitmanager').addClass('form-controlError');
                setTimeout(function () { $('#txtunitmanager').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام  مدیر واحد را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtUnitCode').val() == '') {
                $('#txtUnitCode').addClass('form-controlError');
                setTimeout(function () { $('#txtunitmanager').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا کد واحد را وارد نمایید", { globalPosition: 'top left' });
            }
        }
    </script>
</asp:Content>


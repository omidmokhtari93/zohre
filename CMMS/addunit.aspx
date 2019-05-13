<%@ Page Title="مدیریت واحد ها" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="addunit.aspx.cs" Inherits="CMMS.addunit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .hidethis{ display: none;}
        .print{display: block; text-align: center; font-size: 15pt; color: black; padding: 5px;}
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">ثبت واحد جدید</div>
        <div class="card-body">
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
        <div class="card-footer">
            <asp:Button runat="server" ClientIDMode="Static" CssClass="button" TabIndex="4" Text="ثبت" ID="btnSave" OnClick="btnSave_OnClick"/>
            <asp:Button runat="server" ClientIDMode="Static" CssClass="button" TabIndex="5" Text="ویرایش" ID="btnEdit" OnClick="btnEdit_OnClick" Visible="False"/>
            <asp:Button runat="server" ClientIDMode="Static" CssClass="button" TabIndex="6" Text="انصراف" ID="btnCancel" OnClick="btnCancel_OnClick" Visible="False"/>
        </div>
        <div class="card-footer">
            <a href="UnitPrint.aspx" class="fa fa-print print" target="_blank" title="پرینت"></a>
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="SqlUnits" DataKeyNames="id,unit_code" ID="gridUnits" OnRowCommand="gridUnits_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="id">
                        <ItemStyle CssClass="hidethis"></ItemStyle>
                        <HeaderStyle CssClass="hidethis"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" ReadOnly="True"/>
                    <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name" />
                    <asp:BoundField DataField="unit_manager" HeaderText="سرپرست واحد" SortExpression="unit_manager" />
                    <asp:BoundField DataField="unit_code" HeaderText="کد واحد" SortExpression="unit_code" />
                    <asp:ButtonField Text="ویرایش" CommandName="edt"/>
                    <asp:ButtonField Text="حذف" CommandName="del"/>
                    
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER() OVER (ORDER BY unit_name) AS rownum, id, unit_name, unit_manager,unit_code FROM i_units order by unit_name" >
                
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
        function DellError() {
            $.notify("☓ .این واحد در برنامه استفاده شده است.بررسی نمایید", {
                className: 'error',
                clickToHide: false,
                autoHide: true,
                position: 'bottom center'
            });
        }
        function Dellsucsess() {
            $.notify("واحدبا موفقیت حذف گردید", {
                className:'save',
                clickToHide: false,
                autoHide: true,
                position: 'top left'
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
                setTimeout(function () { $('#txtUnitCode').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا کد واحد را وارد نمایید", { globalPosition: 'top left' });
            }
        }
    </script>
</asp:Content>


<%@ Page Title="خطوط تولید" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Lines.aspx.cs" Inherits="CMMS.Lines" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary">
    <div class="panel-heading">تعریف خط جدید </div>
    <div class="panel-body">
        <div class="row" style="margin: 0; direction: rtl; text-align: right;">
            
            <div class="col-md-6">
                             
            </div>
            <div class="col-md-6">
                <label>نام خط : </label>
                <asp:TextBox id="txtline" CssClass="form-control" runat="server" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
            </div>
        </div>
        <asp:SqlDataSource ID="sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name], [unit_code] FROM [i_units]"></asp:SqlDataSource>
    </div>
        <div class="panel-footer">
            <asp:Button id="btninsert" runat="server" CssClass="button" Text="ثبت" TabIndex="3" OnClick="btninsert_OnClick" />
            <asp:Button id="btnedit" runat="server" CssClass="button" Visible="False" Text="ویرایش" TabIndex="4" OnClick="btnedit_OnClick" />
            <asp:Button id="btncancel" runat="server" CssClass="button" Visible="False" Text="انصراف" TabIndex="5" OnClick="btncancel_OnClick"/>
        </div>
        <div class="panel-footer">
               
            <asp:GridView runat="server" CssClass="table" ID="gridLines" AutoGenerateColumns="False" DataSourceID="sqlLine" OnRowCommand="gridLines_OnRowCommand" DataKeyNames="id">
                <Columns>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" ReadOnly="True" SortExpression="rownum" />
                   
                    <asp:BoundField DataField="line_name" HeaderText="نام خط" SortExpression="line_name" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sqlLine" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER() OVER (ORDER BY i_lines.id) AS rownum, i_lines.id, i_lines.line_name FROM i_lines "></asp:SqlDataSource>
        </div>
    </div>
    <script>
        function Err() {
            if ($('#txtline').val() == '') {
                $('#txtline').addClass('form-controlError');
                setTimeout(function () { $('#txtline').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام خط را وارد نمایید", { globalPosition: 'top left' });
            }
        }

    </script>
</asp:Content>


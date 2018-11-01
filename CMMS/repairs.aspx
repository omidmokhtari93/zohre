<%@ Page Title="لیست تعمیرات" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="repairs.aspx.cs" Inherits="CMMS.repairs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary">
        <div class="panel-heading">ثبت تعمیر</div>
        <div class="panel-body">
            <div class="row" style="margin: 0; direction: rtl; text-align: right;">
                <div class="col-md-12">
                    <label>عملیات تعمیر</label>
                    <asp:TextBox CssClass="form-control" runat="server" ID="txtoprepair"></asp:TextBox>        
                </div>
                
            </div>
        </div>
        <div class="panel-footer">
            <asp:Button runat="server" CssClass="button" Text="ثبت" ID="btninsert" OnClick="btninsert_Click" />
            <asp:Button runat="server" CssClass="button" Text="ویرایش" ID="btnedit" Visible="False" OnClick="btnedit_Click" />
            <asp:Button runat="server" CssClass="button" Text="انصراف" ID="btncancel" Visible="False" OnClick="btncancel_Click"/>
            <asp:SqlDataSource ID="sqloperation" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over (order by id) as rownum,[id], [operation] FROM [i_repairs]"></asp:SqlDataSource>
        </div>
        <div class="panel-footer">
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" ID="gridrepairs" DataSourceID="sqloperation" DataKeyNames="id" OnRowCommand="gridrepairs_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" SortExpression="rownum" />
                    <asp:BoundField DataField="operation" HeaderText="عملیات تعمیر" SortExpression="operation" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                </Columns>
            </asp:GridView>
        </div>
    </div>
<script>
    function Err() {
        if ($('#txtoprepair').val() == '') {
            $('#txtoprepair').addClass('form-controlError');
            setTimeout(function () { $('#txtoprepair').removeClass('form-controlError'); }, 4000);
            $.notify("!!لطفا عملیات تعمیر را وارد نمایید", { globalPosition: 'top left' });
        }
       
    }
</script>
    </asp:Content>

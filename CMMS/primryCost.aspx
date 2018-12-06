<%@ Page Title="هزینه های پایه" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="primryCost.aspx.cs" Inherits="CMMS.primryCost" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label {
            margin: 0;
            margin-right: 5px;
        }
    </style>
    <div class="panel panel-primary">
    <div class="panel-heading">هزینه های پایه</div>
    <div class="panel-body">
        <div class="row" style="margin: 0; direction: rtl; text-align: right;">
           <div class="col-md-8"></div>
            <div class="col-md-4 text-right">
                <label>هزینه های سال مالی : </label>
                <asp:DropDownList runat="server" TabIndex="1" ClientIDMode="Static" CssClass="form-control" ID="drYear" AppendDataBoundItems="True" DataSourceID="SqlYear" DataTextField="year" DataValueField="year">
                    <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                </asp:DropDownList>        
                <asp:SqlDataSource ID="SqlYear" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT year FROM d_year"></asp:SqlDataSource>
            </div>
        </div>
        <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
            <div class="col-md-4">
                <label>حقوق سرشیفت : </label>
                <asp:TextBox ClientIDMode="Static" TabIndex="4" dir="ltr"  ID="txtheadworker" placeholder="ریال" runat="server" CssClass="form-control"  ></asp:TextBox>    
            </div>
            <div class="col-md-4">
                <label>حقوق سرپرست : </label>
                <asp:TextBox ClientIDMode="Static" TabIndex="3" dir="ltr" ID="txtmanager" placeholder="ریال" CssClass="form-control" runat="server" ></asp:TextBox>   
            </div>
            <div class="col-md-4">
                <label>حقوق مدیر فنی : </label>
                <asp:TextBox ClientIDMode="Static" TabIndex="2" dir="ltr"  ID="txttechnicalmanager" placeholder="ریال" runat="server" CssClass="form-control"></asp:TextBox>        
            </div>
        </div>
        <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <label>حقوق نیروی معمولی : </label>
                <asp:TextBox ClientIDMode="Static" TabIndex="6" dir="ltr"  ID="txtworker" placeholder="ریال" CssClass="form-control" runat="server"></asp:TextBox> 
            </div>
            <div class="col-md-4">
                <label>حقوق نیروی ماهر: </label>
                <asp:TextBox ClientIDMode="Static" TabIndex="5"  dir="ltr" ID="txtexpert" placeholder="ریال" CssClass="form-control" runat="server"></asp:TextBox>
                      
            </div>
        </div>
    </div>
    <div class="panel-footer">
        <asp:Button runat="server" CssClass="button" TabIndex="7" Text="ثبت" ID="btnSabt" OnClientClick="getRadio();" OnClick="btnSabt_Click" />
        <asp:Button runat="server" CssClass="button" Text="ویرایش" Visible="False" ID="btnEdit" OnClientClick="getRadio();" OnClick="btnEdit_Click" />
        <asp:Button runat="server" CssClass="button" Text="انصراف" Visible="False" ID="btnCancel" OnClick="btnCancel_Click" />
    </div>
        <div class="panel-footer">
            <asp:SqlDataSource ID="sqlcost_year" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[cost_year],[worker],[expert],[headworker],[manager],[technical_manager] FROM [dbo].[i_costs] order by cost_year"></asp:SqlDataSource>
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="sqlcost_year" DataKeyNames="id" ID="gridCost"  OnRowCommand="gridCost_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="cost_year" HeaderText="سال مالی" SortExpression="cost_year" />
                    <asp:BoundField DataField="worker" HeaderText="حقوق کارگر معمولی" SortExpression="worker" />
                    <asp:BoundField DataField="expert" HeaderText="حقوق کارگر ماهر" SortExpression="expert" />
                    <asp:BoundField DataField="headworker" HeaderText="حقوق سرشیفت" SortExpression="headworker" />
                    <asp:BoundField DataField="manager" HeaderText="حقوق سرپرست" SortExpression="manager" />
                    <asp:BoundField DataField="technical_manager" HeaderText="حقوق مدیرفنی" SortExpression="technical_manager" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                </Columns>
            </asp:GridView>
    </div>
 </div>
   <script>
       $.fn.Digit = function () {
           if ($(this).val()=='') {
               return;
           }
           var num = $(this).val().replace(/,/g, "");
           var intnumber = parseInt(num);
           $(this).val(intnumber.toLocaleString());
       }

       $('#txtheadworker').on('keyup', function() {
           $(this).Digit();
       });
       $('#txtmanager').on('keyup', function () {
           $(this).Digit();
       });
       $('#txttechnicalmanager').on('keyup', function () {
           $(this).Digit();
       });
       $('#txtworker').on('keyup', function () {
           $(this).Digit();
       });
       $('#txtexpert').on('keyup', function () {
           $(this).Digit();
       });
   </script>
</asp:Content>


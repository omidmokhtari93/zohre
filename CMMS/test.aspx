<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="CMMS.test" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <asp:DropDownList runat="server" ClientIDMode="Static" CssClass="chosen-select" ID="dr" DataSourceID="sqlfail" DataTextField="fail" DataValueField="id">
    </asp:DropDownList>
    <asp:SqlDataSource ID="sqlfail" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,fail FROM i_fail_reason"></asp:SqlDataSource>

    <script>
        $(".chosen-select").chosen({width:"50%"});
    </script>
</asp:Content>
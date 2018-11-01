<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="CMMS.test" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="text" id="txt" onkeyup="eletyping('load','myfunc');" onkeydown="elekeydown();" autocomplete="off"/>
    <img id="load" src="Images/loading.png" style="width: 15px; height: 15px; display: none;"/>
    <script>
        var typingTimer = 0;
        var doneTypingInterval = 2000;
        var $e;
        function eletyping(loading,func) {
            $e = $('#' + loading);
            $e.show();
            clearTimeout(typingTimer);
            typingTimer = setTimeout(func, doneTypingInterval);
        }
        function elekeydown() {
            clearTimeout(typingTimer);
        }
        function doneTyping() {
            $e.hide();
        }
    </script>
</asp:Content>
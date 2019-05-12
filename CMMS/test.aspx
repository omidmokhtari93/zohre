<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="CMMS.test" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="assets/js/search.js"></script>
    <style>
         .search-input {
             position: relative;
             display: block;
             width: 100%;
             height: 38px;
             padding: 3px 35px 3px 3px;
             font-size: 1rem;
             line-height: 1.5;
             color: #495057;
             background-color: #e6f3ff;
             background-clip: padding-box;
             border: 1px solid #ced4da;
             border-radius: .25rem;
             transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
             background-image: url(assets/Images/Search_Dark.png);
             background-repeat: no-repeat;
             background-position: right 10px bottom 10px;
             background-size: 15px;
         }
         .search-input input {
             border: none;
             width: 100%;
             height: 100%;
             outline: none;
             font-size: 10pt;
             font-family: sans;
             font-weight: bold;
             padding: 2px 5px;
         }
         .search-input ul {
             width: 100%;
         }
         
    </style>
  <div id="inp">
  </div>
    <script>
        $(function() {
            $('#inp').search({
                width: '55%',
                placeholder: 'جستجوی قطعه ...'
            });  
        })
    </script>
</asp:Content>
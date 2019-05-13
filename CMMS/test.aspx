﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="CMMS.test" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="assets/css/search.css" rel="stylesheet" />
    <script src="assets/js/search.js"></script>
    <div class="row">
        <div class="col-md-4">
            <div id="inp"></div>
        </div>
        <div class="col-md-4">
            <input class="form-control"/>
        </div>
        <div class="col-md-4">
            <div id="mm"></div>
        </div>
    </div>
    <script>
        $(function() {
            $('#inp').search({
                width: '80%',
                placeholder: 'جستجوی قطعه ...',
                url: 'WebService.asmx/PartsFilter',
                arg: 'partName',
                text: 'PartName',
                id:'PartId'
            }); 
            $('#mm').search({
                width: '100%',
                placeholder: 'جستجو ...',
                url: 'WebService.asmx/FilteredGridSubSystem',
                arg: 'subSystemName',
                text: 'ToolName',
                id: 'ToolId'
            }); 
        })
    </script>
</asp:Content>
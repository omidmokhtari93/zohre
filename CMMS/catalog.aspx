<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="catalog.aspx.cs" Inherits="CMMS.catalog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #drUnits {
            border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;
        }
        .searchbox {
            border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;
        }
        .searchButton {
            position: absolute;
            background-image: url(/Images/Search_Dark.png);
            background-repeat: no-repeat;
            background-size: 15px;
            background-color: transparent;
            width: 15px;
            height: 15px;
            border: none;
            left: 3px;
            top: 3px;
            z-index: 900;
            outline: none;
        }
        .bodyarea {
            padding: 0px 15px 15px 15px;
        }
        .img-thumbnail {
            position: relative;
            width: 168px;
            height: 100px;
            margin: 5px;
        }
        .img-thumbnail:hover {
            box-shadow: 0 3px 2px rgba(0,0,0,0.09);
        }
        .fa-download {
            position: absolute;
            left: 10px;
            top: 10px;
            font-size: 20pt;
        }
        .filetype {
            padding: 5px 10px 2px 10px;
            background-color: #dfecfe;
            color: black;
            position: absolute;
            top: 10px;
            right: 10px;
            border-radius: 3px;
        }
        .filename {
            position: absolute;
            bottom: 30px;right: 10px;
            color: black;
        }
        .filecode {
            position: absolute;
            bottom: 10px;
            right: 10px;
            color: black;
        }
    </style>
<div class="panel panel-primary">
    <div class="panel-heading">کاتالوگ دستگاه ها</div>
    <div class="panel-body">
        <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190); border-radius: 5px; background-color: #dfecfe;">
            <div class="col-lg-4" style="padding: 5px;">
                <label style="display: block; text-align: right;"> : محل استقرار</label>
                <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                    <asp:DropDownList runat="server" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code" ID="drUnits">
                        <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                </div>
            </div>
            <div class="col-lg-4" style="padding: 5px;">
                <label style="display: block; text-align: right;"> : کد مدرک</label>
                <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                    <input type="text" id="txtCodeSearch" class="searchbox"/>
                    <button class="searchButton" id="btnSearchCode"></button>
                </div>
            </div>
            <div class="col-lg-4" style="padding: 5px;">
                <label style="display: block; text-align: right;"> : نام مدرک</label>
                <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                    <input type="text" id="txtSearch" class="searchbox"/>
                    <button class="searchButton" id="btnSearch"></button>
                </div>
            </div>
        </div>
    </div>
    <div class="bodyarea">
        <a class="img-thumbnail" href="Images/aboutus.png" target="_blank">
            <span class="fa fa-download"></span>
            <span class="filetype">PDF</span>
            <span class="filename">کاتالوگ شماره 5</span>
            <span class="filecode">54665555</span>
        </a>
    </div>
</div>
</asp:Content>

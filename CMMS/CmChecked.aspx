﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="CmChecked.aspx.cs" Inherits="CMMS.CmChecked" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .dr{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;}
        .txt{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;}
        label{ margin: 0;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">CM نت پیش بینانه انجام شده</div>
        <div class="panel-body">
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-6" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : نام ماشین</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <asp:DropDownList runat="server" ID="drMachines" CssClass="form-control dr" DataTextField="MachineName" DataValueField="MachineId"/>
                    </div>
                </div>
                <div class="col-lg-6" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : نام واحد</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <asp:DropDownList runat="server" ID="drUnits" CssClass="form-control dr" ClientIDMode="Static" AppendDataBoundItems="True" AutoPostBack="True"
                                          DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code" OnSelectedIndexChanged="drUnits_OnSelectedIndexChanged">
                            <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                </div>
                <div style="padding: 10px;">
                    <button class="btn btn-info" style="width: 100%; margin-top: 10px;" runat="server" id="btnShow" OnServerClick="btnShow_OnServerClick">مشاهده</button>
                </div>
            </div>
        </div>
        <div class="panel-footer">
            <asp:GridView runat="server" ID="gridCheckedCm" AutoGenerateColumns="False" CssClass="table" AllowPaging="True" PageSize="15">
                <Columns>
                    <asp:BoundField DataField="rn" HeaderText="ردیف" SortExpression="rn" />
                    <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name" />
                    <asp:BoundField DataField="PartName" HeaderText="نام قطعه" SortExpression="cname" />
                    <asp:BoundField DataField="tarikh" HeaderText="تاریخ تعویض" SortExpression="tarikh" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PmChecked.aspx.cs" Inherits="CMMS.PmChecked" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .dr {
            border: none;
            border-radius: 5px;
            width: 100%;
            direction: rtl;
            outline: none;
            font-weight: 800;
            height: 26px;
            padding: 1px;
        }

        .txt {
            border: none;
            border-radius: 5px;
            width: 100%;
            direction: rtl;
            outline: none;
            font-weight: 800;
        }

        label {
            margin: 0;
        }
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">PM نت پیشگیرانه انجام شده</div>
        <div class="card-body">
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190); border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-6" style="padding: 5px;">
                    <label style="display: block; text-align: right;">: نام ماشین</label>
                    <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                        <asp:DropDownList runat="server" ID="drMachines" CssClass="form-control dr" DataTextField="MachineName" DataValueField="MachineId" />
                    </div>
                </div>
                <div class="col-lg-6" style="padding: 5px;">
                    <label style="display: block; text-align: right;">: نام واحد</label>
                    <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                        <asp:DropDownList runat="server" ID="drUnits" CssClass="form-control dr" ClientIDMode="Static" AppendDataBoundItems="True" AutoPostBack="True"
                            DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code" OnSelectedIndexChanged="drUnits_OnSelectedIndexChanged">
                            <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                </div>
                <div style="padding: 10px;">
                    <button class="btn btn-info" style="width: 100%; margin-top: 10px;" runat="server" id="btnShow" onserverclick="btnShow_OnServerClick">مشاهده</button>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <asp:GridView runat="server" ID="gridCheckedPm" AutoGenerateColumns="False" CssClass="table" PageSize="15" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="rn" HeaderText="ردیف" SortExpression="rn" />
                    <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name" />
                    <asp:BoundField DataField="cname" HeaderText="نام کنترل" SortExpression="cname" />
                    <asp:BoundField DataField="tarikh" HeaderText="تاریخ بازید" SortExpression="tarikh" />
                    <asp:BoundField DataField="priod" HeaderText="پریود بازید" ReadOnly="True" SortExpression="priod" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

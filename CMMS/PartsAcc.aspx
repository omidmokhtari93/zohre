<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PartsAcc.aspx.cs" Inherits="CMMS.PartsAcc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #partsLoading{width: 20px; height: 20px; position: absolute;top: 7px; left:7px; display: none;}
        #PartsSearchResulat tr:hover {
            background-color: #007bff;
            color: white;
        }
        #PartsSearchResulat {
            display: none;
            position: absolute;
            width: 820px;
            padding-left: 0px;
            z-index: 999;
            max-height: 200px;
            left: 15px;
        }
        #gridParts tr { cursor: pointer;}
        .lbl{display: block; text-align: right; direction: ltr;}
        label{ margin: 0;}
        .badgelbl{white-space: nowrap; background-color: lightblue;padding: 2px 5px;border-radius: 5px;}
        .partcheckRes{display: block; margin-top: 10px; padding: 10px; direction: rtl; background-color: aliceblue; vertical-align: middle;}
        #txtSubSearchPart{ width: 100%;outline: none;padding: 0px 3px 0 0;font-weight: 800;border: none;border-radius: 3px;}
        .imgfilter{ position: absolute;top: 7px;right: 6px;width: 17px;height: 17px;}
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">مشاهده موجودی انبار قطعات</div>
        <div class="card-body">
            <ul class="nav nav-tabs sans-small mt-1 rtl" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#PartsAcc" role="tab" aria-controls="home"
                       aria-selected="true">موجودی انبار</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#MachineParts" role="tab" aria-controls="profile"
                       aria-selected="false">موجودی قطعات یدکی دستگاه ها</a>
                </li>
            </ul>
            <div class="tab-content" id="opFrom">
                <div id="PartsAcc" class="tab-pane fade show active">
                    <div class="menubody" style="position: relative;">
                        <label>نام قطعه</label>
                        <div id="PartBadgeArea" style="position: relative;">
                            <input autocomplete="off" dir="rtl" class="form-control text-right" id="txtPartsSearch" placeholder="جستجوی قطعه ..."/>
                        </div>
                        <div id="PartsSearchResulat">
                            <div style="padding: 5px 28px 5px 5px;background-color: #dfecfe">
                                <input type="text" id="txtSubSearchPart" dir="rtl" autocomplete="off"/>
                                <img src="assets/Images/funnel.png" class="imgfilter"/>
                            </div>
                            <div style="overflow: auto; width: 100%; max-height: 200px;">
                                <table id="gridParts" class="PartsTable">
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        <div class="partcheckRes">
                            <label>نام قطعه : </label>
                            <label class="badgelbl" id="partname"></label>&emsp;&emsp;
                            <label>کد قطعه : </label>
                            <label class="badgelbl" id="partcode"></label>&emsp;&emsp;
                            <label>موجودی انبار : </label>
                            <label class="badgelbl" id="partremain"></label>
                        </div>
                        <div id="partloading">
                            <img class="loading-image" src="assets/Images/loading.gif"/>
                        </div>
                    </div>
                </div>

                <div id="MachineParts" class="tab-pane fade">
                    <div class="menubody" style="position: relative;">
                        <div class="row ltr">
                            <div class="col-lg-4">
                                <label class="lbl">&nbsp;</label>
                                <button class="button" type="button" onclick="GetMachineParts();">مشاهده</button>
                            </div>
                            <div class="col-lg-4">
                                <label class="lbl"> : نام ماشین</label>
                                <select class="form-control dr" id="drMachines"></select>
                            </div>
                            <div class="col-lg-4">
                                <label class="lbl"> : نام واحد</label>
                                <asp:DropDownList runat="server" ID="drUnits" CssClass="form-control" ClientIDMode="Static" AppendDataBoundItems="True"
                                                  DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code">
                                    <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                            </div>
                        </div>
                        <div class="partcheckRes">
                            <table id="machinePartMojoodi" class="table">
                                <tbody></tbody>
                            </table>
                        </div>
                        <div id="machinePartloading">
                            <img class="loading-image" src="assets/Images/loading.gif"/>
                        </div>
                    </div>
                </div>  
            </div>
        </div>
    </div>
    <script src="assets/js/PartAcc.js"></script>
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="measurement.aspx.cs" Inherits="CMMS.measurement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label {
            margin: 0;
            margin-right: 5px;
        }

        .card-info {
            margin-bottom: 0;
        }

        #measurTable tr td a:hover {
            cursor: pointer;
        }

        #PartmeasureTable tr td a:hover {
            cursor: pointer;
        }
        ul.sans {
            direction: rtl;
        }
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">واحد های اندازه گیری </div>
        <div class="card-body">
            <ul class="nav nav-tabs sans" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="measur-tab" data-toggle="tab" href="#measur" role="tab" aria-controls="home"
                       aria-selected="true">تعریف واحد اندازه گیری</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="editmeasur-tab" data-toggle="tab" href="#editmeasur" role="tab" aria-controls="profile"
                       aria-selected="false">ویرایش واحد اقلام / کالا</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="Matrial-tab" data-toggle="tab" href="#oilMatrial" role="tab" aria-controls="profile"
                       aria-selected="false">مواد مصرفی/روانکارها</a>
                </li>
            </ul>

            <div class="tab-content" id="opFrom">
                <div id="measur" class="tab-pane fade show active">
                    <div class="menubody">
                        <div class="card card-info">
                            <div class="card-body">
                                <label style="display: block; text-align: right;">واحد اندازه گیری</label>
                                <input class="form-control" style="direction: rtl;" id="txtMeasur" />
                            </div>
                            <div class="card-footer">
                                <button id="btninsertmeasur" type="button" class="button" onclick="insertOrUpdateData('txtMeasur',0,'InsertAndUpdateMeasurement');">ثبت</button>
                                <button id="btneditmeasur" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtMeasur',itemId,'InsertAndUpdateMeasurement')">ویرایش</button>
                                <button id="btncanselmeasur" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertmeasur','btneditmeasur','btncanselmeasur');">انصراف</button>
                            </div>
                            <div class="card-footer">
                                <div class="tablescroll">
                                    <table id="measurTable" class="table">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            
                <div id="editmeasur" class="tab-pane fade">
                    <div class="menubody">
                        <div class="card card-info">
                            <div class="card-body rtl" id="pnlPart">
                                <div class="col-lg-4"></div>
                                <div class="col-lg-3">
                                    <label style="display: block; text-align: right;">واحد اقلام / کالا</label>
                                    <asp:DropDownList runat="server" ID="drmeasur" CssClass="form-control dr" ClientIDMode="Static" AppendDataBoundItems="True"
                                        DataSourceID="Sqlmeasurement" DataTextField="measurement" DataValueField="id">
                                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="Sqlmeasurement" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT measurement, id FROM i_measurement"></asp:SqlDataSource>
                                </div>
                                <div class="col-lg-5">
                                    <label style="display: block; text-align: right;">نام کالا</label>
                                    <input class="form-control" style="direction: rtl;" disabled="disabled" id="txtmeasurpart" />
                                </div>
                            </div>
                            <div class="card-footer">
                                <button id="btneditpart" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('drmeasur',itemId,'InsertAndUpdatePartMeasure');">ویرایش</button>
                                <button id="btncanselpart" style="display: none;" type="button" class="button" onclick="CancelOperation('btnInsertpart','btneditpart','btncanselpart');">انصراف</button>
                            </div>
                            <div class="card-footer">
                                <div class="tablescroll">
                                    <table id="PartmeasureTable" class="table">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
               
                    <div id="oilMatrial" class="tab-pane fade ">
                        <div class="menubody">
                            <div class="card card-info">
                                <div class="card-body">
                                    <label style="display: block; text-align: right;">ماده مصرفی/روانکار</label>
                                    <input class="form-control" style="direction: rtl;" id="txtMatrial" />
                                </div>
                                <div class="card-footer">
                                    <button id="btninsertMatrial" type="button" class="button" onclick="insertOrUpdateMatrialData('txtMatrial',0,'InsertAndUpdateMatrial');">ثبت</button>
                                    <button id="btneditMatrial" style="display: none;" type="button" class="button" onclick="insertOrUpdateMatrialData('txtMatrial',itemId,'InsertAndUpdateMatrial')">ویرایش</button>
                                    <button id="btncanselMatrial" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertMatrial','btneditMatrial','btncanselMatrial');">انصراف</button>
                                </div>
                                <div class="card-footer">
                                    <div class="tablescroll">
                                        <table id="MatrialTable" class="table">
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            
            </div>
        </div>
    </div>
    <script src="assets/js/Measurement.js"></script>
</asp:Content>

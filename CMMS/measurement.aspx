<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="measurement.aspx.cs" Inherits="CMMS.measurement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label{ margin: 0;margin-right: 5px;}
        .panel-info{ margin-bottom: 0;}
        #measurTable tr td a:hover{ cursor: pointer;}
        #PartmeasureTable tr td a:hover{ cursor: pointer;}
       
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">واحد های اندازه گیری </div>
        <div class="panel-body">
            <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px;">
                <li class="active"><a data-toggle="tab" href="#measur">تعریف واحد اندازه گیری</a></li>
                <li><a data-toggle="tab" href="#editmeasur">ویرایش واحد اقلام / کالا</a></li>
              
            </ul>
            <div class="tab-content" id="opFrom">
                <div id="measur" class="tab-pane fade in active">
                    <div class="menubody">
                        <div class="panel panel-info">
                            <div class="panel-body">
                                  <label style="display: block; text-align: right;">واحد اندازه گیری</label>
                                  <input class="form-control" style="direction: rtl;" id="txtMeasur"/>
                               
                            </div>
                            <div class="panel-footer">
                                <button id="btninsertmeasur" type="button" class="button" onclick="insertOrUpdateData('txtMeasur',0,'InsertAndUpdateMeasurement');">ثبت</button>
                                <button id="btneditmeasur" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('txtMeasur',itemId,'InsertAndUpdateMeasurement')">ویرایش</button>
                                <button id="btncanselmeasur" style="display: none;" type="button" class="button" onclick="CancelOperation('btninsertmeasur','btneditmeasur','btncanselmeasur');">انصراف</button>
                            </div>
                            <div class="panel-footer">
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
                        <div class="panel panel-info">
                            <div class="panel-body" id="pnlPart" >
                                <div class="col-lg-4"></div>
                                <div class="col-lg-3">
                                     <label style="display: block; text-align: right;">واحد اقلام / کالا</label>
                                    <asp:DropDownList runat="server" ID="drmeasur" CssClass="form-control dr" ClientIDMode="Static" AppendDataBoundItems="True" 
                                                      DataSourceID="Sqlmeasurement" DataTextField="measurement" DataValueField="id" >
                                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="Sqlmeasurement" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT measurement, id FROM i_measurement"></asp:SqlDataSource>
                               </div>
                                <div class="col-lg-5">
                                    <label style="display: block; text-align: right;">نام کالا</label>
                                    <input class="form-control" style="direction: rtl;" disabled="disabled"  id="txtmeasurpart"/>
                                </div>
                            </div>
                            <div class="panel-footer">
                              
                                <button id="btneditpart" style="display: none;" type="button" class="button" onclick="insertOrUpdateData('drmeasur',itemId,'InsertAndUpdatePartMeasure');">ویرایش</button>
                                <button id="btncanselpart" style="display: none;" type="button" class="button" onclick="CancelOperation('btnInsertpart','btneditpart','btncanselpart');">انصراف</button>
                            </div>
                            <div class="panel-footer">
                                <div class="tablescroll">
                                    <table id="PartmeasureTable" class="table">
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
    <script src="Scripts/Measurement.js"></script>
</asp:Content>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MachinePrint.aspx.cs" Inherits="CMMS.MachinePrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <style>
            @media print {
               .print {
                   -webkit-print-color-adjust: exact;
               }
            }
             @font-face {
                 font-family: 'myfont';
                 src: url('/fonts/BYekan.eot'), 
                      url('/fonts/BYekan.eot?#FooAnything') format('embedded-opentype');
                 src: local('☺'), url('/fonts/BYekan.woff') format('woff'), 
                      url('/fonts/BYekan.ttf') format('truetype'),
                      url('/fonts/BYekan.svg') format('svg');
                 font-weight: 800;
             }
            input{ margin: 0;padding: 0;vertical-align: middle;}
            .rightText{ position: absolute;right: -30px;}
            .rotate {
                -moz-transform: rotate(-90.0deg);
                -o-transform: rotate(-90.0deg);
                -webkit-transform: rotate(-90.0deg);
                -ms-filter: "progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083)";
                transform: rotate(-90.0deg);
            }
            table{ width: 100%;direction: rtl;position: relative;font-family: myfont;margin-right: 0;padding: 0;margin-bottom: -2px;}
            table tr{ position: relative;}
            table td{ border: 1px solid #625f5f;padding: 3px;position: relative !important;font-size: 10pt;}
            img{ width: auto;height: 60px;}
            .tbl th {
                text-align: center !important;
                border: 1px solid #625f5f;
                background-color: #ededed;
            }
            .tbl {
                font-family: myfont;
                text-align: center;
                font-size: 10pt;
                font-weight: 800;
                border: 1px solid black;
                overflow: hidden;
                margin-bottom: 0!important;
            }
            .tbl tr th { padding: 0 !important;}
            .tbl td {
                padding: 0 !important;
                vertical-align: middle !important;
                border: 1px solid #625f5f;
            }
            #gridsubsystems tr td:nth-child(2){ text-align: right;padding-right: 5px!important;}
            #gridControli tr td:nth-child(2){ text-align: right;padding-right: 5px!important;}
        </style>
        <div style="padding: 5px 12px 5px 5px;width: 210mm; min-height: 297mm;" class="print">
        <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 297mm; position: relative;">
            <table>
                <tr style="height: 100px; text-align: center;">
                    <td><img src="Images/zohre1.png" /></td>
                    <td colspan="2"><h2 style="margin: 0;">شناسنامه ماشین آلات و تجهیزات</h2></td>
                    <td style="width: 150px;">
                        <span style="position: absolute; top: 5px; right: 5px;">تاریخ :</span>
                        <label id="lbldate" runat="server"></label>
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td rowspan="7" colspan="1" style="width: 36.2px; background: #d6d5d5;">&nbsp;&nbsp;<label class="rotate rightText" style="width: 100px;">مشخصات عمومی</label></td>
                    <td colspan="3">نام دستگاه : <label id="name"></label></td>
                    <td colspan="2" style="width: 50%;">کد دستگاه : <label id="code"></label></td>
                </tr>
                <tr>
                    <td>گروه تجهیز : <label id="groupTajhiz"></label></td>
                    <td colspan="3">وضعیت تجهیز : <label id="vaziatTajhiz"></label></td>
                    <td style="width: 30%;">
                        کلیدی
                        <input type="checkbox" id="kelidi"/>&nbsp;&nbsp;
                        غیر کلیدی
                        <input type="checkbox" id="nonkelidi"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">سازنده : <label id="creator"></label></td>
                    <td colspan="2">تاریخ نصب : <label id="tarikhNasb"></label></td>
                </tr>
                <tr>
                    <td colspan="3">مدل دستگاه : <label id="model"></label></td>
                    <td colspan="2">تاریخ بهره برداری : <label id="startDate"></label></td>
                </tr>
                <tr>
                    <td colspan="2">محل اسقرار : <label id="location"></label></td>
                    <td>خط تولید : <label id="lblline"></label></td>
                    <td>فاز : <label id="lblfaz"></label></td>
                    <td>توان : <label id="power"></label></td>
                </tr>
                <tr>
                    <td colspan="5">
                        <p style="margin: 0;">مشخصات فروشنده/سازنده :</p>
                        <p style="margin: 0;"><label id="sellInfo"></label></p>
                    </td>
                </tr>
                <tr>
                    <td colspan="5">
                        <p style="margin: 0;">مشخصات مراکز خدمات پس از فروش :</p>
                        <p style="margin: 0;"><label id="suppInfo"></label></p>
                    </td>
                </tr>
            </table>
            <table>
                <tr style="height: 40px;">
                    <td style="width: 36.2px; background: #d6d5d5;"><label class="rotate rightText" style="top: 48px; width: 40px; width: 100px;">ابعاد</label></td>
                    <td>طول : <label id="length"></label></td>
                    <td>عرض : <label id="width"></label></td>
                    <td>ارتفاع : <label id="height"></label></td>
                    <td>وزن : <label id="weight"></label></td>
                </tr>
            </table>
            <table>
                <tr>
                    <td rowspan="4" colspan="1" style="width: 36.2px; background: #d6d5d5;">&nbsp;&nbsp;<label class="rotate rightText" style="width: 100px; top: 60px;">مصارف انرژی</label></td>
                    <td>برق : <input type="checkbox" id="bargh"/></td>
                    <td>مصرف : <label id="barghMasraf"></label></td>
                    <td>ولتاژ : <label id="barghVoltage"></label></td>
                    <td>فاز : <label id="barghPhase"></label></td>
                    <td>سیکل : <label id="barghCycle"></label></td>
                </tr>
                <tr>
                    <td colspan="2">گاز : <input type="checkbox" id="gas"/></td>
                    <td colspan="3">فشار : <label id="gasPressure"></label></td>
                </tr>
                <tr>
                    <td colspan="2">هوا : <input type="checkbox" id="air"/></td>
                    <td colspan="3">فشار : <label id="airPressure"></label></td>
                </tr>
                <tr>
                    <td colspan="2">سوخت مایع : <input type="checkbox" id="fuel"/></td>
                    <td colspan="2" style="width: 30%;">نوع سوخت : <label id="fuelType"></label></td>
                    <td colspan="1" style="width: 25%;">میزان مصرف : <label id="fuelTotal"></label></td>
                </tr>
            </table>
            <table>
                <tr style="text-align: center;">
                  <td colspan="2" style="background: #d6d5d5;">لیست تجهیزات</td>
                </tr>
                <tr>
                    <td colspan="2" style="border: none; padding: 0;"> 
                        <asp:GridView runat="server" Width="100%" CssClass="tbl" ID="gridsubsystems" AutoGenerateColumns="False" DataSourceID="sqlsubsystems" ClientIDMode="Static">
                            <Columns>
                                <asp:BoundField DataField="rn" HeaderText="ردیف" ReadOnly="True" SortExpression="rn" />
                                <asp:BoundField DataField="name" HeaderText="نام تجهیز" SortExpression="name" />
                                <asp:BoundField DataField="code" HeaderText="کد تجهیز" SortExpression="code" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="sqlsubsystems" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
 SELECT row_number()OVER(ORDER BY dbo.m_machine.id) AS rn,
dbo.subsystem.name, dbo.subsystem.code FROM dbo.m_machine INNER JOIN
 dbo.m_subsystem ON dbo.m_machine.id = dbo.m_subsystem.Mid INNER JOIN
 dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id
WHERE (dbo.m_machine.id = @id)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="id" QueryStringField="mid" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
            <table style="position: absolute; bottom: 2px;">
                <tr>
                    <td colspan="2" style="width: 50%;">
                        <p style="margin: 0;">نام و امضا تهیه کننده : </p>
                        <p>&nbsp;</p>
                    </td>
                    <td colspan="3">
                        <p style="margin: 0;">نام و امضا مدیر نت تجهیزات : </p>
                        <p>&nbsp;</p>
                    </td>
                </tr>
            </table>
        </div>
        </div>
    
        
        <div style="padding: 5px 12px 5px 5px;width: 210mm; min-height: 297mm; padding-top: 30px;" class="print">
        <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 297mm; position: relative;">
             <table>
                <tr style="text-align: center;">
                  <td colspan="2" style="background: #d6d5d5;">لیست موارد کنترلی</td>
                </tr>
                <tr>
                    <td colspan="2" style="border: none; padding: 0;"> 
                        <asp:GridView runat="server" Width="100%" CssClass="tbl" ID="gridControli" AutoGenerateColumns="False" DataSourceID="sqlControli" ClientIDMode="Static">
                            <Columns>
                                <asp:BoundField DataField="rn" HeaderText="ردیف" ReadOnly="True" SortExpression="rn" />
                                <asp:BoundField DataField="contName" HeaderText="مورد کنترلی" SortExpression="contName" />
                                <asp:BoundField DataField="period" HeaderText="دوره سرویس کاری" SortExpression="period" />
                                <asp:BoundField DataField="rooz" HeaderText="روز پیش بینی شده" SortExpression="rooz" />
                                <asp:BoundField DataField="opr" HeaderText="عملیات" SortExpression="opr" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="sqlControli" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT row_number()OVER(ORDER BY id) AS rn,
 contName,
  case when period = 0 then 'روزانه' 
  when period = 6 then 'هفتگی'
  when period = 1 then 'ماهیانه'
  when period = 2 then 'سه ماهه'
  when period = 3 then 'شش ماهه'
  when period = 4 then 'یکساله'
  when period = 5 then 'غیره' end as period,
  case when period = 0 then  '----' 
  when period = 6 and rooz = 0 then 'شنبه'
  when period = 6 and rooz = 1 then 'یکشنبه'
  when period = 6 and rooz = 2 then 'دوشنبه'
  when period = 6 and rooz = 3 then 'سه شنبه'
  when period = 6 and rooz = 4 then 'چهارشنبه'
  when period = 6 and rooz = 5 then 'پنجشنبه'
  when period = 6 and rooz = 6 then 'جمعه'
  when period = 5 then 'هر ' + cast(rooz as nvarchar(5)) + ' روز'
  else cast(rooz as nvarchar(10)) end as rooz,
 case when opr = 1 then 'برق' when opr = 2 then 'چک و بازدید' when opr = 3 then 'روانکاری' end as opr                          
FROM m_control WHERE (Mid = @id)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="id" QueryStringField="mid" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
            </div>
        </div>


        <div style="padding: 5px 12px 0px 5px;width: 210mm; min-height: 297mm; padding-top: 30px;" class="print">
        <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 297mm; position: relative;">
            <table>
                <tr style="height: 100px; text-align: center;">
                    <td><img src="Images/zohre1.png" /></td>
                    <td colspan="2"><h2 style="margin: 0;">شناسنامه ماشین آلات و تجهیزات</h2></td>
                    <td style="width: 150px;">
                        <span style="position: absolute; top: 5px; right: 5px;">تاریخ :</span>
                        <label id="lbldate1" runat="server"></label>
                    </td>
                </tr>
            </table>
            <table>
                <tr style="text-align: center;">
                    <td colspan="2" style=" background: #d6d5d5;">لیست قطعات یدکی</td>
                </tr>
                <tr>
                    <td colspan="2" style="border: none; padding: 0;"> 
                        <asp:GridView runat="server" Width="100%" CssClass="tbl" ID="Gridtools" AutoGenerateColumns="False" DataSourceID="Sqltools">
                            <Columns>
                                <asp:BoundField DataField="rn" HeaderText="ردیف" ReadOnly="True" SortExpression="rn" />
                                <asp:BoundField DataField="PartName" HeaderText="نام قطعه" SortExpression="PartName" />
                                <asp:BoundField DataField="mYear" HeaderText="مصرف در سال" SortExpression="mYear" />
                                <asp:BoundField DataField="min" HeaderText="حداقل موجودی" SortExpression="min" />
                                <asp:BoundField DataField="max" HeaderText="حداکثر موجودی" SortExpression="max" />
                                <asp:BoundField DataField="comment" HeaderText="ملاحضات" SortExpression="comment" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="Sqltools" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT row_number()OVER(ORDER BY PartName) AS rn,m_parts.PartId, m_parts.mYear, m_parts.min, m_parts.max, m_parts.comment, sgdb.inv.Part.PartName FROM m_parts INNER JOIN sgdb.inv.Part ON m_parts.PartId = sgdb.inv.Part.Serial WHERE (m_parts.Mid = @id)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="id" QueryStringField="mid" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
            <table>
                <tr style="text-align: center;">
                    <td colspan="5" style=" background: #d6d5d5;">دستورالعمل ایمنی و محیط زیستی</td>
                </tr>
                <tr>
                    <td colspan="5" style="padding-left: 9px;">
                        <textarea class="form-control" style="resize: none;direction: rtl; font-family: myfont; width: 100%; border: none; outline: none;" id="txtInstruc">
                        </textarea>
                    </td>
                </tr>
            </table>
            <table style="position: absolute; bottom: 2px;">
                <tr>
                    <td colspan="2" style="width: 50%;">
                        <p style="margin: 0;">نام و امضا تهیه کننده : </p>
                        <p>&nbsp;</p>
                    </td>
                    <td colspan="3">
                        <p style="margin: 0;">نام و امضا مدیر نت تجهیزات : </p>
                        <p>&nbsp;</p>
                    </td>
                </tr>
            </table>
            </div>
        </div>
    </form>
    <script>
        $(document).ready(function () {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            var mid = parseInt(vars['mid']);
            if (mid != null) {
                $.ajax({
                    type: "POST",
                    url: "WebService.asmx/GetMachineTbl",
                    data: "{mid : " + mid + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (minfo) {
                        var machineInfo = JSON.parse(minfo.d);
                        fillMachineControls(machineInfo);
                        getMasrafiData();
                    },
                    error: function () {
                    }
                });
                function fillMachineControls(mInfo) {
                    var nonkelidi = document.getElementById('nonkelidi');
                    var kelidi = document.getElementById('kelidi');
                    $('#name').text(mInfo[0].Name);
                    $('#code').text(mInfo[0].Code);
                    $('#creator').text(mInfo[0].Creator);
                    $('#tarikhNasb').text(mInfo[0].InsDate);
                    $('#model').text(mInfo[0].Model);
                    $('#startDate').text(mInfo[0].Tarikh);
                    $('#location').text(mInfo[0].LocationName);
                    $('#power').text(mInfo[0].Power);
                    $('#sellInfo').text(mInfo[0].SellInfo);
                    $('#suppInfo').text(mInfo[0].SuppInfo);
                    $('#lblline').text(mInfo[0].LineName);
                    $('#lblfaz').text(mInfo[0].FazName);
                    if (mInfo[0].VaziatTajhiz == 0) { $('#vaziatTajhiz').text('غیرفعال'); }
                    if (mInfo[0].VaziatTajhiz == 1) { $('#vaziatTajhiz').text('فعال'); }
                    if (mInfo[0].VaziatTajhiz == 2) { $('#vaziatTajhiz').text('معیوب'); }
                    if (mInfo[0].CatGroup == 1) { $('#groupTajhiz').text('ماشین آلات'); }
                    if (mInfo[0].CatGroup == 2) { $('#groupTajhiz').text('سیستم تاسیسات و برق'); }
                    if (mInfo[0].CatGroup == 3) { $('#groupTajhiz').text('ساختمان'); }
                    if (mInfo[0].CatGroup == 4) { $('#groupTajhiz').text('حمل و نقل'); }
                    if (mInfo[0].Ahamiyat == "True") { kelidi.checked = true; } else { nonkelidi.checked = true; }
                }
                function getMasrafiData() {
                    $.ajax({
                        type: "POST",
                        url: "WebService.asmx/GetMasrafiTbl",
                        data: "{mid : " + mid + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (masrafi) {
                            var masrafiData = JSON.parse(masrafi.d);
                            fillMasrafiControls(masrafiData);
                            getEnergy();
                        },
                        error: function () {
                        }
                    });
                }
                function fillMasrafiControls(masrafiData) {
                    var bargh = document.getElementById('bargh');
                    var gas = document.getElementById('gas');
                    var hava = document.getElementById('air');
                    var sookht = document.getElementById('fuel');
                    $('#length').text(masrafiData[0].Length);
                    $('#width').text(masrafiData[0].Width);
                    $('#height').text(masrafiData[0].Height);
                    $('#weight').text(masrafiData[0].Weight);
                    if (masrafiData[0].BarghChecked == 1) {
                        bargh.checked = true;
                        $('#barghMasraf').text(masrafiData[0].Masraf);
                        $('#barghVoltage').text(masrafiData[0].Voltage);
                        $('#barghPhase').text(masrafiData[0].Phase);
                        $('#barghCycle').text(masrafiData[0].Cycle);
                    }
                    if (masrafiData[0].GasChecked == 1) {
                        gas.checked = true;
                        $('#gasPressure').text(masrafiData[0].GasPressure);
                    }
                    if (masrafiData[0].AirChecked == 1) {
                        hava.checked = true;
                        $('#airPressure').text(masrafiData[0].AirPressure);
                    }
                    if (masrafiData[0].FuelChecked == 1) {
                        sookht.checked = true;
                        $('#fuelType').text(masrafiData[0].FuelType);
                        $('#fuelTotal').text(masrafiData[0].FuelMasraf);
                    }
                }
                function getEnergy() {
                    $.ajax({
                        type: "POST",
                        url: "WebService.asmx/GetEnergy",
                        data: "{ mid : " + mid + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            var energyData = JSON.parse(data.d);
                            $('#txtInstruc').text(energyData[0].Dastoor);
                            var rows = $('#txtInstruc').val().split("\n");
                            $('#txtInstruc').prop('rows', rows.length + 2);
                        }
                    });
                }
            }
        });
    </script>
</body>
</html>

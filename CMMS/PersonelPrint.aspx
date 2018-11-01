<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PersonelPrint.aspx.cs" Inherits="CMMS.PersonelPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/script.js"></script>
    <title>پرسنل واحد فنی و مهندسی</title>
</head>
<body>
<form id="form1" runat="server">
    <div id="printArea">
        <style>
            @media print {
                .print { -webkit-print-color-adjust: exact; }
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
            @page {
                size: A4;
                margin: 4mm;
            }

            input {
                margin: 0;
                padding: 0;
                vertical-align: middle;
            }

            .rightText {
                position: absolute;
                right: -30px;
            }

            .rotate {
                -moz-transform: rotate(-90.0deg);
                -o-transform: rotate(-90.0deg);
                -webkit-transform: rotate(-90.0deg);
                -ms-filter: "progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083)";
                transform: rotate(-90.0deg);
            }

            table {
                width: 100%;
                direction: rtl;
                position: relative;
                font-family: myfont;
                margin-right: 0;
                padding: 0;
                margin-bottom: -2px;
            }

            table tr { position: relative; }

            table td {
                border: 1px solid #625f5f;
                padding: 3px;
                position: relative !important;
                font-size: 10pt;
            }

            img {
                width: auto;
                height: 60px;
            }

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
                margin-bottom: 0 !important;
                border-collapse: collapse;
            }

            .tbl tr th { padding: 3px 0 !important; }

            .tbl td {
                padding: 0 !important;
                vertical-align: middle !important;
                border: 1px solid #625f5f;
            }
        </style>
    </div>
    <script>
    var allrows;
    var pagess;
    var footerlength;
    var footerContent;
    var hfContent;
    $(function () {
        $.get("Content/personelprint.html",
            function (htmlString) {
                hfContent = htmlString;
                hfContent = hfContent.replace("#date#", JalaliDateTime());
                headerFooterDate();
            },
            'html');
    });

    function headerFooterDate() {
        var d = [];
        d.push({
            url: 'WebService.asmx/GetPersonels',
            parameters: [],
            func: createTables
        });
        AjaxCall(d);
        function createTables(e) {
            var pData = JSON.parse(e.d);
            pagess = Math.ceil(pData.length / 42);
            var page = 1;
            var k;
            var b = 0;
            var body = [];
            var radif = 0;
            for (var i = 0; i < pagess; i++) {
                hfContent = hfContent.replace('id="tbl' + i + '"', 'id="tbl' + page + '"');
                $('#printArea').append(hfContent);
                var table = $('#printArea').find('table#tbl' + page + '');
                body.push('<tr><th>ردیف</th><th>نام پرسنل</th><th>شماره پرسنلی</th><th>سمت</th><th>واحد اشتغال</th></tr>');
                if (i === 0 && pagess > 1) {
                    var first = $('#printArea').find('.print');
                    $(first).css('margin-bottom', '200px');
                }
                for (k = b; k < pData.length;) {
                    body.push('<tr>' +
                        '<td>' + parseInt(++radif) + '</td>' +
                        '<td>' + pData[k][0] + '</td>' +
                        '<td>' + pData[k][1] + '</td>' +
                        '<td>' + pData[k][2] + '</td>' +
                        '<td>' + pData[k][3] + '</td></tr>');
                    ++k;
                    if ((42 * (i + 1) - k) === 0 || k === pData.length) {
                        $(table).append(body.join(''));
                        body = [];
                        b = k;
                        break;
                    }
                    page++;
                }
            }
        }
    }
</script>
</form>
</body>
</html>

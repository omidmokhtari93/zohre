$('#drCategory').on('change', function () {
  GetChartData({
    url: 'Activemachin',
    param: {
      kind: $('#drCategory :selected').val()
    },
    element: 'ActiveMachineChart',
    header: 'ماشین آلات فعال',
    chartype: 'pie'
  });
});

function machineTypes() {
  var obj = {
    url: 'MachinType',
    param: {},
    element: 'MachineTypesChart',
    header: 'نوع ماشین آلات',
    chartype: 'pie'
  };
  GetChartData(obj);
}
function CreateTableForChart(data) {
  var body;
  var i;
  if ($('#ActiveMachine').hasClass('active')) {
    $('#gridActMachine').empty();
    if (data.length > 0) {
      body = [];
      body.push('<tr><th>ردیف</th><th> وضعیت</th><th>تعداد</th></tr>');
      for (i = 0; i < data.length; i++) {
        body.push('<tr>' +
          '<td>' + (i + 1) + '</td>' +
          '<td>' + data[i][0] + '</td>' +
          '<td>' + data[i][1] + '</td>' +
          '</tr>');
      }
      $('#gridActMachine').append(body.join(''));
    }
  }
  if ($('#MachineTypes').hasClass('active')) {
    $('#gridTypMachine').empty();
    if (data.length > 0) {
      body = [];
      body.push('<tr><th>ردیف</th><th>نوع دستگاه</th><th>تعداد</th></tr>');
      for (i = 0; i < data.length; i++) {
        body.push('<tr>' +
          '<td>' + (i + 1) + '</td>' +
          '<td>' + data[i][0] + '</td>' +
          '<td>' + data[i][1] + '</td>' +
          '</tr>');
      }
      $('#gridTypMachine').append(body.join(''));
    }
  }


}


function SubsystemReport() {
  var unit;
  var html;
  if ($('#drsubsystemunits :selected').val() !== '0') {
    unit = 'واحد ' + $('#drsubsystemunits :selected').text();
  } else {
    unit = $('#drsubsystemunits :selected').text();
  }
  $('#SubsystemListPrint').empty();
  $.get("/assets/Content/A4.html", function (e) {
    html = e;
    fill();
  }, 'html');

  function fill(d) {
    AjaxData({
      url: 'Reports.asmx/FilterSubSystems',
      param: { loc: $('#drsubsystemunits :selected').val() },
      func: createSubsystemReport
    })
    function createSubsystemReport(s) {
      var d = JSON.parse(s.d);
      var k = 1;
      for (var A = 0; A < d.length; A++) {
        if (d[A].SubSystemName.length > 0) {
          k++;
          for (var B = 0; B < d[A].SubSystemName.length; B++) {
            var c = Math.ceil(d[A].SubSystemName[B].length / 85);
            k += c;
          }
        }
        else {
          k++;

        }
      }
      var pages = Math.ceil(k / 34);
      k = 1;
      b = 0;
      for (f = 0; f < pages; f++) {
        var pagesHtml = html;
        //$('#SubsystemListPrint').empty();
        pagesHtml = pagesHtml.replace('#ReportArea#', 'subsystem' + f);
        pagesHtml = pagesHtml.replace('printDiv', 'printDiv(1);');
        pagesHtml = pagesHtml.replace('ExportToExcel();', 'ExportToExcel(\'SubsystemListPrint\');');
        pagesHtml = pagesHtml.replace('#RP#', 'لیست تجهیزات');
        pagesHtml = pagesHtml.replace('#cnt#', pages + '' + f);
        pagesHtml = pagesHtml.replace('#unit#', unit);
        $('#SubsystemListPrint').append(pagesHtml);
        if (pages > 1 && f > 0) {
          $('#subsystem' + f + '').css('margin-top', '150px');
        }
        var body = [];
        body.push('<table></tr>');
        if (d.length > 0) {
          for (var i = b; i < d.length; i++) {
            if (k + d[i].SubSystemName.length <= 32) {
              body.push('<tr><th colspan="3">' + d[i].MachineName + '</th></tr>');
              k++;
              if (d[i].SubSystemName.length > 0) {
                for (var j = 0; j < d[i].SubSystemName.length; j++) {
                  k++;
                  body.push('<tr>' +
                    '<td style="width:5%" >' +
                    (j + 1) +
                    '</td>' +
                    '<td style="width:75%;text-align: right;padding-right: 5px;" >' +
                    d[i].SubSystemName[j] +
                    '</td>' +
                    '<td style="width:20%">' +
                    d[i].SubSystemCode[j] +
                    '</td>' +
                    '</tr>');
                }
              }
            } else {
              b = i;
              k = 1;
              break;
            }
          }
          body.push('</table>');
          $('.sDate').text(JalaliDateTime);
          $('#' + pages + f).append(body.join(''));

        }
      }
    }
  }
}
//=========================================Machin Report
$('#drmachineunits').on('change',
  function () {
    $('#drline').val(-1);
    $('#drfaz').val(-1);
  });
$('#drline').on('change',
  function () {
    $('#drmachineunits').val(0);
    $('#drfaz').val(-1);
  });
$('#drfaz').on('change',
  function () {
    $('#drline').val(-1);
    $('#drmachineunits').val(0);
  });
function MachineReport() {
  var unit;
  if ($('#drline :selected').val() !== '-1')
    unit = $('#drline :selected').text();
  else if ($('#drfaz :selected').val() !== '-1')
    unit = $('#drfaz :selected').text();
  else if ($('#drmachineunits :selected').val() !== '0') {
    unit = 'واحد ' + $('#drmachineunits :selected').text();
  } else {
    unit = $('#drmachineunits :selected').text();
  }

  var html;
  $.get("/assets/Content/A4.html", function (e) {
    html = e;
    fillmachine();
  }, 'html');

  function fillmachine(d) {
    $('#MachineListPrint').empty();
    $('#MachineListPrint').append(d);
    var e = [];
    e.push({
      url: 'Reports.asmx/FilterMachines',
      parameters: [
        {
          loc: $('#drmachineunits :selected').val(),
          line: $('#drline :selected').val(),
          faz: $('#drfaz :selected').val()
        }
      ],
      func: createmachineReport
    });
    AjaxCall(e);

    function createmachineReport(s) {
      var d = JSON.parse(s.d);
      var body = [];
      var pages = Math.ceil(d.length / 34);
      var k = 1;
      var b = 0;
      for (var f = 0; f < pages; f++) {
        var pagesHtml = html;
        //$('#SubsystemListPrint').empty();
        pagesHtml = pagesHtml.replace('#ReportArea#', 'machine' + f);
        pagesHtml = pagesHtml.replace('printDiv', 'printDiv(0);');
        //html = html.replace('ExportToExcel();', 'ExportToExcel(\'subbodycontent\');');
        pagesHtml = pagesHtml.replace('#RP#', 'لیست ماشین آلات');
        pagesHtml = pagesHtml.replace('#cnt#', pages + '' + f);
        pagesHtml = pagesHtml.replace('#unit#', unit);
        $('#MachineListPrint').append(pagesHtml);
        if (pages > 1 && f > 0) {
          $('#machine' + f + '').css('margin-top', '150px');
        }
        //
        if (d.length > 0) {
          body.push(
            '<table><tr><th>ردیف</th><th>نام دستگاه</th><th>کد دستگاه</th><th>فاز</th><th>خط</th><th>محل اسقرار</th>' +
            '<th>کلیدی</th><th>وضعیت</th><th>سازنده</th><th>مدل</th><th>تاریخ بهره برداری</th></tr>');
          for (var i = b; i < d.length;) {
            var imp = d[i].Ahamiyat == 'True'
              ? '<input type="checkbox" checked disabled/>'
              : '<input type="checkbox" disabled/>';
            body.push('<tr>' +
              '<td>' + (i + 1) + '</td>' +
              '<td>' + d[i].Name + '</td>' +
              '<td>' + d[i].Code + '</td>' +
              '<td>' + d[i].FazName + '</td>' +
              '<td>' + d[i].LineName + '</td>' +
              '<td>' + d[i].LocationName + '</td>' +
              '<td>' + imp + '</td>' +
              '<td>' + d[i].CatState + '</td>' +
              '<td>' + d[i].Creator + '</td>' +
              '<td>' + d[i].Model + '</td>' +
              '<td>' + d[i].Tarikh + '</td>' +
              '</tr>');
            ++i;
            if ((34 * (f + 1) - i) === 0 || i === d.length) {
              body.push('</table>');
              $('.sDate').text(JalaliDateTime);
              $('#' + pages + f).append(body.join(''));
              body = [];
              b = i;
              break;
            }

          }

        }
      }
    }
  }
}
function printDiv(div) {
  var ele;
  switch (div) {
    case 1:
      ele = $('#SubsystemListPrint')[0];
      break;
    case 0:
      ele = $('#MachineListPrint')[0];
      break;
    case 2:
      ele = $('#MachineControlsPanel')[0];
      break;
    default:
  }
  var newWin = window.open('', 'Print-Window');
  newWin.document.open();
  newWin.document.write('<html><body onload="window.print()">' + ele.innerHTML + '</body></html>');
  newWin.document.close();
  setTimeout(function () { newWin.close(); }, 10);
}
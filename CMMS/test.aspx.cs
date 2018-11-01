using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;
using System.Xml.Linq;
using cmms;

namespace CMMS
{
    public partial class test : System.Web.UI.Page
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            //var S = "1397/06/01";
            //var E = "1397/08/01";
            //var obj = new { };
            //var lst = new List<string>();
            //cnn.Open();
            //var CmdPM = new SqlCommand("SELECT        TOP (100) PERCENT dbo.i_units.unit_code, dbo.i_units.unit_name, dbo.m_machine.name, dbo.m_machine.code, dbo.m_control.contName, dbo.p_pmcontrols.tarikh, dbo.p_pmcontrols.act, dbo.p_pmcontrols.kind, " +
            //                           "  dbo.p_pmcontrols.other " +
            //                           " FROM dbo.m_machine INNER JOIN " +
            //                           "  dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
            //                           "  dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
            //                           " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code " +
            //                           " WHERE(dbo.p_pmcontrols.tarikh BETWEEN '" + S + "' AND '" + E + "') AND(dbo.p_pmcontrols.act = 0) AND(dbo.p_pmcontrols.kind = 5) " +
            //                           " ORDER BY dbo.p_pmcontrols.tarikh ", cnn);
            //var rd = CmdPM.ExecuteReader();
            //while (rd.Read())
            //{
            //    lst.Add(rd["contName"].ToString());
            //    var tarikh = rd["tarikh"].ToString();
            //    var step = Convert.ToInt32(rd["other"]);
            //    lst.Add(tarikh);
            //    DateTime Date;
            //    var DateS = ShamsiCalendar.Shamsi2Miladi(S);
            //    var DateE = ShamsiCalendar.Shamsi2Miladi(E);
            //    while (true)
            //    {
            //        Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
            //        Date = Date.AddDays(step);
            //        if (DateS <= Date && Date <= DateE)
            //        {
            //            tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
            //            lst.Add(tarikh);
            //        }
            //        else
            //        {
            //            break;
            //        }

            //    }
            //}
            //cnn.Close();

            //foreach (string prime in lst)
            //{
            //    System.Console.WriteLine(prime);
            //}
            //var r = "1397/03/05";
            //var date = ShamsiCalendar.Shamsi2Miladi(r);
            //date = date.AddMonths(2);
            //var tarikh = ShamsiCalendar.Miladi2Shamsi(date);
            //cnn.Open();
            //var test = new SqlCommand("create table #Temp(id int, esm Varchar(50))", cnn);
            //test.ExecuteNonQuery();
            //var insert = new SqlCommand("insert into #Temp (id,esm)values (1,'omid')", cnn);
            //insert.ExecuteNonQuery();
            //var read = new SqlCommand("select id , esm from #Temp", cnn);
            //var rd = read.ExecuteReader();
            //while (rd.Read())
            //{
            //    var i = rd["id"].ToString();
            //    var g = rd["esm"].ToString();
            //}


            //var S = "1397/6/1";
            //var E = "1397/8/1";
            //var controlsList = new List<ControlsList>();
            //cnn.Open();
            //var CmdPM = new SqlCommand("SELECT dbo.i_units.unit_code, dbo.i_units.unit_name, dbo.m_machine.name, dbo.m_machine.code," +
            //                           " dbo.m_control.contName, dbo.p_pmcontrols.tarikh, dbo.p_pmcontrols.act, dbo.p_pmcontrols.kind, " +
            //                           "  dbo.p_pmcontrols.other FROM dbo.m_machine INNER JOIN " +
            //                           "  dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
            //                           "  dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
            //                           " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code " +
            //                           " WHERE(dbo.p_pmcontrols.tarikh BETWEEN '" + S + "' AND '" + E + "') AND(dbo.p_pmcontrols.act = 0)" +
            //                           " AND(dbo.p_pmcontrols.kind = 5) ORDER BY dbo.p_pmcontrols.tarikh ", cnn);
            //var rd = CmdPM.ExecuteReader();
            //while (rd.Read())
            //{
            //    var newControl = new ControlsList() { ControlName = rd["contName"].ToString() };
            //    var tarikh = rd["tarikh"].ToString();
            //    newControl.Dates.Add(tarikh);
            //    var step = Convert.ToInt32(rd["other"]);
            //    var dateS = ShamsiCalendar.Shamsi2Miladi(S);
            //    var dateE = ShamsiCalendar.Shamsi2Miladi(E);
            //    while (true)
            //    {
            //        DateTime date = ShamsiCalendar.Shamsi2Miladi(tarikh);
            //        date = date.AddDays(step);
            //        if (dateS <= date && date <= dateE)
            //        {
            //            tarikh = ShamsiCalendar.Shamsi(date);
            //            newControl.Dates.Add(tarikh);
            //        }
            //        else
            //        {
            //            break;
            //        }

            //    }
            //    controlsList.Add(newControl);
            //}
            //cnn.Close();
        }
    }
}
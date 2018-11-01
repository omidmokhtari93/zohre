using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class CmChecked : System.Web.UI.Page
    {
        private readonly SqlConnection _cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void drUnits_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            drMachines.Items.Clear();
            _cnn.Open();
            var list = new List<PmChecked.DrMachine>();
            var selecctItems = new SqlCommand("SELECT [id],[name] FROM [dbo].[m_machine] where loc = " + drUnits.SelectedValue + " ", _cnn);
            var r = selecctItems.ExecuteReader();
            while (r.Read())
            {
                list.Add(new PmChecked.DrMachine() { MachineId = Convert.ToInt32(r["id"]), MachineName = r["name"].ToString() });
            }
            drMachines.DataSource = list;
            drMachines.DataBind();
        }

        protected void btnShow_OnServerClick(object sender, EventArgs e)
        {
            if (drMachines.Items.Count == 0) return;
            var ds = new SqlDataSource
            {
                ConnectionString = "Data Source=.;Initial Catalog=CMMS;Integrated Security=True",
                SelectCommand = "SELECT ROW_NUMBER()over(order by Forecast.id)as rn,Forecast.tarikh, "+
                                "Part.PartName,dbo.m_machine.name FROM dbo.m_machine INNER JOIN " +
                                "dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code INNER JOIN " +
                                "dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid INNER JOIN " +
                                "dbo.p_forecast AS Forecast INNER JOIN " +
                                "sgdb.inv.Part AS Part ON Forecast.PartId = Part.Serial ON dbo.m_parts.id = Forecast.m_partId " +
                                "where  Forecast.act = 1 and m_machine.id = "+drMachines.SelectedValue+" order by tarikh desc"
            };
            gridCheckedCm.DataSource = ds;
            gridCheckedCm.DataBind();
        }
    }
}
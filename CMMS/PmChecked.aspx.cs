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
    public partial class PmChecked : System.Web.UI.Page
    {
        private readonly SqlConnection _cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void drUnits_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            drMachines.Items.Clear();
            _cnn.Open();
            var list = new List<DrMachine>();
            var selecctItems = new SqlCommand("SELECT [id],[name] FROM [dbo].[m_machine] where loc = '"+drUnits.SelectedValue+"' ", _cnn);
            var r = selecctItems.ExecuteReader();
            while (r.Read())
            {
                list.Add(new DrMachine(){MachineId = Convert.ToInt32(r["id"]),MachineName = r["name"].ToString() });
            }
            drMachines.DataSource = list;
            drMachines.DataBind();
        }

        public class DrMachine
        {
            public int MachineId { get; set; }
            public string MachineName { get; set; }
        }

        protected void btnShow_OnServerClick(object sender, EventArgs e)
        {
            if (drMachines.Items.Count == 0) return;
            var ds = new SqlDataSource
            {
                ConnectionString = "Data Source=.;Initial Catalog=CMMS;Integrated Security=True",
                SelectCommand =
                    "SELECT ROW_NUMBER()over(order by (select null))as rn,dbo.m_machine.name, dbo.m_control.contName as cname, dbo.p_pmcontrols.tarikh, " +
                    "CASE WHEN dbo.m_control.period = 0 THEN 'روزانه' WHEN dbo.m_control.period = 6 THEN 'هفتگی' " +
                    "WHEN dbo.m_control.period = 1 THEN 'ماهیانه' WHEN dbo.m_control.period = 2 THEN 'سه ماهه' WHEN dbo.m_control.period = 3 THEN " +
                    "'شش ماهه' WHEN dbo.m_control.period = 4 THEN 'سالیانه' WHEN dbo.m_control.period = 5 THEN 'غیره' " +
                    "END AS priod FROM dbo.m_machine INNER JOIN dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
                    "dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol " +
                    "WHERE(dbo.p_pmcontrols.act = 1) AND(dbo.m_machine.id = " + drMachines.SelectedValue + ") " +
                    "ORDER BY dbo.p_pmcontrols.tarikh DESC"
            };
            gridCheckedPm.DataSource = ds;
            gridCheckedPm.DataBind();
        }
    }
}
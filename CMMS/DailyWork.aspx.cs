using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class DailyWork : System.Web.UI.Page
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                    break;
                default:
                    Response.Redirect("login.aspx");
                    break;

            }
            var tarikh = ShamsiCalendar.ShamsiDateTime();
            if (!Page.IsPostBack)
            {
                txtWorkDate.Value = tarikh;
                Date.Value = tarikh;
                gridDailyWorks.DataBind();
                grid_LineWorks.DataBind();
            }
            
           
        }

        protected void btnShow_OnClick(object sender, EventArgs e)
        {
            Date.Value= txtWorkDate.Value;
            gridDailyWorks.DataBind();
            grid_LineWorks.DataBind();
        }
    }
}
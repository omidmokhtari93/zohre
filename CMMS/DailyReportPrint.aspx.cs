using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class DailyReportPrint : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                switch (UserAccess.CheckAccess())
                {
                    case 0:
                    case 1:
                        break;
                    default:
                        Response.Redirect("login.aspx");
                        break;

                }
                var id = Request.Params.Get("id");
                if (string.IsNullOrEmpty(id)) return;
                try
                {
                    dailyId.Value = Crypto.Decrypt(id);
                    lblDate.InnerText = ShamsiCalendar.ShamsiDateTime();
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "cancel();", true);
                }
            }
            
        }
    }
}
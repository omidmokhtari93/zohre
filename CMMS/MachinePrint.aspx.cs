using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class MachinePrint : System.Web.UI.Page
    {
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
            if (Page.IsPostBack) return;
            var machineId = Request.Params.Get("mid");
            if (string.IsNullOrEmpty(machineId)) return;
            try
            {
                lbldate.InnerText = ShamsiCalendar.ShamsiDateTime();
                lbldate1.InnerText = ShamsiCalendar.ShamsiDateTime();
            }
            catch
            {
                //
            }
        }
    }
}
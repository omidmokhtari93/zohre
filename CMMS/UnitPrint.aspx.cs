using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class UnitPrint : System.Web.UI.Page
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
            ShamsiCalendar.ChangCulter(ShamsiCalendar.CulterType.Fa);
            lbldate.InnerText = DateTime.Now.ToShortDateString();
        }
    }
}
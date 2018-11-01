using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class welcome1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                    break;
                case 1:
                    Response.Redirect("FinancialReport.aspx");
                    break;
                case 2:
                    Response.Redirect("repairRequest.aspx");
                    break;
            }
            DateTime.Value = ShamsiCalendar.ShamsiDateTime();
        }
    }
}
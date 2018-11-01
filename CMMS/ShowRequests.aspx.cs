using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class ShowRequests : System.Web.UI.Page
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
        }

        protected void gridRequests_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "show")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var reqid = (int) gridRequests.DataKeys[index]["req_id"];
                Response.Redirect("Reply.aspx" + "?reqid=" + Crypto.Crypt(reqid.ToString()));
            }
        }
    }
}
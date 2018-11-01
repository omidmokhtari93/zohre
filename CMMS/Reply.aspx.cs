using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class Reply : System.Web.UI.Page
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
            if (!Page.IsPostBack)
            {
                try
                {
                    ReqId.Value = Crypto.Decrypt(Request.Params.Get("reqid"));
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "cancel();", true);
                }
            }
        }

       
    }
}
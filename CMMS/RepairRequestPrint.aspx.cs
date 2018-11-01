using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class RepairRequestPrint : System.Web.UI.Page
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
           
            var reqId = Request.Params.Get("reqid");
            if (string.IsNullOrEmpty(reqId)) return;
            try
            {
                RequestId.Value = Crypto.Decrypt(reqId);
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "cancel();", true);
            }
        }
    }
}
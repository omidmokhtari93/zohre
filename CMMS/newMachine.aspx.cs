using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using rijndael;

namespace CMMS
{
    public partial class newMachine : System.Web.UI.Page
    {
        private string _machineId;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                switch (UserAccess.CheckAccess())
                {
                    case 0:
                        break;
                    default:
                        Response.Redirect("login.aspx");
                        break;

                }
                _machineId = Request.Params.Get("mid");
                if (string.IsNullOrEmpty(_machineId)) return;
                try
                {
                    Mid.Value = Crypto.Decrypt(_machineId);
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "cancel();", true);
                }
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using rijndael;

namespace CMMS
{
    public partial class login : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                var limit = Request.Cookies.Count;
                for (var i = 0; i < limit; i++)
                {
                    var cookieName = Request.Cookies[i].Name;
                    var aCookie = new HttpCookie(cookieName) { Expires = DateTime.Now.AddDays(-1) };
                    Response.Cookies.Add(aCookie);
                }
            }
        }
    }
}
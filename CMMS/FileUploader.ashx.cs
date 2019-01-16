using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace CMMS
{
    /// <summary>
    /// Summary description for FileUploader
    /// </summary>
    public class FileUploader : IHttpHandler
    {
        private readonly SqlConnection _cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        public void ProcessRequest(HttpContext context)
        {
            var fileName = Guid.NewGuid();
            var fileData = new JavaScriptSerializer().Deserialize<CatalogFiles>(context.Request["catData"]);
            if (context.Request.Files.Count <= 0) return;
            var files = context.Request.Files;
            if (files.Count == 0) return;
            var file = files[0];
            var fileExtension = Path.GetExtension(file.FileName);
            var fname = Path.Combine(context.Server.MapPath("files/"), fileName + fileExtension);
            var filePath = "files/" + fileName + fileExtension;
            file.SaveAs(fname);
            _cnn.Open();
            var insertToTabel = new SqlCommand("insert into catalog (address,name,code)values" +
                                               "('"+ filePath + "','"+fileData.Filename+"','"+fileData.FileCode+"')",_cnn);
            insertToTabel.ExecuteNonQuery();
        }

        public bool IsReusable => false;
    }
}
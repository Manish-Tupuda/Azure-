using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Company.Function
{
     public class Root
    {
        public List<int> numbers { get; set; }
    }
     
    public static class sum 
    {
        
        [FunctionName("sum")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            
             var content = await new StreamReader(req.Body).ReadToEndAsync();
             Root myClass = JsonConvert.DeserializeObject<Root>(content);

             List<int> x = myClass.numbers;
            /* int m = Convert.ToInt32(myClass.a);
             int n =Convert.ToInt32(myClass.b);
             int k = m + n;
             */
              int k = x.Sum();
          /*  string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;

            string responseMessage = string.IsNullOrEmpty(name)
                ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {name}. This HTTP triggered function executed successfully.";
   */


            return new OkObjectResult(k);
        }
    }
}

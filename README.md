Fortify MuleSoft Demo
=====================

This is an example [Mulesoft Anypoint](https://www.mulesoft.com/platform/enterprise-integration) project that includes 
[Fortify Static Code Analyzer](https://www.microfocus.com/en-us/cyberres/application-security/static-code-analyzer) 
custom rules for vulnerability scanning of Mulesoft's XML configuration files. 

The example includes a MuleSoft domain project (where global configuration is typically set) and an [APIKit](https://docs.mulesoft.com/apikit)
application project. The application project exposes a MySQL database as a REST API. It also includes a [Postman](https://www.postman.com/) collection so that
the deployed API can be tesed and vulnerability scanned using [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).

*PLEASE NOTE: This is a work in progress and is not officially supported by Micro Focus.*

**Environment Setup**

To demonstrate this application you will need the following installed and configured:

  - Fortify Static Code Analyzer
  - Fortify WebInspect or ScanCentral DAST (optional)
  - The [Postman app](https://www.postman.com/downloads/) (optional)
  - [AnyPoint Studio](https://www.mulesoft.com/lp/dl/studio)
  - [MySQL Community Server](https://dev.mysql.com/downloads/mysql/)
  - PowerShell (if not already installed)

If you want to use the PowerShell scripts that are included with this project you will need to create an `.env` file in the root directory with contents 
similar to the following:

```
# The applications URL
APP_URL=http://localhost:8082/api/products
# The URL of Software Security Center
SSC_URL=http://YOUR_SCC_SERVER_URL
SSC_USERNAME=admin
SSC_PASSWORD=password
# SSC Authentication Token (recommended to use CIToken)
SSC_AUTH_TOKEN=XXXX...
SSC_AUTH_TOKEN_BASE64=YYYYY...
# Name of the application in SSC
SSC_APP_NAME=FortifyMuleSoftDemo
# Name of the application version in SSC
SSC_APP_VER_NAME=main
SCANCENTRAL_CTRL_URL=http://YOUR_SCANCENTRAL_CONTROLLER_URL
SCANCENTRAL_CTRL_TOKEN=XXX...
SCANCENTRAL_POOL_ID=00000000-0000-0000-0000-000000000002
SCANCENTRAL_EMAIL=your_email@somewhere.com
SCANCENTRAL_DAST_API=http://YOUR_SCANCENTRAL_DAST_URL
SCANCENTRAL_DAST_CICD_TOKEN=YYY...
```

*NOTE: do not place this file under source control*

**Creating the MySQL database**

To create the required MySQL database, first install [MySQL](https://www.mysql.com/) and then as a priviledged MySQL user (e.g. root) execute
the following:

```
mysql -u root -p
mysql> source mule-api-app\src\main\resources\sql\schema.sql
mysql> source mule-api-app\src\main\resources\sql\data.sql
mysql> exit
```

**Editing and Running in Anypoint Studio**

To edit and run this project in Anypoint Studio you need to import both the domain and application project(s). This can be achieved as follows:

1. Download this repository to a directory on your local disk using Git:
   `git checkout https://github.com/fortify-presales/FortifyMuleSoftDemo.git`
3. Startup Anypoint Studio and select the default workspace.
4. In the Package Explorer click on Import Project and select `Anypoint Studio project from Filesystem`.
5. Browse to the local copy of the downloaded `mule-domain` directory. The Project Name should be shown as `fortify-1.0.0-mule-domain`.
   Note: I usually keep the downloaded files in the current location by unticking `Copy project into workspace`.
6. Repeat the Import operation again by right-clicking in the Package Explorer and this time select the `mule-api-app` directory.

You can now run the MuleSoft API application by right-clicking on it and selecting Run As->Mule Application.

Once the application (and domain) have deployed you can browse to the API at `https://localhost:8082/console/` or use the provided Postman collection
in the `mule-api-app\src\test\resources` directory to exercise it.

**Deploying to a standalone server**

TBD

**Fortify Static Code Analyzer (SAST) scan**

To execute a Fortify Static Code Analyzer SAST scan, run the following commands from the root directory of the project:

```
sourceanalyzer -verbose -rules rules/mulesoft_rules.xml -scan mule-domain/src/main/ mule-api-app/src/main/
```

or you can use the provided PowerShell script [bin\fortify_sca.ps1]:

```
powershell bin\fortify-sca.ps1 -SkipSSC
```

Note: if you want to upload the results to Software Security Center you can remove the `-SkipSSC` switch.

You can then view the results with Audit Workbench as follows:

```
auditworkbench FortifyMuleSoftDemo.fpr
```

You should see output similar to the following:

```
Issue counts by analyzer:

 "configuration" => 9 Issues
     mule-api-app/src/main/mule/store-api.xml:46 (MuleSoft Bad Practice: MySQL - hardcoded database host)
     mule-api-app/src/main/mule/store-api.xml:46 (Password Management: MySQL - hardcoded password)
     mule-domain/src/main/mule/mule-domain-config.xml:0 (MuleSoft Misconfiguration: Domain - Hard-coded Key Store configuration)
     mule-domain/src/main/mule/mule-domain-config.xml:22 (MuleSoft Misconfiguration: HTTP(S) port not configured)
     mule-domain/src/main/mule/mule-domain-config.xml:25 (MuleSoft Misconfiguration: Domain - Insecure Trust Store)
     mule-domain/src/main/mule/mule-domain-config.xml:41 (MuleSoft Misconfiguration: Domain - HTTP Requestor configuration uses dynamic default query params)
     mule-domain/src/main/mule/mule-domain-config.xml:45 (MuleSoft Misconfiguration: Domain - HTTP Requestor configuration uses dynamic default headers)
     mule-domain/src/main/resources/ssl/server-dev-keystore.p12:0 (Key Management: Hardcoded Encryption Key)
     mule-domain/src/main/resources/ssl/trusted-client-truststore.p12:0 (Key Management: Hardcoded Encryption Key)
 "semantic" => 2 Issues
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:18 (Insecure Randomness)
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:26 (Insecure Randomness)
 "structural" => 1 Issues
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:31 (J2EE Bad Practices: Leftover Debug Code)

Total for all analyzers => 12 Issues
```

Note: because the API project also contains some Java beans and encryption keys - these issues are found using existing rules.

**Fortify WebInpsect (DAST) scan**

A Postman collection is included so that the deployed API can also be vulnerability scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect).

To use Postman collections with WebInspect you will need to have installed [node.js](https://nodejs.org/en/) and [newman](https://www.npmjs.com/package/newman) as per the Fortify Documentation. 
Then start the application, load the Postman collection into WebInspect and then execute it.

**Fortify ScanCentral DAST scan**

A Postman collection is included so that the deployed API can also be vulnerability scanned with Fortify ScanCentral DAST.


---

Kevin A. Lee (kadraman) - kevin.lee@microfocus.com

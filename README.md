Fortify MuleSoft Demo
=====================

This is an example [Mulesoft Anypoint](https://www.mulesoft.com/platform/enterprise-integration) project that can be
used for [Fortify Static Code Analyzer](https://www.microfocus.com/en-us/cyberres/application-security/static-code-analyzer) 
vulnerability scanning of Mulesoft's XML configuration files. 

The example includes a MuleSoft domain project (where global configuration is typically set) and an [APIKit](https://docs.mulesoft.com/apikit)
application project. The application project exposes a MySQL database as a REST API. It also includes a [Postman](https://www.postman.com/) collection so that
the deployed API can be tested and vulnerability scanned using [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).

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
```

*NOTE: do not place this file under source control*

**Creating the MySQL database**

To create the required MySQL database, first install [MySQL](https://www.mysql.com/) and then as a privileged 
MySQL user (e.g. root) execute the following:

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
sourceanalyzer -verbose -scan mule-domain/src/main/ mule-api-app/src/main/
```

or you can use the provided PowerShell script [bin\fortify_sast.ps1]:

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

 "configuration" => 13 Issues
     mule-api-app/src/main/mule/store-api.xml:34 (Password Management: Password in Comment)
     mule-api-app/src/main/mule/store-api.xml:44 (Mule Misconfiguration: Hardcoded Password)
     mule-api-app/src/main/mule/store-api.xml:44 (Mule Misconfiguration: Insecure Database Transport)
     mule-api-app/src/main/mule/store-api.xml:44 (Password Management: Password in Configuration File)
     mule-api-app/src/main/mule/store-api.xml:61 (Password Management: Password in Comment)
     mule-api-app/src/main/resources/beans.xml:19 (Password Management: Password in Configuration File)
     mule-api-app/src/main/resources/beans.xml:20 (Password Management: Password in Configuration File)
     mule-api-app/src/main/resources/beans.xml:21 (Password Management: Password in Configuration File)
     mule-api-app/src/main/resources/beans.xml:22 (Password Management: Password in Configuration File)
     mule-domain/src/main/mule/mule-domain-config.xml:42 (Mule Misconfiguration: Server Identity Verification Disabled)
     mule-domain/src/main/mule/mule-domain-config.xml:45 (Password Management: Password in Configuration File)
     mule-domain/src/main/resources/ssl/server-dev-keystore.p12:0 (Key Management: Hardcoded Encryption Key)
     mule-domain/src/main/resources/ssl/trusted-client-truststore.p12:0 (Key Management: Hardcoded Encryption Key)
 "semantic" => 2 Issues
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:18 (Insecure Randomness)
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:26 (Insecure Randomness)
 "structural" => 7 Issues
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:31 (J2EE Bad Practices: Leftover Debug Code)
     mule-api-app/src/main/resources/config/config-dev.yaml:22 (Password Management: Hardcoded Password)
     mule-api-app/src/main/resources/config/config-dev.yaml:27 (Password Management: Hardcoded Password)
     mule-api-app/src/main/resources/config/config-local.yaml:22 (Password Management: Hardcoded Password)
     mule-api-app/src/main/resources/config/config-local.yaml:27 (Password Management: Hardcoded Password)
     mule-domain/src/main/resources/config/config-dev.yaml:9 (Password Management: Hardcoded Password)
     mule-domain/src/main/resources/config/config-local.yaml:9 (Password Management: Hardcoded Password)

Total for all analyzers => 22 Issues
```

Note: because the API project also contains some Java beans and encryption keys - these issues are also found.

**Fortify WebInpsect (DAST) scan**

A Postman collection is included so that the deployed API can also be vulnerability scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect).

To use Postman collections with WebInspect you will need to have installed [node.js](https://nodejs.org/en/) and [newman](https://www.npmjs.com/package/newman) as per the Fortify Documentation. 
Then start the application, load the Postman collection into WebInspect and then execute it.

**Fortify ScanCentral DAST scan**

A Postman collection is included so that the deployed API can also be vulnerability scanned with Fortify WebInspect and/or Fortify ScanCentral DAST.


---

Kevin A. Lee (kadraman) - kevin.lee@microfocus.com

Fortify MuleSoft Demo
=====================

This is an example [Mulesoft AnyPoint](https://www.mulesoft.com/platform/enterprise-integration) project that includes 
some [Fortify Static Code Analyzer](https://www.microfocus.com/en-us/cyberres/application-security/static-code-analyzer) 
custom rules for scanning Mulesoft XML configuration files for security vulnerabilities. 

The example includes both a MuleSoft domain project (where global configuration is typically set) and an application
project. The application project exposes a MySQL database as a Mulesoft APIKit REST API and also includes a Postman collection so that
the deployed API can also be scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).


*PLEASE NOTE: This is a work in progress and is not officially supported by Micro Focus.*

**Creating the MySQL database**

To create the required MySQL database, first install MySQL and then as a priviledged user (e.g. root) execute
the following:

```
mysql -u root -p
mysql> source db\schema.sql
mysql> source db\data.sql
mysql> exit
```

**Fortify Static Code Analyzer scan**

To execute a Fortify Static Code Analyzer SAST scan, run the following commands:

```
sourceanalyzer -b FortifyMuleSoftDemo -clean
sourceanalyzer -b FortifyMuleSoftDemo mule-domain/src/main mule-api-app/src/main
sourceanalyzer -b FortifyMuleSoftDemo -verbose -rules rules/mulesoft_rules.xml -scan -f FortifyMuleSoftDemo.fpr
```

or you can use the provided PowerShell script [bin\fortify_sca.ps1]. If you want to use this script you will need
to create a `.env` file in the root directory with contents similar to the following:

```
APP_URL=https://localhost:8082/api/products
SSC_URL=http://fortify.mfdemouk.com
SSC_USERNAME=admin
SSC_PASSWORD=XXXX
# SSC Authentication Token (recommended to use CIToken)
SSC_AUTH_TOKEN=XXXX
SSC_APP_NAME=FortifyMuleSoftDemo
SSC_APP_VER_NAME=main
```

and then you can execute:

```
powershell bin\fortify-sca.ps1
```

You can then view the results with Audit Workbench as follows:

```
auditworkbench FortifyMuleSoftDemo.fpr
```

You should see output similar to the following:

```
Issue counts by analyzer:

 "configuration" => 7 Issues
     mule-api-app/src/main/mule/products-api.xml:33 (MuleSoft Bad Practice: MySQL - hardcoded database host)
     mule-api-app/src/main/mule/products-api.xml:33 (Password Management: MySQL - hardcoded password)
     mule-domain/src/main/mule/mule-domain-config.xml:0 (MuleSoft Misconfiguration: Domain - Hardcoded Key Store configuration)
     mule-domain/src/main/mule/mule-domain-config.xml:19 (MuleSoft Misconfiguration: HTTP(S) port not configured)
     mule-domain/src/main/mule/mule-domain-config.xml:21 (MuleSoft Misconfiguration: Domain - Insecure Trust Store)
     mule-domain/src/main/resources/ssl/server-dev-keystore.p12:0 (Key Management: Hardcoded Encryption Key)
     mule-domain/src/main/resources/ssl/trusted-client-truststore.p12:0 (Key Management: Hardcoded Encryption Key)
 "semantic" => 2 Issues
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:18 (Insecure Randomness)
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:26 (Insecure Randomness)
 "structural" => 1 Issues
     mule-api-app/src/main/java/com/microfocus/example/StockService.java:31 (J2EE Bad Practices: Leftover Debug Code)

Total for all analyzers => 10 Issues
```

**Fortify WebInpsect scan**

A Postman collection is included so that the deployed API can also be scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).
Simply start the application and load the Postman script into WebInspect or ScanCentral DAST and execute it.


TBD

---

Kevin A. Lee (kadraman) - kevin.lee@microfocus.com

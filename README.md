Fortify MuleSoft Demo
=====================

This is an example [Mulesoft AnyPoint](https://www.mulesoft.com/platform/enterprise-integration) project that includes some [Fortify Static Code Analyzer](https://www.microfocus.com/en-us/cyberres/application-security/static-code-analyzer) custom rules for scanning Mulesoft XML source files for vulnerabilities.

The project exposes a MySQL database as a Mulesoft APIKit REST API and also includes a Postman collection so that
the deployed API can also be scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).

PLEASE NOTE: This is a work in progress and is not officially supported by Micro Focus.

**Creating the MySQL database**

To create the required MySQL, first install MySQL and then as a priviledged user (e.g. root) execute
the following scripts:

```
mysql -u root -p
mysql> source src\main\resources\schema.sql
mysql> source src\main\resources\data.sql
mysql> exit
```

**Fortify Static Code Analyzer scan**

From the root directory, run the following commands:

```
sourceanalyzer -b FortifyMuleSoftDemo -clean
sourceanalyzer -b FortifyMuleSoftDemo src/main/mule/
sourceanalyzer -b FortifyMuleSoftDemo -verbose -rules rules/mulesoft_rules.xml -scan -f FortifyMuleSoftDemo.fpr
```

or use the PowerShell script [bin\fortify_sca.ps1] from a PowerShell console or as follows:

```
powershell bin\fortify-sca.ps1
```

You can then view the results with Audit Workbench as follows:

```
auditworkbench FortifyMuleSoftDemo.fpr
```

You should see output similar to the following:

 - Fortify MuleSoft Demo
=====================

This is an example [Mulesoft AnyPoint](https://www.mulesoft.com/platform/enterprise-integration) project that includes some [Fortify Static Code Analyzer](https://www.microfocus.com/en-us/cyberres/application-security/static-code-analyzer) custom rules for scanning Mulesoft XML source files for vulnerabilities.

The project exposes a MySQL database as a Mulesoft APIKit REST API and also includes a Postman collection so that
the deployed API can also be scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).

PLEASE NOTE: This is a work in progress and is not officially supported by Micro Focus.

**Creating the MySQL database**

To create the required MySQL, first install MySQL and then as a priviledged user (e.g. root) execute
the following scripts:

```
mysql -u root -p
mysql> source src\main\resources\schema.sql
mysql> source src\main\resources\data.sql
mysql> exit
```

**Fortify Static Code Analyzer scan**

From the root directory, run the following commands:

```
sourceanalyzer -b FortifyMuleSoftDemo -clean
sourceanalyzer -b FortifyMuleSoftDemo src/main/mule/
sourceanalyzer -b FortifyMuleSoftDemo -verbose -rules rules/mulesoft_rules.xml -scan -f FortifyMuleSoftDemo.fpr
```

or use the PowerShell script [bin\fortify_sca.ps1] from a PowerShell console or as follows:

```
powershell bin\fortify_sca.ps1
```

You can then view the results with Audit Workbench as follows:

```
auditworkbench FortifyMuleSoftDemo.fpr
```

You should see output similar to the following:

 -Fortify MuleSoft Demo
=====================

This is an example [Mulesoft AnyPoint](https://www.mulesoft.com/platform/enterprise-integration) project that includes some [Fortify Static Code Analyzer](https://www.microfocus.com/en-us/cyberres/application-security/static-code-analyzer) custom rules for scanning Mulesoft XML source files for vulnerabilities.

The project exposes a MySQL database as a Mulesoft APIKit REST API and also includes a Postman collection so that
the deployed API can also be scanned with [Fortify WebInspect](https://www.microfocus.com/en-us/cyberres/application-security/webinspect) (or ScanCentral DAST).

PLEASE NOTE: This is a work in progress and is not officially supported by Micro Focus.

**Creating the MySQL database**

To create the required MySQL, first install MySQL and then as a priviledged user (e.g. root) execute
the following scripts:

```
mysql -u root -p
mysql> source src\main\resources\schema.sql
mysql> source src\main\resources\data.sql
mysql> exit
```

**Fortify Static Code Analyzer scan**

From the root directory, run the following commands:

```
sourceanalyzer -b FortifyMuleSoftDemo -clean
sourceanalyzer -b FortifyMuleSoftDemo src/main/mule/
sourceanalyzer -b FortifyMuleSoftDemo -verbose -rules rules/mulesoft_rules.xml -scan -f FortifyMuleSoftDemo.fpr
```

or use the PowerShell script [bin\fortify_sca.ps1] from a PowerShell console or as follows:

```
powershell bin\fortify_sca.ps1
```

You can then view the results with Audit Workbench as follows:

```
auditworkbench FortifyMuleSoftDemo.fpr
```

You should see output similar to the following:

 - products-api.xml:9 (Mulesoft Misconfiguration: HTTP(S) port not configured)
 - products-api.xml:9 (Mulesoft Misconfiguration: HTTPS Not Required)

**Fortify WebInpsect scan**

TBD

---

Kevin A. Lee (kadraman) - kevin.lee@microfocus.com



**Fortify WebInpsect scan**

TBD

---

Kevin A. Lee (kadraman) - kevin.lee@microfocus.com



**Fortify WebInpsect scan**

TBD

---

Kevin A. Lee (kadraman) - kevin.lee@microfocus.com


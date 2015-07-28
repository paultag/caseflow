# README

This README will help you get the Caseflow application up and running!

## JRuby

Caseflow uses JRuby 1.7.16.1 in 2.0 mode and Java 1.8.


## OJDBC6 Jar

You must place the ojdbc6.jar file into your JRuby /lib folder in order to connect to the VACOLS database.

You can find this jar at etc/ojdbc6.jar

## Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 8 Download

You must upgrade Java's default encryption library to support Unlimited Strength, due to export laws.

1. Unzip the file at etc/jce_policy-8.zip
2. Identify your JRE security path.  Look at the README file for more info.

Note: Mac OS X with Java 8 is commonly at: /Library/Java/JavaVirtualMachines/jdk1.8.0_<PATCH VERSION>.jdk/Contents/Home/jre/lib/security

3. Rename `local_policy.jar` to `local_policy.jar.back` and `US_export_policy.jar` to `US_export_policy.jar.back`
4. Place the new `local_policy.jar` and `US_export_policy.jar` into the security folder.
5. Restart the application

## PDFTK

You must install PDFTK before the pdf-forms gem will install.  Please see the latest up-to-date installation instructions [at the GitHub repo](https://github.com/jkraemer/pdf-forms#installation).

## Java Key Store (JKS)

To verify the contents of a JKS file, do the following:

`keytool -list -v  -keystore client3.jks`

Also, if you need to change the alias, do the following:

keytool -changealias -keystore client3.jks -storepass <keypass> -alias <current alias>

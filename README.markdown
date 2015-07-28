# Caseflow

Caseflow is a web application to move appealed claims from an AOJ (Area of Jurisdiction) to the BVA (Board of Veterans Appeals).

## First Time Setup

- Install RVM to install Ruby or JRuby
    - `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`
    - `\curl -sSL https://get.rvm.io | bash -s stable`
- Install JRuby
    - `rvm install jruby-1.7.20`
- Switch to JRuby
    - `rvm use jruby-1.7.20`
- Install bundle
    - `jruby --2.0 -S gem install bundle`
- Install dependencies
    - `jruby --2.0 -S bundle install`
- Install JCE Security ([link](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html))
    - Download it
    - Put in the Java installation (see below)
    - Get JAva installation path `/usr/libexec/java_home`
    - Take the JCE ZIP and unload into (below dir)
- Install OJDBC6
    - Add to lib for Jruby
- Install PDFTK
    - Download from: `https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg`
- Setup database.yml (there is a sample)
- Configure environment to point to VBMS credentials

```
ENV['CONNECT_VBMS_URL'],
ENV['CONNECT_VBMS_KEYFILE'],
ENV['CONNECT_VBMS_SAML'],
ENV['CONNECT_VBMS_KEY'],
ENV['CONNECT_VBMS_KEYPASS'],
ENV['CONNECT_VBMS_CACERT'],
ENV['CONNECT_VBMS_CERT']
```

- Run
    - `jruby --2.0 ./bin/rails console`


## For Getting Setup with VBMS Environment

- brew install ansible
- Get deployment repo
- Go to deployment/


# README

This README will help you get the Caseflow application up and running!

## JRuby
Caseflow uses JRuby 1.7.20 in 2.0 mode and Java 1.8.


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

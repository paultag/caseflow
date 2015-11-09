# Caseflow

Caseflow is a web application to move appealed claims from an AOJ (Area of Jurisdiction) to the BVA (Board of Veterans Appeals).

## First Time Setup

These are things you'll have to do the first time that you setup the application. For parts where it asks you to enter commands, do these in a terminal window. (Note: Instructions assume the developer is using Mac OS X 10.10 or above.)

### Java Setup

You'll need a Java 8 (or higher) development kit (JDK). This can be downloaded from [Oracle's Java site](http://www.oracle.com/technetwork/java/javase/downloads/index.html).

Complete the install before moving on (it should be straightforward via the installer).

Next, you'll need the Java Cryptography Extension (JCE) that is required by JRuby. This can be [downloaded from Oracle too](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html). To install, do the following:

1. Identify your JRE security path. On Mac OS X, it's at: `/Library/Java/JavaVirtualMachines/jdk1.8.0_<PATCH VERSION>.jdk/Contents/Home/jre/lib/security` or you can find the base Java directory by running `/usr/libexec/java_home`
1. Rename `local_policy.jar` to `local_policy.jar.back` and `US_export_policy.jar` to `US_export_policy.jar.back` (this step is simply for backup purposes)
1. Unzip the JCE Zip file file, go into the `UnlimitedJCEPolicy8` folder
1. Place the new `local_policy.jar` and `US_export_policy.jar` into the security folder.

### JRuby Setup

Install `rbenv`, which is a tool that helps install/manage versions of Ruby:

`$ brew install rbenv`

Using `rbenv` install JRuby:

`$ rbenv install jruby-9.0.3.0`

Now, make JRuby the Ruby being used in your current terminal. Run the following commands

`$ rbenv local jruby-9.0.3.0`

Install bundle, which will help download/manage Ruby dependencies:

`> gem install bundle`

Then use it to install dependencies:

`> bundle install`

### Oracle Setup

You'll need Oracle Database drivers so that you can connect to the VACOLS database. [Get these from Oracle](http://www.oracle.com/technetwork/apps-tech/jdbc-112010-090769.html), by downloading ojdbc6.jar.

From here you'll need to find your JRuby installation (`which jruby` helps or going to `~/.rvm/rubies/jruby-1.7.22` if you used RVM). Place ojdbc6.jar into the `lib` directory.

### PDFTK

To generate Form 8 PDFs, Caseflow uses a library called PDFTK. [Download this from PDF Labs](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg), then install it.

### Connect VBMS

To communicate with VBMS (Veterans Benefit Management System), Caseflow uses a library called Connect VBMS. It requires a few environment variables to be setup. They are:

- `CONNECT_VBMS_ENV_DIR`: The directory that contains VBMS credentials for various environments
- `CONNECT_VBMS_ENV`: The directory that contains the VBMS credentials within `CONNECT_VBMS_ENV_DIR`.
- `CONNECT_VBMS_URL`: The URL to the VBMS eFolder
- `CONNECT_VBMS_KEYFILE`: The name of the Java KeyStore File for VBMS (contained in `CONNECT_VBMS_ENV_DIR` + `CONNECT_VBMS_ENV`)
- `CONNECT_VBMS_KEYPASS`: The password for the Java KeyStore file
- `CONNECT_VBMS_SAML`: The name of the single sign on token XML file (contained in `CONNECT_VBMS_ENV_DIR` + `CONNECT_VBMS_ENV`)
- `CONNECT_VBMS_KEY`: (Not needed for test environment) The name of the VBMS key file (contained in `CONNECT_VBMS_ENV_DIR` + `CONNECT_VBMS_ENV`)
- `CONNECT_VBMS_CACERT`: (Not needed for test environment) The name of the CA certificate for VBMS (contained in `CONNECT_VBMS_ENV_DIR` + `CONNECT_VBMS_ENV`)
- `CONNECT_VBMS_CERT`: (Not needed for test environment) The name of the client certificate for VBMS (contained in `CONNECT_VBMS_ENV_DIR` + `CONNECT_VBMS_ENV`)

To get some of these files, you'll have to extract them for your desired environment from the [DSVA Deployment project](https://github.com/department-of-veterans-affairs/deployment) (this repo is closed source to the DSVA team for security reasons). Follow the instructions in there to extract the files.

To help with this, a sample setup script is enclosed at `env.sh` in the Caseflow project. You can edit this file, then run `source env.sh`.

For more information, consult the [documentation for Connect VBMS](https://github.com/department-of-veterans-affairs/connect_vbms).

### Configure the Database

To connect to the VACOLS database, you'll have to configure the URL for the VACOLS database.

Start by making a copy of `config/database.yml.sample` to `config/database.yml`.

Then, configure the following variables *for development* (you may need to uncomment them):

- `default/username`: VACOLS database username
- `default/password`: VACOLS database user password
- `development/url`: VACOLS development database

For *production* (you may need to uncomment them):

- `production/url`: The URL for Caseflow itself
- `production/username`: VACOLS database username
- Create an environment variable called CASEFLOW_DATABASE_PASSWORD with the production database password

## Everytime Setup

Make sure you're using the correct JRuby and environment variables.

```
> rvm use jruby-1.7.22
> source env.sh
```

Then to launch the application, run:

```
> rails s
```

## Running the case identification script

In addition to the web interface, Caseflow has a script for running batch checks
of cases to see if they have matching dates in VACOLS and VBMS. To run this
script:

```
./bin/rails runner lib/sources/caseflow/reports.rb <report-name> <output.csv>
```

Valid report names are `seam` and `mismatched`.

## Quick Testing

Setting up data both in VACOLS and VBMS can be time consuming. There's an easy way to provide mock data so that different scenarios can be tested quickly.

To enable this, add this environment variable:

```
CASEFLOW_TEST=true
```

You can add new fake data in `app/models/fakes.rb`.

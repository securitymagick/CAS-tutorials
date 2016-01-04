#Setting Up CAS to Use a Database

This is the second tutorial on my CAS and secure coding series.  It will take you through a more complex CAS set up to a database and show how to fix and correct certain common web application problems.

Step One:  Set up MySQl database.
Download MySQL.  Currently for windows go to https://dev.mysql.com/downloads/windows/installer/.  Download the mysql-installer-web-community-5.6.26.0.msi.  Run the installer.  On the screen where you set up your root account go ahead and add another account with DBAdmin rights.  This account is catAdmin / catPass.

Step Two:  Create your databases.  
From the commandline client:

	CREATE DATABASE insecureCat;
	Use insecureCat;

	CREATE TABLE `catlovers` (
		 `cat_name` varchar(45) NOT NULL,
  		`email` varchar(45) NOT NULL,
  		`uname` varchar(45) NOT NULL,
  		`pass` varchar(45) NOT NULL,
  		`regdate` date NOT NULL,
		`securityQuestion` varchar(45) NOT NULL,  
  		`answer` varchar(45) NOT NULL, 
  		PRIMARY KEY  (`email`)
	);

	CREATE TABLE `catcomments` (
		`id` int(10) unsigned NOT NULL auto_increment,
		`uname` varchar(45) NOT NULL,
		`writtenBy` varchar(45) NOT NULL,
		`comment` varchar(128) NOT NULL,  
		PRIMARY KEY  (`id`)
	);

	CREATE TABLE `catphotos` (
		`uname` varchar(45) NOT NULL,
		`private` varchar(1) NOT NULL,
		`public` varchar(1) NOT NULL,  
  		PRIMARY KEY  (`uname`)
	);

Step Three:  Modify CAS Client from tutorial 1 to use this database.
Modify your cas pom to include:

	<dependency>
		<groupId>org.jasig.cas</groupId>
		<artifactId>cas-server-support-jdbc</artifactId>
		<version>${cas.version}</version>
	</dependency>
	<dependency>
		<groupId>c3p0</groupId>
		<artifactId>c3p0</artifactId>
		<version>0.9.1.2</version>
	</dependency>
	<dependency>
        	<groupId>mysql</groupId>
        	<artifactId>mysql-connector-java</artifactId>
        	<version>5.1.26</version>
    	</dependency>

Modify the deployConfigContext.xml
Add the following beans:

	<bean id="passwordEncoder"
      		class="org.jasig.cas.authentication.handler.PlainTextPasswordEncoder" />

	<bean id="dbAuthHandler"
      		class="org.jasig.cas.adaptors.jdbc.SearchModeSearchDatabaseAuthenticationHandler"
      		p:dataSource-ref="dataSource"
      		p:passwordEncoder-ref="passwordEncoder"
      		p:tableUsers="catlovers"
      		p:fieldUser="uname"
      		p:fieldPassword="pass" />
	
	<bean id="dataSource"
		class="com.mchange.v2.c3p0.ComboPooledDataSource"
		p:driverClass="${database.driverClass}"
		p:jdbcUrl="${database.url}"
		p:user="${database.user}"
		p:password="${database.password}"
		p:initialPoolSize="${database.pool.minSize}"
		p:minPoolSize="${database.pool.minSize}"
		p:maxPoolSize="${database.pool.maxSize}"
		p:maxIdleTimeExcessConnections="${database.pool.maxIdleTime}"
		p:checkoutTimeout="${database.pool.maxWait}"
		p:acquireIncrement="${database.pool.acquireIncrement}"
		p:acquireRetryAttempts="${database.pool.acquireRetryAttempts}"
		p:acquireRetryDelay="${database.pool.acquireRetryDelay}"
		p:idleConnectionTestPeriod="${database.pool.idleConnectionTestPeriod}"
		p:preferredTestQuery="${database.pool.connectionHealthQuery}" />

Change the authenticationManager to point to the dbAuthHandler
    
    <bean id="authenticationManager" class="org.jasig.cas.authentication.PolicyBasedAuthenticationManager">
        <constructor-arg>
            <map>
                <!--
                   | IMPORTANT
                   | Every handler requires a unique name.
                   | If more than one instance of the same handler class is configured, you must explicitly
                   | set its name to something other than its default name (typically the simple class name).
                   -->
                <entry key-ref="proxyAuthenticationHandler" value-ref="proxyPrincipalResolver" />
                <entry key-ref="dbAuthHandler" value-ref="primaryPrincipalResolver" />
            </map>
        </constructor-arg>

Copy the cas.properties from a target to src.  Add the following to the bottom:

     # == Basic database connection pool configuration ==
    database.driverClass=com.mysql.jdbc.Driver
    database.url=jdbc:mysql://localhost:3306/insecureCat
    database.user=catAdmin
    database.password=catPass
    database.pool.minSize=6
    database.pool.maxSize=18
     
    # Maximum amount of time to wait in ms for a connection to become
    # available when the pool is exhausted
    database.pool.maxWait=10000
     
    # Amount of time in seconds after which idle connections
    # in excess of minimum size are pruned.
    database.pool.maxIdleTime=120
     
    # Number of connections to obtain on pool exhaustion condition.
    # The maximum pool size is always respected when acquiring
    # new connections.
    database.pool.acquireIncrement=6
     
    # == Connection testing settings ==
     
    # Period in s at which a health query will be issued on idle
    # connections to determine connection liveliness.
    database.pool.idleConnectionTestPeriod=30
     
    # Query executed periodically to test health
    database.pool.connectionHealthQuery=select 1
     
    # == Database recovery settings ==
     
    # Number of times to retry acquiring a _new_ connection
    # when an error is encountered during acquisition.
    database.pool.acquireRetryAttempts=5
     
    # Amount of time in ms to wait between successive aquire retry attempts.
    database.pool.acquireRetryDelay=2000

Now you are ready to start the OWASP top 10 tutorials.  CAS-tutorials 3 and 4 are part of one of the OWASP top 10 tutorials.
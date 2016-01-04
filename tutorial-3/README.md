#Basic Password Hashing in CAS

This tutorial build on the last to add basic password hashing to your CAS server.

Modify the deployConfigContext.xml
Change the passwordEncoder to use a SHA-256 hashing algorithm.

Please read:
http://jasig.github.io/cas/4.1.x/installation/Database-Authentication.html

https://github.com/Jasig/cas/blob/15baf7f42cfad6ff6c321f92065fdf4f3178a540/cas-server-core-authentication/src/main/java/org/jasig/cas/authentication/handler/DefaultPasswordEncoder.java

https://docs.oracle.com/javase/7/docs/technotes/guides/security/StandardNames.html#MessageDigest



import AssemblyKeys._ // put this at the top of the file

assemblySettings  

mainClass in (Compile,run) := Some("PBox")

name := "pbox"

version := "1.1"

scalaVersion := "2.10.0"

resolvers += "twitter shit" at "http://maven.twttr.com/"

//libraryDependencies += "org.scalatest"             % "scalatest_2.10"          % "1.9.1"      % "test"

libraryDependencies += "log4j"                     %  "log4j"                  % "1.2.16"

libraryDependencies +=  "junit"                    % "junit"                   % "4.11"       % "test"

libraryDependencies += "com.novocode" % "junit-interface" % "0.10" % "test"

javaOptions ++= Seq("-Djava.awt.headless=false")


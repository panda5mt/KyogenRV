// See README.md for license details.

def scalacOptionsVersion(scalaVersion: String): Seq[String] = {
  Seq() ++ {
    // If we're building with Scala > 2.11, enable the compile option
    //  switch to support our anonymous Bundle definitions:
    //  https://github.com/scala/bug/issues/10047
    CrossVersion.partialVersion(scalaVersion) match {
      case Some((2, scalaMajor: Long)) if scalaMajor < 12 => Seq()
      case _ => Seq("-Xsource:2.11")
    }
  }
}

def javacOptionsVersion(scalaVersion: String): Seq[String] = {
  Seq() ++ {
    // Scala 2.12 requires Java 8. We continue to generate
    //  Java 7 compatible code for Scala 2.11
    //  for compatibility with old clients.
    CrossVersion.partialVersion(scalaVersion) match {
      case Some((2, scalaMajor: Long)) if scalaMajor < 12 =>
        Seq("-source", "1.7", "-target", "1.7")
      case _ =>
        Seq("-source", "1.8", "-target", "1.8")
    }
  }
}

name := "kyogenrv"

version := "0.1.0"

scalaVersion := "2.12.10"

crossScalaVersions := Seq("2.12.10", "2.11.12")

resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases")
)

// Provide a managed dependency on X if -DXVersion="" is supplied on the command line.
val defaultVersions = Map(
  "chisel3" -> "3.4.+",
  "chisel-iotesters" -> "1.5.+",
  "firrtl" -> "1.4.+",
  "firrtl-interpreter" -> "1.4.+",
  "treadle" -> "1.3.+"
)

libraryDependencies ++= Seq("chisel3","chisel-iotesters","treadle" ).map {
  dep: String => "edu.berkeley.cs" %% dep % sys.props.getOrElse(dep + "Version", defaultVersions(dep)) }

scalacOptions ++= scalacOptionsVersion(scalaVersion.value)

javacOptions ++= javacOptionsVersion(scalaVersion.value)

lazy val commonSettings = Seq (
  organization := "edu.berkeley.cs",
  version := "2.0",
  autoAPIMappings := true,
  scalaVersion := "2.11.12",
  crossScalaVersions := Seq("2.11.12", "2.12.6"),
  resolvers ++= Seq(
    Resolver.sonatypeRepo("snapshots"),
    Resolver.sonatypeRepo("releases")
  ),
  scalacOptions := Seq(
    "-deprecation",
    "-feature",
    "-language:reflectiveCalls") ++ scalacOptionsVersion(scalaVersion.value),
  javacOptions ++= javacOptionsVersion(scalaVersion.value),

  libraryDependencies ++= Seq("chisel3", "chisel-iotesters").map {
    dep: String => "edu.berkeley.cs" %% dep % sys.props.getOrElse(dep + "Version", defaultVersions(dep))
  },
  updateOptions := updateOptions.value.withLatestSnapshots(false),
  addCompilerPlugin("org.scalamacros" % "paradise" % "2.1.0" cross CrossVersion.full),
)

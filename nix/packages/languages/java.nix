{ pkgs }:

with pkgs; [
  # Development tools
  google-java-format
  checkstyle
  spring-boot-cli
  
  # Database & Migration
  flyway
  liquibase
  
  # Analysis & Documentation
  spotbugs
  pmd
  plantuml
  
  # Testing & Performance
  jmeter
  visualvm
  
  # Infrastructure
  tomcat9
  jetty
  jib
  coursier
]

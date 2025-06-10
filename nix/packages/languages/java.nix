# Java development tools and ecosystem
# Usage: nix-env -if ~/.dotfiles/nix/packages/languages/java.nix
# Note: Use mise or SDKMAN for actual JDK runtime management

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # JDK (fallback - prefer mise/SDKMAN for version management)
  openjdk21              # Latest LTS Java (fallback)
  
  # Build tools
  maven                  # Maven build tool
  gradle                 # Gradle build tool
  ant                    # Apache Ant (legacy projects)
  
  # Language servers & development
  jdt-language-server    # Java Language Server (Eclipse JDT)
  google-java-format     # Code formatter
  checkstyle             # Code style checker
  
  # Spring Boot tools
  spring-boot-cli        # Spring Boot CLI
  
  # Testing tools
  junit                  # Testing framework (if needed globally)
  
  # Application servers & containers
  tomcat9                # Apache Tomcat
  jetty                  # Eclipse Jetty
  
  # Database tools
  flyway                 # Database migration tool
  liquibase              # Database version control
  
  # Code analysis
  spotbugs               # Static analysis tool
  pmd                    # Source code analyzer
  
  # Documentation
  plantuml               # UML diagram generator
  
  # Utilities
  jq                     # JSON processor (useful for REST APIs)
  httpie                 # HTTP client for API testing
  
  # Profiling & monitoring
  visualvm               # Visual profiling tool
  
  # Java-specific utilities
  jmeter                 # Load testing tool
  
  # Container tools for Java apps
  jib                    # Container image builder for Java
  
  # Dependency management
  coursier               # Scala/Java dependency resolver
  
  # Build cache & performance
  ccache                 # Compiler cache (can help with native compilation)
]

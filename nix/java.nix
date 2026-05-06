{ pkgs }:
with pkgs; [
  # Formatting & style
  google-java-format
  checkstyle

  # Static analysis
  spotbugs
  pmd

  # Diagrams
  plantuml

  # DB migration CLIs (useful globally for ad-hoc work)
  flyway
  liquibase

  # Spring Boot CLI (useful for scaffolding)
  spring-boot-cli

  # Dependency resolution
  coursier
]

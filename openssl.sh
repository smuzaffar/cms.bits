package: OpenSSL
version: v1.1.1m
system_requirement_missing: |
   Please install bison and flex develpment package on your system.
   If they are there, make sure you have them in your default path.
system_requirement: ".*"
system_requirement_check: |
   command openssl version
---

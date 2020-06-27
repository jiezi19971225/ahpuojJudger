#!/bin/bash
update-alternatives --auto java
update-alternatives --auto javac
supervisord
exit 0

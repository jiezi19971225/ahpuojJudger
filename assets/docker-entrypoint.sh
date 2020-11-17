#!/bin/bash
update-alternatives --auto java
update-alternatives --auto javac
supervisord
/bin/bash
exit 0
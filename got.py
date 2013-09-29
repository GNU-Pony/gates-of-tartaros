#!/usr/bin/env python3
'''
gates-of-tartaros – Minimal replacement for agetty with SSH support

Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''


import sys
import os
from subprocess import Popen

for arg in sys.argv[1:]:
    if "=" in arg:
        os.putenv(arg.split("=")[0], "=".join(arg.split("=")[1:]))

def spawn(cmd):
    Popen(cmd, stdin = sys.stdin, stdout = sys.stdout, stderr = sys.stderr).wait()

user = input()
if "@" in user:
    os.putenv("GOT_COMMAND", "ssh " + user)
    spawn(["login", "-p", "-f", "sshlogin"])
else:
    spawn(["login"] + user.split(" "))

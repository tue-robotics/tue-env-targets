#! /usr/bin/env python3

import site
import sys

pip_user_site = site.getusersitepackages()
pip_system_site = site.getsitepackages()[0]


def catkin_tools_pip_installed():
    try:
        import catkin_tools
    except ImportError:
        return False

    if pip_user_site in catkin_tools.__file__:
        print("user")
        return True
    elif pip_system_site in catkin_tools.__file__:
        print("system")
        return True

    return False

if __name__ == "__main__":
    sys.exit(catkin_tools_pip_installed())

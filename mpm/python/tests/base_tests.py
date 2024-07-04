#
# Copyright 2019 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""
Base Test Case classes
"""

import platform
import unittest

class TestBase(unittest.TestCase):
    """
    Base Test Case class which contains commonly required functionality
    """
    def skipUnlessOnLinux():
        """
        Test function decorator which skips tests unless the current
        execution environment is a linux OS.
        """
        if 'linux' in platform.system().lower():
            return lambda func: func
        return unittest.skip("This test is only valid when run on a Linux system.")

    def skipUnlessOnUsrp():
        """
        Test function decorator which skips tests unless the current
        execution environment is a USRP.

        Assumes that 'arm' in the machine name constitutes an ARM
        processor, aka a USRP.
        """
        if 'arm' in platform.machine().lower():
            return lambda func: func
        return unittest.skip("This test is only valid when run on the USRP.")

    def set_device_name(self, device_name):
        """
        Stores a device name attribute for tests whose success condition
        depends on the current device.
        """
        self.device_name = device_name

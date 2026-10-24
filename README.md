# MT7925 on Windows 10
By default, the MediaTek MT7925 does not function on Windows 10. Through two PowerShell scripts however, the ``mtkwl6ex`` driver works just fine under Windows 10. In my testing, WiFi 6 is fully functional. I haven't looked into WiFi 7 and do not plan to.

# Get Started

## 1. Get the package
The package contains everything you need to modify ``mtkwl6ex`` to work on your specific device. We need to add your specific board to the .inf file of the driver. The script and this readme will walk you through every step. After downloading, extract the .zip into its own folder somewhere convenient like your desktop.

## 2. Prepare your computer
For this to work, we need to disable Secure Boot and allow unsigned PowerShell scripts (mine) to run. Later on, Test Mode will also be enabled. Don't worry, once everything is done, we can turn Test Mode off, and turn Secure Boot back on. Unsigned PowerShell scripts can also be restricted again once done.

IF YOU HAVE BITLOCKER ENABLED, THIS WILL LIKELY LOCK YOUR DRIVE DOWN. DISABLE BITLOCKER, OR ENSURE YOU HAVE THE RECOVERY KEY HANDY.

1. Disable Secure Boot: This is different for every manufacturer. Please refer to online guides, videos, or your computer's manual for details on how to enter your UEFI Setup and do this.
2. Allow unsigned PowerShell scripts: Run PowerShell as administrator, then enter the following command:

``Set-ExecutionPolicy Unrestricted``
## 3. Run initialize.ps1 for the first time
Don't move the script or driver files anywhere!
Open PowerShell as administrator, ``cd`` into the folder with the scripts and driver files, and run the script with:

``.\initialize.ps1``

When asked, press enter to enable Test Mode. Reboot your computer.

If a Notepad window opens and a Done! message appears on your PowerShell, Test Mode is already enabled. Continue reading.

## 4. Run initialize.ps1 a second time
Upon detecting Test Mode is on, the script will prepare a Workspace folder, output some information, and open a file in Notepad. We'll be modifying this file. Take note of the string that was output to your terminal, which will look something like this:

``InstanceId : PCI\VEN_14C3&DEV_7925&SUBSYS_XXXXXXXX&REV_XX\XXXXXXXXXXXXXXXXX``

Of this output, copy the following for later:
``PCI\VEN_14C3&DEV_7925&SUBSYS_XXXXXXXX``

(The ``XXXXXXXX`` will be different depending on your board.)

## 5. Modify the .inf file in Notepad
Find the following section which reads ``Mediatek2 Win10 specific entries``.
Replace the placeholder ``PCI\VEN_14C3&DEV_7925&SUBSYS_XXXXXXXX`` with the output we copied in step four. Save the file.

## 6. Run installDriver.ps1
Open PowerShell as administrator, ``cd`` into the folder with the scripts and driver files, and run the script with:

``.\installDriver.ps1``

This will automatically generate a certificate and a new catalog for the modified driver. It will sign the catalog with our new certificate, then install the driver. You will receive a warning saying Windows can't verify the publisher. This is expected, as we modified the driver ourselves. Install anyways.

## 7. Finished!
Try connecting to the internet!

## 8. Cleanup
Now we can disable Test Mode. Open PowerShell as administrator and run the following command:

``bcdedit /set testsigning off``

Then restart your computer.

After this, we can turn Secure Boot on again. Do this in your UEFI setup.

After coming back, we can also disable running unsigned scripts in. Open PowerShell as administrator:

``Set-ExecutionPolicy Undefined``

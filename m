From: Phillip Susi <phill@thesusis.net>
Date: Tue, 02 Apr 2019 18:07:46 +0000
Subject: Wiki errors
Message-Id: <7d1d12c6-9d9e-4003-8db1-211f270c3e1f@thesusis.net>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I've been reading up at http://linux-iscsi.org/wiki/Main_Page and found
the following issues:

1) The backend section lists the following backstores with links:
"Backstores: SATA, SAS, SCSI, SSD, FLASH, DVD, USB, ramdisk, etc.".  Not
only are none of these backing stores ( those would be FILEIO, IBLOCK,
PSCSI, and RAMDISK ), but all of the links redirect to a wiki page named
"Target" which simply points you to LIO.

2) The LIO page correctly lists the backing stores, but those links also
go to the "Target" page which just direct you back to the LIO page.

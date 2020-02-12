From: Dakshaja Uppalapati <dakshaja@chelsio.com>
Date: Wed, 12 Feb 2020 05:43:08 +0000
Subject: Re: IOZONE fails intermittently while toggling the interface
Message-Id: <20200212053106.GA18378@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
References: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Monday, February 02/10/20, 2020 at 19:47:41 -0800, Bart Van Assche wrote:
> On 2020-02-10 06:19, Dakshaja Uppalapati wrote:
> > I had run the test multiple times with the given patch, attached traces are seen.
> 
> Thanks for having tested the patch I had shared. Can you test the
> attached patch on top of v5.6-rc1? It reverts the following two patches:
> * e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish
> before freeing a session") # v5.5-rc1.
> * 04060db41178 ("scsi: RDMA/isert: Fix a recently introduced regression
> related to logout") # v5.5

Hi Bart,

With the given patch on 5.6-rc1, the test runs fine overnight.

Thanks,
Dakshaja

From: Alan Adamson <alan.adamson@oracle.com>
Date: Tue, 16 Apr 2019 20:54:16 +0000
Subject: Re: How can I change Vendor name LIO-ORG
Message-Id: <22707fe2-473d-6992-d9e3-472a1a421052@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAPUHmCreBhAa7Dzr+6pkYXyifXnRQfXt39KLHMVCer9jd+Lh3A@mail.gmail.com>
In-Reply-To: <CAPUHmCreBhAa7Dzr+6pkYXyifXnRQfXt39KLHMVCer9jd+Lh3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Here you go:

# echo "APA-ORG" > 
/sys/kernel/config/target/core/fileio_0/shareddata/wwn/vendor_id


Alan


On 4/10/19 5:43 AM, Özkan Göksu wrote:
> Hello.
>
> I couldn't find any way to change LIO-SCSI Vendor name which is shown
> as LIO-ORG when we attached to client.
> I do not want to re-compile kernel with the changing hard-coded Vendor name.
>
> If there is any way to change it, please can you show me the way?
>
> P.S: I'm so sorry to bother you with this out-of topic question. I'm
> aware its not the right place to ask this question  but I could not
> find any answer from anywhere. Please forgive me for this.
>
> Best Regards.

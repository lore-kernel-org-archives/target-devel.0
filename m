From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 14:31:37 +0000
Subject: Re: [PATCH v6 3/5] target: add device vendor_id configfs attribute
Message-Id: <20181204153137.17a2609f@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181204101238.20587-4-ddiss@suse.de>
In-Reply-To: <20181204101238.20587-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 4 Dec 2018 16:26:59 +0300, Roman Bolshakov wrote:

> wrt PATCH 5 in the series. Should we allow to set vendor_id for for
> pscsi? target_transport_configure sets t10_wwn fields for pscsi, but but
> an attempt to set vendor_id will overwrite the value recieved from
> scsi_device.

I considered adding an if (PASSTHROUGH){return -EINVAL}, but we already
allow the model/product string to be set for pscsi+tcmu backends via
emulate_model_alias, so decided against it.

> And (please correct me if I'm wrong) it's not used anywhere except
> statistics config_group. That means in the actual INQUIRY commands it
> will still return vendor_id of the underlying storage. If that's that's
> true, this means an attempt to set vendor_id will be succesful but it
> won't do what's intended for.

That's correct.

Cheers, David

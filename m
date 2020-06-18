From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 18 Jun 2020 14:03:52 +0000
Subject: Re: [PATCH v3] IB/srpt: Remove WARN_ON from srpt_cm_req_recv
Message-Id: <3d0354bc-e859-740a-f2d8-362604377f86@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200617140803.181333-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200617140803.181333-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing Xiangfeng <jingxiangfeng@huawei.com>, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On 2020-06-17 07:08, Jing Xiangfeng wrote:
> The callers pass the pointer '&req' or 'private_data' to
> srpt_cm_req_recv(), and 'private_data' is initialized in srp_send_req().
> 'sdev' is allocated and stored in srpt_add_one(). It's easy to show that
> sdev and req are always valid. So we remove unnecessary WARN_ON.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

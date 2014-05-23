#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <../libtopk/topk.h>

#include "const-c.inc"

MODULE = TopK		PACKAGE = TopK

INCLUDE: const-xs.inc

topk_t *
topk_new(size)
	int	size

SV *
topk_insert(tk, v)
	topk_t *	tk
	SV *	v
    CODE:
        STRLEN  vlen = 0;
        char *vptr = SvPVbyte(v, vlen);
        topk_insert(tk, vptr, vlen);
        XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

AV *
topk_top(tk)
    topk_t *    tk
    CODE:
        int i;
        AV* ret = newAV();
        sv_2mortal((SV*)ret);
        for(i=0;i<tk->msize;i++) {
            av_push(ret, newSVpv(tk->mlist[i].v, tk->mlist[i].vlen));
        }
        RETVAL = ret;
    OUTPUT:
        RETVAL

HV *
topk_counts(tk)
    topk_t *    tk
    CODE:
        int i;
        HV* ret = newHV();
        sv_2mortal((SV*)ret);
        for(i=0;i<tk->msize;i++) {
            hv_store(ret, tk->mlist[i].v, tk->mlist[i].vlen, newSViv(tk->mlist[i].count), 0);
        }
        RETVAL = ret;
    OUTPUT:
        RETVAL


MODULE = TopK		PACKAGE = topk_tPtr PREFIX=topkptr_

SV *
topkptr_DESTROY(tk)
    topk_t *tk
    CODE:
        topk_free(tk);
        XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

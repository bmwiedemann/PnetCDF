#include <mpi.h>
#include <pnetcdf.h>
#include <dispatch.h>
#include <nc4io_driver.h>

extern int 
nc4io_req_list_init(NC_nc4_req_list *lp);

extern int 
nc4io_req_list_free(NC_nc4_req_list *lp);

extern int 
nc4io_req_list_add(NC_nc4_req_list *lp, int *id);

extern int 
nc4io_req_list_remove(NC_nc4_req_list *lp, int reqid);

extern int 
nc4io_wait_put_reqs(NC_nc4 *nc4p, int nreq, int *reqids, int *stats);

extern int 
nc4io_wait_get_reqs(NC_nc4 *nc4p, int nreq, int *reqids, int *stats);

extern int 
nc4io_init_req( NC_nc4 *nc4p,
                    NC_nc4_req *req,
                    int        varid,
                    const MPI_Offset *start,
                    const MPI_Offset *count,
                    const MPI_Offset *stride, 
                    const MPI_Offset *imap,
                    const void *buf,
                    MPI_Datatype buftype,
                    int deepcp);
extern int 
nc4io_init_varn_req( NC_nc4 *nc4p,
                        NC_nc4_req *req,
                        int        varid,
                        int        nreq,
                        MPI_Offset *const*starts,
                        MPI_Offset *const*counts, 
                        const void *buf,
                        MPI_Datatype buftype,
                        int deepcp);
dnl Process this m4 file to produce 'C' language file.
dnl
dnl If you see this line, you can ignore the next one.
/* Do not edit this file. It is produced from the corresponding .m4 source */
dnl
/*
 *  Copyright (C) 2017, Northwestern University and Argonne National Laboratory
 *  See COPYRIGHT notice in top-level directory.
 *
 *  $Id$
 */

/* This program tests whether the correct error codes can be returned when
 * using NULL arguments for start, count, stride, or imap
 */

#include <stdio.h>
#include <stdlib.h>
#include <strings.h> /* strcasecmp() */
#include <libgen.h> /* basename() */
#include <mpi.h>
#include <pnetcdf.h>

#include <testutils.h>

include(`foreach.m4')dnl
include(`utils.m4')dnl

#define text char

#ifndef schar
#define schar signed char
#endif
#ifndef uchar
#define uchar unsigned char
#endif
#ifndef ushort
#define ushort unsigned short
#endif
#ifndef uint
#define uint unsigned int
#endif
#ifndef longlong
#define longlong long long
#endif
#ifndef ulonglong
#define ulonglong unsigned long long
#endif

define(`TEST_NULL_ARGS',dnl
`dnl
')dnl

#define EXP_ERR_MSG(exp,msg) { \
    if (err != exp) { \
        nerrs++; \
        fprintf(stderr, "Error at %s:%d: (%s) expect %s but got %s\n", \
                __FILE__,__LINE__, msg, \
                ncmpi_strerrno(exp), ncmpi_strerrno(err)); \
    } \
}

define(`TEST_NULL_ARGS',`

    memset($1_buf, 0, 100*sizeof($1));

    /*---- test put_var1 ---- */
    err = ncmpi_put_var1_$1_all(ncid, vid_$1, start, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_var1")

    err = ncmpi_put_var1_$1_all(ncid, vid_$1, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_var1 start=NULL")

    /*---- test put_vara ---- */
    err = ncmpi_put_vara_$1_all(ncid, vid_$1, start, count, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_vara")

    err = ncmpi_put_vara_$1_all(ncid, vid_$1, NULL, count, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_vara start=NULL")

    err = ncmpi_put_vara_$1_all(ncid, vid_$1, start, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_vara count=NULL")

    err = ncmpi_put_vara_$1_all(ncid, vid_$1, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_vara start=count=NULL")

    /*---- test put_vars ---- */
    err = ncmpi_put_vars_$1_all(ncid, vid_$1, start, count, stride, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_vars")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, NULL, count, stride, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_vars start=NULL")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, start, NULL, stride, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_vars count=NULL")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, start, count, NULL, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_vars stride=NULL")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, NULL, NULL, stride, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_vars start=count=NULL")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, NULL, count, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_vars start=stride=NULL")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, start, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_vars count=stride=NULL")

    err = ncmpi_put_vars_$1_all(ncid, vid_$1, NULL, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_vars start=count=stride=NULL")

    /*---- test put_varm ---- */
    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, count, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_varm")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, count, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, NULL, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_varm count=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, count, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_varm stride=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, count, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_varm imap=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, NULL, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=count=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, count, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=stride=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, count, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=imap=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, NULL, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_varm count=stride=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, NULL, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_varm count=imap=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, count, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "put_varm stride=imap=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, NULL, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=count=stride=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, NULL, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=count=imap=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, start, NULL, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "put_varm count=stride=imap=NULL")

    err = ncmpi_put_varm_$1_all(ncid, vid_$1, NULL, NULL, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "put_varm start=count=stride=imap=NULL")

    /*---- test get_var1 ---- */
    err = ncmpi_get_var1_$1_all(ncid, vid_$1, start, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_var1")

    err = ncmpi_get_var1_$1_all(ncid, vid_$1, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_var1 start=NULL")

    /*---- test get_vara ---- */
    err = ncmpi_get_vara_$1_all(ncid, vid_$1, start, count, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_vara")

    err = ncmpi_get_vara_$1_all(ncid, vid_$1, NULL, count, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_vara start=NULL")

    err = ncmpi_get_vara_$1_all(ncid, vid_$1, start, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_vara count=NULL")

    err = ncmpi_get_vara_$1_all(ncid, vid_$1, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_vara start=count=NULL")

    /*---- test get_vars ---- */
    err = ncmpi_get_vars_$1_all(ncid, vid_$1, start, count, stride, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_vars")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, NULL, count, stride, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_vars start=NULL")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, start, NULL, stride, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_vars count=NULL")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, start, count, NULL, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_vars stride=NULL")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, NULL, NULL, stride, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_vars start=count=NULL")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, NULL, count, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_vars start=stride=NULL")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, start, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_vars count=stride=NULL")

    err = ncmpi_get_vars_$1_all(ncid, vid_$1, NULL, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_vars start=count=stride=NULL")

    /*---- test get_varm ---- */
    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, count, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_varm")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, count, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, NULL, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_varm count=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, count, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_varm stride=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, count, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_varm imap=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, NULL, stride, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=count=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, count, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=stride=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, count, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=imap=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, NULL, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_varm count=stride=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, NULL, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_varm count=imap=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, count, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_NOERR, "get_varm stride=imap=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, NULL, NULL, imap, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=count=stride=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, NULL, stride, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=count=imap=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, start, NULL, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EEDGE, "get_varm count=stride=imap=NULL")

    err = ncmpi_get_varm_$1_all(ncid, vid_$1, NULL, NULL, NULL, NULL, $1_buf);
    EXP_ERR_MSG(NC_EINVALCOORDS, "get_varm start=count=stride=imap=NULL")
')dnl

define(`CDF5_ITYPES',`schar,uchar,short,ushort,int,uint,long,float,double,longlong,ulonglong')dnl
define(`CDF2_ITYPES',`schar,short,int,long,float,double')dnl
define(`EXTRA_ITYPES',`uchar,ushort,uint,longlong,ulonglong')dnl

define(`TEST_FORMAT',dnl
`dnl
static int
test_format_nc$1(char *filename)
{
    int err, nerrs=0, ncid, cmode, dimid[2];
    MPI_Offset start[2], count[2], stride[2], imap[2];

    /* NC_FORMAT_NETCDF4_CLASSIC does not support extended data types, i.e. NC_UINT, NC_INT64 etc. */
    define(`TYPE_LIST',`ifelse(`$1',`5',`CDF5_ITYPES',`$1',`3',`CDF5_ITYPES',`CDF2_ITYPES')')dnl

    /* variable IDs */dnl
    foreach(`itype',(text,TYPE_LIST),`
    _CAT(`int vid_',itype);')

    /* variable buffers */dnl
    foreach(`itype',(text,TYPE_LIST),`
    _CAT(itype itype,`_buf[1024];')')dnl

    dnl constants defined in netcdf.h and pnetcdf.h
    dnl #define NC_FORMAT_CLASSIC         (1)
    dnl #define NC_FORMAT_64BIT_OFFSET    (2)
    dnl #define NC_FORMAT_NETCDF4         (3)
    dnl #define NC_FORMAT_NETCDF4_CLASSIC (4)
    dnl #define NC_FORMAT_64BIT_DATA      (5)

    ifelse(`$1',`2',`cmode = NC_CLOBBER | NC_64BIT_OFFSET;',
           `$1',`5',`cmode = NC_CLOBBER | NC_64BIT_DATA;',
           `$1',`3',`cmode = NC_CLOBBER | NC_NETCDF4;',
           `$1',`4',`cmode = NC_CLOBBER | NC_NETCDF4 | NC_CLASSIC_MODEL;',
                    `cmode = NC_CLOBBER;')dnl

    err = ncmpi_create(MPI_COMM_WORLD, filename, cmode, MPI_INFO_NULL, &ncid);
    EXP_ERR_MSG(NC_NOERR, "create")

    err = ncmpi_def_dim(ncid, "Y", NC_UNLIMITED, &dimid[0]);
    EXP_ERR_MSG(NC_NOERR,"def_dim Y")
    err = ncmpi_def_dim(ncid, "X", 10, &dimid[1]);
    EXP_ERR_MSG(NC_NOERR,"def_dim X")

    /* define variables */dnl
    foreach(`itype',(text, TYPE_LIST),`_CAT(`
    err = ncmpi_def_var(ncid,"var_'itype`",NC_TYPE(itype),2,dimid,&vid_',itype`);
    EXP_ERR_MSG(NC_NOERR,"def_var")')')

    err = ncmpi_enddef(ncid);
    EXP_ERR_MSG(NC_NOERR,"enddef")

     start[0] =  start[1] = 0;
     count[0] =  count[1] = 1;
    stride[0] = stride[1] = 1;
      imap[0] =   imap[1] = 1;

    foreach(`itype',(text, TYPE_LIST),`TEST_NULL_ARGS(itype)')

    err = ncmpi_close(ncid);
    EXP_ERR_MSG(NC_NOERR, "close")

    return nerrs;
}
')dnl

TEST_FORMAT(1)
TEST_FORMAT(2)
TEST_FORMAT(5)
TEST_FORMAT(3)
TEST_FORMAT(4)

int main(int argc, char **argv)
{
    char filename[256], *hint_value;;
    int err, nerrs=0, rank, bb_enabled=0;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (argc > 2) {
        if (!rank) printf("Usage: %s [filename]\n",argv[0]);
        MPI_Finalize();
        return 1;
    }
    if (argc == 2) snprintf(filename, 256, "%s", argv[1]);
    else           strcpy(filename, "testfile.nc");

    if (rank == 0) {
        char *cmd_str = (char*)malloc(strlen(argv[0]) + 256);
        sprintf(cmd_str, "*** TESTING C   %s for NULL arguments ", basename(argv[0]));
        printf("%-66s ------ ", cmd_str); fflush(stdout);
        free(cmd_str);
    }

    /* check whether burst buffering is enabled */
    if (inq_env_hint("nc_burst_buf", &hint_value)) {
        if (strcasecmp(hint_value, "enable") == 0) bb_enabled = 1;
        free(hint_value);
    }

    nerrs += test_format_nc1(filename);
    nerrs += test_format_nc2(filename);
#ifdef ENABLE_NETCDF4
    if (!bb_enabled) {
        nerrs += test_format_nc3(filename);
        nerrs += test_format_nc4(filename);
    }
#endif
    nerrs += test_format_nc5(filename);

    /* check if PnetCDF freed all internal malloc */
    MPI_Offset malloc_size, sum_size;
    err = ncmpi_inq_malloc_size(&malloc_size);
    if (err == NC_NOERR) {
        MPI_Reduce(&malloc_size, &sum_size, 1, MPI_OFFSET, MPI_SUM, 0, MPI_COMM_WORLD);
        if (rank == 0 && sum_size > 0)
            printf("heap memory allocated by PnetCDF internally has %lld bytes yet to be freed\n",
                   sum_size);
        if (malloc_size > 0) ncmpi_inq_malloc_list();
    }

    MPI_Allreduce(MPI_IN_PLACE, &nerrs, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    if (rank == 0) {
        if (nerrs) printf(FAIL_STR,nerrs);
        else       printf(PASS_STR);
    }

    MPI_Finalize();
    return (nerrs > 0);
}

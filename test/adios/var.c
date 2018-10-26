/*
 *  Copyright (C) 2018, Northwestern University and Argonne National Laboratory
 *  See COPYRIGHT notice in top-level directory.
 *
 *  $Id$
 */

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * This program try openiing a simple adios BP file
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
#include <stdio.h>
#include <stdlib.h> /* setenv() */
#include <libgen.h> /* basename() */
#include <mpi.h>
#include "pnetcdf.h"
#include <math.h>

#include <testutils.h>

/* This is the name of the data file we will read. */
#define FILE_NAME "arrays.bp"
#define V1_NAME "var_double_2Darray"
#define V2_NAME "var_int_1Darray"
#define D1_NAME "NX"
#define D2_NAME "NY"

/* We are reading 2D data, a 6 x 12 grid. */
#define NX 10ULL
#define NY 100ULL
#define NDIMS 2

/* Handle errors by printing an error message and exiting with a
 * non-zero status. */
#define ERRCODE 2
#define ERR(e) {printf("Error: %s\n", nc_strerror(e)); exit(ERRCODE);}

int main(int argc, char** argv) {
    int i, j, nerrs=0, rank, nprocs, err;
    int ncid, vid, ndim;
    int dimids[2];
    MPI_Offset start[2], count[2];
    double data[NY];

    MPI_Offset dlen;
    char tmp[1024];
    int x, y;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

    err = ncmpi_open(MPI_COMM_WORLD, FILE_NAME, NC_NOWRITE, MPI_INFO_NULL, &ncid);
    CHECK_ERR

    err = ncmpi_inq_dim(ncid, 0, tmp, &dlen); CHECK_ERR
    if (strcmp(tmp, D1_NAME) != 0){
        printf("Rank %d: Expect Dim 0 name = %s, but got %s\n", rank, D1_NAME, tmp);
        nerrs++;
    }
    if (dlen != (MPI_Offset)NX){
        printf("Rank %d: Expect Dim 0 len = %llu, but got %llu\n", rank, NX, (unsigned long long)dlen);
        nerrs++;
    }

    err = ncmpi_inq_dim(ncid, 1, tmp, &dlen); CHECK_ERR
    if (strcmp(tmp, D2_NAME) != 0){
        printf("Rank %d: Expect Dim 1 name = %s, but got %s\n", rank, D2_NAME, tmp);
        nerrs++;
    }
    if (dlen != (MPI_Offset)NY){
        printf("Rank %d: Expect Dim 1 len = %llu, but got %llu\n", rank, NY, (unsigned long long)dlen);
        nerrs++;
    }

    err = ncmpi_inq_var(ncid, 0, tmp, NULL, &ndim, dimids, NULL); CHECK_ERR
    if (strcmp(tmp, V1_NAME) != 0){
        printf("Rank %d: Expect Var 0 name = %s, but got %s\n", rank, D2_NAME, tmp);
        nerrs++;
    }
    if (ndim != 2){
        printf("Rank %d: Expect Var 0 ndim = %d, but got %d\n", rank, 2, ndim);
        nerrs++;
    }
    for(i = 0; i < ndim; i++){
        if (dimids[i] != i){
            printf("Rank %d: Expect Var 0 dimids[%d] = %d, but got %d\n", rank, i, i, dimids[i]);
            nerrs++;
        }
    }

    err = ncmpi_inq_var(ncid, 1, tmp, NULL, &ndim, dimids, NULL); CHECK_ERR
    if (strcmp(tmp, V2_NAME) != 0){
        printf("Rank %d: Expect Var 1 name = %s, but got %s\n", rank, D2_NAME, tmp);
        nerrs++;
    }
    if (ndim != 1){
        printf("Rank %d: Expect Var 1 ndim = %d, but got %d\n", rank, 1, ndim);
        nerrs++;
    }
    for(i = 0; i < ndim; i++){
        if (dimids[i] != i){
            printf("Rank %d: Expect Var 1 dimids[%d] = %d, but got %d\n", rank, i, i, dimids[i]);
            nerrs++;
        }
    }

    start[0] = rank % NX;
    start[1] = 0;
    count[0] = 1;
    count[1] = NY;
    err = ncmpi_get_vara_double_all(ncid, 0, start, count, data); CHECK_ERR
    for(i = 0; i < NY; i++){
        if (fabs(data[i] - (((double)start[0]) + ((double)i) / 100)) > 0.0001){
            printf("Rank %d: Expect Var 0 [%llu][%d] = %lf, but got %lf\n", rank, start[0], i, ((double)start[0]) + ((double)i) / 100, data[i]);
            nerrs++;
        }
    }

    start[0] = rank % NX;
    count[0] = 1;
    err = ncmpi_get_vara_double_all(ncid, 1, start, count, data); CHECK_ERR
    if (fabs(data[0] - ((double)start[0])) > 0.0001){
        printf("Rank %d: Expect Var 1 [%llu] = %lf, but got %lf\n", rank, start[0], ((double)start[0]), data[i]);
        nerrs++;
    }

    ncmpi_close(ncid);

fn_exit:
    MPI_Allreduce(MPI_IN_PLACE, &nerrs, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    if (rank == 0) {
        if (nerrs) printf(FAIL_STR,nerrs);
        else       printf(PASS_STR);
    }

    MPI_Finalize();
    return (nerrs > 0);
}


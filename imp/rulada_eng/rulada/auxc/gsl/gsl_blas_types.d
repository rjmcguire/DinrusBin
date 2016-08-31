/* Converted to D from gsl_blas_types.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_blas_types;
/* blas/gsl_blas_types.h
 * 
 * Copyright (C) 1996, 1997, 1998, 1999, 2000 Gerard Jungman
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

/*
 * Author:  G. Jungman
 */
/* Based on draft BLAST C interface specification  [Jul 7 1998]
 */

public import auxc.gsl.gsl_cblas;

extern (C):
alias size_t CBLAS_INDEX_t;

alias CBLAS_ORDER CBLAS_ORDER_t;

alias CBLAS_TRANSPOSE CBLAS_TRANSPOSE_t;

alias CBLAS_UPLO CBLAS_UPLO_t;

alias CBLAS_DIAG CBLAS_DIAG_t;

alias CBLAS_SIDE CBLAS_SIDE_t;

/* typedef  gsl_complex  COMPLEX; */


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}

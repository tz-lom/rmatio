## rmatio, a R interface to the C library matio, MAT File I/O Library.
## Copyright (C) 2013-2014  Stefan Widgren
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## rmatio is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

##' Reads the values in a mat-file to a list.
##'
##' Reads the values in a mat-file and stores them in a list.
##' @note
##' \itemize{
##'   \item A sparse complex matrix is read as a dense complex matrix.
##'
##'   \item A sparse logical matrix is read as a 'lgCMatrix'
##'
##'   \item A sparse matrix is read as a 'dgCMatrix'
##'
##'   \item A matrix of dimension  \code{1 x n} or \code{n x 1} is read as a vector
##'
##'   \item A structure is read as a named list with fields.
##'
##'   \item A cell array is read as an unnamed list with cell data
##' }
##' @title Read Matlab file
##' @param filename Character string, with the MAT file or URL to read.
##' @return A list with the variables read.
##' @seealso See \code{\link[rmatio:write.mat]{write.mat}} for more details and examples.
##' @export
##' @useDynLib rmatio
##' @examples
##' \dontrun{
##' ## Read a mat file from an URL
##' url <- paste("http://sourceforge.net/p/matio/matio_test_datasets/ci/",
##'              "master/tree/matio_test_cases_compressed_le.mat?format=raw",
##'              sep="")
##' m <- read.mat(url)
##' }
read.mat <- function(filename) {
    ## Argument checking
    stopifnot(is.character(filename),
              identical(length(filename), 1L),
              nchar(filename) > 0)

    if (length(grep("^(http|ftp|https)://", filename))) {
        tmp <- tempfile(fileext = ".mat")
        download.file(filename, tmp, quiet = TRUE, mode = "wb")
        filename <- tmp
        on.exit(unlink(filename))
    } else if(!file.exists(filename)) {
        stop(sprintf("File don't exists: %s", filename))
    }

    return(.Call('read_mat', filename))
}

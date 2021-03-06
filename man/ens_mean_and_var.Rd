% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ens_mean_and_var.R
\name{ens_mean_and_var}
\alias{ens_mean_and_var}
\title{Compute the ensemble mean and variance}
\usage{
ens_mean_and_var(.fcst, mean_name = "ens_mean", var_name = "ens_var", ...)
}
\arguments{
\item{.fcst}{A \code{harp_fcst} object, or a data frame containing columns
with "_mbr" as part of the column names.}
}
\value{
A \code{harp_fcst} object with columns ens_mean and ens_var added to
  the forecast tables.
}
\description{
The ensemble mean and variance are computed and added as columns to tables in
a \code{harp_fcst} object.
}

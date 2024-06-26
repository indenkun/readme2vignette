% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/install_cran_with_readme.R
\name{install_cran_with_readme}
\alias{install_cran_with_readme}
\title{Attempts to install a package from CRAN with with convert README to Vignette during Package installation.}
\usage{
install_cran_with_readme(
  pkgs,
  repos = getOption("repos"),
  type = getOption("pkgType"),
  dependencies = NA,
  upgrade = c("default", "ask", "always", "never"),
  force = FALSE,
  quiet = FALSE,
  build = TRUE,
  build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
  build_manual = FALSE,
  readme_to_vignette = TRUE,
  build_vignettes = readme_to_vignette,
  ...
)
}
\arguments{
\item{pkgs}{A character vector of packages to install.}

\item{repos}{A character vector giving repositories to use.}

\item{type}{Type of package to \code{update}.}

\item{dependencies}{Which dependencies do you want to check?
Can be a character vector (selecting from "Depends", "Imports",
"LinkingTo", "Suggests", or "Enhances"), or a logical vector.

\code{TRUE} is shorthand for "Depends", "Imports", "LinkingTo" and
"Suggests". \code{NA} is shorthand for "Depends", "Imports" and "LinkingTo"
and is the default. \code{FALSE} is shorthand for no dependencies (i.e.
just check this package, not its dependencies).

The value "soft" means the same as \code{TRUE}, "hard" means the same as \code{NA}.

You can also specify dependencies from one or more additional fields,
common ones include:
\itemize{
\item Config/Needs/website - for dependencies used in building the pkgdown site.
\item Config/Needs/coverage for dependencies used in calculating test coverage.
}}

\item{upgrade}{Should package dependencies be upgraded? One of "default", "ask", "always", or "never". "default"
respects the value of the \code{R_REMOTES_UPGRADE} environment variable if set,
and falls back to "ask" if unset. "ask" prompts the user for which out of
date packages to upgrade. For non-interactive sessions "ask" is equivalent
to "always". \code{TRUE} and \code{FALSE} are also accepted and correspond to
"always" and "never" respectively.}

\item{force}{Force installation, even if the remote state has not changed
since the previous install.}

\item{quiet}{If \code{TRUE}, suppress output.}

\item{build}{If \code{TRUE} build the package before installing.}

\item{build_opts}{Options to pass to \verb{R CMD build}, only used when \code{build} is \code{TRUE}.}

\item{build_manual}{If \code{FALSE}, don't build PDF manual ('--no-manual').}

\item{readme_to_vignette}{Logical value. If TRUE, installs the contents of \code{README.md} as Vignette for packages without Vignette, if \code{README.md} is available; if FALSE, the behavior is the same as \code{\link[remotes:install_cran]{remotes::install_cran()}}.}

\item{build_vignettes}{If \code{FALSE}, don't build package vignettes ('--no-build-vignettes').}

\item{...}{Other arguments passed on to \code{\link[utils:install.packages]{utils::install.packages()}}.}
}
\value{
Invisible \code{NULL}.
}
\description{
The bulk of the code is based on \code{\link[remotes:install_cran]{remotes::install_cran()}}, for packages without vignette, convert \code{README.md} to vignette and install.
}
\details{
The code is basically based on \code{\link[remotes:install_cran]{remotes::install_cran()}}, that \code{remotes} version 2.4.2.
It just intersperses the process of making \code{README.md} into vignettes if there are no vignettes when the package source is extracted during the installation.

The \code{remotes} package on which this code is based was created by the author of \code{remotes} and is now released at MIT.
The author of the remotes package is currently listed as Developed by Gábor Csárdi, Jim Hester, Hadley Wickham, Winston Chang, Martin Morgan, Dan Tenenbaum, Posit Software, PBC.
See \href{https://github.com/r-lib/remotes}{r-lib/remote} for detailed authorship.
}
\note{
Binary format is not supported. The package must be installed from the source package.

Under the current specification, the images in the \code{README.md} are copied for the figures in the directories under \verb{man/figures/}, but not for the images in other directories, which are missing.
}
\examples{
\dontrun{
install_cran_with_readme("arabic2kansuji")
}
}
\seealso{
\code{\link[remotes:install_cran]{remotes::install_cran()}}

\url{https://github.com/r-lib/remotes}

\url{https://remotes.r-lib.org/}

Other package installation: 
\code{\link{install_github_with_readme}()}
}
\concept{package installation}

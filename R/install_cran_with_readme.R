#' Attempts to install a package from CRAN with with convert README to Vignette during Package installation.
#'
#' @description
#' The bulk of the code is based on [remotes::install_cran()], for packages without vignette, convert `README.md` to vignette and install.
#'
#' @param readme_to_vignette Logical value. If TRUE, installs the contents of `README.md` as Vignette for packages without Vignette, if `README.md` is available; if FALSE, the behavior is the same as [remotes::install_cran()].
#' @inheritParams remotes::install_cran
#' @details
#' The code is basically based on [remotes::install_cran()], that `remotes` version 2.4.2.
#' It just intersperses the process of making `README.md` into vignettes if there are no vignettes when the package source is extracted during the installation.
#'
#' The `remotes` package on which this code is based was created by the author of `remotes` and is now released at MIT.
#' The author of the remotes package is currently listed as Developed by Gábor Csárdi, Jim Hester, Hadley Wickham, Winston Chang, Martin Morgan, Dan Tenenbaum, Posit Software, PBC.
#' See [r-lib/remote](https://github.com/r-lib/remotes) for detailed authorship.
#'
#' @returns
#' Invisible `NULL`.
#'
#' @note
#' Binary format is not supported. The package must be installed from the source package.
#'
#' Under the current specification, the images in the `README.md` are copied for the figures in the directories under `man/figures/`, but not for the images in other directories, which are missing.
#'
#' @seealso
#' [remotes::install_cran()]
#'
#' [https://github.com/r-lib/remotes](https://github.com/r-lib/remotes)
#'
#' [https://remotes.r-lib.org/](https://remotes.r-lib.org/)
#' @family package installation
#' @examples
#' \donttest{
#' install_cran_with_readme("arabic2kansuji")
#' }
#' @export

install_cran_with_readme <- function(pkgs, repos = getOption("repos"), type = getOption("pkgType"),
                                     dependencies = NA,
                                     upgrade = c("default", "ask", "always", "never"),
                                     force = FALSE,
                                     quiet = FALSE,
                                     build = TRUE, build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                                     build_manual = FALSE,
                                     readme_to_vignette = TRUE,
                                     build_vignettes = readme_to_vignette,
                                     ...){
  if(grepl("binary", type)) stop("Binary format is not supported.")

  remotes <- lapply(pkgs, cran_remote, repos = repos, type = type)

  install_remotes(remotes,
                  dependencies = dependencies,
                  upgrade = upgrade,
                  force = force,
                  quiet = quiet,
                  build = build,
                  build_opts = build_opts,
                  build_manual = build_manual,
                  readme_to_vignette = readme_to_vignette,
                  build_vignettes = build_vignettes,
                  repos = repos,
                  type = type,
                  ...)
}

#'
remote_download.cran_remote <- function(x, quiet = FALSE){
  utils::download.packages(pkgs = x$name, destdir = tempdir(), repos = x$repos, type = x$pkg_type)
}

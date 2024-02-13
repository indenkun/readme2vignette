#' Attempts to install a package directly from GitHub with convert README to Vignette during Package installation.
#' @description
#' The bulk of the code is based on [remotes::install_github()], for packages without vignette, convert `README.md` to vignette and install.
#' @param readme_to_vignette Logical value. If TRUE, installs the contents of `README.md` as Vignette for packages without Vignette, if `README.md` is available; if FALSE, the behavior is the same as [remotes::install_github()].
#' @inheritParams remotes::install_github
#' @inheritParams remotes::install_deps
#' @details
#' The code is basically based on [remotes::install_github()].
#' It just intersperses the process of making `README.md` into vignettes if there are no vignettes when the package source is extracted during the installation.
#'
#' The `remotes` package on which this code is based was created by the author of `remotes` and is now released at MIT.
#' The author of the remotes package is currently listed as Developed by Gábor Csárdi, Jim Hester, Hadley Wickham, Winston Chang, Martin Morgan, Dan Tenenbaum, Posit Software, PBC.
#' See [r-lib/remote](https://github.com/r-lib/remotes) for detailed authorship.
#' @note
#' Under the current specification, the images in the `README.md` are copied for the figures in the directories under `man/figures/`, but not for the images in other directories, which are missing.
#'
#' @seealso
#' [remotes::install_github()]
#'
#' [https://github.com/r-lib/remotes](https://github.com/r-lib/remotes)
#'
#' [https://remotes.r-lib.org/](https://remotes.r-lib.org/)
#' @export
install_github_with_readme <- function(repo,
                                       ref = "HEAD",
                                       subdir = NULL,
                                       auth_token = github_pat(quiet),
                                       host = "api.github.com",
                                       dependencies = NA,
                                       upgrade = c("default", "ask", "always", "never"),
                                       force = FALSE,
                                       quiet = FALSE,
                                       build = TRUE, build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                                       build_manual = FALSE,
                                       readme_to_vignette = TRUE,
                                       build_vignettes = readme_to_vignette,
                                       repos = getOption("repos"),
                                       type = getOption("pkgType"),
                                       ...) {

  remotes <- lapply(repo, remotes::github_remote, ref = ref,
                    subdir = subdir, auth_token = auth_token, host = host)

  install_remotes(remotes, auth_token = auth_token, host = host,
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
install_remotes <- function(remotes, ...) {
  res <- character(length(remotes))
  for (i in seq_along(remotes)) {
    tryCatch(
      res[[i]] <- install_remote(remotes[[i]], ...),
      error = function(e) {
        stop(remote_install_error(remotes[[i]], e))
      })
  }
  invisible(res)
}

#'
install_remote <- function(remote,
                           dependencies,
                           upgrade,
                           force,
                           quiet,
                           build,
                           build_opts,
                           build_manual,
                           readme_to_vignette,
                           build_vignettes,
                           repos,
                           type,
                           ...) {

  stopifnot(is.remote(remote))

  package_name <- remotes::remote_package_name(remote)
  local_sha <- local_sha(package_name)
  remote_sha <- remote_sha(remote, local_sha)

  if (!isTRUE(force) &&
      !different_sha(remote_sha = remote_sha, local_sha = local_sha)) {

    if (!quiet) {
      message(
        "Skipping install of '", package_name, "' from a ", sub("_remote", "", class(remote)[1L]), " remote,",
        " the SHA1 (", substr(remote_sha, 1L, 8L), ") has not changed since last install.\n",
        "  Use `force = TRUE` to force installation")
    }
    return(invisible(package_name))
  }

  if (inherits(remote, "cran_remote")) {
    install_packages(
      package_name, repos = remote$repos, type = remote$pkg_type,
      dependencies = dependencies,
      quiet = quiet,
      ...)
    return(invisible(package_name))
  }

  res <- try(bundle <- remotes::remote_download(remote, quiet = quiet), silent = quiet)
  if (inherits(res, "try-error")) {
    return(NA_character_)
  }

  on.exit(unlink(bundle), add = TRUE)

  source <- source_pkg(bundle, subdir = remote$subdir)
  on.exit(unlink(source, recursive = TRUE), add = TRUE)
  if(readme_to_vignette){
    add_readme_to_vignette(source)
  }
  update_submodules(source, remote$subdir, quiet)

  remotes::add_metadata(source, remotes::remote_metadata(remote, bundle, source, remote_sha))

  # Because we've modified DESCRIPTION, its original MD5 value is wrong
  clear_description_md5(source)

  install(source,
          dependencies = dependencies,
          upgrade = upgrade,
          force = force,
          quiet = quiet,
          build = build,
          build_opts = build_opts,
          build_manual = build_manual,
          build_vignettes = build_vignettes,
          repos = repos,
          type = type,
          ...)
}

#'
github_pat <- utils::getFromNamespace("github_pat", "remotes")
remote_install_error <- utils::getFromNamespace("remote_install_error", "remotes")
is.remote <- utils::getFromNamespace("is.remote", "remotes")
local_sha <- utils::getFromNamespace("local_sha", "remotes")
remote_sha <- utils::getFromNamespace("remote_sha", "remotes")
different_sha <- utils::getFromNamespace("different_sha", "remotes")
source_pkg <- utils::getFromNamespace("source_pkg", "remotes")
update_submodules <- utils::getFromNamespace("update_submodules", "remotes")
clear_description_md5 <- utils::getFromNamespace("clear_description_md5", "remotes")
install <- utils::getFromNamespace("install", "remotes")
install_packages <- utils::getFromNamespace("install_packages", "remotes")

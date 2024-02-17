#' The code is basically based on `remotes` version 2.4.2.
#'
#' The `remotes` package on which this code is based was created by the author of `remotes` and is now released at MIT.
#' The author of the remotes package is currently listed as Developed by Gábor Csárdi, Jim Hester, Hadley Wickham, Winston Chang, Martin Morgan, Dan Tenenbaum, Posit Software, PBC.
#' See [r-lib/remote](https://github.com/r-lib/remotes) for detailed authorship.
#' @noRd
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

  # if (inherits(remote, "cran_remote")) {
  #   install_packages(
  #     package_name, repos = remote$repos, type = remote$pkg_type,
  #     dependencies = dependencies,
  #     quiet = quiet,
  #     ...)
  #   return(invisible(package_name))
  # }

  if(!inherits(remote, "cran_remote")){
    res <- try(bundle <- remotes::remote_download(remote, quiet = quiet), silent = quiet)
    if (inherits(res, "try-error")) {
      return(NA_character_)
    }
  }else if(inherits(remote, "cran_remote")){
    bundle <- suppressWarnings(remote_download.cran_remote(remote))
    if(length(bundle) == 0) stop(gettextf("package %s does not exist on the CRAN repository.",
                                          sQuote(remote$name)))
    bundle <- bundle[2]
  }

  on.exit(unlink(bundle), add = TRUE)

  source <- source_pkg(bundle, subdir = remote$subdir)
  on.exit(unlink(source, recursive = TRUE), add = TRUE)
  if(readme_to_vignette){
    add_readme_to_vignette(source)
  }
  if(!inherits(remote, "cran_remote")){
    update_submodules(source, remote$subdir, quiet)

    remotes::add_metadata(source, remotes::remote_metadata(remote, bundle, source, remote_sha))

    # Because we've modified DESCRIPTION, its original MD5 value is wrong
    clear_description_md5(source)
  }

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

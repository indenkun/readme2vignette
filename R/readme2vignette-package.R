#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
#' @importFrom knitr knit
#' @importFrom rmarkdown render
NULL

#'
cran_remote <- utils::getFromNamespace("cran_remote", "remotes")

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

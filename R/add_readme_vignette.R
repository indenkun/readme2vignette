#' Add README to vignette
#' @description
#' If a package does not have a vignette but has a `README.md`, make the contents of the `README.md` be the vignette
#' @param source String. The directory path where the package is deployed.
#' @param vignette_title String. The intended title of the vignette. If not provided, no title will be attached.
#' @param vignette_slug String. filename to be used as the vignette. By default this will be README.
#'
#' @details
#' Review the DISCRIPTION file and file structure and add the necessary dependencies and files.
#'
#' @returns
#' Invisible `NULL`.
#'
#' @examples
#' \dontrun{
#' # In the package directory.
#' add_readme_to_vignette(".")
#' }
#' @export
add_readme_to_vignette <- function(source = ".", vignette_title = NULL, vignette_slug = "README"){
  desc_file <- desc::desc(file = fs::path(source, "DESCRIPTION"))

  if(fs::file_exists(fs::path(source, "README.md")) &&
     !fs::file_exists(fs::path(source, "vignetts"))){
    if(!desc_file$has_dep("knitr")){
      desc_file$set_dep("knitr", "Suggests")
      desc_file$write()
    }
    if(!desc_file$has_dep("rmarkdown")){
      desc_file$set_dep("rmarkdown", "Suggests")
      desc_file$write()
    }
    if(!desc_file$has_fields("VignetteBuilder")){
      desc_file$set_list("VignetteBuilder", "knitr")
      desc_file$write()
    }

    readme_vignette <- paste0('---
title: "', vignette_title, '"
output: rmarkdown::html_vignette
vignette: >
  %\\VignetteIndexEntry{README}
  %\\VignetteEngine{knitr::rmarkdown}
  %\\VignetteEncoding{UTF-8}
---

```{r, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>")
if(dir.exists("../man/figures/")){
  dir.create("./man/figures/", recursive = TRUE)
  file.copy("../man/figures/", "./man/", recursive = TRUE)
}
```
<!-- This vignette was automatically created from README.md -->

```{r child = "../README.md"}
```
  ')

  fs::dir_create(fs::path(source, "vignettes"))

  usethis::write_over(fs::path(source, "vignettes", vignette_slug, ext = "Rmd"),
                      readme_vignette,
                      quiet = TRUE)
  }
}

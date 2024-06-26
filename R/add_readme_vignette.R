#' Add README to vignette
#' @description
#' If a package does not have a vignette but has a `README.md`, make the contents of the `README.md` be the vignette
#' @param source String. The directory path where the package is deployed.
#' @param vignette_title String. The intended title of the vignette. If not provided, no title will be attached.
#' @param braced_vignette_title String. The title of the vignette.
#' @param vignette_slug String. filename to be used as the vignette. By default this will be README.
#' @param quiet Logical. Whether to message about what is happening.
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
add_readme_to_vignette <- function(source, vignette_title = NULL,
                                   braced_vignette_title = "README",
                                   vignette_slug = "README",
                                   quiet = FALSE){
  check_vignette_name(vignette_slug)

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

    fs::dir_create(fs::path(source, "vignettes"))

    readme_vignette <- render_template("readme2vignette-template.Rmd",
                                       data = list(vignette_title = vignette_title,
                                                   braced_vignette_title = glue::glue("{{{braced_vignette_title}}}")),
                                       package = "readme2vignette")
    usethis::write_over(path = fs::path(source, "vignettes", vignette_slug, ext = "Rmd"),
                        readme_vignette,
                        quiet = quiet)
  }
  invisible()
}

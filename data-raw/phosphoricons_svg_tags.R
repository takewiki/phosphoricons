## code to prepare `ph_icons` dataset goes here

# Submodule ----

#
# gert::git_submodule_add(url = "https://github.com/phosphor-icons/phosphor-icons", path = "data-raw/phosphor-icons")
# gert::git_submodule_fetch(submodule = "data-raw/phosphor-icons")


# Funs ----

convert_svg <- function(x) {
  svg <- readLines(x)
  svg <- paste(svg, collapse = "\n")
  name <- tools::file_path_sans_ext(basename(x))
  svg <- XML::htmlParse(svg)
  svg <- XML::getNodeSet(svg, "/html/body/*")
  svg <- svg[[1]]
  svg <- charpente:::render_node(svg, prefix = TRUE)
  sprintf(
    "phosphoricons_svg_tags[[\"%s\"]] <- %s", name, svg
  )
}


# Convert SVG ----

cat("phosphoricons_svg_tags <- list()\n", file = "data-raw/phosphor-svg.R")

svg_icons_path <- list.files(path = "data-raw/phosphor-icons/assets/", full.names = TRUE, recursive = TRUE, pattern = "\\.svg$")

library(progress)
pb <- progress_bar$new(
  format = "  converting svg [:bar] :percent",
  total = length(svg_icons_path)
)
for (path in svg_icons_path) {
  pb$tick()
  cat(styler::style_text(convert_svg(path)), file = "data-raw/phosphor-svg.R", sep = "\n", append = TRUE)
}



# check it works
library(htmltools)
source("data-raw/phosphor-svg.R")
browsable(phosphoricons_svg_tags$`activity-bold`)
browsable(phosphoricons_svg_tags$`activity-thin`)
browsable(phosphoricons_svg_tags$`battery-warning-vertical-bold`)


# Icon's name ----

# Get names from regular type folder
phosphoricons_names <- list.files(path = "data-raw/phosphor-icons/assets/regular/", pattern = "\\.svg$")
phosphoricons_names <- tools::file_path_sans_ext(basename(phosphoricons_names))
length(phosphoricons_names)
head(phosphoricons_names)


usethis::use_data(phosphoricons_svg_tags, phosphoricons_names, overwrite = TRUE, internal = TRUE)

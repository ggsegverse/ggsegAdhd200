# Create ADHD-200 Parcellation Atlases
#
# Source: https://www.nitrc.org/frs/?group_id=427
# Reference: Craddock RC, et al. (2012). Human Brain Mapping, 33(8):1914-1928.
# Date obtained: 2026-03-28
#
# Run with: Rscript data-raw/make_atlas.R

library(ggseg.extra)
library(ggseg.formats)

Sys.setenv(FREESURFER_HOME = "/Applications/freesurfer/7.4.1")

sysdata_env <- new.env(parent = emptyenv())

for (res in c(200, 400)) {
  atlases <- create_wholebrain_from_volume(
    input_volume = here::here("data-raw", "source", paste0("ADHD200_parcellate_", res, ".nii.gz")),
    atlas_name = paste0("adhd200_", res),
    output_dir = "data-raw",
    skip_existing = TRUE,
    cleanup = FALSE
  )

  if (!is.null(atlases$cortical)) {
    sysdata_env[[paste0(".adhd200_", res, "_cortical")]] <- atlases$cortical
    print(atlases$cortical)
    plot(atlases$cortical)
  }
  if (!is.null(atlases$subcortical)) {
    sysdata_env[[paste0(".adhd200_", res, "_subcortical")]] <- atlases$subcortical
    print(atlases$subcortical)
    plot(atlases$subcortical)
  }
}

save(
  list = ls(sysdata_env, all.names = TRUE),
  envir = sysdata_env,
  file = here::here("R", "sysdata.rda"),
  compress = "xz"
)

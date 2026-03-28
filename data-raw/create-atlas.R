# Create ADHD 200 spectral clustering parcellation atlases
#
# Spatially constrained spectral clustering parcellations at 200 and 400
# parcel resolutions, derived from 650 ADHD 200 consortium subjects.
#
# Source: http://ccraddock.github.io/cluster_roi/atlases.html
#
# Reference: Craddock RC, et al. (2012). "A whole brain fMRI atlas generated
#   via spatially constrained spectral clustering." Human Brain Mapping,
#   33(8):1914-1928. DOI: 10.1002/hbm.21333
#
# Requirements:
#   - ggseg.extra, ggseg.formats
#
# Run with: Rscript data-raw/create-atlas.R

library(dplyr)
library(ggseg.extra)
library(ggseg.formats)

options(chromote.timeout = 120)
future::plan(future::sequential)
progressr::handlers("cli")
progressr::handlers(global = TRUE)

# ── Obtain volumetric parcellations ─────────────────────────────
# Download the ADHD 200 spectral clustering atlases from:
# http://ccraddock.github.io/cluster_roi/atlases.html
#
# Needed files (place in data-raw/):
#   - ADHD200_parcellate_200.nii.gz
#   - ADHD200_parcellate_400.nii.gz

vol_dir <- here::here("data-raw")
resolutions <- c(200, 400)

for (res in resolutions) {
  vol_file <- file.path(vol_dir, sprintf("ADHD200_parcellate_%d.nii.gz", res))
  if (!file.exists(vol_file)) {
    cli::cli_abort(c(
      "Volume file not found: {.path {vol_file}}",
      "i" = "Download from: {.url http://ccraddock.github.io/cluster_roi/atlases.html}",
      "i" = "Place as: {.path {vol_file}}"
    ))
  }
}

# ── Create atlases from volumes ──────────────────────────────────
all_internals <- list()

for (res in resolutions) {
  nm <- paste0("adhd200_", res)
  vol_file <- file.path(vol_dir, sprintf("ADHD200_parcellate_%d.nii.gz", res))

  cli::cli_h1("Creating {nm} atlas ({res} parcels)")

  atlas <- callr::r(function(vol, name, outdir) {
    library(ggseg.extra)
    library(ggseg.formats)
    library(dplyr)

    result <- create_subcortical_from_volume(
      input_volume = vol,
      atlas_name = name,
      output_dir = outdir,
      skip_existing = TRUE,
      cleanup = FALSE
    )

    result |>
      atlas_region_contextual("unknown|Background", "label")
  }, args = list(vol = vol_file, name = nm, outdir = vol_dir))

  cli::cli_alert_success("{nm}: {nrow(atlas$core)} regions")
  print(atlas)

  all_internals[[paste0(".", nm)]] <- atlas
}

# ── Save all atlas objects as internal data ──────────────────────
list2env(all_internals, envir = environment())
do.call(
  usethis::use_data,
  c(
    lapply(names(all_internals), as.name),
    list(internal = TRUE, overwrite = TRUE, compress = "xz")
  )
)
cli::cli_alert_success("All ADHD 200 atlases saved as internal data")

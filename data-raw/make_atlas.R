# Create ADHD-200 Parcellation Atlases
#
# Creates subcortical atlases from Craddock CC200/CC400 parcellations.
#
# Source: https://www.nitrc.org/projects/cluster_roi/
# Download: https://www.nitrc.org/frs/?group_id=427
#   - Place cc200_2MM.nii.gz and cc400_2MM.nii.gz in data-raw/source/
#
# Reference: Craddock RC, James GA, Holtzheimer PE, Hu XP, Mayberg HS
#   (2012). A whole brain fMRI atlas generated via spatially constrained
#   spectral clustering. Human Brain Mapping, 33(8):1914-1928.
#   doi:10.1002/hbm.21333
#
# Date obtained: [FILL IN WHEN DOWNLOADED]
#
# Run with: Rscript data-raw/make_atlas.R

library(ggseg.extra)
library(ggseg.formats)

# ── CC200 ─────────────────────────────────────────────────────────
adhd200_200 <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "source", "cc200_2MM.nii.gz"),
  atlas_name = "adhd200_200",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
)

print(adhd200_200)
plot(adhd200_200)

# ── CC400 ─────────────────────────────────────────────────────────
adhd200_400 <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "source", "cc400_2MM.nii.gz"),
  atlas_name = "adhd200_400",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
)

print(adhd200_400)
plot(adhd200_400)

# ── Save ──────────────────────────────────────────────────────────
.adhd200_200 <- adhd200_200
.adhd200_400 <- adhd200_400
usethis::use_data(.adhd200_200, .adhd200_400,
  overwrite = TRUE, compress = "xz", internal = TRUE
)

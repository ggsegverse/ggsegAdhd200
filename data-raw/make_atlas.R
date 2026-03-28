# Create ADHD-200 Parcellation Atlases
#
# Craddock CC200/CC400 spatially constrained spectral clustering parcellations.
#
# Source: https://www.nitrc.org/frs/?group_id=427
# Reference: Craddock RC, et al. (2012). Human Brain Mapping, 33(8):1914-1928.
#   doi:10.1002/hbm.21333
#
# Date obtained: 2026-03-28
#
# Run with: Rscript data-raw/make_atlas.R

library(ggseg.extra)
library(ggseg.formats)

adhd200_200 <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "source", "ADHD200_parcellate_200.nii.gz"),
  atlas_name = "adhd200_200",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
)

print(adhd200_200)
plot(adhd200_200)

adhd200_400 <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "source", "ADHD200_parcellate_400.nii.gz"),
  atlas_name = "adhd200_400",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
)

print(adhd200_400)
plot(adhd200_400)

.adhd200_200 <- adhd200_200
.adhd200_400 <- adhd200_400
usethis::use_data(.adhd200_200, .adhd200_400,
  overwrite = TRUE, compress = "xz", internal = TRUE
)

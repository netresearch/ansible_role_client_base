# Bake definition for the ansible_role_client_base container image.
#
# Tags and labels are deliberately NOT declared here. CI runs
# docker/metadata-action (through the `metadata-images` / `metadata-tags`
# inputs of netresearch/.github build-container-bake.yml) and appends the
# tag + label bake files it generates, which populate the
# `docker-metadata-action` stub target below. `app` inherits that target and
# therefore picks up the whole tag fan-out plus the OCI labels.
#
# Never add `tags` to `app`: a target's own `tags` replaces the inherited
# ones, which would silently drop the metadata-action tag scheme.
#
# The generated tag/label bake files live in $RUNNER_TEMP, i.e. in the local
# checkout — which is why the workflow passes `bake-source: "."`. Without it
# docker/bake-action defaults to the git remote context and cannot see them.
#
# Local use (no metadata-action, so the image stays untagged):
#   docker buildx bake --print
#   docker buildx bake app

# Populated at build time by docker/metadata-action's generated bake files.
target "docker-metadata-action" {}

target "app" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "Dockerfile"
}

group "default" {
  targets = ["app"]
}
